//
//  test_LuaStack.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import XCTest
@testable import Lua

/// Luaスタックのテスト
final class testLuaStack: XCTestCase {
    
    /// 基本的なスタックの操作
    func testPushPop(){
        let lua = Lua()
        
        let initialTop = lua.stackTop
        
        // 一つ積む
        lua.push("Test")
        XCTAssertEqual(lua.stackTop, initialTop + 1)
        
        // 続けて積む
        lua.pushNil()
        lua.push(false)
        lua.push(123)
        XCTAssertEqual(lua.stackTop, initialTop + 4)
        
        // 2つpopする
        lua.pop(count: 2)
        XCTAssertEqual(lua.stackTop, initialTop + 2)
        XCTAssertEqual(try! lua.getType(), LuaType.Nil)
        
        // また積む
        lua.push(true)
        lua.push(2.34)
        XCTAssertEqual(try! lua.getType(), LuaType.Number)
        
        // 1つpopする
        lua.pop()
        XCTAssertEqual(try! lua.getType(), LuaType.Boolean)
    }
    
    // 様々な操作
    func testVariousOperations(){
        let lua = Lua()
        
        // データを作っておく
        // 上から b n ? n s
        lua.push("Hello!")
        lua.push(456)
        lua.pushNil()
        lua.push(3.14)
        lua.push(true)
        
        /**
         Luaスタックのインデックスは、正数の場合は下(最初にpushしたもの)を、負数の場合は上(最後にpushしたもの)を指す
         */
        
        // コピーする
        // これにより s b n ? n s となる
        lua.push(valueAt: 1)
        XCTAssertEqual(try! lua.getType(), .String)
        
        // 3番目に1番目の要素を挿入
        // これにより b n ? s n s となる
        lua.insert(at: 3)
        XCTAssertEqual(try! lua.getType(), .Boolean)
        XCTAssertEqual(try! lua.getType(at: -2), .Number)
        XCTAssertEqual(try! lua.getType(at: -3), .Nil)
        
        // 2番目の要素を削除
        // これにより b n ? s s となる
        lua.remove(at: 2)
        XCTAssertEqual(try! lua.getType(at: 1), .String)
        XCTAssertEqual(try! lua.getType(at: 2), .String)
        XCTAssertEqual(try! lua.getType(at: 3), .Nil)
        XCTAssertEqual(lua.stackTop, 5)
        
        // 先頭の要素を3番目に移動(上書き)
        // これにより n b s s となる
        lua.replace(at: 3)
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
        lua.push("Hello!")
        lua.push(456)
        lua.pushNil()
        lua.push(3.14)
        lua.push(true)
        
        // 成功例
        let boolValue: Bool = try lua.get()
        XCTAssertTrue(boolValue)
        lua.pop()
        
        let doubleValue: Double = try lua.get()
        XCTAssertEqual(doubleValue, 3.14)
        lua.pop()
        
        XCTAssertEqual(try! lua.getType(), .Nil)
        lua.pop()
        
        // 整数を実数として受け取ることは可能
        let intValue: Int = try lua.get()
        XCTAssertEqual(intValue, 456)
        let doubleValue2: Double = try lua.get()
        XCTAssertEqual(doubleValue2, 456)
        lua.pop()
        
        let stringValue: String = try lua.get()
        XCTAssertEqual(stringValue, "Hello!")
        lua.pop()
        
        // 失敗例
        lua.push("ABCDE")
        XCTAssertThrowsError(try lua.get() as Int)
        lua.pop()
        
        // 自動型キャストはされない
        lua.push("123")
        XCTAssertThrowsError(try lua.get() as Int)
        lua.pop()
        
        lua.push(true)
        XCTAssertThrowsError(try lua.get() as Int)
        lua.pop()
        
        lua.push(12345)
        XCTAssertThrowsError(try lua.get() as String)
        lua.pop()
    }
    
}
