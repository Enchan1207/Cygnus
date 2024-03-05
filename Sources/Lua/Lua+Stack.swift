//
//  Lua+Stack.swift
//  Luaスタックの操作
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaCore

public extension Lua {
    
    /// スタック最小値
    var minStack: Int32 { LUA_MINSTACK }
    
    ///  Luaスタックの先頭位置
    var stackTop: Int32 {
        get{
            lua_gettop(state)
        }
        
        set{
            lua_settop(state, newValue)
        }
    }
    
    /// スタックに積めるかを返す
    /// - Parameter n: 積みたい要素の数
    func check(atleast n: Int32) -> Bool {
        lua_checkstack(state, n) != 0
    }
    
    /// 真偽値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Bool){
        lua_pushboolean(state, v ? 1 : 0)
    }
    
    /// 整数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Int){
        push(.init(v))
    }
    
    /// 実数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Double){
        lua_pushnumber(state, v)
    }
    
    /// 整数値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: Int64){
        lua_pushinteger(state, v)
    }
    
    /// 文字列値をスタックに積む
    /// - Parameter v: 積む値
    func push(_ v: String){
        lua_pushstring(state, v)
    }
    
    /// nilをスタックに積む
    /// - Parameter v: 積む値
    func pushNil(){
        lua_pushnil(state)
    }
    
    /// 指定位置の値をコピーしてスタックに積む
    /// - Parameter index: コピー元のインデックス
    func push(valueAt index: Int32){
        lua_pushvalue(state, index)
    }
    
    /// 指定位置の値を削除する
    /// - Parameter index: 削除するインデックス
    func remove(at index: Int32){
        lua_remove(state, index)
    }
    
    /// スタック最上にある値を指定位置に挿入する
    /// - Parameter index: 挿入するインデックス
    func insert(at index: Int32){
        lua_insert(state, index)
    }
    
    /// 指定位置の値をスタック最上にある値に置換する
    /// - Parameter index: 置換するインデックス
    func replace(at index: Int32){
        lua_replace(state, index)
    }
    
    /// 指定された数の要素をスタックからポップ(破棄)する
    /// - Parameter count: ポップする要素数
    func pop(count: Int32 = 1){
        lua_pop(state, count)
    }
    
}
