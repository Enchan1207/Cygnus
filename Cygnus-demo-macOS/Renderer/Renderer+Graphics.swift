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

extension Renderer.API {
    
    /// API関数が示すLua関数オブジェクトを返す
    fileprivate var function: lua_CFunction {
        switch self {
        case .SetSize:
            return {Renderer.default.setCanvasSize($0)}
        case .SetBackgroundColor:
            return {Renderer.default.setBackgroundColor($0)}
        }
    }
    
}

extension Renderer {

    /// レンダラのメソッドをLuaインスタンスに登録する
    /// - Parameter lua: Luaインスタンス
    func installMethods(to lua: Lua){
        Renderer.API.allCases.forEach({try! lua.register(function: $0.function, for: $0.rawValue)})
    }
    
    /// キャンバスビューのサイズを設定
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func setCanvasSize(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.Number, .Number]),
              let width = try? lua.get(at: -2) as Int,
              let height = try? lua.get(at: -1) as Int else {return 0}
        
        // キャンバスサイズをいじる
        canvas?.setFrameSize(.init(width: width, height: height))
        return 0
    }
    
    /// キャンバスの背景色を設定
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func setBackgroundColor(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        
        // カラーコードを変換して反映
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        canvas?.layer!.backgroundColor = color
        return 0
    }
}
