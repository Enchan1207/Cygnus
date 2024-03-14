//
//  Renderer.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cocoa
import CoreGraphics
import Foundation

/// レンダラ
final class Renderer {
    
    // MARK: - Properties
    
    /// Singletonインスタンス
    static let `default` = Renderer()
    
    /// グラフィックスコンテキスト
    private (set) public var context: CGContext?
    
    /// API関数群
    enum API: String, LuaAPI {
        /// 描画領域のサイズを設定する
        case SetSize = "size"
        
        /// 背景色を設定する
        case SetBackgroundColor = "background"
        
        /// 塗りつぶし色を設定する
        case SetFillColor = "fill"
        
        /// 線の色を設定する
        case SetStrokeColor = "stroke"
        
        /// 線分を描画する
        case DrawLine = "line"
        
        /// 矩形を描画する
        case DrawRect = "rect"
        
        var name: String { self.rawValue }
    }
    
    // MARK: - Initializers
    
    /// 内部イニシャライザ
    private init(){
        initCanvas(size: .zero)
    }
    
    /// グラフィックスコンテキストを初期化する
    /// - Parameter canvasSize: 描画領域のサイズ
    func initCanvas(size: NSSize){
        context = .init(
            data: nil,
            width: .init(size.width),
            height: .init(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: .init(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    }
    
}
