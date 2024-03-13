//
//  LuaRunner.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation
import Cygnus

/// Luaコードのランナー
final class LuaRunner {
    
    // MARK: - Properties
    
    /// Luaインスタンス
    private var lua = Lua() {
        didSet {
            configureRendererFunctions()
        }
    }
    
    /// loop関数を定期的に実行するためのタイマ
    private var loopTimer: Timer?
    
    /// loop関数の実行間隔
    var frameRate: TimeInterval = 0.1
    
    /// デリゲート
    weak var delegate: LuaRunnerDelegate?
    
    // MARK: - Initializers
    
    init(){
        // レンダラの関数をインスタンスに登録
        configureRendererFunctions()
    }
    
    // MARK: - Public methods
    
    /// ソースコードを読み込む
    /// - Parameter code: コード
    func load(_ code: String) throws {
        // Luaインスタンスを立て直す
        lua = .init()
        
        // 面倒なので丸ごとevalに通す
        try lua.eval(code)
        
        // 関数setup,loopが存在することを確認する
        try lua.getGlobal(name: "setup")
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function setup() not defined or it is not function object")}
        try lua.getGlobal(name: "loop")
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function loop() not defined or it is not function object")}
        try lua.pop(count: 2)
    }
    
    /// 読み込んだLuaコードを実行する
    func run() throws {
        // 関数setupを呼び出す
        try lua.getGlobal(name: "setup")
        try lua.call(argCount: 0, returnCount: 0)
        
        // 関数loopを呼び出すタイマを構成
        loopTimer = .scheduledTimer(withTimeInterval: frameRate, repeats: true, block: {[weak self] timer in
            do {
                try self?.lua.getGlobal(name: "loop")
                try self?.lua.call(argCount: 0, returnCount: 0)
            } catch {
                // 実行時にエラーになったら止める
                self?.stop(withError: error)
            }
        })
        
        self.delegate?.didStart(self)
    }
    
    /// 実行中のコードを停止する
    /// - Parameter error: 発生したエラー
    func stop(withError error: Error? = nil){
        loopTimer?.invalidate()
        delegate?.didStop(self, withError: error)
    }
    
    // MARK: - Private methods
    
    /// Luaインスタンスにレンダラを構成する
    private func configureRendererFunctions(){
        try! lua.register(function: {Renderer.default.setCanvasSize($0)}, for: "size")
        try! lua.register(function: {Renderer.default.setBackgroundColor($0)}, for: "background")
    }
}
