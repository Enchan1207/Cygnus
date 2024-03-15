//
//  Renderer.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cocoa

/// レンダラ
final class Renderer {
    
    // MARK: - Properties
    
    /// Singletonインスタンス
    static let `default` = Renderer()
    
    /// 描画オブジェクトリスト
    private var renderObjects: [RenderingObject] = []
    
    /// デリゲート
    weak var delegate: RendererDelegate?
    
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
        
        /// 線の太さを設定する
        case SetStrokeWeight = "strokeWeight"
        
        /// 線分を描画する
        case DrawLine = "line"
        
        /// 矩形を描画する
        case DrawRect = "rect"
        
        /// 楕円を描画する
        case DrawEllipse = "ellipse"
        
        /// 文字列を描画する
        case DrawText = "text"
        
        /// 文字のフォントサイズを設定する
        case SetTextSize = "textSize"
        
        /// 以降の描画座標軸を回転する
        case SetRotation = "rotate"
        
        /// 以降の描画座標軸を移動する
        case SetTranslation = "translate"
        
        /// 描画時に線を引かない
        case SetNoStroke = "noStroke"
        
        /// 描画時に塗りつぶさない
        case SetNoFill = "noFill"
        
        /// 描画座標情報を退避する
        case SaveTransform = "saveTransform"
        
        /// 退避した座標情報を復帰する
        case RestoreTransform = "restoreTransform"
        
        var name: String { self.rawValue }
    }
    
    // MARK: - Initializers
    
    /// 内部イニシャライザ
    private init(){
    }
    
    /// 描画オブジェクトをリストに追加する
    /// - Parameter object: 追加するオブジェクト
    func addRenderObject(_ object: RenderingObject){
        renderObjects.append(object)
    }
    
    /// 描画オブジェクトリストを返し、内部リストをクリアする
    /// - Returns: 描画オブジェクトリスト
    func getRenderObjects() -> [RenderingObject]{
        let objects = renderObjects
        renderObjects.removeAll()
        return objects
    }
}
