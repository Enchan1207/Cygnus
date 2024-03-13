//
//  LuaExt.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cygnus
import CygnusCore

extension Lua {
    
    /// インスタンスに関数を登録する
    /// - Parameters:
    ///   - function: 関数
    ///   - name: Luaから呼び出す時の関数名
    func register(function: lua_CFunction, for name: String) throws {
        try push(function)
        try setGlobal(name: name)
    }
    
}
