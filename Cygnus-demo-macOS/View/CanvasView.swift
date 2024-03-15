//
//  CanvasView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

/// キャンバスビュー
class CanvasView: NSView {
    
    // MARK: - Properties
    
    override var isFlipped: Bool{ true }
    
    /// レンダリングオブジェクトの配列
    private var renderObjects: [RenderingObject] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                setNeedsDisplay(bounds)
            }
        }
    }
    
    /// オブジェクト配列にアクセスするためのQueue
    private let objectAccessQueue = DispatchQueue(label: "me.enchan.objectaccessqueue", attributes: .concurrent)
    
    /// 現在の塗りつぶし色
    private var currentFillcolor: NSColor = .clear
    
    /// 現在の線の色
    private var currentStrokeColor: NSColor = .clear
    
    /// 現在の線の太さ
    private var currentStrokeWidth: CGFloat = 0
    
    /// 現在のフォントサイズ
    private var currentTextSize: CGFloat = 0
    
    // MARK: - Initializers
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Overridden methods
    
    override func draw(_ dirtyRect: NSRect) {
        // オブジェクト配列を取得
        var objects: [RenderingObject] = []
        objectAccessQueue.sync{[weak self] in
            guard let self = self else {return}
            objects = renderObjects
        }
        objects.forEach({render(object: $0, in: dirtyRect)})
    }
    
    // MARK: - Methods
    
    /// キャンバスビューを構成する
    private func configure(){
        wantsLayer = true
        layer!.needsDisplayOnBoundsChange = true
        layer!.frame = bounds
        layer!.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }
    
    /// オブジェクトを描画する
    /// - Parameters:
    ///   - object: 描画するオブジェクト
    ///   - rect: 描画領域
    /// - Note: グラフィックスコンテキストには `NSGraphicsContext.current` が使用されます。
    private func render(object: RenderingObject, in rect: NSRect){
        currentFillcolor.setFill()
        currentStrokeColor.setStroke()
        
        switch object {
            
        case .background(color: let color):
            color.setFill()
            rect.fill()
            
        case .fill(color: let color):
            currentFillcolor = color
            
        case .stroke(color: let color):
            currentStrokeColor = color
            
        case .strokeWeight(weight: let width):
            currentStrokeWidth = width
            
        case .line(from: let from, to: let to):
            let path = NSBezierPath()
            path.lineWidth = currentStrokeWidth
            path.move(to: from)
            path.line(to: to)
            path.stroke()
            
        case .rect(origin: let origin, size: let size):
            let path = NSBezierPath(rect: .init(origin: origin, size: size))
            path.lineWidth = currentStrokeWidth
            path.fill()
            path.stroke()
            
        case .ellipse(origin: let origin, size: let size):
            let path = NSBezierPath(ovalIn: .init(origin: origin, size: size))
            path.lineWidth = currentStrokeWidth
            path.fill()
            path.stroke()
        
        case .text(origin: let origin, content: let content):
            let attr: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: currentTextSize),
                .foregroundColor: currentStrokeColor
            ]
            let string = NSAttributedString(string: content, attributes: attr)
            string.draw(at: origin)
            
        case .textSize(point: let point):
            currentTextSize = point
        }
    }
    
    /// レンダリングオブジェクトを更新する
    /// - Parameter objects: 設定する描画オブジェクト
    func setObjects(_ objects: [RenderingObject]){
        objectAccessQueue.async(flags: .barrier) {[weak self] in
            guard let self = self else {return}
            renderObjects = objects
        }
    }
}
