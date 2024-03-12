//
//  LuaCanvasClipView.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/12.
//

import Cocoa

class LuaCanvasClipView: NSClipView {
    
    override var isFlipped: Bool {true}
    
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        let base = super.constrainBoundsRect(proposedBounds)
        
        // clipview直下のframeを取得
        guard let documentViewFrame = self.documentView?.frame else {return base}
        
        // ビューの拡大率を取得
        let magnification = frame.width / proposedBounds.width
        
        // 必要な原点移動量を算出し、その分だけ移動したRectを返す
        let deltaX = max(frame.width / magnification - documentViewFrame.width, 0.0)
        let deltaY = max(frame.height / magnification - documentViewFrame.height, 0.0)
        return base.offsetBy(dx: -deltaX/2.0, dy: -deltaY/2.0)
    }
    
}
