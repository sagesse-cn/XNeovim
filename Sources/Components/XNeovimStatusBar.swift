//
//  XNeovimStatusBar.swift
//  XNeovim
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

import AppKit

internal class XNeovimStatusBar: NSTextField {
    
    convenience init(configure path: String) {
        self.init(frame: .zero)
        
        logger.trace?.write("init status bar")
        
        self.isEditable = false
        self.isSelectable = true
        self.isBordered = false
        
        self.stringValue = ""
        self.updateTheme()
        
        // Automatic update theme
        self.observer = NotificationCenter.default.addObserver(forName: .init("DVTFontAndColorSourceTextSettingsChangedNotification"), object: nil, queue: nil) { [weak self] _ in
            self?.updateTheme()
        }
    }
    deinit {
        self.scrollView = nil
        self.observer.map {
            NotificationCenter.default.removeObserver($0)
        }
        
        logger.trace?.write("deinit status bar")
    }
    
    override var isHidden: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: NSSize {
        //  When hidden, need to change the height
        guard isHidden else {
            return super.intrinsicContentSize
        }
        return .init(width: NSView.noIntrinsicMetric, height: 0)
    }
    
    override func layout() {
        super.layout()
        
        /// Update status bar height for scrollview if needed
        if extendedContentInsets.bottom != frame.height {
            extendedContentInsets.bottom = frame.height
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        logger.debug?.write(object, change)
    }
    
    func updateTheme() {
        // If cannot get theme, the topic switch is not supported
        guard let theme = DVTFontAndColorTheme.currentTheme() as? DVTFontAndColorTheme else {
            return
        }
        
        // configure status bar with theme
        font = theme.sourcePlainTextFont
        textColor = .white
        backgroundColor = theme.sourceTextSidebarBackgroundColor
        invalidateIntrinsicContentSize()
    }
    
    weak var scrollView: NSScrollView? {
        willSet {
            // Need restores old scrollview extended content insets
            scrollView.map {
                $0.contentInsets = .init(top: $0.contentInsets.top - extendedContentInsets.top,
                                         left: $0.contentInsets.left - extendedContentInsets.left,
                                         bottom: $0.contentInsets.bottom - extendedContentInsets.bottom,
                                         right: $0.contentInsets.right - extendedContentInsets.right)
                
                $0.removeObserver(self, forKeyPath: "contentSize")
            }
            
            // Need to update scrollview extended content insets at initialization
            newValue.map {
                $0.contentInsets = .init(top: $0.contentInsets.top + extendedContentInsets.top,
                                         left: $0.contentInsets.left + extendedContentInsets.left,
                                         bottom: $0.contentInsets.bottom + extendedContentInsets.bottom,
                                         right: $0.contentInsets.right + extendedContentInsets.right)
                
                $0.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            }
        }
    }
    
    var extendedContentInsets: NSEdgeInsets = .init() {
        willSet {
            // This is incremental change
            scrollView.map {
                $0.contentInsets = .init(top: $0.contentInsets.top + newValue.top - extendedContentInsets.top,
                                         left: $0.contentInsets.left + newValue.left - extendedContentInsets.left,
                                         bottom: $0.contentInsets.bottom + newValue.bottom - extendedContentInsets.bottom,
                                         right: $0.contentInsets.right + newValue.right - extendedContentInsets.right)
            }
        }
    }
    
    var observer: Any?
}
