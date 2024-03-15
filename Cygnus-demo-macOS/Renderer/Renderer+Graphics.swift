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
        case .SetTextAlign:
            return {Renderer.default.setTextAlign(.init(state: $0!, owned: false))}
        case .SetRotation:
            return {Renderer.default.setRotation(.init(state: $0!, owned: false))}
        case .SetTranslation:
            return {Renderer.default.setTranslation(.init(state: $0!, owned: false))}
        case .SetNoStroke:
            return {Renderer.default.setNoStroke(.init(state: $0!, owned: false))}
        case .SetNoFill:
            return {Renderer.default.setNoFill(.init(state: $0!, owned: false))}
        case .SaveTransform:
            return {Renderer.default.saveTransform(.init(state: $0!, owned: false))}
        case .RestoreTransform:
            return {Renderer.default.restoreTransform(.init(state: $0!, owned: false))}
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
        
        // 新しいサイズを生成し、デリゲートに通知 コード内で参照できるようグローバル変数にも設定
        let newSize = NSSize(width: width, height: height)
        delegate?.renderer(self, didResizeCanvas: newSize)
        do {
            try lua.push(width)
            try lua.setGlobal(name: "width")
            try lua.push(height)
            try lua.setGlobal(name: "height")
        } catch {
            print("Failed to update lua globals")
        }
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
        
        // パスを構成
        let path = NSBezierPath()
        path.move(to: .init(x: startX, y: startY))
        path.line(to: .init(x: endX, y: endY))
        addRenderObject(.path(path))
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
        
        addRenderObject(.path(.init(rect: .init(x: startX, y: startY, width: width, height: height))))
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
        
        addRenderObject(.path(.init(ovalIn: .init(x: startX, y: startY, width: width, height: height))))
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
    
    /// 文字列のアライメントを設定
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setTextAlign(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.String]),
              let alignmentString = try? lua.get(at: -1) as String else {return 0}
        
        let align: RenderingObject.TextAlign
        switch alignmentString.lowercased() {
        case "left":
            align = .Left
        case "center":
            align = .Center
        case "right":
            align = .Right
        default:
            try? lua.push("Unexpected argument \(alignmentString) (acceptable: left, center, or right)")
            lua_error(lua.state)
            return 0
        }
        addRenderObject(.textAlign(align: align))
        return 0
    }
    
    /// 描画領域を回転
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setRotation(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number]),
              let angle = try? lua.get(at: -1) as Double else {return 0}

        addRenderObject(.rotate(angle: angle))
        return 0
    }
    
    /// 描画領域の原点を移動
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setTranslation(_ lua: Lua) -> Int32 {
        // 引数チェック
        guard lua.checkArguments([.Number, .Number]),
              let x = try? lua.get(at: -2) as Double,
              let y = try? lua.get(at: -1) as Double else {return 0}

        addRenderObject(.translate(offset: .init(x: x, y: y)))
        return 0
    }
    
    /// 描画時に線を引かない
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setNoStroke(_ lua: Lua) -> Int32 {
        // この関数は引数を取らない
        addRenderObject(.stroke(color: .clear))
        return 0
    }
    
    /// 描画時に塗りつぶさない
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func setNoFill(_ lua: Lua) -> Int32 {
        // この関数は引数を取らない
        addRenderObject(.fill(color: .clear))
        return 0
    }
    
    /// 座標軸情報を退避する
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func saveTransform(_ lua: Lua) -> Int32 {
        // この関数は引数を取らない
        addRenderObject(.saveTransform)
        return 0
    }
    
    /// 退避した座標軸情報を復帰する
    /// - Parameter lua: Luaインスタンス
    /// - Returns: 戻り値の数
    fileprivate func restoreTransform(_ lua: Lua) -> Int32 {
        // この関数は引数を取らない
        addRenderObject(.restoreTransform)
        return 0
    }
}
