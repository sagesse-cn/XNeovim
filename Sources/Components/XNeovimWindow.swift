//
//  XNeovimWindow.swift
//  XNeovim
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

import AppKit
import XNeovimService

internal class XNeovimWindow: NSObject {
    
    internal init(editor: IDEEditor, editorView: NSView) {
        // Save document context
        self.editor = editor
        self.editorView = editorView

        self.plugin = XNeovim.shared
        self.service = XNeovim.shared.service
        
        // Initializes the status bar
        self.statusBar = .init(configure: "")
        
        super.init()

        // Setup environment
        self.editor.xvim_window = self
        self.editorView.xvim_window = self
        
        // Load file
        editor.document.fileURL.flatMap {
            var path = $0.path
            if editor.document.fileType == "com.apple.dt.playground" {
                path += "/Contents.swift"
            }
            service.command(.init(string: "edit \(path)"))
        }
    }
    
    internal func keyUp(_ event: NSEvent) -> NSEvent? {
        return event
    }
    
    internal func keyDown(_ event: NSEvent) -> NSEvent? {
        
        
        service.input(.init(event: event))
        
        //return event
        return nil
    }
    
    let plugin: XNeovim
    let service: XNeovimService
    
    let statusBar: XNeovimStatusBar
    
    unowned let editor: IDEEditor
    unowned let editorView: NSView
}
