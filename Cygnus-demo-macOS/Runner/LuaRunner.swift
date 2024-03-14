//
//  LuaRunner.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation
import Cygnus
import CygnusCore

/// Luaコードのランナー
final class LuaRunner {
    
    // MARK: - Properties
    
    /// Luaインスタンス
    private var lua = Lua()
    
    /// セットアップ関数の名前
    private let setupFunctionName = "setup"
    
    /// ループ関数の名前
    private let drawFunctionName = "draw"
    
    /// loop関数を定期的に実行するためのタイマ
    private var loopTimer: Timer?
    
    /// loop関数の実行間隔
    var frameRate: TimeInterval = 0.1
    
    /// デリゲート
    weak var delegate: LuaRunnerDelegate?
    
    // MARK: - Public methods
    
    /// Luaステートをリセットする
    /// - Note: 導入したAPIは削除されます。
    func reset(){
        lua = .init()
    }
    
    /// Luaコードを読み込む
    /// - Parameter code: コード
    func load(_ code: String) throws {
        // 丸ごとevalに通す
        try lua.eval(code)
        
        // 必要な関数が定義されていることを確認する
        try lua.getGlobal(name: setupFunctionName)
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function \(setupFunctionName)() not defined or it is not function object")}
        try lua.getGlobal(name: drawFunctionName)
        guard try lua.getType() == .Function else {throw LuaError.FileError("Function \(drawFunctionName)() not defined or it is not function object")}
        try lua.pop(count: 2)
    }
    
    /// 読み込んだLuaコードを実行する
    func run() {
        // Luaコードの実行が始まったことをデリゲートに通知
        self.delegate?.didStartRunning(self)
        
        // セットアップ関数とループ関数を呼び出す
        do {
            try lua.getGlobal(name: setupFunctionName)
            try lua.call(argCount: 0, returnCount: 0)
            try lua.getGlobal(name: drawFunctionName)
            try lua.call(argCount: 0, returnCount: 0)
        } catch {
            stop(withError: error)
        }
        
        // 定期実行タイマを構成
        loopTimer = .scheduledTimer(withTimeInterval: frameRate, repeats: true, block: {[weak self] timer in
            guard let self = self else {return}
            do {
                delegate?.didStartLoopFunction(self)
                try lua.getGlobal(name: drawFunctionName)
                try lua.call(argCount: 0, returnCount: 0)
                delegate?.didFinishLoopFunction(self)
            } catch {
                // 実行時にエラーになったら止める
                stop(withError: error)
            }
        })
    }
    
    /// 実行中のコードを停止する
    /// - Parameter error: 発生したエラー
    func stop(withError error: Error? = nil){
        loopTimer?.invalidate()
        delegate?.didStop(self, withError: error)
    }
    
    /// ランナーにAPIを導入する
    /// - Parameter api: 導入するAPI
    func install<T>(api: T.Type) where T: LuaAPI {
        T.allCases.forEach({try! lua.register(function: $0.function, for: $0.name)})
    }
    
}
