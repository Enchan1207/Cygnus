//
//  Lua+Error.swift
//  LuaVMのエラー
//
//  Created by EnchantCode on 2024/03/05.
//

/// Lua VMのエラー
public enum LuaError: Error {
    
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
}
