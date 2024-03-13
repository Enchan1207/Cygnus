//
//  CanvasView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

class CanvasView: NSView {
    
    weak var delegate: CanvasViewDelegate?
    
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
        layer!.needsDisplayOnBoundsChange = true
        layer!.frame = bounds
        layer!.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        delegate?.canvas(self, didResize: newSize)
    }
    
    override func setBoundsSize(_ newSize: NSSize) {
        super.setBoundsSize(newSize)
        delegate?.canvas(self, didResize: newSize)
    }
}
