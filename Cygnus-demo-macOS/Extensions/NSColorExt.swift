//
//  NSColorExt.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Cocoa

extension NSColor {
    
    /// カラーコードから生成
    /// - Parameter code: カラーコード
    /// - Returns: 生成されたNSColorインスタンス
    /// - Note: フォーマットは `#RGB`, `#RGBA`, `#RRGGBB`, `#RRGGBBAA` のいずれかです。それ以外のフォーマットではnilが返ります。
    static func fromColorCode(_ code: String) -> NSColor? {
        guard [4, 5, 7, 9].contains(code.count), code.starts(with: "#") else {return nil}
        
        // 頭の#を外し、各色要素の桁数と成分数を求めておく
        let codeElement = code.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .init(["#"]))
        let componentDigits = codeElement.count > 5 ? 2 : 1
        let numberOfComponents = codeElement.count / componentDigits
        let maxComponentValue: UInt64 = (1 << (componentDigits * 4) - 1)
        
        // カラーコードを64bit値に変換
        var rawCodeValue: UInt64 = 0
        guard Scanner(string: codeElement).scanHexInt64(&rawCodeValue) else {return nil}
        
        // 桁数と成分数からビットマスクを生成
        // 桁数2, 成分数3なら [0xFF, 0xFF00, 0xFF0000] が、桁数1, 成分数4なら [0x0F, 0xF0, 0xF00, 0xF000] が生成される
        let bitmasks: [UInt64] = (0..<numberOfComponents).map({maxComponentValue << ($0 * componentDigits * 4)})
        
        // マスクを適用して値を取得し、CGColorを生成して返す
        let componentValues: [CGFloat] = bitmasks.enumerated().map({($0.element & rawCodeValue) >> ($0.offset * componentDigits * 4)}).reversed().map({Double($0) / Double(maxComponentValue)})
        switch numberOfComponents {
        case 3:
            return .init(red: componentValues[0], green: componentValues[1], blue: componentValues[2], alpha: 1.0)
        case 4:
            return .init(red: componentValues[0], green: componentValues[1], blue: componentValues[2], alpha: componentValues[3])
        default:
            return nil
        }
    }
    
}
