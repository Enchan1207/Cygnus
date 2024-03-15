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
    
    /// 現在のテキストアライメント
    private var currentTextAlign: RenderingObject.TextAlign = .Left
    
    /// 現在の座標軸オフセット量
    private var currentOffset: CGPoint = .zero
    
    /// 現在の座標軸傾き量
    private var currentTilt: CGFloat = 0
    
    /// 退避されたオフセット量
    private var pastOffset: CGPoint?
    
    /// 退避された傾き量
    private var pastTilt: CGFloat?
    
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
        //　座標軸の変形を初期化
        currentOffset = .zero
        currentTilt = 0
        
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
    
    /// 現在の傾き情報をもとに座標軸の基準点を移動する
    /// - Parameters:
    ///   - dx: 移動量x
    ///   - dy: 移動量y
    private func moveOffset(dx: CGFloat, dy: CGFloat){
        // 極座標系に変換
        let radius = sqrt(dx * dx + dy * dy)
        let theta = atan2(dy, dx)
        
        // 現在の傾きの値を加算し、各軸増加量を決定
        let newX = radius * cos(theta + currentTilt)
        let newY = radius * sin(theta + currentTilt)
        
        // 移動
        currentOffset = currentOffset.applying(.init(translationX: newX, y: newY))
    }
    
    /// 座標軸情報を退避してリセットする
    private func saveTranslationInfos(){
        // 退避
        pastOffset = currentOffset
        pastTilt = currentTilt
        
        // 初期化
        currentOffset = .zero
        currentTilt = 0
    }
    
    /// 退避していた座標軸情報を復帰する
    private func restoreTranslationInfos(){
        guard pastOffset != nil, pastTilt != nil else {return}
        // 復帰
        currentOffset = pastOffset!
        currentTilt = pastTilt!
        
        // 消去
        pastOffset = nil
        pastTilt = nil
    }
    
    // MARK: - Object rendering processes
    
    /// レンダリングオブジェクトを更新する
    /// - Parameter objects: 設定する描画オブジェクト
    func setObjects(_ objects: [RenderingObject]){
        objectAccessQueue.async(flags: .barrier) {[weak self] in
            guard let self = self else {return}
            renderObjects = objects
        }
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
            
        case .path(let path):
            // 変換行列を生成
            var transform = AffineTransform()
            transform.append(.init(rotationByRadians: currentTilt))
            transform.append(.init(translationByX: currentOffset.x, byY: currentOffset.y))
            
            // パスをコピーし、変換を適用して描画
            let _path: NSBezierPath = path.copy() as! NSBezierPath
            _path.lineWidth = currentStrokeWidth
            _path.transform(using: transform)
            _path.fill()
            _path.stroke()
            
        case .text(origin: let origin, content: let content):
            // テキストオブジェクトを準備
            let attr: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: currentTextSize),
                .foregroundColor: currentStrokeColor
            ]
            let string = NSAttributedString(string: content, attributes: attr)
            
            // アライメントに従って原点を移動
            let stringWidth = string.size().width
            let stringOriginX: CGFloat
            switch currentTextAlign {
            case .Left:
                stringOriginX = origin.x
            case .Center:
                stringOriginX = origin.x - stringWidth / 2
            case .Right:
                stringOriginX = origin.x - stringWidth
            }
            string.draw(at: .init(x: stringOriginX, y: origin.y))
            
        case .textSize(point: let point):
            currentTextSize = point
            
        case .textAlign(align: let align):
            currentTextAlign = align
        
        case .rotate(angle: let angle):
            currentTilt += angle
            
        case .translate(offset: let offset):
            moveOffset(dx: offset.x, dy: offset.y)
        
        case .saveTransform:
            saveTranslationInfos()

        case .restoreTransform:
            restoreTranslationInfos()
        }
    }
}
