//
//  test_LuaSwiftTests.swift
//
//
//  Created by EnchantCode on 2024/03/04.
//

import XCTest
@testable import LuaSwift

typealias LuaState = UnsafeMutablePointer<lua_State>

final class test_LuaSwiftTests: XCTestCase {
    
    /// Luaステートの生成・破棄
    func testCreateLuaState() throws {
        // Luaの状態を新しく生成し、保持
        let luaState: LuaState = luaL_newstate()
        
        // 標準ライブラリの関数を使えるようにする
        luaL_openlibs(luaState)
        
        // 状態を終了し、閉じる
        lua_close(luaState)
    }
    
}
