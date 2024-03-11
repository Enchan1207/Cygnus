//
//  Lua+Type.swift
//  型関連
//
//  Created by EnchantCode on 2024/03/05.
//

import CygnusCore

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
            return LUA_TNONE
        case .Nil:
            return LUA_TNIL
        case .Boolean:
            return LUA_TBOOLEAN
        case .LightUserData:
            return LUA_TLIGHTUSERDATA
        case .Number:
            return LUA_TNUMBER
        case .String:
            return LUA_TSTRING
        case .Table:
            return LUA_TTABLE
        case .Function:
            return LUA_TFUNCTION
        case .UserData:
            return LUA_TUSERDATA
        case .Thread:
            return LUA_TTHREAD
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
            return "none"
        case .Nil:
            return "nil"
        case .Boolean:
            return "boolean"
        case .LightUserData:
            return "light user data"
        case .Number:
            return "number"
        case .String:
            return "string"
        case .Table:
            return "table"
        case .Function:
            return "function"
        case .UserData:
            return "user data"
        case .Thread:
            return "thread"
        }
    }
}
