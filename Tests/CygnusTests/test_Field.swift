//
//  test_Field.swift
//  
//
//  Created by EnchantCode on 2024/03/07.
//

import XCTest
@testable import Cygnus
@testable import CygnusMacros

/// テーブルフィールド読み書きのテスト
final class testField: XCTestCase {
    
    func testFields() throws {
        let lua = Lua()
        
        _ = try lua.getGlobal(name: "io")
        XCTAssertEqual(try lua.getField(key: "write"), .Function)
        try lua.pushNil()
        try lua.setField(index: -3, key: "write")
        lua.popAll()
        
        _ = try lua.getGlobal(name: "io")
        XCTAssertEqual(try lua.getField(key: "write"), .Nil)
    }
    
}
