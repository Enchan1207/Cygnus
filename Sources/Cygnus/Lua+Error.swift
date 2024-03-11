//
//  Lua+Error.swift
//  LuaVMのエラー
//
//  Created by EnchantCode on 2024/03/05.
//
import CygnusCore

/// Lua VMのエラー
public enum LuaError: Error {
    
    /// Yield (LUA\_YIELD)
    case Yield
    
    /// ランタイムエラー (LUA\_ERRRUN)
    case RuntimeError(_ message: String)
    
    /// 構文エラー (LUA\_ERRSYNTAX)
    case SyntaxError(_ message: String)
    
    /// メモリエラー (LUA\_ERRMEM)
    case MemoryError(_ message: String)
    
    /// メッセージハンドリングエラー (LUA\_ERRERR)
    case MessageHandlingError(_ message: String)
    
    /// ファイルエラー (LUA\_ERRFILE)
    case FileError(_ message: String)
    
    /// 型エラー
    case TypeError(_ message: String)
    
    /// 不正インデックスエラー
    case IndexError(_ message: String)
    
    /// 不正な関数呼び出し
    case IllegalFunctionCall(_ message: String)
    
    /// Luaスタックに空きがないか、無にアクセスしようとした
    case StackError(_ message: String)
    
    /// Luaのステータスコードから初期化
    /// - Parameter statusCode: ステータスコード
    /// - Parameter message: メッセージ
    init?(statusCode: Int32, message: String? = nil) {
        let message = message ?? "(unknown)"
        switch statusCode {
        case LUA_YIELD:
            self = .Yield
        case LUA_ERRRUN:
            self = .RuntimeError(message)
        case LUA_ERRSYNTAX:
            self = .SyntaxError(message)
        case LUA_ERRMEM:
            self = .MemoryError(message)
        case LUA_ERRERR:
            self = .MessageHandlingError(message)
        case LUA_ERRFILE:
            self = .FileError(message)
        default:
            return nil
        }
    }
}

// MARK: - エラーメッセージの表記ゆれを回避するためのエイリアス
extension LuaError {
    
    /// スタックに余裕がない
    internal static let StackOverflow = LuaError.StackError("Stack overflow")
    
    /// スタックに何も積まれていない
    internal static let StackUnderflow = LuaError.StackError("Stack underflow")
    
    /// インデックス範囲外
    internal static let IndexOutOfRange = LuaError.IndexError("Index out of range")
    
    /// 型が一致しない
    /// - Parameters:
    ///   - expected: 予期された型
    ///   - actual: 実際の型
    /// - Returns: LuaError
    internal static func TypeMismatch(expected: Any.Type, actual: Any.Type) -> LuaError {
        LuaError.TypeError("Type mismatch. expected \(expected), but \(actual) passed.")
    }
    
    /// この型の値は当該処理をサポートしていない
    /// - Parameter type: 渡された型
    /// - Returns: LuaError
    internal static func UnsupportedType(_ type: Any.Type) -> LuaError {
        LuaError.TypeError("Unsupported type: \(type)")
    }
    
    /// このLua型の値は当該処理をサポートしていない
    /// - Parameter type: 渡されたLua型
    /// - Returns: LuaError
    internal static func UnsupportedType(_ type: LuaType) -> LuaError {
        LuaError.TypeError("Unsupported type: \(type)")
    }
    
}
