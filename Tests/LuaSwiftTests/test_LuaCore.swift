//
//  test_LuaCore.swift
//
//
//  Created by EnchantCode on 2024/03/04.
//

import XCTest
@testable import LuaCore

typealias LuaState = UnsafeMutablePointer<lua_State>

/// コアのテスト
final class testLuaCore: XCTestCase {
    
    /// 基本的なLuaのハンドリング
    func testBasicOperation() throws {
        // Luaステートを生成
        let luaState: LuaState = luaL_newstate()
        
        // 関数をLuaステートに登録
        lua_pushcclosure(luaState, testFunction, 0)
        lua_setglobal(luaState, ("testFunction"))
        
        for n in 1..<20 {
            // 登録した関数を呼び出す
            // 関数名, 引数, 引数, ... をプッシュしたのち lua_pcallk を呼び出すことで関数が呼び出され、結果がスタックに積まれる
            lua_getglobal(luaState, "testFunction")
            lua_pushnumber(luaState, .init(n))
            guard lua_pcallk(luaState, 1, 1, 0, 0, nil) == 0 else {
                XCTFail(getErrorReason(state: luaState))
                return
            }
            guard lua_isnumber(luaState, -1) == 1 else {
                XCTFail("unexpected type")
                return
            }
            let resultByLua = lua_tointegerx(luaState, -1, nil)
            
            // Swiftの方でも同じ計算を行い、結果が一致することを確認
            let resultBySwift = factorial(.init(n))
            XCTAssertEqual(resultByLua, resultBySwift)
        }
        
        // 状態を終了し、閉じる
        lua_close(luaState)
    }
    
    /// 最後に発生したエラーの情報を取得
    /// - Parameter state: Luaステート
    /// - Returns: エラー情報文字列
    private func getErrorReason(state: LuaState?) -> String {
        guard let reason = lua_tolstring(state, -1, nil),
              let reasonStr = String.init(cString: reason, encoding: .utf8) else {return "(unknown)"}
        return reasonStr
    }
    
}

/*
 Luaから呼べるのは、その場で生成して内部で完結するタイプのクロージャかグローバル関数のみ
 */

/// Luaから呼び出す関数
/// - Parameter state: Luaステート
/// - Returns: 戻り値の数
fileprivate func testFunction(state: LuaState?) -> Int32 {
    // Luaスタックから引数を取得し、演算
    let n = luaL_checkinteger(state, -1)
    let result = factorial(n)
    
    // 結果をスタックに積み、「関数の戻り値の数」を返す
    lua_pushinteger(state, result)
    return 1
}

/// 階乗を計算する
/// - Parameter limit: 最大値
/// - Returns: 計算結果
fileprivate func factorial(_ limit: Int64) -> Int64 {
    return (1...limit).reduce(1, *)
}
