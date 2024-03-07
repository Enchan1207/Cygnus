//
//  Lua.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaSwiftCore
import Foundation

public typealias LuaState = UnsafeMutablePointer<lua_State>

/// Lua
open class Lua {
    
    /// Luaステート
    public let state: LuaState
    
    /// 標準入力
    internal (set) public var stdin: FileHandle?
    
    /// 標準出力
    internal (set) public var stdout: FileHandle?
    
    /// Luaステートを渡して初期化
    /// - Parameter state: Luaステート
    public init(state: LuaState){
        self.state = state
    }
    
    /// 新しくLuaステートを作成し、インスタンスを初期化
    /// - Note: 標準ライブラリの読み込みなどの初期化処理が行われます。
    convenience init() {
        self.init(state: luaL_newstate())
        luaL_openlibs(state)
    }
    
    deinit {
        // ファイルハンドルを握っている場合は放す
        do{
            try stdin?.close()
            try stdout?.close()
        } catch {
            print("Failed to close standard I/O.")
        }
        
        // Luaステートを閉じる
        lua_close(state)
    }
    
}
