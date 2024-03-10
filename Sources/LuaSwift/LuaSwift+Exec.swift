//
//  Lua+Exec.swift
//  関数呼び出し、コードの読込み/実行
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaSwiftCore
import LuaSwiftMacros

public extension Lua {
    
    /// Luaファイルを読み込む
    /// - Parameter at: 読み込み元のファイル
    func load(file at: String) throws {
        let result = luaL_loadfile(state, at)
        guard result == 0 else { throw LuaError(statusCode: result, message: try? get() as String)! }
    }
    
    /// 式を評価する
    /// - Parameter statement: 式
    func eval(_ statement: String) throws {
        // luaL_dostring マクロを使うとloadstringのエラーが握り潰されてしまうため、2段階に分割
        
        let loadResult = luaL_loadstring(state, statement)
        guard loadResult == 0 else { throw LuaError(statusCode: loadResult, message: try? get() as String)! }
        
        let callResult = lua_pcall(state, 0, LUA_MULTRET, 0)
        guard callResult == 0 else { throw LuaError(statusCode: callResult, message: try? get() as String)! }
    }
    
    /// 引数の数と戻り値の数を渡して関数を実行する
    /// - Parameters:
    ///   - argCount: 引数の数
    ///   - returnCount: 戻り値の数
    /// - Note: 関数は`yield`できません(内部で`lua_pcall`を呼び出しています)。
    func call(argCount: Int32, returnCount: Int32) throws {
        guard numberOfItems > argCount else {throw LuaError.StackUnderflow}
        let result = lua_pcall(state, argCount, returnCount, 0)
        guard result == 0 else {throw LuaError(statusCode: result, message: try? get() as String)!}
    }
    
}
