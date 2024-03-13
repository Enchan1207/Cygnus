//
//  Renderer+Graphics.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cocoa
import Cygnus
import CygnusCore
import CygnusMacros

/// グラフィックス関連
extension Renderer {
    
    /// キャンバスビューのサイズを設定
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    func setCanvasSize(_ state: LuaState?) -> Int32 {
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        
        // 引数は整数二つのはず
        guard lua.numberOfItems >= 2,
              let width = try? lua.get(at: -2) as Int,
              let height = try? lua.get(at: -1) as Int else {
            try? lua.push("Function expected two integers")
            lua_error(state)
            return 0
        }
        
        // キャンバスサイズをいじる
        canvas?.setFrameSize(.init(width: width, height: height))
        return 0
    }
    
    func setBackgroundColor(_ state: LuaState?) -> Int32 {
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        
        // 引数は文字列ひとつのはず
        guard lua.numberOfItems >= 1,
              let colorCode = try? lua.get(at: -1) as String else {
            try? lua.push("Function expected one string")
            lua_error(state)
            return 0
        }
        
        // カラーコードを変換して反映
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        canvas?.layer!.backgroundColor = color
        return 0
    }
    
}
