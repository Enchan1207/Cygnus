//
//  Renderer+API.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation

/// レンダラがLua向けに提供するAPI
extension Renderer {
    
    /// API関数
    enum API: String, CaseIterable {
        
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
        
    }
    
}
