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
        case .SetFillColor:
            return {Renderer.default.setFillColor($0)}
        case .SetStrokeColor:
            return {Renderer.default.setStrokeColor($0)}
        case .DrawLine:
            return {Renderer.default.drawLine($0)}
        case .DrawRect:
            return {Renderer.default.drawRect($0)}
        }
    }
    
}

/// グラフィックス関数の実装
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
        
        let newSize = NSSize(width: width, height: height)
        
        // コンテキストを再生成し、キャンバスサイズを変更
        initContext(with: newSize)
        canvas?.setFrameSize(newSize)
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
        
        // カラーコードをCGColorに変換
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        
        // コンテキストが生きてるなら塗り潰す fill() に影響しないよう、一旦ステートを保存してから行う
        if let context = context {
            context.saveGState()
            context.setFillColor(color)
            context.fill(.init(origin: .zero, size: .init(width: context.width, height: context.height)))
            context.restoreGState()
        }
        return 0
    }
    
    /// 塗りつぶし色を設定
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func setFillColor(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        
        // カラーコードをCGColorに変換
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        context?.setFillColor(color)
        return 0
    }
    
    /// 線分の色を設定
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func setStrokeColor(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        
        // カラーコードをCGColorに変換
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        context?.setStrokeColor(color)
        return 0
    }
    
    /// 線分を描画
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func drawLine(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.Number, .Number, .Number, .Number]),
              let startX = try? lua.get(at: -4) as Int,
              let startY = try? lua.get(at: -3) as Int,
              let endX = try? lua.get(at: -2) as Int,
              let endY = try? lua.get(at: -1) as Int else {return 0}
        
        guard let context = context else {return 0}
        context.move(to: .init(x: startX, y: startY))
        context.addLine(to: .init(x: endX, y: endY))
        return 0
    }

    /// 矩形を描画
    /// - Parameter state: Luaステート
    /// - Returns: 戻り値の数
    fileprivate func drawRect(_ state: LuaState?) -> Int32 {
        // 引数チェック
        guard let state = state else {return 0}
        let lua = Lua(state: state, owned: false)
        guard lua.checkArguments([.Number, .Number, .Number, .Number]),
              let startX = try? lua.get(at: -4) as Int,
              let startY = try? lua.get(at: -3) as Int,
              let width = try? lua.get(at: -2) as Int,
              let height = try? lua.get(at: -1) as Int else {return 0}
        
        guard let context = context else {return 0}
        context.addRect(.init(x: startX, y: startY, width: width, height: height))
        return 0
    }
    
}
