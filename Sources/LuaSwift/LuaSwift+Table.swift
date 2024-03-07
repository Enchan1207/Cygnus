//
//  LuaSwift+Table.swift
//  テーブル関連の操作
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore

public extension Lua {
    
    func setField(index: Int32 = -1, key: String) throws {
        guard try getType(at: index) == .Table else {throw LuaError.TypeError}
        lua_setfield(state, index, key)
    }
    
    func getField(index: Int32 = -1, key: String) throws -> LuaType {
        guard try getType(at: index) == .Table else {throw LuaError.TypeError}
        return .init(rawValue: lua_getfield(state, index, key))!
    }
    
}
