//
//  Lua+Macros.swift
//  マクロとして定義されているものたち
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaCore

// MARK: - lua.h

/// #define LUA_REGISTRYINDEX    (-LUAI_MAXSTACK - 1000)
internal let LUA_REGISTRYINDEX = -LUAI_MAXSTACK - 1000

/// #define lua_call(L,n,r)        lua_callk(L, (n), (r), 0, NULL)
@inline(__always) internal func lua_call(_ L: LuaState, _ n: Int32, _ r: Int32){
    lua_callk(L, n, r, 0, nil)
}

/// #define lua_pcall(L,n,r,f)    lua_pcallk(L, (n), (r), (f), 0, NULL)
@inline(__always) internal func lua_pcall(_ L: LuaState, _ n: Int32, _ r: Int32, _ f: Int32) -> Int32 {
    lua_pcallk(L, n, r, f, 0, nil)
}

/// #define lua_yield(L,n)        lua_yieldk(L, (n), 0, NULL)
@inline(__always) internal func lua_yield(_ L: LuaState, _ n: Int32) -> Int32 {
    lua_yieldk(L, n, 0, nil)
}

/// #define lua_tonumber(L,i)    lua_tonumberx(L,(i),NULL)
@inline(__always) internal func lua_tonumber(_ L: LuaState, _ idx: Int32) throws -> lua_Number {
    var succeeded: Int32 = 0
    let result = lua_tonumberx(L, idx, &succeeded)
    guard succeeded != 0 else {throw LuaError.TypeError}
    return result
}

/// #define lua_tointeger(L,i)    lua_tointegerx(L,(i),NULL)
@inline(__always) internal func lua_tointeger(_ L: LuaState, _ idx: Int32) throws -> lua_Integer {
    var succeeded: Int32 = 0
    let result = lua_tointegerx(L, idx, &succeeded)
    guard succeeded != 0 else {throw LuaError.TypeError}
    return result
}

/// #define lua_pop(L,n)        lua_settop(L, -(n)-1)
@inline(__always) internal func lua_pop(_ L: LuaState, _ idx: Int32){
    lua_settop(L, -idx - 1)
}

/// #define lua_newtable(L)        lua_createtable(L, 0, 0)
@inline(__always) internal func lua_newtable(_ L: LuaState){
    lua_createtable(L, 0, 0)
}

/// #define lua_register(L,n,f) (lua_pushcfunction(L, (f)), lua_setglobal(L, (n)))
@inline(__always) internal func lua_register(_ L: LuaState, _ n: UnsafePointer<CChar>?, _ f: lua_CFunction){
    lua_pushcfunction(L, f)
    lua_setglobal(L, n)
}

/// #define lua_pushcfunction(L,f)    lua_pushcclosure(L, (f), 0)
@inline(__always) internal func lua_pushcfunction(_ L: LuaState, _ f: lua_CFunction){
    lua_pushcclosure(L, f, 0)
}

/// #define lua_isfunction(L,n)    (lua_type(L, (n)) == LUA_TFUNCTION)
@inline(__always) internal func lua_isfunction(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TFUNCTION
}

/// #define lua_istable(L,n)    (lua_type(L, (n)) == LUA_TTABLE)
@inline(__always) internal func lua_istable(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TTABLE
}

/// #define lua_islightuserdata(L,n)    (lua_type(L, (n)) == LUA_TLIGHTUSERDATA)
@inline(__always) internal func lua_islightuserdata(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TLIGHTUSERDATA
}

/// #define lua_isnil(L,n)        (lua_type(L, (n)) == LUA_TNIL)
@inline(__always) internal func lua_isnil(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TNIL
}

/// #define lua_isboolean(L,n)    (lua_type(L, (n)) == LUA_TBOOLEAN)
@inline(__always) internal func lua_isboolean(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TBOOLEAN
}

/// #define lua_isthread(L,n)    (lua_type(L, (n)) == LUA_TTHREAD)
@inline(__always) internal func lua_isthread(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TTHREAD
}

/// #define lua_isnone(L,n)        (lua_type(L, (n)) == LUA_TNONE)
@inline(__always) internal func lua_isnone(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) == LUA_TNONE
}

/// #define lua_isnoneornil(L, n)    (lua_type(L, (n)) <= 0)
@inline(__always) internal func lua_isnoneornil(_ L: LuaState, _ n: Int32) -> Bool {
    lua_type(L, n) <= 0
}

/// #define lua_pushliteral(L, s)    lua_pushstring(L, "" s)
@inline(__always) internal func lua_pushliteral(_ L: LuaState, _ s: UnsafePointer<CChar>) {
    lua_pushstring(L, s)
}

/// #define lua_pushglobaltable(L) ((void)lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS))
@inline(__always) internal func lua_pushglobaltable(_ L: LuaState) {
    lua_rawgeti(L, LUA_REGISTRYINDEX, .init(LUA_RIDX_GLOBALS))
}

/// #define lua_tostring(L,i)    lua_tolstring(L, (i), NULL)
@inline(__always) internal func lua_tostring(_ L: LuaState, _ i: Int32) -> UnsafePointer<CChar>! {
    lua_tolstring(L, i, nil)
}

/// #define lua_insert(L,idx)    lua_rotate(L, (idx), 1)
@inline(__always) internal func lua_insert(_ L: LuaState, _ idx: Int32) {
    lua_rotate(L, idx, 1)
}

