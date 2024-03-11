//
//  test_LuaIOInjection.swift
//
//
//  Created by EnchantCode on 2024/03/06.
//

import XCTest
@testable import LuaSwift
@testable import LuaSwiftCore
@testable import LuaSwiftMacros

/// 標準入出力のインジェクション
final class testLuaIOInjection: XCTestCase {
    
    /// 標準出力を置き換える
    func testInjectOutput() throws {
        let lua = Lua(state: luaL_newstate(), owned: true)
        luaL_openlibs(lua.state)
        
        // pipeシステムコールを呼び出し、書込み用のファイルポインタを生成
        var fileDescriptors: [Int32] = .init(repeating: -1, count: 2)
        guard pipe(&fileDescriptors) != -1 else {fatalError("Failed to configure pipe")}
        guard let fileWritePtr = fdopen(fileDescriptors[1], "w") else {fatalError("Failed to open file descriptor")}

        // ioライブラリを積んでおく
        lua_getglobal(lua.state, "io")
        
        // luaストリームを生成
        let luaStream = lua_newuserdatauv(lua.state, MemoryLayout<luaL_Stream>.size, 0).bindMemory(to: luaL_Stream.self, capacity: 1)
        luaStream.pointee.f = fileWritePtr
        luaStream.pointee.closef = { state in
            guard let state = state else {return 0}
            // ここは io.close() の呼び出し時に内部で呼ばれる関数
            // Luaの仕様上、stdout を閉じるのは lua_close() が呼ばれたときだけなので、
            // ここでこの処理をする必要性はあまりないかも
            
            // ioテーブルのstdoutオブジェクトを取得
            lua_getglobal(state, "io")
            lua_getfield(state, -1, "stdout")
            
            // 型チェックして取り出し、luaStreamに変換
            guard lua_type(state, -1) == LUA_TUSERDATA else {return 0}
            let stdoutStreamPtr = lua_touserdata(state, -1).bindMemory(to: luaL_Stream.self, capacity: 1)
            
            // ファイルポインタを取り出し、fclose()を呼ぶ
            let stdoutPtr = stdoutStreamPtr.pointee.f
            fflush(stdoutPtr)
            fclose(stdoutPtr)
            
            print("Lua state \(state): stdout closed")
            return 0
        }
        
        // ストリームにファイルハンドルメタテーブルを設定
        luaL_setmetatable(lua.state, LUA_FILEHANDLE)
        
        // レジストリの_IO_outputとio.stdoutに登録
        lua_pushvalue(lua.state, -1)
        lua_setfield(lua.state, LUA_REGISTRYINDEX, "_IO_output")
        lua_setfield(lua.state, -2, "stdout")
        lua_settop(lua.state, -2)
        
        // 実行
        let outputStatement = "Hello, Lua! now we can get content of standard output using file descriptor!"
        try lua.eval("io.write(\"\(outputStatement)\")")
        
        // stdoutを閉じる
        // 実際にこの操作が行われるのは lua_close が呼ばれる時だけ (先述)
        try lua.eval("io.close(io.stdout)")
        
        // 結果は読み込み側のファイルポインタから
        guard let fileReadPtr = fdopen(fileDescriptors[0], "r") else {fatalError("Failed to open file descriptor")}
        var totalResult: [Int8] = []
        var readBuffer: [Int8] = .init(repeating: 0, count: 4096)
        var readCount = fread(&readBuffer, 1, 4096, fileReadPtr)
        while(readCount > 0) {
            totalResult.append(contentsOf: readBuffer[..<readCount])
            readCount = fread(&readBuffer, 1, 4096, fileReadPtr)
        }
        
        // 文字列に変換するのはちょっと面倒
        let line = String(totalResult.map{Character(.init(.init($0)))})
        XCTAssertEqual(line, outputStatement)
    }
    
