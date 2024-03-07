//
//  LuaSwiftMacros+lauxlib_h.swift
//  lauxlib.hで定義されているマクロ
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore

/// #define LUAL_NUMSIZES    (sizeof(lua_Integer)*16 + sizeof(lua_Number))
internal let LUAL_NUMSIZES = MemoryLayout<lua_Integer>.size * 16 + MemoryLayout<lua_Number>.size

/// #define luaL_checkversion(L) luaL_checkversion_(L, LUA_VERSION_NUM, LUAL_NUMSIZES)
@inline(__always) public func luaL_checkversion(_ L: LuaState) {
    luaL_checkversion_(L, .init(LUA_VERSION_NUM), LUAL_NUMSIZES)
}

/// #define luaL_loadfile(L,f)    luaL_loadfilex(L,f,NULL)
@inline(__always) public func luaL_loadfile(_ L: LuaState, _ f: UnsafePointer<CChar>!) -> Int32 {
    luaL_loadfilex(L, f, nil)
}

/// #define luaL_newlibtable(L,l) lua_createtable(L, 0, sizeof(l)/sizeof((l)[0]) - 1)
@inline(__always) public func luaL_newlibtable(_ L: LuaState, _ l: [luaL_Reg]) {
    lua_createtable(L, 0, .init(l.count / MemoryLayout<luaL_Reg>.size - 1))
}

/// #define luaL_newlib(L,l) (luaL_checkversion(L), luaL_newlibtable(L,l), luaL_setfuncs(L,l,0))
@inline(__always) public func luaL_newlib(_ L: LuaState, _ l: [luaL_Reg]) {
    luaL_checkversion(L)
    luaL_newlibtable(L, l)
    luaL_setfuncs(L, l, 0)
}

/// #define luaL_argcheck(L, cond,arg,extramsg) ((void)(luai_likely(cond) || luaL_argerror(L, (arg), (extramsg))))
@inline(__always) public func luaL_argcheck(_ L: LuaState, _ cond: Bool, _ arg: Int32, _ extramsg: UnsafePointer<CChar>!) {
    guard !cond else {return}
    luaL_argerror(L, arg, extramsg)
}

/// #define luaL_argexpected(L,cond,arg,tname) ((void)(luai_likely(cond) || luaL_typeerror(L, (arg), (tname))))
@inline(__always) public func luaL_argexpected(_ L: LuaState, _ cond: Bool, _ arg: Int32, _ tname: UnsafePointer<CChar>!) {
    guard !cond else {return}
    luaL_typeerror(L, arg, tname)
}

/// #define luaL_checkstring(L,n) (luaL_checklstring(L, (n), NULL))
@inline(__always) public func luaL_checkstring(_ L: LuaState, _ n: Int32) -> UnsafePointer<CChar>!{
    luaL_checklstring(L, n, nil)
}

/// #define luaL_optstring(L,n,d)    (luaL_optlstring(L, (n), (d), NULL))
@inline(__always) public func luaL_optstring(_ L: LuaState, _ n: Int32, d: UnsafePointer<CChar>!) -> UnsafePointer<CChar>! {
    luaL_optlstring(L, n, d, nil)
}

/// #define luaL_typename(L,i)    lua_typename(L, lua_type(L,(i)))
@inline(__always) public func luaL_typename(_ L: LuaState, _ i: Int32) -> UnsafePointer<CChar>! {
    lua_typename(L, lua_type(L, i))
}

/// #define luaL_dofile(L, fn) (luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0))
@available(*, deprecated, message: "This macros return value is incompliant to rawValue of LuaError.")
@inline(__always) public func luaL_dofile(_ L: LuaState, _ fn: UnsafePointer<CChar>!) -> Int32 {
    guard luaL_loadfile(L, fn) == 0 else {return 1}
    return lua_pcall(L, 0, LUA_MULTRET, 0)
}


/// #define luaL_dostring(L, s) (luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))
@available(*, deprecated, message: "This macros return value is incompliant to rawValue of LuaError.")
@inline(__always) public func luaL_dostring(_ L: LuaState, s: UnsafePointer<CChar>!) -> Int32 {
    guard luaL_loadstring(L, s) == 0 else {return 1}
    return lua_pcall(L, 0, LUA_MULTRET, 0)
}

/// #define luaL_getmetatable(L,n)    (lua_getfield(L, LUA_REGISTRYINDEX, (n)))
@inline(__always) public func luaL_getmetatable(_ L: LuaState, _ n: UnsafePointer<CChar>!) -> Int32 {
    lua_getfield(L, LUA_REGISTRYINDEX, n)
}

/// #define luaL_opt(L,f,n,d)    (lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))
@inline(__always) public func luaL_opt(_ L: LuaState, _ f: (LuaState, Int32) -> Int32, _ n: Int32, _ d: Int32) -> Int32 {
    lua_isnoneornil(L, n) ? d : f(L, n)
}

/// #define luaL_loadbuffer(L,s,sz,n)    luaL_loadbufferx(L,s,sz,n,NULL)
@inline(__always) public func luaL_loadbuffer(_ L: LuaState, _ s: UnsafePointer<CChar>!, _ sz: Int, _ n: UnsafePointer<CChar>!) -> Int32 {
    luaL_loadbufferx(L, s, sz, n, nil)
}

