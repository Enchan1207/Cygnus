//
//  test_LuaStack.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import XCTest
@testable import LuaSwift
@testable import LuaSwiftCore
@testable import LuaSwiftMacros

/// Luaスタックのテスト
final class testLuaStack: XCTestCase {
    
    /// 基本的な操作
    func testPushPop() throws {
        let lua = Lua()
        
        let initialTop = lua.stackTop
        
        // 一つ積む
        try lua.push("Test")
        XCTAssertEqual(lua.stackTop, initialTop + 1)
        
        // 続けて積む
        try lua.pushNil()
        try lua.push(false)
        try lua.push(123)
        XCTAssertEqual(lua.stackTop, initialTop + 4)
        
        // 2つpopする
        try lua.pop(count: 2)
        XCTAssertEqual(lua.stackTop, initialTop + 2)
        XCTAssertEqual(try! lua.getType(), LuaType.Nil)
        
        // また積む
        try lua.push(true)
        try lua.push(2.34)
        XCTAssertEqual(try! lua.getType(), LuaType.Number)
        
        // 1つpopする
        try lua.pop()
        XCTAssertEqual(try! lua.getType(), LuaType.Boolean)
    }
    
    // スタックを壊す
    func testOverflow(){
        let lua = Lua()
        do{
            try (0..<Int.max).forEach({try lua.push($0)})
            XCTFail("一体どんな化け物マシン使ったらこれが通るんだよ！！")
        } catch {
            print("Stack overflow! current item count: \(lua.numberOfItems)")
        }
    }
    
    // インデックスとか境界とか
    func testBounds() throws {
        let lua = Lua()
        try lua.push(1)
        try lua.push(1)
        XCTAssertNoThrow(try lua.pop(count: 2))
        XCTAssertThrowsError(try lua.pop())
        
        try lua.push(123)
        XCTAssertNoThrow(try lua.get() as Int)
        XCTAssertThrowsError(try lua.get(at: 0) as Int)
        XCTAssertNoThrow(try lua.get(at: 1) as Int)
        XCTAssertThrowsError(try lua.get(at: -2) as Int)
        
        
        try lua.push(123)
        XCTAssertNoThrow(try lua.getType())
        XCTAssertThrowsError(try lua.getType(at: 0))
        XCTAssertNoThrow(try lua.getType(at: -1))
        XCTAssertNoThrow(try lua.getType(at: 1))
    }
    
    // 様々な操作
    func testVariousOperations() throws {
        let lua = Lua()
        
        // データを作っておく
        // 上から b n ? n s
        try lua.push("Hello!")
        try lua.push(456)
        try lua.pushNil()
        try lua.push(3.14)
        try lua.push(true)
        
        /**
         Luaスタックのインデックスは、正数の場合は下(最初にpushしたもの)を、負数の場合は上(最後にpushしたもの)を指す
         */
        
        // コピーする
        // これにより s b n ? n s となる
        try lua.push(valueAt: 1)
        XCTAssertEqual(try! lua.getType(), .String)
        
        // 3番目に1番目の要素を挿入
        // これにより b n ? s n s となる
        try lua.insert(at: 3)
        XCTAssertEqual(try! lua.getType(), .Boolean)
        XCTAssertEqual(try! lua.getType(at: -2), .Number)
        XCTAssertEqual(try! lua.getType(at: -3), .Nil)
        
        // 2番目の要素を削除
        // これにより b n ? s s となる
        try lua.remove(at: 2)
        XCTAssertEqual(try! lua.getType(at: 1), .String)
        XCTAssertEqual(try! lua.getType(at: 2), .String)
        XCTAssertEqual(try! lua.getType(at: 3), .Nil)
        XCTAssertEqual(lua.stackTop, 5)
        
        // 先頭の要素を3番目に移動(上書き)
        // これにより n b s s となる
        try lua.replace(at: 3)
        XCTAssertEqual(lua.stackTop, 4)
        let expects: [Int32: LuaType] = [
            1: .String,
            2: .String,
            3: .Boolean,
            4: .Number
        ]
        expects.forEach({XCTAssertEqual(try! lua.getType(at: $0.key), $0.value)})
    }
    
    /// Luaスタックから値を取り出す
    func testGetValue() throws {
        let lua = Lua()
        
        // データを作っておく
        // 上から b n ? n s
        try lua.push("Hello!")
        try lua.push(456)
        try lua.pushNil()
        try lua.push(3.14)
        try lua.push(true)
        
        // 成功例
        let boolValue: Bool = try lua.get()
        XCTAssertTrue(boolValue)
        try lua.pop()
        
        let doubleValue: Double = try lua.get()
        XCTAssertEqual(doubleValue, 3.14)
        try lua.pop()
        
        XCTAssertEqual(try! lua.getType(), .Nil)
        try lua.pop()
        
        // 整数を実数として受け取ることは可能
        let intValue: Int = try lua.get()
        XCTAssertEqual(intValue, 456)
        let doubleValue2: Double = try lua.get()
        XCTAssertEqual(doubleValue2, 456)
        try lua.pop()
        
        let stringValue: String = try lua.get()
        XCTAssertEqual(stringValue, "Hello!")
        try lua.pop()
        
        // 失敗例
        try lua.push("ABCDE")
        XCTAssertThrowsError(try lua.get() as Int)
        try lua.pop()
        
        // 自動型キャストはされない
        try lua.push("123")
        XCTAssertThrowsError(try lua.get() as Int)
        try lua.pop()
        
        try lua.push(true)
        XCTAssertThrowsError(try lua.get() as Int)
        try lua.pop()
        
        try lua.push(12345)
        XCTAssertThrowsError(try lua.get() as String)
        try lua.pop()
    }
    
    /// 関数オブジェクトのpush/pop
    func testPushPopFunc() throws {
        let lua = Lua()
        try lua.configureStardardIO(replacePrintStatement: false)
        
        // 引数を二つとって乗じる関数をpush
        try lua.push({ state in
            guard let state = state else {return 0}
            
            guard lua_gettop(state) >= 2,
                  lua_type(state, -1) == LuaType.Number.rawValue,
                  lua_type(state, -2) == LuaType.Number.rawValue
            else {return 0}
            
            let lhs = lua_tonumber(state, -1)
            let rhs = lua_tonumber(state, -2)
            lua_pop(state, 2)
            
            let result: Int64 = .init(lhs * rhs)
            lua_pushinteger(state, result)
            return 1
        })
        
        // グローバルに登録
        try lua.setGlobal(name: "mul")
        
        // luaから呼び出してみる
        let luaSemaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            try! lua.eval("""
                print("lhs pending")
                lhs = tonumber(io.read())
                print(lhs)
                print("rhs pending")
                rhs = tonumber(io.read())
                print(rhs)
                result = mul(lhs, rhs)
                print(result)
                io.write(result)
                io.flush()
            """)
            luaSemaphore.signal()
        }
        
        // 数値を二つ入力し
        let lhs = 3, rhs = 5
        try lua.stdin?.write(contentsOf: "\(lhs)\n\(rhs)\n".data(using: .ascii)!)
        
        // 読み出し
        let result = Int(String(data: lua.stdout!.availableData, encoding: .ascii)!)
        XCTAssertEqual(lhs * rhs, result)
    }
    
}
