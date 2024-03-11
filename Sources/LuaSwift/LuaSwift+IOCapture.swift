//
//  LuaSwift+IOCapture.swift
//  標準入出力の構成
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore
import LuaSwiftMacros
import Foundation

public extension Lua {
    
    /// Luaインスタンスの標準入出力を構成する
    /// - Parameter replacePrintStatement: 標準関数 `print` を差し替えるかどうか
    /// - Note: Luaの標準関数 `print` は、内部で `stdio.h` レベルの `stdout` を使用しています。
    ///         引数 `replacePrintStatement` を `true` に設定することにより、`print` の出力先を `Lua.stdout` に変更することが可能です。
    func configureStandardIO(replacePrintStatement: Bool = true) throws {
        try configureStandardInput()
        try configureStandardOutput()
        
        guard replacePrintStatement else {return}
        
        lua_pushnil(state)
        lua_setglobal(state, "print")
        try eval("""
        function print(...)
            for _, arg in ipairs({...}) do
                io.write(tostring(arg))
            end
            io.flush()
        end
        """)
    }
    
    /// Luaインスタンスの標準入力を構成する
    /// - Warning: 実験的な機能です。メモリ安全等については一切検証していません。
    func configureStandardInput() throws {
        // 構成済みの場合は戻る
        guard self.stdin == nil else {return}
        
        // ioテーブル、luaStream、luaStreamで合計3要素積むことになる
        guard check(atleast: 3) else {throw LuaError.StackOverflow}

        // グローバルのioテーブルを要求し、スタックに積む
        luaL_requiref(state, "io", luaopen_io, 1)
        
        // パイプを構成し、読み出し側ディスクリプタにストリームを設定
        guard let (readDescriptor, writeDescriptor) = configurePipe(),
              let readPtr = fdopen(readDescriptor, "r") else {throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EFAULT)}
        
        // メンバを設定
        self.stdin = .init(fileDescriptor: writeDescriptor)
        
        // 入力ストリームを生成・登録
        let luaInputStream = lua_newuserdatauv(state, MemoryLayout<luaL_Stream>.size, 0).bindMemory(to: luaL_Stream.self, capacity: 1)
        luaInputStream.pointee.f = readPtr
        luaInputStream.pointee.closef = { state in
            guard let state = state else {return 0}
            let lua = Lua(state: state, owned: false)
            do {
                try lua.getGlobal(name: "io")
                try lua.getField(key: "stdin")
                guard try lua.getType() == .UserData else {return 0}
                let streamPtr = lua_touserdata(state, -1).bindMemory(to: luaL_Stream.self, capacity: 1)
                fclose(streamPtr.pointee.f)
                print("Lua state \(state): stdin closed")
                try lua.pop(count: 2)
            } catch {
                print("Failed to close stdin")
            }
            return 0
        }
        luaL_setmetatable(state, LUA_FILEHANDLE)
        lua_pushvalue(state, -1)
        lua_setfield(state, LUA_REGISTRYINDEX, "_IO_input")
        lua_setfield(state, -2, "stdin")
    }
    
    /// Luaインスタンスの標準出力を構成する
    /// - Warning: 実験的な機能です。メモリ安全等については一切検証していません。
    func configureStandardOutput() throws {
        // 構成済みの場合は戻る
        guard self.stdout == nil else {return}
        
        // ioテーブル、luaStream、luaStreamで合計3要素積むことになる
        guard check(atleast: 3) else {throw LuaError.StackOverflow}

        // グローバルのioテーブルを要求し、スタックに積む
        luaL_requiref(state, "io", luaopen_io, 1)
        
        // パイプを構成し、読み出し側ディスクリプタにストリームを設定
        guard let (readDescriptor, writeDescriptor) = configurePipe(),
              let writePtr = fdopen(writeDescriptor, "w") else {throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EFAULT)}
        
        // メンバを設定
        self.stdout = .init(fileDescriptor: readDescriptor)
        
        // 入力ストリームを生成・登録
        let luaInputStream = lua_newuserdatauv(state, MemoryLayout<luaL_Stream>.size, 0).bindMemory(to: luaL_Stream.self, capacity: 1)
        luaInputStream.pointee.f = writePtr
        luaInputStream.pointee.closef = { state in
            guard let state = state else {return 0}
            let lua = Lua(state: state, owned: false)
            do {
                try lua.getGlobal(name: "io")
                try lua.getField(key: "stdout")
                guard try lua.getType() == .UserData else {return 0}
                let streamPtr = lua_touserdata(state, -1).bindMemory(to: luaL_Stream.self, capacity: 1)
                fclose(streamPtr.pointee.f)
                print("Lua state \(state): stdout closed")
                try lua.pop(count: 2)
            } catch {
                print("Failed to close stdout")
            }
            return 0
        }
        luaL_setmetatable(state, LUA_FILEHANDLE)
        lua_pushvalue(state, -1)
        lua_setfield(state, LUA_REGISTRYINDEX, "_IO_output")
        lua_setfield(state, -2, "stdout")
    }
    
    /// パイプを作成し、そのディスクリプタを返す
    /// - Returns: ディスクリプタのタプル (読出し, 書込み)
    /// - Note: パイプの作成に失敗した場合はnilが返ります。
    fileprivate func configurePipe() -> (Int32, Int32)? {
        var descriptors: [Int32] = .init(repeating: -1, count: 2)
        guard pipe(&descriptors) != -1 else {return nil}
        return (descriptors[0], descriptors[1])
    }
    
}
