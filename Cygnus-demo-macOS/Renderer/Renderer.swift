//
//  Renderer.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation

/// レンダラ
final class Renderer {
    
    // MARK: - Properties
    
    /// Singletonインスタンス
    static let `default` = Renderer()
    
    /// キャンバスビュー
    var canvas: CanvasView?
    
    // MARK: - Initializers
    
    /// 内部イニシャライザ
    private init(){
    }
}
