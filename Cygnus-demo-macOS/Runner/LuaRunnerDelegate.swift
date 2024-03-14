//
//  LuaRunnerDelegate.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/13.
//

import Foundation

protocol LuaRunnerDelegate: AnyObject {
    
    /// コードの実行が開始された
    /// - Parameter runner: Runnerインスタンス
    func didStartRunning(_ runner: LuaRunner)

    /// セットアップ関数の実行が開始された
    /// - Parameter runner: Runnerインスタンス
    func didStartSetupFunction(_ runner: LuaRunner)
    
    /// セットアップ関数の実行が完了した
    /// - Parameter runner: Runnerインスタンス
    func didFinishSetupFunction(_ runner: LuaRunner)
    
    /// ループ関数の実行が開始された
    /// - Parameter runner: Runnerインスタンス
    func didStartLoopFunction(_ runner: LuaRunner)
    
    /// ループ関数の実行が完了した
    /// - Parameter runner: Runnerインスタンス
    func didFinishLoopFunction(_ runner: LuaRunner)
    
    /// コードの実行が止まった
    /// - Parameters:
    ///   - runner: Runnerインスタンス
    ///   - error: 停止要因となったエラー (nil時、ユーザによる停止)
    func didStop(_ runner: LuaRunner, withError error: Error?)
    
}
