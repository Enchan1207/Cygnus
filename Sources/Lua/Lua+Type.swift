//
//  Lua+Type.swift
//  型関連
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaCore

/// Luaが扱う型
public enum LuaType: Int32 {
    
    /// インデックス範囲外の時に返される
    case None
    
    /// nil
    case Nil
    
    /// 真偽値
    case Boolean
    
    /// 軽量ユーザデータ
    case LightUserData
    
    /// 数値
    case Number
    
    /// 文字列
    case String
    
    /// テーブル
    case Table
    
    /// 関数
    case Function
    
    /// ユーザデータ
    case UserData
    
    /// スレッド
    case Thread
    
    public var rawValue: Int32 {
        switch self {
        case .None:
            LUA_TNONE
        case .Nil:
            LUA_TNIL
        case .Boolean:
            LUA_TBOOLEAN
        case .LightUserData:
            LUA_TLIGHTUSERDATA
        case .Number:
            LUA_TNUMBER
        case .String:
            LUA_TSTRING
        case .Table:
            LUA_TTABLE
        case .Function:
            LUA_TFUNCTION
        case .UserData:
            LUA_TUSERDATA
        case .Thread:
            LUA_TTHREAD
        }
    }
    
    public init?(rawValue: Int32) {
        switch rawValue {
        case LUA_TNONE:
            self = .None
        case LUA_TNIL:
            self = .Nil
        case LUA_TBOOLEAN:
            self = .Boolean
        case LUA_TLIGHTUSERDATA:
            self = .LightUserData
        case LUA_TNUMBER:
            self = .Number
        case LUA_TSTRING:
            self = .String
        case LUA_TTABLE:
            self = .Table
        case LUA_TFUNCTION:
            self = .Function
        case LUA_TUSERDATA:
            self = .UserData
        case LUA_TTHREAD:
            self = .Thread
        default:
            return nil
        }
    }
    
    public var name: String {
        switch self {
        case .None:
            "none"
        case .Nil:
            "nil"
        case .Boolean:
            "boolean"
        case .LightUserData:
            "light user data"
        case .Number:
            "number"
        case .String:
            "string"
        case .Table:
            "table"
        case .Function:
            "function"
        case .UserData:
            "user data"
        case .Thread:
            "thread"
        }
    }
}

public extension Lua {
    
    /// Luaスタックの特定位置にある要素の型を返す
    /// - Parameter index: 位置 (デフォルト: 先頭)
    /// - Returns: 型
    func type(at index: Int32 = -1) -> LuaType {
        .init(rawValue: lua_type(state, index))!
    }
    
}
