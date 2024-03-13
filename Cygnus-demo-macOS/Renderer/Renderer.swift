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
    
    /// API関数
    enum API: String, CaseIterable {
        
        /// 描画領域のサイズを設定する
        case SetSize = "size"
        
        /// 背景色を設定する
        case SetBackgroundColor = "background"
    }
    
    /// キャンバスビュー
    var canvas: CanvasView?
    
    // MARK: - Initializers
    
    /// 内部イニシャライザ
    private init(){
    }
}
