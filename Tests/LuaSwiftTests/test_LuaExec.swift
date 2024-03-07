//
//  test_LuaExec.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import XCTest
@testable import LuaSwift
@testable import LuaSwiftCore
@testable import LuaSwiftMacros

/// Luaコードの実行テスト
final class testLuaExec: XCTestCase {
    
    /// 1行ずつ評価していく
    func testEvaluateSingleStatements() throws {
        let lua = Lua()
        
        let a = 123
        try lua.eval("a = \(a)")
        let b = 456
        try lua.eval("b = \(b)")
        try lua.eval("c = a + b")
        
        lua_getglobal(lua.state, "c")
        let result: Int = try lua.get()
        XCTAssertEqual(result, a + b)
    }
    
    /// まとめて実行
    func testEvaluateCode() throws {
        // Luaを初期化し、print文を置き換える
        let lua = Lua()
        lua_pushcfunction(lua.state, {state in
            let argsCount = lua_gettop(state!)
            outputStream.append((1...argsCount).map({String(cString: lua_tostring(state!, $0))}).joined(separator: " "))
            return 0
        })
        lua_setglobal(lua.state, "print")
        
        // コードを用意
        let limit = 100
        let code = """
        --
        -- FizzBuzz
        --
        
        -- 最大値を設定
        local limit = \(limit)
        
        --カウントアップ
        for n = 1, limit do
            if n % 3 == 0 and n % 5 == 0 then
                print("FizzBuzz")
            elseif n % 3 == 0 then
                print("Fizz")
            elseif n % 5 == 0 then
                print("Buzz")
            else
                print(n)
            end
        end
        """
        
        // 実行
        try lua.eval(code)
        
        let expected: [String] = (1...100).map{
            if $0 % 3 == 0 && $0 % 5 == 0 {
                "FizzBuzz"
            }else if $0 % 3 == 0 {
                "Fizz"
            }else if $0 % 5 == 0 {
                "Buzz"
            }else{
                "\($0)"
            }
        }
        
        // 同じ結果が得られるはず
        XCTAssertEqual(expected, outputStream)
    }
    
    /// yieldのテスト
    func testYield() throws {
        let lua = Lua()
        
        // これは通る
        let value = 123
        try lua.eval("a = \(value)")
        
        // これは通らない となるとREPLは一体どんな仕組みになっているのか…?
        do {
            try lua.eval("a")
        } catch LuaError.SyntaxError {
            print("Syntax error: \(try lua.get() as String)")
        }
    }
    
}

fileprivate var outputStream: [String] = []
