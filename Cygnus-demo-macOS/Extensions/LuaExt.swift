//
//  LuaExt.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cygnus
import CygnusCore

extension Lua {
    
    /// インスタンスに関数を登録する
    /// - Parameters:
    ///   - function: 関数
    ///   - name: Luaから呼び出す時の関数名
    func register(function: lua_CFunction, for name: String) throws {
        try push(function)
        try setGlobal(name: name)
    }
    
    /// 関数チェック時のエラー
    fileprivate enum ArgumentError: Error {
        
        /// 個数が合わない
        case Insufficient(expected: Int, actual: Int)
        
        /// 型が合わない
        case TypeMismatch(at: Int, expected: LuaType, actual: LuaType)
    }
    
    /// 関数呼び出し時の引数チェック
    /// - Parameter argTypes: 引数として予期される型の配列
    /// - Returns: 正しい引数が渡っているかどうか
    /// - Note: 不正な引数が渡された場合はエラーメッセージをスタックに積み、`lua_error`を呼び出します。
    func checkArguments(_ argTypes: [LuaType]) -> Bool {
        do {
            // 個数確認
            guard numberOfItems >= argTypes.count else {throw ArgumentError.Insufficient(expected: argTypes.count, actual: .init(numberOfItems))}
            
            try argTypes.reversed().enumerated().forEach { arg in
                let expectedType = arg.element
                let actualType = try getType(at: -.init(arg.offset + 1))
                guard expectedType == actualType else {throw ArgumentError.TypeMismatch(at: arg.offset + 1, expected: expectedType, actual: actualType)}
            }
            return true
        } catch let error as ArgumentError {
            let message: String
            switch error {
            case .Insufficient(let expected, let actual):
                message = "Expected \(expected) arguments, got \(actual)"
            case .TypeMismatch(let at, let expected, let actual):
                message = "Argument #\(at): expected \(expected.name), got \(actual.name)"
            }
            try? push(message)
        } catch {
            try? push("unknown argument error")
        }
        lua_error(state)
        return false
    }
    
}
