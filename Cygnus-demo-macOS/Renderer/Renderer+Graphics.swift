//
//  Renderer+Graphics.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cocoa
import Cygnus
import CygnusCore

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
        case .SetStrokeWeight:
            return {Renderer.default.setStrokeWeight(.init(state: $0!, owned: false))}
        case .DrawLine:
            return {Renderer.default.drawLine(.init(state: $0!, owned: false))}
        case .DrawRect:
            return {Renderer.default.drawRect(.init(state: $0!, owned: false))}
        case .DrawEllipse:
            return {Renderer.default.drawEllipse(.init(state: $0!, owned: false))}
        case .DrawText:
            return {Renderer.default.drawText(.init(state: $0!, owned: false))}
        case .SetTextSize:
            return {Renderer.default.setTextSize(.init(state: $0!, owned: false))}
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
        guard let color = NSColor.fromColorCode(colorCode) else {return 0}
        addRenderObject(.background(color: color))
        return 0
    }
    
    /// 塗りつぶし色を設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setFillColor(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        guard let color = NSColor.fromColorCode(colorCode) else {return 0}
        addRenderObject(.fill(color: color))
        return 0
    }
    
    /// 線分の色を設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setStrokeColor(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.String]),
              let colorCode = try? lua.get(at: -1) as String else {return 0}
        guard let color = NSColor.fromColorCode(colorCode) else {return 0}
        addRenderObject(.stroke(color: color))
        return 0
    }
    
    /// 線分の太さを設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setStrokeWeight(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number]),
              let weight = try? lua.get(at: -1) as Double else {return 0}
        addRenderObject(.strokeWeight(weight: weight))
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
        addRenderObject(.line(from: .init(x: startX, y: startY), to: .init(x: endX, y: endY)))
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
        
        addRenderObject(.rect(origin: .init(x: startX, y: startY), size: .init(width: width, height: height)))
        return 0
    }

    /// 楕円を描画
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func drawEllipse(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number, .Number, .Number]),
              let startX = try? lua.get(at: -4) as Double,
              let startY = try? lua.get(at: -3) as Double,
              let width = try? lua.get(at: -2) as Double,
              let height = try? lua.get(at: -1) as Double else {return 0}
        
        addRenderObject(.ellipse(origin: .init(x: startX, y: startY), size: .init(width: width, height: height)))
        return 0
    }
    
    /// 文字列を描画
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func drawText(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number, .String]),
              let x = try? lua.get(at: -3) as Double,
              let y = try? lua.get(at: -2) as Double,
              let content = try? lua.get(at: -1) as String else {return 0}
        
        addRenderObject(.text(origin: .init(x: x, y: y), content: content))
        return 0
    }
    
    /// フォントサイズを設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setTextSize(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number]),
              let point = try? lua.get(at: -1) as Double else {return 0}

        addRenderObject(.textSize(point: point))
        return 0
    }
}
