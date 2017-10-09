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
    
    internal init(editor: IDEEditor, editorView: NSView, editorContentView: NSView) {
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
    
    func serverView(_ serverView: XNeovimServerView, selectionDidChange selection: XNeovimServerSelection) {
        //
        _selection = selection
        
        let startRow = selection.start.row
        let startColumn = selection.start.column
        
        let range = editorContentView.accessibilityRange(forLine: startRow - 1)
        let offset = range.location + max(min(startColumn, range.length - 2), 0)
        
        logger.debug?.write("\(startRow):\(startColumn) = \(offset) % \(range)")
        
        DispatchQueue.main.async {
            self.editorContentView.setAccessibilitySelectedTextRange(.init(location: offset, length: 0))
        }
    }
    
    let plugin: XNeovim
    let server: XNeovimServer
    
    let statusBar: XNeovimStatusBar
    
    unowned let editor: IDEEditor
    unowned let editorView: NSView
    unowned let editorContentView: NSView
    
    private var _selection: XNeovimServerSelection = .init()
}
