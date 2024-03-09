//
//  test_LuaGlobals.swift
//
//
//  Created by EnchantCode on 2024/03/07.
//

import XCTest
@testable import LuaSwift

/// グローバル変数のテスト
final class testLuaGlobals: XCTestCase {
    
    func testAccessGlobals() throws {
        let lua = Lua()
        XCTAssertEqual(try lua.getGlobal(name: "io"), .Table)
        
        try lua.push(123)
        try lua.setGlobal(name: "myvalue")
        
        XCTAssertEqual(try lua.getGlobal(name: "myvalue"), .Number)
        XCTAssertEqual(try lua.get() as Int, 123)
        
        lua.popAll()
        XCTAssertEqual(lua.numberOfItems, 0)
        XCTAssertThrowsError(try lua.setGlobal(name: "test"))
    }
    
}
