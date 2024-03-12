//
//  ReplWindowController.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/11.
//

import Cocoa

class ReplWindowController: NSWindowController {
    
    // MARK: - GUI components
    
    /// コードエリアとキャンバスが配置されているスプリットビュー
    @IBOutlet weak var splitView: NSSplitView! {
        didSet {
            splitView.delegate = self
        }
    }
    
    /// キャンバスが配置されているスクロールビュー
    @IBOutlet weak var canvasScrollView: LuaCanvasScrollView!
    
    /// キャンバス
    @IBOutlet weak var canvasView: LuaCanvasView! {
        didSet {
            let layer = canvasView.layer!
            
            // グラデーションレイヤを構成
            let gradientLayer = CAGradientLayer()
            let colors: [NSColor] = [.red, .green]
            gradientLayer.frame = layer.bounds
            gradientLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            gradientLayer.colors = colors.map({$0.cgColor})
            gradientLayer.startPoint = .init(x: 0.0, y: 0.0)
            gradientLayer.endPoint = .init(x: 1.0, y: 1.0)
            gradientLayer.locations = [0.0, 1.0]
            layer.addSublayer(gradientLayer)
        }
    }
    
    /// ソースコード編集エリア
    @IBOutlet var codeView: NSTextView!
    
    // MARK: - Properties
    
    override var windowNibName: NSNib.Name? { "ReplWindow" }
    
    // MARK: - View lifecycles
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    // MARK: - GUI actions
    
}

extension ReplWindowController: NSSplitViewDelegate {
    
    func splitViewDidResizeSubviews(_ notification: Notification) {
        // キャンバスビューとスクロールビューの幅を取得し…
        let canvasViewWidth = canvasScrollView.documentView!.bounds.width
        let scrollViewWidth = canvasScrollView.bounds.width
        
        // マージンを足して本来の幅を求め、キャンバスビューの幅で割って倍率を設定
        let margin: CGFloat = 10
        let fitScale = (scrollViewWidth - margin * 2) / canvasViewWidth
        canvasScrollView.magnification = fitScale
    }
    
}

