//
//  Lua.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaCore

internal typealias LuaState = UnsafeMutablePointer<lua_State>

/// Lua
public class Lua {
    
    /// Luaステート
    internal let state: LuaState
    
    /// Lua VMを初期化
    public init(){
        state = luaL_newstate()
        luaL_openlibs(state)
    }
    
    deinit {
        lua_close(state)
    }
    
}
