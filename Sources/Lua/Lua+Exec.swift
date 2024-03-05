//
//  Lua+Exec.swift
//  Luaコードの読み込みと実行
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaCore

public extension Lua {
    
    /// Luaファイルを読み込む
    /// - Parameter at: 読み込み元のファイル
    func load(file at: String) throws {
        let result = luaL_loadfile(state, at)
        guard result == 0 else { throw LuaError(statusCode: result)! }
    }
    
    /// 式を評価する
    /// - Parameter statement: 式
    func eval(_ statement: String) throws {
        let result = luaL_dostring(state, s: statement)
        guard result == 0 else { throw LuaError(statusCode: result)! }
    }
    
}
