//
//  test_Exec.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import XCTest
@testable import Cygnus
@testable import CygnusCore
@testable import CygnusMacros

/// Luaコードの実行テスト
final class testExec: XCTestCase {
    
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
    
    /// 戻り値のない関数呼び出しのテスト
    func testCallNoRetFunction() throws {
        let lua = Lua()
        try lua.configureStandardIO()
        
        // print()
        let argument = "Hello, Lua!"
        try lua.getGlobal(name: "print")
        try lua.push(argument)
        try lua.call(argCount: 1, returnCount: 0)
        guard let output = lua.stdout?.availableData else {fatalError("Failed to capture output")}
        XCTAssertEqual(argument, String(data: output, encoding: .ascii))
    }
    
    /// 戻り値のある関数呼び出しのテスト
    func testCallFunctionWithReturn() throws {
        let lua = Lua()
        try lua.configureStandardIO()
        
        // string.lower()
        let argument = "HELLO, LUA!"
        try lua.getGlobal(name: "string")
        try lua.getField(key: "lower")
        try lua.push(argument)
        try lua.call(argCount: 1, returnCount: 1)
        guard lua.numberOfItems >= 1 else {fatalError("Expected 1 return value, but no value is stored in stack")}
        let result = try lua.get() as String
        XCTAssertEqual(argument.lowercased(), result)
    }
    
    /// カスタム関数の登録
    func testRegisterCustomFunction() throws {
        let lua = Lua()
        try lua.configureStandardIO()
        
        // 文字列をcapitalizeする関数を作成・登録
        let capitalize: lua_CFunction = {state in
            let lua = Lua(state: state!, owned: false)
            guard let argument = try? lua.get() as String else {return 0}
            try! lua.eval("print(\"\(argument.capitalized)\")")
            return 0
        }
        lua_pushcfunction(lua.state, capitalize)
        try lua.setGlobal(name: "capitalize")
        lua.popAll()
        
        // 呼び出して実行
        let input = "Hello! this is test text."
        try lua.getGlobal(name: "capitalize")
        try lua.push(input)
        try lua.call(argCount: 1, returnCount: 0)
        
        // 結果を取得
        guard let output = lua.stdout?.availableData,
              let outputString = String(data: output, encoding: .utf8) else {fatalError("Failed to capture output")}
        XCTAssertEqual(outputString, input.capitalized)
    }
    
}

fileprivate var outputStream: [String] = []