    /// 標準入力を置き換える
    func testInjectInput() throws {
        let lua = Lua(state: luaL_newstate(), owned: true)
        luaL_openlibs(lua.state)
        
        // pipeシステムコールを呼び出し、読出し用のファイルポインタを生成
        var fileDescriptors: [Int32] = .init(repeating: -1, count: 2)
        guard pipe(&fileDescriptors) != -1 else {fatalError("Failed to configure pipe")}
        guard let fileReadPtr = fdopen(fileDescriptors[0], "r") else {fatalError("Failed to open file descriptor")}

        // ioライブラリを積んでおく
        lua_getglobal(lua.state, "io")
        
        // luaストリームを生成
        let luaStream = lua_newuserdatauv(lua.state, MemoryLayout<luaL_Stream>.size, 0).bindMemory(to: luaL_Stream.self, capacity: 1)
        luaStream.pointee.f = fileReadPtr
        luaStream.pointee.closef = { state in
            guard let state = state else {return 0}
            lua_getglobal(state, "io")
            lua_getfield(state, -1, "stdin")
            guard lua_type(state, -1) == LUA_TUSERDATA else {return 0}
            let stdoutStreamPtr = lua_touserdata(state, -1).bindMemory(to: luaL_Stream.self, capacity: 1)
            let stdoutPtr = stdoutStreamPtr.pointee.f
            fclose(stdoutPtr)
            print("Lua state \(state): stdin closed")
            return 0
        }
        
        // ストリームにファイルハンドルメタテーブルを設定
        luaL_setmetatable(lua.state, LUA_FILEHANDLE)
        
        // レジストリの_IO_inputとio.stdinに登録
        lua_pushvalue(lua.state, -1)
        lua_setfield(lua.state, LUA_REGISTRYINDEX, "_IO_input")
        lua_setfield(lua.state, -2, "stdin")
        lua_settop(lua.state, -2)
        
        // 先に書込み先のディスクリプタを用意しておく
        guard let fileWritePtr = fdopen(fileDescriptors[1], "w") else {fatalError("Failed to open file descriptor")}
        
        // Lua側で待ち受ける
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            try! lua.eval("print(\"pending \" .. os.time())")
            try! lua.eval("data_1 = io.read()")
            try! lua.eval("print(\"data_1 received \" .. os.time() .. \" : \" .. data_1)")
            try! lua.eval("data_2 = io.read()")
            try! lua.eval("print(\"data_2 received \" .. os.time() .. \" : \" .. data_2)")
            sema.signal()
        }
        
        // バックグラウンドで待っている間に書き込む
        let expect_1 = "First data..."
        fwrite(expect_1.cString(using: .ascii), 1, expect_1.count, fileWritePtr)
        fwrite("\n".cString(using: .ascii), 1, 1, fileWritePtr)
        fflush(fileWritePtr)
        
        let expect_2 = "Second data..."
        fwrite(expect_2.cString(using: .ascii), 1, expect_2.count, fileWritePtr)
        fwrite("\n".cString(using: .ascii), 1, 1, fileWritePtr)
        fflush(fileWritePtr)
        
        // この時点でio.readは完結するはず というかしていてくれ
        XCTAssertEqual(sema.wait(timeout: .now().advanced(by: .seconds(2))), .success)
        
        // luaに値が渡せたかを確認する
        lua_getglobal(lua.state, "data_1")
        let passed_1: String = try lua.get()
        lua_getglobal(lua.state, "data_2")
        let passed_2: String = try lua.get()
        XCTAssertEqual(expect_1, passed_1)
        XCTAssertEqual(expect_2, passed_2)
    }
    
    /// Luaインスタンス内で構成されたstdioのテスト
    func testStardardIO() throws {
        let lua = Lua()
        try lua.configureStandardIO(replacePrintStatement: false)
        
        // Luaには「読んで小文字にして返す」を繰り返してもらう
        DispatchQueue.global().async {
            let statement = """
            while true do
                print("Lua: pending...")
                local received = io.read()
            
                print("Lua: received " .. received)
                local converted = string.lower(received)
            
                print("Lua: sending... " .. converted)
                io.write(converted)
                io.flush()
            end
            """
            try! lua.eval(statement)
        }
        
        // いくつか送ってみる
        let lines = [
            "Hello, Lua!",
            "This is test to data injection to standard input, and capture of standard output.",
            "In current implementation, you must call io.flush() after io.write().",
            "Looks little complicated, but It is Lua's specification."
        ]
        try lines.forEach { line in
            // 書き込む
            print("Swift: sending... \(line)")
            try lua.stdin!.write(contentsOf: (line + "\n").data(using: .ascii)!)
            
            // 読み出す
            print("Swift: pending...")
            let received = String(data: lua.stdout!.availableData, encoding: .ascii)!
            print("Swift: received \(received)")
        
            // 比較する
            XCTAssertEqual(received, line.lowercased())
        }
    }
    
    /// printとio.writeを同じところに向ける
    func testUnifiedPrint() throws {
        let lua = Lua()
        try lua.configureStandardIO()
        
        // printがホストのstdoutではなくLuaインスタンスのstdoutに接続される
        let sendPrint = "Hello, Lua! I'm from print()!"
        try lua.eval("print(\"\(sendPrint)\")")
        let receivePrint = String(data: lua.stdout!.availableData, encoding: .ascii)!
        XCTAssertEqual(sendPrint, receivePrint)
        
        // 同じ結果になる
        let sendWrite = "Hello, Lua! I'm from io.write()!"
        try lua.eval("io.write(\"\(sendWrite)\")")
        try lua.eval("io.flush()")
        let receiveWrite = String(data: lua.stdout!.availableData, encoding: .ascii)!
        XCTAssertEqual(sendWrite, receiveWrite)
    }
}
