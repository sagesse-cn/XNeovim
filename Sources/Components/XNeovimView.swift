//
//  XNeovimServerWindow.swift
//  XNeovim
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

import AppKit
import XNeovimService

internal class XNeovimView: NSObject, XNeovimServerViewDelegate {
    
    internal init(editor: IDEEditor, editorView: SourceEditorView, editorContentView: NSView) {
        // Save document context
        self.editor = editor
        self.editorView = editorView
        self.editorContentView = editorContentView
        
        self.plugin = XNeovim.shared
        self.server = XNeovim.shared.server
        
        // Initializes the status bar
        self.statusBar = .init(configure: "")
        
        super.init()

        // Setup environment
        self.editor.xvim_window = self
        self.editorView.xvim_window = self
        
        // Load file
        editor.document.fileURL.map { URL in
            server.view.delegate = self
            server.view.open(with: URL)
        }
    }
    
    internal func keyUp(_ event: NSEvent) -> NSEvent? {
        return event
    }
    
    internal func keyDown(_ event: NSEvent) -> NSEvent? {

        server.input(NSString.input(with: event))
        
        return nil
    }
    
    var selection: XNeovimServerSelection {
        set {
            // the selection is changed?
            guard _selection != newValue else {
                return
            }
            _selection = newValue
            
        logger.debug?.write(newValue.start.row, newValue.start.column)
            // up
            server.view.selection = newValue
        }
        get {
            return _selection
        }
    }
    var alu: Bool = true
    func serverView(_ serverView: XNeovimServerView, selectionDidChange selection: XNeovimServerSelection) {
        //
        _selection = selection
        
        let start = SourceEditorPosition(line: selection.start.row - 1, col: selection.start.column)
        let end = SourceEditorPosition(line: selection.end.row - 1, col: selection.end.column)
        let range = SourceEditorRange(start: start, end: end)
        
        logger.debug?.write(range)
        
        DispatchQueue.main.async {
            //self.editorView.setSelectedRange(.init(start: start, end: end), modifiers: .unknow0)
            self.editorView.selectTextRange(range, scrollPlacement: 0, alwaysScroll: true)
            //self.editorContentView.setAccessibilitySelectedTextRange(.init(location: offset, length: 0))
        }
    }
    func serverView(_ serverView: XNeovimServerView!, modeDidChange mode: Int) {
        logger.debug?.write("\(mode)")

        DispatchQueue.main.async {
            if mode == 2 {
                self.editorView.setCursorStyle(0)
            } else {
                self.editorView.setCursorStyle(1)
            }
        }
    }
    
    let plugin: XNeovim
    let server: XNeovimServer
    
    let statusBar: XNeovimStatusBar
    
    unowned let editor: IDEEditor
    unowned let editorView: SourceEditorView
    unowned let editorContentView: NSView
    
    private var _selection: XNeovimServerSelection = .init()
}
