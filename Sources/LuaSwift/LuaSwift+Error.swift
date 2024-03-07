//
//  Lua+Error.swift
//  LuaVMのエラー
//
//  Created by EnchantCode on 2024/03/05.
//
import LuaSwiftCore

/// Lua VMのエラー
public enum LuaError: Error {
    
    /// Yield (LUA\_YIELD)
    case Yield
    
    /// ランタイムエラー (LUA\_ERRRUN)
    case RuntimeError
    
    /// 構文エラー (LUA\_ERRSYNTAX)
    case SyntaxError
    
    /// メモリエラー (LUA\_ERRMEM)
    case MemoryError
    
    /// メッセージハンドリングエラー (LUA\_ERRERR)
    case MessageHandlingError
    
    /// ファイルエラー (LUA\_ERRFILE)
    case FileError
    
    /// 型エラー
    case TypeError
    
    /// 不正インデックスエラー
    case IndexError
    
    /// 不正な関数呼び出し
    case IllegalFunctionCall
    
    /// Luaスタックに空きがない
    case StackOverflow
    
    /// Luaのステータスコードから初期化
    /// - Parameter statusCode: ステータスコード
    init?(statusCode: Int32) {
        switch statusCode {
        case LUA_YIELD:
            self = .Yield
        case LUA_ERRRUN:
            self = .RuntimeError
        case LUA_ERRSYNTAX:
            self = .SyntaxError
        case LUA_ERRMEM:
            self = .MemoryError
        case LUA_ERRERR:
            self = .MessageHandlingError
        case LUA_ERRFILE:
            self = .FileError
        default:
            return nil
        }
    }
}
