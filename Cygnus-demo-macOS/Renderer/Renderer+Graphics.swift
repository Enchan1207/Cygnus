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
    
    var function: lua_CFunction {
        switch self {
        case .SetSize:
            return {Renderer.default.setCanvasSize(.init(state: $0!, owned: false))}
        case .SetBackgroundColor:
            return {Renderer.default.setBackgroundColor(.init(state: $0!, owned: false))}
        case .SetFillColor:
            return {Renderer.default.setFillColor(.init(state: $0!, owned: false))}
        case .SetStrokeColor:
            return {Renderer.default.setStrokeColor(.init(state: $0!, owned: false))}
        case .DrawLine:
            return {Renderer.default.drawLine(.init(state: $0!, owned: false))}
        case .DrawRect:
            return {Renderer.default.drawRect(.init(state: $0!, owned: false))}
        }
    }
    
}

/// グラフィックス関数の実装
extension Renderer {

    /// キャンバスビューのサイズを設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setCanvasSize(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number]),
              let width = try? lua.get(at: -2) as Double,
              let height = try? lua.get(at: -1) as Double else {return 0}
        
        let newSize = NSSize(width: width, height: height)
        
        // コンテキストを再生成し、キャンバスサイズを変更
        initCanvas(size: newSize)
        delegate?.renderer(self, didResizeCanvas: newSize)
        return 0
    }
    
    /// キャンバスを指定された色で塗りつぶす
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setBackgroundColor(_ lua: Lua) -> Int32 {
        // 引数チェック
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
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setFillColor(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        
        // カラーコードをCGColorに変換
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        context?.setFillColor(color)
        return 0
    }
    
    /// 線分の色を設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setStrokeColor(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        
        // カラーコードをCGColorに変換
        guard let color = CGColor.fromColorCode(colorCode) else {return 0}
        context?.setStrokeColor(color)
        return 0
    }
    
    /// 線分を描画
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func drawLine(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number, .Number, .Number]),
              let startX = try? lua.get(at: -4) as Double,
              let startY = try? lua.get(at: -3) as Double,
              let endX = try? lua.get(at: -2) as Double,
              let endY = try? lua.get(at: -1) as Double else {return 0}
        
        guard let context = context else {return 0}
        context.move(to: .init(x: startX, y: startY))
        context.addLine(to: .init(x: endX, y: endY))
        context.strokePath()
        return 0
    }

    /// 矩形を描画
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func drawRect(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number, .Number, .Number]),
              let startX = try? lua.get(at: -4) as Double,
              let startY = try? lua.get(at: -3) as Double,
              let width = try? lua.get(at: -2) as Double,
              let height = try? lua.get(at: -1) as Double else {return 0}
        
        guard let context = context else {return 0}
        context.addRect(.init(x: startX, y: startY, width: width, height: height))
        context.fillPath()
        context.strokePath()
        return 0
    }
    
}
