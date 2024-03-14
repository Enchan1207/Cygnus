//
//  RendererDelegate.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/14.
//

import Foundation

protocol RendererDelegate: AnyObject {
    
    /// キャンバスのサイズが変更された
    /// - Parameters:
    ///   - renderer: Rendererインスタンス
    ///   - to: 変更後のサイズ
    func renderer(_ renderer: Renderer, didResizeCanvas to: NSSize)
    
}
