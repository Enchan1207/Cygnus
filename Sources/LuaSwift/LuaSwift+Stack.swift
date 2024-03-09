//
//  Lua+Stack.swift
//  Luaスタックの操作
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaSwiftCore
import LuaSwiftMacros

public extension Lua {
    
    /// Luaが最低限保証するスタック容量
    var minimumStackCapacity: Int32 { LUA_MINSTACK }
    
    ///  Luaスタックの先頭位置
    var stackTop: Int32 {
        get{
            lua_gettop(state)
        }
        
        set{
            lua_settop(state, newValue)
        }
    }
    
    /// スタックに積まれている要素数 (エイリアス)
    var numberOfItems: Int32 { stackTop }
    
    /// インデックス範囲判定
    /// - Parameter index: インデックス
    internal func checkBounds(_ index: Int32) throws {
        let absoluteIndex = lua_absindex(state, index)
        guard absoluteIndex > 0 && absoluteIndex <= numberOfItems else {throw LuaError.IndexError}
    }
    
    /// スタックに積めるかを返す
    /// - Parameter n: 積みたい要素の数
    func check(atleast n: Int32) -> Bool {
        lua_checkstack(state, n) != 0
    }
    
    /// 真偽値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Bool) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushboolean(state, v ? 1 : 0)
    }
    
    /// 整数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Int) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        try push(.init(v))
    }
    
    /// 実数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Double) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushnumber(state, v)
    }
    
    /// 整数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Int64) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushinteger(state, v)
    }
    
    /// 文字列値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: String) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushstring(state, v)
    }
    
    /// 関数をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: lua_CFunction) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushcfunction(state, v)
    }
    
    /// nilをスタックに積む
    /// - Parameter v: 積む値
    func pushNil() throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushnil(state)
    }
    
    /// 指定位置の値をコピーしてスタックに積む
    /// - Parameter index: コピー元のインデックス
    func push(valueAt index: Int32) throws {
        guard check(atleast: 1) else {throw LuaError.StackError}
        lua_pushvalue(state, index)
    }
    
    /// 指定位置の値を削除する
    /// - Parameter index: 削除するインデックス
    func remove(at index: Int32) throws {
        try checkBounds(index)
        lua_remove(state, index)
    }
    
    /// スタック最上にある値を指定位置に挿入する
    /// - Parameter index: 挿入するインデックス
    func insert(at index: Int32) throws {
        try checkBounds(index)
        lua_insert(state, index)
    }
    
    /// 指定位置の値をスタック最上にある値に置換する
    /// - Parameter index: 置換するインデックス
    func replace(at index: Int32) throws {
        try checkBounds(index)
        lua_replace(state, index)
    }
    
    /// 指定された数の要素をスタックからポップ(破棄)する
    /// - Parameter count: ポップする要素数
    func pop(count: Int32 = 1) throws {
        guard numberOfItems >= count else {throw LuaError.StackError}
        lua_pop(state, count)
    }
    
    /// スタックを空にする
    func popAll() {
        guard numberOfItems > 0 else {return}
        lua_pop(state, numberOfItems)
    }
    
    /// Luaスタックの特定位置にある要素の型を返す
    /// - Parameter index: 位置 (デフォルト: 先頭)
    /// - Returns: 型
    func getType(at index: Int32 = -1) throws -> LuaType {
        try checkBounds(index)
        return LuaType(rawValue: lua_type(state, index))!
    }
    
    /// 指定位置の値を取り出す
    /// - Parameter index: 位置
    /// - Returns: 取り出された値
    func get<T>(at index: Int32 = -1) throws -> T {
        try checkBounds(index)
        
        switch (T.self, try getType(at: index)) {
            
            // TODO: 他のLuaTypeにも対応する
            
        case (is Int64.Type, .Number):
            return lua_tointeger(state, index) as! T
            
        case (is Int.Type, .Number):
            return Int(lua_tointeger(state, index)) as! T
            
        case (is Double.Type, .Number):
            return lua_tonumber(state, index) as! T
        
        case (is String.Type, .String):
            guard let stringPtr = lua_tostring(state, index) else {throw LuaError.TypeError}
            return String(cString: stringPtr) as! T
            
        case (is Bool.Type, .Boolean):
            return (lua_toboolean(state, index) != 0) as! T
        
        case (is lua_CFunction.Type, .Function):
            return lua_tocfunction(state, index) as! T
            
        default:
            throw LuaError.TypeError
        }
    }
}
