//
//  test_Error.swift
//  
//
//  Created by EnchantCode on 2024/03/10.
//

import XCTest
@testable import Cygnus
@testable import CygnusCore
@testable import CygnusMacros

/// いろんな環境のエラーを起こしてみる
final class testError: XCTestCase {
    
    func testStackError() throws {
        // 無を取得
        let lua = Lua()
        do {
            _ = try lua.get() as Int
        } catch LuaError.IndexError(_) {}
        
        // 範囲外remove
        do {
            _ = try lua.remove(at: -1)
        } catch LuaError.IndexError(_) {}
        
        // 範囲外pop
        do {
            _ = try lua.pop(count: 10)
        } catch LuaError.StackError(_) {}
        
        // 非対応typeのget
        lua.popAll()
        try lua.pushNil()
        do {
            _ = try lua.get() as testError
        } catch LuaError.TypeError(_) {}
        
        // 非tableオブジェクトに対するフィールド操作
        do {
            _ = try lua.getField(key: "test")
        } catch LuaError.TypeError(_) {}
        try lua.pushNil()
        do {
            _ = try lua.setField(key: "test")
        } catch LuaError.TypeError(_) {}
        
        // 不正なファイル呼び出し
        do {
            _ = try lua.load(file: "/")
        } catch LuaError.FileError(_) {}
        
        // 不正なプログラムの実行
        do {
            try lua.eval("this is invalid code")
        } catch LuaError.SyntaxError(_) {}
        
        // 関数でないものを無理やり呼び出す
        lua.popAll()
        try lua.push("no function")
        try lua.push("argument")
        do {
            _ = try lua.call(argCount: 1, returnCount: 0)
        } catch LuaError.RuntimeError(_) {}
        
        
    }
    
}
