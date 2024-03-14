//
//  CanvasView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

class CanvasView: NSView {
    
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
        layer!.needsDisplayOnBoundsChange = true
        layer!.frame = bounds
        layer!.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }
}
