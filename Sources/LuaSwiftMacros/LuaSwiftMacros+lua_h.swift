//
//  LuaSwiftMacros+lua_h.swift
//  lua.hで定義されているマクロ
//
//  Created by EnchantCode on 2024/03/07.
//

import LuaSwiftCore

/// #define LUA_REGISTRYINDEX    (-LUAI_MAXSTACK - 1000)
internal let LUA_REGISTRYINDEX = -LUAI_MAXSTACK - 1000

/// #define lua_call(L,n,r)        lua_callk(L, (n), (r), 0, NULL)
@inline(__always) public func lua_call(_ L: LuaState, _ n: Int32, _ r: Int32){
    lua_callk(L, n, r, 0, nil)
}

/// #define lua_pcall(L,n,r,f)    lua_pcallk(L, (n), (r), (f), 0, NULL)
@inline(__always) public func lua_pcall(_ L: LuaState, _ n: Int32, _ r: Int32, _ f: Int32) -> Int32 {
    lua_pcallk(L, n, r, f, 0, nil)
}

/// #define lua_yield(L,n)        lua_yieldk(L, (n), 0, NULL)
@inline(__always) public func lua_yield(_ L: LuaState, _ n: Int32) -> Int32 {
    lua_yieldk(L, n, 0, nil)
}

/// #define lua_tonumber(L,i)    lua_tonumberx(L,(i),NULL)
@inline(__always) public func lua_tonumber(_ L: LuaState, _ idx: Int32) throws -> lua_Number {
    lua_tonumberx(L, idx, nil)
}

/// #define lua_tointeger(L,i)    lua_tointegerx(L,(i),NULL)
@inline(__always) public func lua_tointeger(_ L: LuaState, _ idx: Int32) throws -> lua_Integer {
    lua_tointegerx(L, idx, nil)
}

/// #define lua_pop(L,n)        lua_settop(L, -(n)-1)
@inline(__always) public func lua_pop(_ L: LuaState, _ idx: Int32){
    lua_settop(L, -idx - 1)
}

/// #define lua_newtable(L)        lua_createtable(L, 0, 0)
@inline(__always) public func lua_newtable(_ L: LuaState){
    lua_createtable(L, 0, 0)
}

/// #define lua_register(L,n,f) (lua_pushcfunction(L, (f)), lua_setglobal(L, (n)))
@inline(__always) public func lua_register(_ L: LuaState, _ n: UnsafePointer<CChar>?, _ f: lua_CFunction){
    lua_pushcfunction(L, f)
    lua_setglobal(L, n)
}

/// #define lua_pushcfunction(L,f)    lua_pushcclosure(L, (f), 0)
@inline(__always) public func lua_pushcfunction(_ L: LuaState, _ f: lua_CFunction){
    lua_pushcclosure(L, f, 0)
}

/// #define lua_isfunction(L,n)    (lua_type(L, (n)) == LUA_TFUNCTION)
@inline(__always) public func lua_isfunction(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TFUNCTION
}

/// #define lua_istable(L,n)    (lua_type(L, (n)) == LUA_TTABLE)
@inline(__always) public func lua_istable(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TTABLE
}

/// #define lua_islightuserdata(L,n)    (lua_type(L, (n)) == LUA_TLIGHTUSERDATA)
@inline(__always) public func lua_islightuserdata(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TLIGHTUSERDATA
}

/// #define lua_isnil(L,n)        (lua_type(L, (n)) == LUA_TNIL)
@inline(__always) public func lua_isnil(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TNIL
}

/// #define lua_isboolean(L,n)    (lua_type(L, (n)) == LUA_TBOOLEAN)
@inline(__always) public func lua_isboolean(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TBOOLEAN
}

/// #define lua_isthread(L,n)    (lua_type(L, (n)) == LUA_TTHREAD)
@inline(__always) public func lua_isthread(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TTHREAD
}

/// #define lua_isnone(L,n)        (lua_type(L, (n)) == LUA_TNONE)
@inline(__always) public func lua_isnone(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TNONE
}

/// #define lua_isnoneornil(L, n)    (lua_type(L, (n)) <= 0)
@inline(__always) public func lua_isnoneornil(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) <= 0
}

/// #define lua_pushliteral(L, s)    lua_pushstring(L, "" s)
@inline(__always) public func lua_pushliteral(_ L: LuaState, _ s: UnsafePointer<CChar>) {
    lua_pushstring(L, s)
}

/// #define lua_pushglobaltable(L) ((void)lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS))
@inline(__always) public func lua_pushglobaltable(_ L: LuaState) {
    lua_rawgeti(L, LUA_REGISTRYINDEX, .init(LUA_RIDX_GLOBALS))
}

/// #define lua_tostring(L,i)    lua_tolstring(L, (i), NULL)
@inline(__always) public func lua_tostring(_ L: LuaState, _ i: Int32) -> UnsafePointer<CChar>! {
    lua_tolstring(L, i, nil)
}

/// #define lua_insert(L,idx)    lua_rotate(L, (idx), 1)
@inline(__always) public func lua_insert(_ L: LuaState, _ idx: Int32) {
    lua_rotate(L, idx, 1)
}

/// #define lua_remove(L,idx)    (lua_rotate(L, (idx), -1), lua_pop(L, 1))
@inline(__always) public func lua_remove(_ L: LuaState, _ idx: Int32){
    lua_rotate(L, idx, -1)
    lua_pop(L, 1)
}

/// #define lua_replace(L,idx)    (lua_copy(L, -1, (idx)), lua_pop(L, 1))
@inline(__always) public func lua_replace(_ L: LuaState, _ idx: Int32) {
    lua_copy(L, -1, idx)
    lua_pop(L, 1)
}

