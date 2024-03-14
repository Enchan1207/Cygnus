//
//  LuaAPI.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/14.
//

import Foundation
import CygnusCore

typealias LuaAPI = CaseIterable & LuaAPIProtocol

protocol LuaAPIProtocol {
    
    /// 関数名
    var name: String { get }
    
    /// 実際に呼び出される関数オブジェクト
    var function: lua_CFunction { get }
    
}
