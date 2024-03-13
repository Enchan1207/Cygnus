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
    
    /// キャンバスビュー
    var canvas: CanvasView?
    
    /// グラフィックスコンテキスト
    private (set) public var context: CGContext?
    
    // MARK: - Initializers
    
    /// 内部イニシャライザ
    private init(){
        initContext(with: .init(width: 400, height: 300))
    }
    
    /// 指定されたサイズでコンテキストを初期化する
    /// - Parameter size: サイズ
    func initContext(with size: NSSize){
        context = .init(data: nil, width: .init(size.width), height: .init(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: .init(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    }
    
    /// コンテキストの内容をキャンバスに反映する
    func updateCanvas(){
        canvas?.layer!.contents = context?.makeImage()
    }
}
