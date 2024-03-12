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
    @IBOutlet weak var splitView: NSSplitView!
    
    /// キャンバスが配置されているスクロールビュー
    @IBOutlet weak var canvasScrollView: NSScrollView! {
        didSet {
            // 最大最小倍率を設定し、ズームジェスチャを設定
            canvasScrollView.minMagnification = 0.5
            canvasScrollView.maxMagnification = 4.0
            canvasScrollView.addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(pinch)))
        }
    }
    
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
    
    /// スケールコントローラのビュー
    @IBOutlet weak var scaleControllerView: NSView! {
        didSet {
            scaleControllerView.wantsLayer = true
            scaleControllerView.layer!.cornerRadius = 10.0
        }
    }
    
    /// スケールラベル
    @IBOutlet weak var scaleLabel: NSTextField!
    
    /// ソースコード編集エリア
    @IBOutlet var codeView: NSTextView!
    
    // MARK: - Properties
    
    override var windowNibName: NSNib.Name? { "ReplWindow" }
    
    // MARK: - View lifecycles
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        setCanvasScaleToFit()
    }
    
    // MARK: - Private methods
    
    /// スクロールビューの倍率をいじる
    /// - Parameter magnification: 倍率
    private func setScrollViewMagnification(_ magnification: CGFloat) {
        canvasScrollView.magnification = magnification
        let scaleString = String(format: "%.0f%%", canvasScrollView.magnification * 100.0)
        let sizeString = String(format: "%.0fpx x %.0fpx", canvasView.bounds.size.width, canvasView.bounds.size.height)
        scaleLabel.stringValue = "\(scaleString) (\(sizeString))"
    }
    
    /// スクロールビューの倍率をウィンドウサイズにフィットするように変更する
    private func setCanvasScaleToFit() {
        // 最低限必要なマージン
        let margin: CGFloat = 10
        
        // 理想的な幅の倍率を計算
        let canvasViewWidth = canvasScrollView.documentView!.bounds.width
        let scrollViewWidth = canvasScrollView.bounds.width
        let bestScaleByWidth = (scrollViewWidth - margin * 2) / canvasViewWidth
        
        // 理想的な高さの倍率を計算
        let canvasViewHeight = canvasScrollView.documentView!.bounds.height
        let scrollViewHeight = canvasScrollView.bounds.height
        let bestScaleByHeight = (scrollViewHeight - margin * 2) / canvasViewHeight
        
        // 小さい方を採用
        setScrollViewMagnification(min(bestScaleByWidth, bestScaleByHeight))
    }
    
    /// キャンバスのサイズを変更する
    /// - Parameter to: サイズ
    private func setCanvasSize(_ to: NSSize) {
        canvasScrollView.documentView?.setFrameSize(to)
    }
    
    // MARK: - GUI actions
    
    /// スクロールビューの拡大縮小
    @objc private func pinch(_ gesture: NSMagnificationGestureRecognizer) {
        // そのまま突っ込むとデカくなりすぎるので減衰し、現在のズームレベルに乗じる
        let dampingRatio = 0.5
        let scale = gesture.magnification * dampingRatio + 1.0
        setScrollViewMagnification(canvasScrollView.magnification * scale)
    }
    
    /// 自動スケーリングボタン
    @IBAction func onClickScaleToFit(_ sender: Any) {
        setCanvasScaleToFit()
    }
    
}
