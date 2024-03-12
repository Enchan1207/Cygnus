//
//  LuaCanvasView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

class LuaCanvasView: NSView {
    
    override var isFlipped: Bool {true}
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        wantsLayer = true
        layer!.frame = bounds
        layer!.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
