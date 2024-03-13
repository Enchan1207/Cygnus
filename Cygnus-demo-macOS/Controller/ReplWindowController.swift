//
//  ReplWindowController.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/11.
//

import Cocoa
import Cygnus

class ReplWindowController: NSWindowController {
    
    // MARK: - GUI components
    
    /// コードエリアとキャンバスが配置されているスプリットビュー
    @IBOutlet weak var splitView: NSSplitView!
    
    /// キャンバスが配置されているスクロールビュー
    @IBOutlet weak var canvasScrollView: NSScrollView! {
        didSet {
            // 最大最小倍率を設定し、ズームジェスチャを設定
            canvasScrollView.minMagnification = 0.5
            canvasScrollView.maxMagnification = 4.0
            canvasScrollView.addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(pinch)))
        }
    }
    
    /// キャンバス
    @IBOutlet weak var canvasView: LuaCanvasView!
    
    /// スケールコントローラのビュー
    @IBOutlet weak var scaleControllerView: NSView! {
        didSet {
            scaleControllerView.wantsLayer = true
            scaleControllerView.layer!.cornerRadius = 10.0
        }
    }
    
    /// スケールラベル
    @IBOutlet weak var scaleLabel: NSTextField!
    
    /// ソースコード編集エリア
    @IBOutlet var codeView: NSTextView! {
        didSet {
            // フォント設定
            codeView.font = .monospacedSystemFont(ofSize: 13.0, weight: .regular)
            
            // 自動置換を無効化
            codeView.isAutomaticDataDetectionEnabled = false
            codeView.isAutomaticLinkDetectionEnabled = false
            codeView.isAutomaticTextCompletionEnabled = false
            codeView.isAutomaticTextReplacementEnabled = false
            codeView.isAutomaticDashSubstitutionEnabled = false
            codeView.isAutomaticQuoteSubstitutionEnabled = false
            codeView.isAutomaticSpellingCorrectionEnabled = false
            
            // アセットからサンプルコードを読み込んで反映
            if let sampleURL = Bundle.main.url(forResource: "Sample", withExtension: "lua"),
               let sampleCode = try? String(contentsOf: sampleURL) {
                codeView.string = sampleCode
            }
        }
    }
    
    /// 「実行」ボタン
    @IBOutlet weak var runButton: NSButton! {
        didSet {
            isRunning = false
        }
    }
    
    // MARK: - Properties
    
    override var windowNibName: NSNib.Name? { "ReplWindow" }
    
    /// Luaコード実行状態
    private var isRunning: Bool = false {
        didSet {
            let buttonName = isRunning ? "pause.fill" : "play.fill"
            let buttonLabel = isRunning ? "Pause" : "Run"
            runButton.image = .init(systemSymbolName: buttonName, accessibilityDescription: buttonLabel)
            runButton.toolTip = buttonLabel
        }
    }
    
    private let runner = LuaRunner()
    
    // MARK: - View lifecycles
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        setCanvasScaleToFit()
        runner.delegate = self
    }
    
    // MARK: - Private methods
    
    /// スクロールビューの倍率をいじる
    /// - Parameter magnification: 倍率
    private func setScrollViewMagnification(_ magnification: CGFloat) {
        canvasScrollView.magnification = magnification
        updateScaleLabel()
    }
    
    /// スクロールビューの倍率をウィンドウサイズにフィットするように変更する
    private func setCanvasScaleToFit() {
        // 最低限必要なマージン
        let margin: CGFloat = 10
        
        // キャンバスビューのサイズを取得 ゼロ除算を防ぐため、幅か高さがゼロなら戻る
        let canvasSize = canvasView.bounds.size
        guard canvasSize.width > 0, canvasSize.height > 0 else {return}
        
        // 外側(スクロール)ビューのサイズを取得
        let outerViewSize = canvasScrollView.bounds.size
        
        // 幅と高さそれぞれについて、はみ出ない最大の倍率を計算
        let bestScaleByWidth = (outerViewSize.width - margin * 2) / canvasSize.width
        let bestScaleByHeight = (outerViewSize.height - margin * 2) / canvasSize.height
        
        // 小さい方を採用
        setScrollViewMagnification(min(bestScaleByWidth, bestScaleByHeight))
    }
    
    /// キャンバスのサイズを変更する
    /// - Parameter to: サイズ
    private func setCanvasSize(_ to: NSSize) {
        canvasScrollView.documentView?.setFrameSize(to)
        updateScaleLabel()
    }
    
    /// スケールラベルの情報を更新する
    private func updateScaleLabel(){
        let scaleString = String(format: "%.0f%%", canvasScrollView.magnification * 100.0)
        let sizeString = String(format: "%.0fpx x %.0fpx", canvasView.bounds.size.width, canvasView.bounds.size.height)
        scaleLabel.stringValue = "\(scaleString) (\(sizeString))"
    }
    
    /// エラーダイアログを表示
    /// - Parameter error: エラー
    private func showErrorDialog(error: Error){
        // エラーメッセージを生成
        let errorMessage: String
        let errorInfo: String
        if let luaError = error as? LuaError {
            errorMessage = luaError.name
            errorInfo = luaError.reason
        } else {
            errorMessage = "\(type(of: error))"
            errorInfo = error.localizedDescription
        }
        
        // ダイアログを構成して表示
        let dialog = NSAlert()
        dialog.messageText = errorMessage
        dialog.informativeText = errorInfo
        dialog.runModal()
    }
    
    // MARK: - GUI actions
    
    /// スクロールビューの拡大縮小
    @objc private func pinch(_ gesture: NSMagnificationGestureRecognizer) {
        // そのまま突っ込むとデカくなりすぎるので減衰し、現在のズームレベルに乗じる
        let dampingRatio = 0.5
        let scale = gesture.magnification * dampingRatio + 1.0
        setScrollViewMagnification(canvasScrollView.magnification * scale)
    }
    
    /// 自動スケーリングボタン
    @IBAction func onClickScaleToFit(_ sender: Any) {
        setCanvasScaleToFit()
    }
    
    /// 実行ボタン
    @IBAction func onClickRun(_ sender: Any) {
        // 実行中なら止めて戻る
        guard !isRunning else {
            runner.stop()
            return
        }
        
        do {
            // コードをランナーに食わせて実行
            try runner.load(codeView.string)
            try runner.run()
        } catch {
            showErrorDialog(error: error)
        }
    }
    
}

extension ReplWindowController: LuaRunnerDelegate {
    func didStart(_ runner: LuaRunner) {
        isRunning = true
    }
    
    func didStop(_ runner: LuaRunner, withError error: Error?) {
        isRunning = false
        if let error = error {
            showErrorDialog(error: error)
        }
    }
}