/// #define lua_remove(L,idx)    (lua_rotate(L, (idx), -1), lua_pop(L, 1))
@inline(__always) internal func lua_remove(_ L: LuaState, _ idx: Int32){
    lua_rotate(L, idx, -1)
    lua_pop(L, 1)
}

/// #define lua_replace(L,idx)    (lua_copy(L, -1, (idx)), lua_pop(L, 1))
@inline(__always) internal func lua_replace(_ L: LuaState, _ idx: Int32) {
    lua_copy(L, -1, idx)
    lua_pop(L, 1)
}

// MARK: - lauxlib.h

internal let LUAL_NUMSIZES = MemoryLayout<lua_Integer>.size * 16 + MemoryLayout<lua_Number>.size

/// #define luaL_checkversion(L) luaL_checkversion_(L, LUA_VERSION_NUM, LUAL_NUMSIZES)
@inline(__always) internal func luaL_checkversion(_ L: LuaState) {
    luaL_checkversion_(L, .init(LUA_VERSION_NUM), LUAL_NUMSIZES)
}

/// #define luaL_loadfile(L,f)    luaL_loadfilex(L,f,NULL)
@inline(__always) internal func luaL_loadfile(_ L: LuaState, _ f: UnsafePointer<CChar>!) -> Int32 {
    luaL_loadfilex(L, f, nil)
}

/// #define luaL_newlibtable(L,l) lua_createtable(L, 0, sizeof(l)/sizeof((l)[0]) - 1)
@inline(__always) internal func luaL_newlibtable(_ L: LuaState, _ l: [luaL_Reg]) {
    lua_createtable(L, 0, .init(l.count / MemoryLayout<luaL_Reg>.size - 1))
}

/// #define luaL_newlib(L,l) (luaL_checkversion(L), luaL_newlibtable(L,l), luaL_setfuncs(L,l,0))
@inline(__always) internal func luaL_newlib(_ L: LuaState, _ l: [luaL_Reg]) {
    luaL_checkversion(L)
    luaL_newlibtable(L, l)
    luaL_setfuncs(L, l, 0)
}

/// #define luaL_argcheck(L, cond,arg,extramsg) ((void)(luai_likely(cond) || luaL_argerror(L, (arg), (extramsg))))
@inline(__always) internal func luaL_argcheck(_ L: LuaState, _ cond: Bool, _ arg: Int32, _ extramsg: UnsafePointer<CChar>!) {
    guard !cond else {return}
    luaL_argerror(L, arg, extramsg)
}

/// #define luaL_argexpected(L,cond,arg,tname) ((void)(luai_likely(cond) || luaL_typeerror(L, (arg), (tname))))
@inline(__always) internal func luaL_argexpected(_ L: LuaState, _ cond: Bool, _ arg: Int32, _ tname: UnsafePointer<CChar>!) {
    guard !cond else {return}
    luaL_typeerror(L, arg, tname)
}

/// #define luaL_checkstring(L,n) (luaL_checklstring(L, (n), NULL))
@inline(__always) internal func luaL_checkstring(_ L: LuaState, _ n: Int32) -> UnsafePointer<CChar>!{
    luaL_checklstring(L, n, nil)
}

/// #define luaL_optstring(L,n,d)    (luaL_optlstring(L, (n), (d), NULL))
@inline(__always) internal func luaL_optstring(_ L: LuaState, _ n: Int32, d: UnsafePointer<CChar>!) -> UnsafePointer<CChar>! {
    luaL_optlstring(L, n, d, nil)
}

/// #define luaL_typename(L,i)    lua_typename(L, lua_type(L,(i)))
@inline(__always) internal func luaL_typename(_ L: LuaState, _ i: Int32) -> UnsafePointer<CChar>! {
    lua_typename(L, lua_type(L, i))
}

/// #define luaL_dofile(L, fn) (luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0))
@inline(__always) internal func luaL_dofile(_ L: LuaState, _ fn: UnsafePointer<CChar>!) -> Int32 {
    guard luaL_loadfile(L, fn) == 0 else {return 1}
    return lua_pcall(L, 0, LUA_MULTRET, 0)
}


/// #define luaL_dostring(L, s) (luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))
@inline(__always) internal func luaL_dostring(_ L: LuaState, s: UnsafePointer<CChar>!) -> Int32 {
    guard luaL_loadstring(L, s) == 0 else {return 1}
    return lua_pcall(L, 0, LUA_MULTRET, 0)
}

/// #define luaL_getmetatable(L,n)    (lua_getfield(L, LUA_REGISTRYINDEX, (n)))
@inline(__always) internal func luaL_getmetatable(_ L: LuaState, _ n: UnsafePointer<CChar>!) -> Int32 {
    lua_getfield(L, LUA_REGISTRYINDEX, n)
}

/// #define luaL_opt(L,f,n,d)    (lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))
@inline(__always) internal func luaL_opt(_ L: LuaState, _ f: (LuaState, Int32) -> Int32, _ n: Int32, _ d: Int32) -> Int32 {
    lua_isnoneornil(L, n) ? d : f(L, n)
}

/// #define luaL_loadbuffer(L,s,sz,n)    luaL_loadbufferx(L,s,sz,n,NULL)
@inline(__always) internal func luaL_loadbuffer(_ L: LuaState, _ s: UnsafePointer<CChar>!, _ sz: Int, _ n: UnsafePointer<CChar>!) -> Int32 {
    luaL_loadbufferx(L, s, sz, n, nil)
}
