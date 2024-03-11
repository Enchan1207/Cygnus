//
//  CygnusMacros.swift
//  Luaコア内部で定義されているマクロ群のSwiftによる実装
//
//  Created by EnchantCode on 2024/03/07.
//

import CygnusCore

/**
 Luaコア内部、 `lua.h` や `lauxlib.h` などのファイルには多くの便利なマクロが定義されていますが、
 C/C++のマクロはSwiftから直接呼び出すことができません。
 
 そこで、これらマクロをSwiftの**インライン関数**として実装し、本体およびライブラリとは別個に `CygnusMacros` として公開しています。
 */

public typealias LuaState = UnsafeMutablePointer<lua_State>
