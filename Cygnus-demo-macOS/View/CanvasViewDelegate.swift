//
//  CanvasViewDelegate.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation

protocol CanvasViewDelegate: AnyObject {
    
    /// キャンバスがリサイズされた
    /// - Parameters:
    ///   - view: キャンバスインスタンス
    ///   - to: 更新後のサイズ
    func canvas(_ view: CanvasView, didResize to: NSSize)
    
}
