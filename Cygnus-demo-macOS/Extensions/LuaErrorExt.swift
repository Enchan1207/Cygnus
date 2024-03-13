//
//  LuaErrorExt.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cygnus

extension LuaError {
    
    /// エラーの原因
    var reason: String {
        switch self {
        case .Yield:
            return "Coroutine yield"
        case .RuntimeError(let message):
            return message
        case .SyntaxError(let message):
            return message
        case .MemoryError(let message):
            return message
        case .MessageHandlingError(let message):
            return message
        case .FileError(let message):
            return message
        case .TypeError(let message):
            return message
        case .IndexError(let message):
            return message
        case .IllegalFunctionCall(let message):
            return message
        case .StackError(let message):
            return message
        }
    }
    
    /// エラー名
    var name: String {
        switch self {
        case .Yield:
            return "Lua coroutine yielded"
        case .RuntimeError(_):
            return "Lua runtime error"
        case .SyntaxError(_):
            return "Lua syntax error"
        case .MemoryError(_):
            return "Lua memory error"
        case .MessageHandlingError(_):
            return "Lua message handling error"
        case .FileError(_):
            return "Lua file error"
        case .TypeError(_):
            return "Lua type error"
        case .IndexError(_):
            return "Lua index error"
        case .IllegalFunctionCall(_):
            return "Lua illegal function error"
        case .StackError(_):
            return "Lua stack error"
        }
    }
}
