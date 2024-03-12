//
//  LuaCanvasScrollView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

class LuaCanvasScrollView: NSScrollView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        // 最大最小倍率を設定し、ズームジェスチャを設定
        minMagnification = 0.5
        maxMagnification = 4.0
        addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(pinch)))
    }
    
    @objc private func pinch(_ gesture: NSMagnificationGestureRecognizer) {
        // そのまま突っ込むとデカくなりすぎるので減衰し、現在のズームレベルに乗じる
        let dampingRatio = 0.5
        let scale = gesture.magnification * dampingRatio + 1.0
        magnification *= scale
    }
    
}
