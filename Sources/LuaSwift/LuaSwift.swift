//
//  Lua.swift
//
//
//  Created by EnchantCode on 2024/03/05.
//

import LuaSwiftCore
import LuaSwiftMacros
import Foundation

/// Lua
open class Lua {
    
    /// Luaステート
    public let state: LuaState
    
    /// ステートが借り物かどうか
    private let isStateOwned: Bool
    
    /// 標準入力
    internal (set) public var stdin: FileHandle?
    
    /// 標準出力
    internal (set) public var stdout: FileHandle?
    
    /// Luaステートを渡して初期化
    /// - Parameter state: Luaステート
    /// - Parameter owned: stateオブジェクトをこのインスタンスに管理させるかどうか
    /// - Note: `owned`  に `true` を渡した場合、Luaステートはこのインスタンスのデイニシャライザ内で閉じられます。
    public init(state: LuaState, owned: Bool){
        self.state = state
        self.isStateOwned = owned
    }
    
    /// 新しくLuaステートを作成し、インスタンスを初期化
    /// - Note: 標準ライブラリの読み込みなどの初期化処理が行われます。
    public convenience init() {
        self.init(state: luaL_newstate(), owned: true)
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
        
        // このインスタンスの所有物なら、Luaステートを閉じる
        if isStateOwned {
            lua_close(state)
        }
    }
    
}
