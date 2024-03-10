//
//  LuaSwift+Table.swift
//  テーブル関連の操作
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore

public extension Lua {
    
    /// テーブルの指定したフィールドスタックトップの値に設定する
    /// - Parameters:
    ///   - index: スタック上でのテーブルオブジェクトの位置
    ///   - key: 設定するフィールド名
    func setField(index: Int32 = -1, key: String) throws {
        let elementType = try getType(at: index)
        guard elementType == .Table else {throw LuaError.UnsupportedType(elementType)}
        lua_setfield(state, index, key)
    }
    
    /// テーブルのフィールドを取得する
    /// - Parameters:
    ///   - index: スタック上でのテーブルオブジェクトの位置
    ///   - key: 取得するフィールド名
    /// - Returns: フィールドに対応するオブジェクト
    @discardableResult
    func getField(index: Int32 = -1, key: String) throws -> LuaType {
        let elementType = try getType(at: index)
        guard elementType == .Table else {throw LuaError.UnsupportedType(elementType)}
        return .init(rawValue: lua_getfield(state, index, key))!
    }
    
}
