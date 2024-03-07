//
//  LuaSwift+Globals.swift
//  グローバル変数の操作
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore

public extension Lua {
    
    /// 指定した名称のグローバル変数を取得し、スタックに積む
    /// - Parameter name: 変数名
    /// - Returns: 変数の型
    @discardableResult
    func getGlobal(name: String) throws -> LuaType {
        guard check(atleast: 1) else {throw LuaError.StackError}
        return .init(rawValue: lua_getglobal(state, name))!
    }
    
    /// 指定した名称のグローバル変数をスタック最上段の値に設定する
    /// - Parameter name: 変数名
    func setGlobal(name: String) throws {
        guard numberOfItems > 0 else {throw LuaError.StackError}
        lua_setglobal(state, name)
    }
    
}
