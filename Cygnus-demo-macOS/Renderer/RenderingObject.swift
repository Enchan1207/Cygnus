//
//  RenderingObject.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/14.
//

import Cocoa

/// 描画オブジェクト
enum RenderingObject {
    
    /// 文字列のアライメント
    enum TextAlign {
        /// 左揃え
        case Left
        
        /// 中央揃え
        case Center
        
        /// 右揃え
        case Right
    }
    
    /// 背景を塗り潰す
    case background(color: NSColor)
    
    /// 塗り潰しに使う色を設定する
    case fill(color: NSColor)
    
    /// 線の色を設定する
    case stroke(color: NSColor)
    
    /// 線の太さを設定する
    case strokeWeight(weight: CGFloat)
    
    /// パスを引く
    case path(_ path: NSBezierPath)
    
    /// 文字列を描く
    case text(origin: CGPoint, content: String)
    
    /// 文字のフォントサイズを設定する
    case textSize(point: CGFloat)
    
    /// 文字列のアライメントを設定する
    case textAlign(align: TextAlign)
    
    /// 座標軸の回転角度を設定する
    case rotate(angle: CGFloat)
    
    /// 座標軸の原点オフセットを設定する
    case translate(offset: CGPoint)
    
    /// 座標軸の変換情報を退避する
    case saveTransform
    
    /// 退避した座標軸変換情報を復帰する
    case restoreTransform
    
}

