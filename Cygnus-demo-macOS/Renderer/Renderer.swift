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
        
        /// 線分を描画する
        case DrawLine = "line"
        
        /// 矩形を描画する
        case DrawRect = "rect"
        
        /// 楕円を描画する
        case DrawEllipse = "ellipse"
        
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
