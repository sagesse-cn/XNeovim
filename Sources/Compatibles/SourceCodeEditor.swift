//
//  XVimSourceCodeEditor.m
//  XVim
//
//  Created by Tomas Lundell on 31/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

import AppKit


// SourceEditorSelectedSourceRangeChangedNotification
// SourceEditorDiagnosticsChangedNotification
//let SourceEditorDataSourceWillChangeNotification: Notification.Name = .init("SourceEditorDataSourceWillChangeNotification")
//let SourceEditorDataSourceChangedNotification: Notification.Name = .init("SourceEditorDataSourceChangedNotification")
//
//let SourceEditorDataSourceDidDeleteTextNotification: Notification.Name = .init("SourceEditorDataSourceDidDeleteTextNotification")
//let SourceEditorDataSourceDidInsertTextNotification: Notification.Name = .init("SourceEditorDataSourceDidInsertTextNotification")

var ix = 0

internal class SourceCodeEditor: IDEEditor {
    
    
    @NSManaged var sourceEditorView: SourceEditorView
    
    @objc dynamic func xvim_revertStateWithDictionary(_ sender: NSDictionary) {
        xvim_revertStateWithDictionary(sender)
        logger.debug?.write(sender)
    }
    
    @objc dynamic func xvim_viewDidLoad() {
        self.xvim_viewDidLoad()
        
        // Initialize neovim window
        let view = XNeovimView(editor: self, editorView: sourceEditorView, editorContentView: sourceEditorView.contentView)
        
        // defaults is normal mode
        sourceEditorView.setCursorStyle(1)
        
        // Initialize neovim statusbar
        view.statusBar.scrollView = sourceEditorView.scrollView
        view.statusBar.translatesAutoresizingMaskIntoConstraints = false
        
        //        // Bind its visibility to 'laststatus'
        //        XVimLaststatusTransformer* transformer = [[XVimLaststatusTransformer alloc] init];
        //        [status bind:@"hidden" toObject:[[XVim instance] options] withKeyPath:@"laststatus" options:@{NSValueTransformerBindingOption:transformer}];

        // Add status view & constraints (for the source view and status bar)
        sourceEditorView.addSubview(view.statusBar)
        sourceEditorView.addConstraints([
            .init(item: sourceEditorView, attribute: .bottom, relatedBy: .equal, toItem: view.statusBar, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: sourceEditorView, attribute: .leading, relatedBy: .equal, toItem: view.statusBar, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: sourceEditorView, attribute: .trailing, relatedBy: .equal, toItem: view.statusBar, attribute: .trailing, multiplier: 1, constant: 0),
        ])

//        let ptr = rd_function_byname("_T012SourceEditor0aB4ViewC11cursorStyleAA0ab6CursorE0Ofs", nil)
//        logger.debug?.write(ptr)
        
        NotificationCenter.default.addObserver(forName: SourceCodeEditor.dataSourceWillDidChangeNotification, object: nil, queue: nil) { notification in
            // forward to xvim_selectionDidChange
            //(notification.object as AnyObject?)?.xvim_selectionDidChange?(notification)
        }
        
        // Add to change observer
        SourceCodeEditor.selectionDidChangeObserver()
    }
    
    internal static let dataSourceWillDidChangeNotification: Notification.Name = .init("SourceEditorDataSourceWillChangeNotification")
    internal static let dataSourceDidChangeNotification: Notification.Name = .init("SourceEditorDataSourceChangedNotification")
    
    internal static let selectionDidChangeNotification: Notification.Name = .init("SourceEditorSelectedSourceRangeChangedNotification")
    internal static let selectionDidChangeObserver: () -> () = {
        var observer: Any?
        return {
            observer = observer ?? NotificationCenter.default.addObserver(forName: SourceCodeEditor.selectionDidChangeNotification, object: nil, queue: nil) { notification in
                // forward to xvim_selectionDidChange
                (notification.object as AnyObject?)?.xvim_selectionDidChange?(notification)
            }
        }
    }()
}

struct SourceEditorPosition: CustomStringConvertible {
    var line: Int
    var col: Int
    var description: String {
        return "\(line):\(col)"
    }
}

struct SourceEditorRange: CustomStringConvertible {
    var start: SourceEditorPosition
    var end: SourceEditorPosition
    var description: String {
        return "\(start) - \(end)"
    }
}

//cursorStyle: SourceEditor.SourceEditorCursorStyle.block

//enum SourceEditorSelectionModifiers: Int {
//    case unknow0
//    case unknow1
//    case unknow2 // block
//}
enum SourceEditorSelection {
    
    case single(range: SourceEditorRange, modifiers: Int)
    
    case multiple(ranges: [SourceEditorRange], modifiers: Int) // 2
}


internal class SourceEditorView: NSView {
    


    
    @nonobjc func unknow_000() {}//SourceEditor`SourceEditor.SourceEditorView.delegate.getter : weak Swift.Optional<SourceEditor.SourceEditorViewDelegate>
    @nonobjc func unknow_001() {}//SourceEditor`SourceEditor.SourceEditorView.delegate.setter : weak Swift.Optional<SourceEditor.SourceEditorViewDelegate>
    @nonobjc func unknow_002() {}//SourceEditor`SourceEditor.SourceEditorView.delegate.materializeForSet : weak Swift.Optional<SourceEditor.SourceEditorViewDelegate>
    @nonobjc func unknow_003() {}//SourceEditor`SourceEditor.SourceEditorView.contentViewOffset.getter : CoreGraphics.CGFloat
    @nonobjc func unknow_004() {}//SourceEditor`SourceEditor.SourceEditorView.contentViewOffset.setter : CoreGraphics.CGFloat
    @nonobjc func unknow_005() {}//SourceEditor`SourceEditor.SourceEditorView.contentViewOffset.materializeForSet : CoreGraphics.CGFloat
    @nonobjc func unknow_006() {}//SourceEditor`SourceEditor.SourceEditorView.structuredEditingController.getter : Swift.Optional<SourceEditor.StructuredEditingController>
    @nonobjc func unknow_007() {}//SourceEditor`SourceEditor.SourceEditorView.structuredEditingController.setter : Swift.Optional<SourceEditor.StructuredEditingController>
    @nonobjc func unknow_008() {}//SourceEditor`SourceEditor.SourceEditorView.structuredEditingController.materializeForSet : Swift.Optional<SourceEditor.StructuredEditingController>
    @nonobjc func unknow_009() {}//SourceEditor`SourceEditor.SourceEditorView.dataSource.getter : SourceEditor.SourceEditorDataSource
    @nonobjc func unknow_010() {}//SourceEditor`SourceEditor.SourceEditorView.dataSource.setter : SourceEditor.SourceEditorDataSource
    @nonobjc func unknow_011() {}//SourceEditor`SourceEditor.SourceEditorView.dataSource.materializeForSet : SourceEditor.SourceEditorDataSource
    @nonobjc func unknow_012() {}
    @nonobjc func unknow_013() {}
    @nonobjc func unknow_014() {}
    @nonobjc func unknow_015() {}
    @nonobjc func unknow_016() {}
    @nonobjc func unknow_017() {}
    @nonobjc func unknow_018() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.init(frame: __C.CGRect, sourceEditorScrollViewClass: __ObjC.SourceEditorScrollView.Type) -> IDEPegasusSourceEditor.SourceCodeEditorView
    @nonobjc func unknow_019() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.init(coder: __ObjC.NSCoder, sourceEditorScrollViewClass: __ObjC.SourceEditorScrollView.Type) -> Swift.Optional<IDEPegasusSourceEditor.SourceCodeEditorView>
    @nonobjc func unknow_020() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.__allocating_init(coder: __ObjC.NSCoder) -> Swift.Optional<IDEPegasusSourceEditor.SourceCodeEditorView>
    @nonobjc func unknow_021() {}//SourceEditor`SourceEditor.SourceEditorView.(commonInit in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> ()
    @nonobjc func unknow_022() {}//SourceEditor`SourceEditor.SourceEditorView.(updateSelectionManagerIsActive in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> ()
    @nonobjc func unknow_023() {}//SourceEditor`SourceEditor.SourceEditorView._wantsKeyDownForEvent(__ObjC.NSEvent) -> ObjectiveC.ObjCBool
    @nonobjc func unknow_024() {}//SourceEditor`SourceEditor.SourceEditorView.lineWrappingStyle.getter : Swift.Optional<SourceEditor.LineWrappingStyle>
    @nonobjc func unknow_025() {}//SourceEditor`SourceEditor.SourceEditorView.lineWrappingStyle.setter : Swift.Optional<SourceEditor.LineWrappingStyle>
    @nonobjc func unknow_026() {}//SourceEditor`SourceEditor.SourceEditorView.lineWrappingStyle.materializeForSet : Swift.Optional<SourceEditor.LineWrappingStyle>
    @nonobjc func unknow_027() {}//SourceEditor`SourceEditor.SourceEditorView.editorViewSnapshots(in: Swift.Array<__C.CGRect>) -> Swift.Optional<Swift.Array<__ObjC.NSImage>>
    @nonobjc func unknow_028() {}//SourceEditor`SourceEditor.SourceEditorView.setupStructuredEditingController() -> ()
    @nonobjc func unknow_029() {}//SourceEditor`SourceEditor.SourceEditorView.selectStructureAtPosition(SourceEditor.SourceEditorPosition) -> ()
    @nonobjc func unknow_030() {}
    @nonobjc func unknow_031() {}
    @nonobjc func unknow_032() {}
    @nonobjc func unknow_033() {}//SourceEditor`SourceEditor.SourceEditorView.trimTrailingWhitespaceStyle.getter : Swift.Optional<SourceEditor.TrimTrailingWhitespaceStyle>
    @nonobjc func unknow_034() {}//SourceEditor`SourceEditor.SourceEditorView.trimTrailingWhitespaceStyle.setter : Swift.Optional<SourceEditor.TrimTrailingWhitespaceStyle>
    @nonobjc func unknow_035() {}//SourceEditor`SourceEditor.SourceEditorView.trimTrailingWhitespaceStyle.materializeForSet : Swift.Optional<SourceEditor.TrimTrailingWhitespaceStyle>
    @nonobjc func unknow_036() {}
    @nonobjc func unknow_037() {}//SourceEditor`SourceEditor.SourceEditorView.(configureEditAssistant in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> ()
    @nonobjc func unknow_038() {}//SourceEditor`SourceEditor.SourceEditorView.colorTheme.getter : SourceEditor.SourceEditorColorTheme
    @nonobjc func unknow_039() {}//SourceEditor`SourceEditor.SourceEditorView.colorTheme.setter : SourceEditor.SourceEditorColorTheme
    @nonobjc func unknow_040() {}//SourceEditor`SourceEditor.SourceEditorView.colorTheme.materializeForSet : SourceEditor.SourceEditorColorTheme
    @nonobjc func unknow_041() {}//SourceEditor`SourceEditor.SourceEditorView.fontTheme.getter : SourceEditor.SourceEditorFontTheme
    @nonobjc func unknow_042() {}//SourceEditor`SourceEditor.SourceEditorView.fontTheme.setter : SourceEditor.SourceEditorFontTheme
    @nonobjc func unknow_043() {}//SourceEditor`SourceEditor.SourceEditorView.fontTheme.materializeForSet : SourceEditor.SourceEditorFontTheme
    @nonobjc func unknow_044() {}//SourceEditor`SourceEditor.SourceEditorView.showInvisiblesTheme.getter : Swift.Optional<SourceEditor.ShowInvisiblesTheme>
    @nonobjc func unknow_045() {}//SourceEditor`SourceEditor.SourceEditorView.showInvisiblesTheme.setter : Swift.Optional<SourceEditor.ShowInvisiblesTheme>
    @nonobjc func unknow_046() {}//SourceEditor`SourceEditor.SourceEditorView.showInvisiblesTheme.materializeForSet : Swift.Optional<SourceEditor.ShowInvisiblesTheme>
    @nonobjc func unknow_047() {}//SourceEditor`SourceEditor.SourceEditorView.fontSmoothingAttributes.getter : SourceEditor.SourceEditorFontSmoothingAttributes
    @nonobjc func unknow_048() {}//SourceEditor`SourceEditor.SourceEditorView.fontSmoothingAttributes.setter : SourceEditor.SourceEditorFontSmoothingAttributes
    @nonobjc func unknow_049() {}//SourceEditor`SourceEditor.SourceEditorView.fontSmoothingAttributes.materializeForSet : SourceEditor.SourceEditorFontSmoothingAttributes
    @nonobjc func unknow_050() {}//SourceEditor`SourceEditor.SourceEditorView.automaticallyAdjustsContentMargins.getter : Swift.Bool
    @nonobjc func unknow_051() {}//SourceEditor`SourceEditor.SourceEditorView.automaticallyAdjustsContentMargins.setter : Swift.Bool
    @nonobjc func unknow_052() {}//SourceEditor`SourceEditor.SourceEditorView.automaticallyAdjustsContentMargins.materializeForSet : Swift.Bool
    @nonobjc func unknow_053() {}//SourceEditor`SourceEditor.SourceEditorView.cursorStyle.getter : SourceEditor.SourceEditorCursorStyle
    @nonobjc func setCursorStyle(_: Int) {}//SourceEditor`SourceEditor.SourceEditorView.cursorStyle.setter : SourceEditor.SourceEditorCursorStyle
    @nonobjc func unknow_055() {}//SourceEditor`SourceEditor.SourceEditorView.cursorStyle.materializeForSet : SourceEditor.SourceEditorCursorStyle
    @nonobjc func unknow_056() {}//SourceEditor`SourceEditor.SourceEditorView.invalidateCursorRects() -> ()
    @nonobjc func unknow_057() {}//SourceEditor`SourceEditor.SourceEditorView.contentRectForCursor() -> __C.CGRect
    @nonobjc func unknow_058() {}//SourceEditor`SourceEditor.SourceEditorView.(cursorForContentRect in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> __ObjC.NSCursor
    @nonobjc func unknow_059() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.mouseCursorForStructuredSelection(with: Swift.Optional<__ObjC.NSEvent>) -> Swift.Optional<__ObjC.NSCursor>
    @nonobjc func unknow_060() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotations.getter : Swift.Array<SourceEditor.SourceEditorLineAnnotation>
    @nonobjc func unknow_061() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotations.setter : Swift.Array<SourceEditor.SourceEditorLineAnnotation>
    @nonobjc func unknow_062() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotations.materializeForSet : Swift.Array<SourceEditor.SourceEditorLineAnnotation>
    @nonobjc func unknow_063() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotationManager.getter : SourceEditor.SourceEditorLineAnnotationManager
    @nonobjc func unknow_064() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotationManager.setter : SourceEditor.SourceEditorLineAnnotationManager
    @nonobjc func unknow_065() {}//SourceEditor`SourceEditor.SourceEditorView.lineAnnotationManager.materializeForSet : SourceEditor.SourceEditorLineAnnotationManager
    @nonobjc func unknow_066() {}//SourceEditor`SourceEditor.SourceEditorView.expandLineAnnotationsOnLine(Swift.Int, animated: Swift.Bool) -> ()
    @nonobjc func unknow_067() {}//SourceEditor`SourceEditor.SourceEditorView.allowLineAnnotationAnimations.getter : Swift.Bool
    @nonobjc func unknow_068() {}//SourceEditor`SourceEditor.SourceEditorView.allowLineAnnotationAnimations.setter : Swift.Bool
    @nonobjc func unknow_069() {}//SourceEditor`SourceEditor.SourceEditorView.allowLineAnnotationAnimations.materializeForSet : Swift.Bool
    @nonobjc func unknow_070() {}
    @nonobjc func unknow_071() {}//SourceEditor`SourceEditor.SourceEditorView.gutter.getter : Swift.Optional<SourceEditor.SourceEditorGutter>
    @nonobjc func unknow_072() {}//SourceEditor`SourceEditor.SourceEditorView.gutter.setter : Swift.Optional<SourceEditor.SourceEditorGutter>
    @nonobjc func unknow_073() {}//SourceEditor`SourceEditor.SourceEditorView.gutter.materializeForSet : Swift.Optional<SourceEditor.SourceEditorGutter>
    @nonobjc func unknow_074() {}//SourceEditor`SourceEditor.SourceEditorView.gutterAnnotations.getter : Swift.Set<SourceEditor.SourceEditorGutterAnnotation>
    @nonobjc func unknow_075() {}//SourceEditor`SourceEditor.SourceEditorView.gutterAnnotations.setter : Swift.Set<SourceEditor.SourceEditorGutterAnnotation>
    @nonobjc func unknow_076() {}//SourceEditor`SourceEditor.SourceEditorView.gutterAnnotations.materializeForSet : Swift.Set<SourceEditor.SourceEditorGutterAnnotation>
    @nonobjc func unknow_077() {}
    @nonobjc func unknow_078() {}
    @nonobjc func unknow_079() {}
    @nonobjc func unknow_080() {}//SourceEditor`SourceEditor.SourceEditorView.registerDraggingExtension(SourceEditor.SourceEditorViewDraggingExtension, identifier: Swift.String) -> ()
    @nonobjc func unknow_081() {}//SourceEditor`SourceEditor.SourceEditorView.unregisterDraggingExtensionWith(identifier: Swift.String) -> ()
    @nonobjc func unknow_082() {}
    @nonobjc func unknow_083() {}//SourceEditor`SourceEditor.SourceEditorView.textFindableDisplay.getter : SourceEditor.TextFindableDisplay
    @nonobjc func unknow_084() {}//SourceEditor`SourceEditor.SourceEditorView.textFindableDisplay.setter : SourceEditor.TextFindableDisplay
    @nonobjc func unknow_085() {}//SourceEditor`SourceEditor.SourceEditorView.textFindableDisplay.materializeForSet : SourceEditor.TextFindableDisplay
    @nonobjc func unknow_086() {}//SourceEditor`SourceEditor.SourceEditorView.textFindPanel.getter : SourceEditor.TextFindPanel
    @nonobjc func unknow_087() {}//SourceEditor`SourceEditor.SourceEditorView.textFindPanel.setter : SourceEditor.TextFindPanel
    @nonobjc func unknow_088() {}//SourceEditor`SourceEditor.SourceEditorView.textFindPanel.materializeForSet : SourceEditor.TextFindPanel
    @nonobjc func unknow_089() {}//SourceEditor`SourceEditor.SourceEditorView.textFindPanelHost.getter : SourceEditor.TextFindPanelHost
    @nonobjc func unknow_090() {}//SourceEditor`SourceEditor.SourceEditorView.textFindPanelDisplayed.getter : Swift.Bool
    @nonobjc func unknow_091() {}
    @nonobjc func unknow_092() {}
    @nonobjc func unknow_093() {}//SourceEditor`SourceEditor.SourceEditorView.findQuery.getter : SourceEditor.TextFindQuery
    @nonobjc func unknow_094() {}//SourceEditor`SourceEditor.SourceEditorView.findQuery.setter : SourceEditor.TextFindQuery
    @nonobjc func unknow_095() {}//SourceEditor`SourceEditor.SourceEditorView.findQuery.materializeForSet : SourceEditor.TextFindQuery
    @nonobjc func unknow_096() {}//SourceEditor`SourceEditor.SourceEditorView.findResult.getter : Swift.Optional<SourceEditor.TextFindResult>
    @nonobjc func unknow_097() {}//SourceEditor`SourceEditor.SourceEditorView.findResult.setter : Swift.Optional<SourceEditor.TextFindResult>
    @nonobjc func unknow_098() {}//SourceEditor`SourceEditor.SourceEditorView.findResult.materializeForSet : Swift.Optional<SourceEditor.TextFindResult>
    @nonobjc func unknow_099() {}//SourceEditor`SourceEditor.SourceEditorView.findReplaceWith.getter : Swift.Optional<SourceEditor.TextFindValue>
    @nonobjc func unknow_0a0() {}//SourceEditor`SourceEditor.SourceEditorView.findReplaceWith.setter : Swift.Optional<SourceEditor.TextFindValue>
    @nonobjc func unknow_0a1() {}//SourceEditor`SourceEditor.SourceEditorView.findReplaceWith.materializeForSet : Swift.Optional<SourceEditor.TextFindValue>
    @nonobjc func unknow_0a2() {}//SourceEditor`SourceEditor.SourceEditorView.findResultNeedUpdate.getter : Swift.Bool
    @nonobjc func unknow_0a3() {}//SourceEditor`SourceEditor.SourceEditorView.findResultNeedUpdate.setter : Swift.Bool
    @nonobjc func unknow_0a4() {}//SourceEditor`SourceEditor.SourceEditorView.findResultNeedUpdate.materializeForSet : Swift.Bool
    @nonobjc func unknow_0a5() {}
    @nonobjc func unknow_0a6() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.pullFindConfigurationForFindQuery() -> ()
    @nonobjc func unknow_0a7() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.pushFindConfigurationForFindQuery() -> ()
    @nonobjc func unknow_0a8() {}//SourceEditor`SourceEditor.SourceEditorView.findPanelTopAnchor.getter : __ObjC.NSLayoutYAxisAnchor
    @nonobjc func unknow_0a9() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.present(SourceEditor.TextFindPanel) -> ()
    @nonobjc func unknow_0b0() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.dismiss(SourceEditor.TextFindPanel) -> ()
    @nonobjc func unknow_0b1() {}//SourceEditor`SourceEditor.SourceEditorView.selectedSymbolHighlightDelay.getter : Swift.Optional<Swift.Double>
    @nonobjc func unknow_0b2() {}//SourceEditor`SourceEditor.SourceEditorView.selectedSymbolHighlightDelay.setter : Swift.Optional<Swift.Double>
    @nonobjc func unknow_0b3() {}//SourceEditor`SourceEditor.SourceEditorView.selectedSymbolHighlightDelay.materializeForSet : Swift.Optional<Swift.Double>
    @nonobjc func unknow_0b4() {}
    @nonobjc func unknow_0b5() {}
    @nonobjc func unknow_0b6() {}
    @nonobjc func unknow_0b7() {}
    @nonobjc func unknow_0b8() {}
    @nonobjc func unknow_0b9() {}
    @nonobjc func unknow_0c0() {}//SourceEditor`SourceEditor.SourceEditorView.delimiterHighlightEnabled.getter : Swift.Bool
    @nonobjc func unknow_0c1() {}//SourceEditor`SourceEditor.SourceEditorView.delimiterHighlightEnabled.setter : Swift.Bool
    @nonobjc func unknow_0c2() {}//SourceEditor`SourceEditor.SourceEditorView.delimiterHighlightEnabled.materializeForSet : Swift.Bool
    @nonobjc func unknow_0c3() {}//SourceEditor`SourceEditor.SourceEditorView.coverageLayoutVisualization.getter : Swift.Optional<SourceEditor.CodeCoverageVisualization>
    @nonobjc func unknow_0c4() {}//SourceEditor`SourceEditor.SourceEditorView.coverageLayoutVisualization.setter : Swift.Optional<SourceEditor.CodeCoverageVisualization
    @nonobjc func unknow_0c5() {}//SourceEditor`SourceEditor.SourceEditorView.coverageLayoutVisualization.materializeForSet : Swift.Optional<SourceEditor.CodeCoverageVisualization>
    @nonobjc func unknow_0c6() {}//SourceEditor`SourceEditor.SourceEditorView.isEditingEnabled.getter : Swift.Bool
    @nonobjc func unknow_0c7() {}//SourceEditor`SourceEditor.SourceEditorView.isEditingEnabled.setter : Swift.Bool
    @nonobjc func unknow_0c8() {}//SourceEditor`SourceEditor.SourceEditorView.isEditingEnabled.materializeForSet : Swift.Bool
    @nonobjc func unknow_0c9() {}
    @nonobjc func unknow_0d0() {}
    @nonobjc func unknow_0d1() {}
    @nonobjc func unknow_0d2() {}//SourceEditor`SourceEditor.SourceEditorView.clearSelectionAnchors() -> ())
    @nonobjc func selection() -> SourceEditorSelection? { fatalError() }//SourceEditor`SourceEditor.SourceEditorView.selection.getter : Swift.Optional<SourceEditor.SourceEditorSelection>
    @nonobjc func unknow_0d4() {}
    @nonobjc func unknow_0d5() {}
    @nonobjc func setSelectedRange(_ range: SourceEditorRange, modifiers: Int) {}//SourceEditor`SourceEditor.SourceEditorView.setSelectedRange(SourceEditor.SourceEditorRange, modifiers: SourceEditor.SourceEditorSelectionModifiers) -> ()
    @nonobjc func setSelectedRanges(_ ranges: [SourceEditorRange], modifiers: Int) {}//SourceEditor`SourceEditor.SourceEditorView.setSelectedRanges(Swift.Array<SourceEditor.SourceEditorRange>, modifiers: SourceEditor.SourceEditorSelectionModifiers) -> ()
    @nonobjc func unknow_0d8() {}//SourceEditor`SourceEditor.SourceEditorView.addSelectedRange(SourceEditor.SourceEditorRange, modifiers: SourceEditor.SourceEditorSelectionModifiers) -> ()
    @nonobjc func unknow_0d9() {}//SourceEditor`SourceEditor.SourceEditorView.addSelectedRanges(Swift.Array<SourceEditor.SourceEditorRange>, modifiers: SourceEditor.SourceEditorSelectionModifiers) -> ()
    @nonobjc func unknow_0e0() {}
    @nonobjc func unknow_0e1() {}
    @nonobjc func unknow_0e2() {}//SourceEditor`SourceEditor.SourceEditorView.selectedSourceRange.getter : Swift.Optional<SourceEditor.SourceEditorRange>
    @nonobjc func unknow_0e3() {}//SourceEditor`SourceEditor.SourceEditorView.drawableSelectedSourceRanges.getter : Swift.Array<SourceEditor.SourceEditorRange>
    @nonobjc func selectionWillChange() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.selectionWillChange() -> ()
    @nonobjc func unknow_0e5() {}
    @nonobjc func unknow_0e6() {}
    @nonobjc func unknow_0e7() {}
    @nonobjc func unknow_0e8() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.selectionDidChange(from: Swift.Optional<SourceEditor.SourceEditorSelection>) -> ()
    @nonobjc func unknow_0e9() {}//SourceEditor`SourceEditor.SourceEditorView.(calloutVisualization in _21FB12A7D498BCC8AE8B7D65E086EAF9).getter : SourceEditor.RangePopLayoutVisualization
    @nonobjc func unknow_0f0() {}
    @nonobjc func unknow_0f1() {}
    @nonobjc func unknow_0f2() {}//SourceEditor`SourceEditor.SourceEditorView.showCallout(for: SourceEditor.SourceEditorRange) -> ()
    @nonobjc func unknow_0f3() {}//SourceEditor`SourceEditor.SourceEditorView.escapeKeyTriggersCodeCompletion.getter : Swift.Bool
    @nonobjc func unknow_0f4() {}//SourceEditor`SourceEditor.SourceEditorView.isShowingCodeCompletion.getter : Swift.Bool
    @nonobjc func unknow_0f5() {}//SourceEditor`SourceEditor.SourceEditorView.isCodeCompletionEnabled.getter : Swift.Bool
    @nonobjc func unknow_0f6() {}//SourceEditor`SourceEditor.SourceEditorView.isCodeCompletionEnabled.setter : Swift.Bool
    @nonobjc func unknow_0f7() {}//SourceEditor`SourceEditor.SourceEditorView.isCodeCompletionEnabled.materializeForSet : Swift.Bool
    @nonobjc func unknow_0f8() {}
    @nonobjc func unknow_0f9() {}
    @nonobjc func unknow_100() {}
    @nonobjc func unknow_101() {}//SourceEditor`SourceEditor.SourceEditorView.codeCompletionController.getter : Swift.Optional<SourceEditor.SourceEditorCodeCompletionController>
    @nonobjc func unknow_102() {}
    @nonobjc func unknow_103() {}
    @nonobjc func unknow_104() {}//SourceEditor`SourceEditor.SourceEditorView.currentListShownExplicitly.getter : Swift.Bool
    @nonobjc func unknow_105() {}//SourceEditor`SourceEditor.SourceEditorView.currentListShownExplicitly.setter : Swift.Bool
    @nonobjc func unknow_106() {}//SourceEditor`SourceEditor.SourceEditorView.currentListShownExplicitly.materializeForSet : Swift.Bool
    @nonobjc func unknow_107() {}//SourceEditor`SourceEditor.SourceEditorView.currentListWordStart.getter : Swift.Optional<SourceEditor.SourceEditorPosition>
    @nonobjc func unknow_108() {}//SourceEditor`SourceEditor.SourceEditorView.currentListWordStart.setter : Swift.Optional<SourceEditor.SourceEditorPosition>
    @nonobjc func unknow_109() {}//SourceEditor`SourceEditor.SourceEditorView.currentListWordStart.materializeForSet : Swift.Optional<SourceEditor.SourceEditorPosition>
    @nonobjc func unknow_110() {}//SourceEditor`SourceEditor.SourceEditorView.tokenRangeAtCursorPosition(SourceEditor.SourceEditorPosition) -> Swift.Optional<(Swift.Optional<SourceEditor.SourceEditorTokenType>, SourceEditor.SourceEditorRange)>
    @nonobjc func unknow_111() {}//SourceEditor`SourceEditor.SourceEditorView.rangeOfCodeCompletionTokenToReplace(at: SourceEditor.SourceEditorPosition) -> Swift.Optional<SourceEditor.SourceEditorRange>
    @nonobjc func unknow_112() {}//SourceEditor`SourceEditor.SourceEditorView.codeCompletionWordStart(for: SourceEditor.SourceEditorPosition) -> SourceEditor.SourceEditorPosition
    @nonobjc func unknow_113() {}//SourceEditor`SourceEditor.SourceEditorView.shouldProvideCodeCompletionInCurrentRange.getter : Swift.Bool
    @nonobjc func unknow_114() {}
    @nonobjc func unknow_115() {}
    @nonobjc func unknow_116() {}
    @nonobjc func unknow_117() {}
    @nonobjc func unknow_118() {}
    @nonobjc func unknow_119() {}//SourceEditor`SourceEditor.SourceEditorView.overrideCompletionDisplay(shouldDisplay: Swift.Bool) -> ()
    @nonobjc func unknow_120() {}//SourceEditor`SourceEditor.SourceEditorView.codeCompletionAvailabilityChanged(duringReload: Swift.Bool) -> ()
    @nonobjc func unknow_121() {}//SourceEditor`SourceEditor.SourceEditorView.queueCodeCompletion(explicitly: Swift.Bool) -> ()
    @nonobjc func unknow_122() {}//SourceEditor`SourceEditor.SourceEditorView.shouldAutocompleteHumanTextInRange(SourceEditor.SourceEditorRange) -> Swift.Bool
    @nonobjc func unknow_123() {}//SourceEditor`SourceEditor.SourceEditorView.completionRangeForCodeCompletionController(SourceEditor.SourceEditorCodeCompletionController) -> Swift.Optional<SourceEditor.SourceEditorRange>
    @nonobjc func unknow_124() {}//SourceEditor`SourceEditor.SourceEditorView.completionDataSourceForCodeCompletionController(SourceEditor.SourceEditorCodeCompletionController) -> SourceEditor.SourceEditorDataSource
    @nonobjc func unknow_125() {}//SourceEditor`SourceEditor.SourceEditorView.performCompletionForSuggestion(SourceEditor.SourceEditorCodeCompletionSuggestion, knownSnippets: Swift.Dictionary<Swift.String, Swift.String>, isReturn: Swift.Bool) -> (Swift.Bool, Swift.Bool)
    @nonobjc func unknow_126() {}//SourceEditor`SourceEditor.SourceEditorView.replaceTextAtCodeCompletionInsertionPoint(with: Swift.String, eraseBytes: Swift.Int) -> (Swift.Bool, Swift.Bool)
    @nonobjc func unknow_127() {}//SourceEditor`SourceEditor.SourceEditorView.showCodeCompletionSuggestionList() -> ()
    @nonobjc func unknow_128() {}//SourceEditor`SourceEditor.SourceEditorView.hideCodeCompletionSuggestionList(withReason: SourceEditor.CodeCompletionDismissalReason) -> Swift.Bool
    @nonobjc func unknow_129() {}//SourceEditor`SourceEditor.SourceEditorView.shouldAutomaticallyShowCompletionSuggestions(at: SourceEditor.SourceEditorPosition) -> Swift.Bool
    @nonobjc func unknow_130() {}//SourceEditor`SourceEditor.SourceEditorView.shouldSuppressCodeCompletion() -> Swift.Bool
    @nonobjc func unknow_131() {}
    @nonobjc func unknow_132() {}
    @nonobjc func unknow_133() {}
    @nonobjc func unknow_134() {}
    @nonobjc func unknow_135() {}
    @nonobjc func unknow_136() {}
    @nonobjc func unknow_137() {}
    @nonobjc func unknow_138() {}
    @nonobjc func unknow_139() {}
    @nonobjc func unknow_140() {}
    @nonobjc func unknow_141() {}
    @nonobjc func unknow_142() {}
    @nonobjc func unknow_143() {}
    @nonobjc func unknow_144() {}
    @nonobjc func unknow_145() {}
    @nonobjc func selectTextPosition(_ position: SourceEditorPosition, scrollPlacement: Int?, alwaysScroll: Bool) {}//SourceEditor`SourceEditor.SourceEditorView.selectTextPosition(SourceEditor.SourceEditorPosition, scrollPlacement: Swift.Optional<SourceEditor.ScrollPlacement>, alwaysScroll: Swift.Bool) -> ()
    @nonobjc func selectTextRange(_ range: SourceEditorRange?, scrollIfNeeded: Bool) {}//SourceEditor`SourceEditor.SourceEditorView.selectTextRange(Swift.Optional<SourceEditor.SourceEditorRange>, scrollIfNeeded: Swift.Bool) -> ()
    @nonobjc func selectTextRange(_ range: SourceEditorRange?, scrollPlacement: Int?, alwaysScroll: Bool) {}//SourceEditor`SourceEditor.SourceEditorView.selectTextRange(Swift.Optional<SourceEditor.SourceEditorRange>, scrollPlacement: Swift.Optional<SourceEditor.ScrollPlacement>, alwaysScroll: Swift.Bool) -> ()
    @nonobjc func unknow_149() {}
    @nonobjc func unknow_150() {}//SourceEditor`SourceEditor.SourceEditorView.scrollToSelection(scrollPlacement: SourceEditor.ScrollPlacement, alwaysScroll: Swift.Bool) -> ()
    @nonobjc func unknow_151() {}//SourceEditor`SourceEditor.SourceEditorView.scrollTo(position: SourceEditor.SourceEditorPosition, placement: SourceEditor.ScrollPlacement, offset: CoreGraphics.CGFloat) -> ()
    @nonobjc func unknow_152() {}
    @nonobjc func unknow_153() {}//SourceEditor`SourceEditor.SourceEditorView.(suggestedHorizontalScrollPoint in _21FB12A7D498BCC8AE8B7D65E086EAF9)(for: SourceEditor.SourceEditorRange, anchorToStart: Swift.Bool, placement: SourceEditor.ScrollPlacement) -> Swift.Optional<CoreGraphics.CGFloat>
    @nonobjc func unknow_154() {}
    @nonobjc func unknow_155() {}
    @nonobjc func unknow_156() {}//SourceEditor`SourceEditor.SourceEditorView.isPositionInVisibleRect(SourceEditor.SourceEditorPosition) -> Swift.Bool
    @nonobjc func unknow_157() {}//SourceEditor`SourceEditor.SourceEditorView.currentScrollState() -> (Swift.Int, CoreGraphics.CGFloat)
    @nonobjc func unknow_158() {}//SourceEditor`SourceEditor.SourceEditorView.applyScrollState(line: Swift.Int, offset: CoreGraphics.CGFloat) -> ()
    @nonobjc func unknow_159() {}//SourceEditor`SourceEditor.SourceEditorView.contextualMenuItemProvider.getter : weak Swift.Optional<SourceEditor.SourceEditorViewContextualMenuItemProvider>
    @nonobjc func unknow_160() {}//SourceEditor`SourceEditor.SourceEditorView.contextualMenuItemProvider.setter : weak Swift.Optional<SourceEditor.SourceEditorViewContextualMenuItemProvider>
    @nonobjc func unknow_161() {}//SourceEditor`SourceEditor.SourceEditorView.contextualMenuItemProvider.materializeForSet : weak Swift.Optional<SourceEditor.SourceEditorViewContextualMenuItemProvider>
    @nonobjc func unknow_162() {}//SourceEditor`SourceEditor.SourceEditorView.structuredSelectionDelegate.getter : weak Swift.Optional<SourceEditor.SourceEditorViewStructuredSelectionDelegate>
    @nonobjc func unknow_163() {}//SourceEditor`SourceEditor.SourceEditorView.structuredSelectionDelegate.setter : weak Swift.Optional<SourceEditor.SourceEditorViewStructuredSelectionDelegate>
    @nonobjc func unknow_164() {}//SourceEditor`SourceEditor.SourceEditorView.structuredSelectionDelegate.materializeForSet : weak Swift.Optional<SourceEditor.SourceEditorViewStructuredSelectionDelegate>
    @nonobjc func unknow_165() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.quickEditRangeForPosition(SourceEditor.SourceEditorPosition) -> Swift.Optional<SourceEditor.SourceEditorRange>
    @nonobjc func unknow_166() {}//SourceEditor`SourceEditor.SourceEditorView.eventConsumers.getter : Swift.Array<SourceEditor.SourceEditorViewEventConsumer>
    @nonobjc func unknow_167() {}
    @nonobjc func unknow_168() {}
    @nonobjc func unknow_169() {}//SourceEditor`SourceEditor.SourceEditorView.addEventConsumer(SourceEditor.SourceEditorViewEventConsumer) -> ()
    @nonobjc func unknow_170() {}//SourceEditor`SourceEditor.SourceEditorView.removeEventConsumer(SourceEditor.SourceEditorViewEventConsumer) -> ()
    @nonobjc func unknow_171() {}
    @nonobjc func unknow_172() {}
    @nonobjc func unknow_173() {}
    @nonobjc func unknow_174() {}
    @nonobjc func unknow_175() {}//SourceEditor`SourceEditor.SourceEditorView.closestPositionAtPoint(__C.CGPoint) -> Swift.Optional<SourceEditor.SourceEditorPosition>
    @nonobjc func unknow_176() {}//SourceEditor`SourceEditor.SourceEditorView.positionAtPoint(__C.CGPoint) -> Swift.Optional<SourceEditor.SourceEditorPosition>
    @nonobjc func unknow_177() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.dataSourceContentsChanged(Swift.Optional<SourceEditor.SourceEditorRange>) -> ()
    @nonobjc func unknow_178() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceDidInsertTextInRange(SourceEditor.SourceEditorRange) -> ()
    @nonobjc func unknow_179() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceDidDeleteTextInRange(SourceEditor.SourceEditorRange) -> ()
    @nonobjc func unknow_180() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceDidInsertLines(Foundation.IndexSet) -> ()
    @nonobjc func unknow_181() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceDidDeleteLines(Foundation.IndexSet) -> ()
    @nonobjc func unknow_182() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceBeginEditTransaction() -> ()
    @nonobjc func unknow_183() {}//SourceEditor`SourceEditor.SourceEditorView.dataSourceEndEditTransaction() -> ()
    @nonobjc func unknow_184() {}
    @nonobjc func unknow_185() {}//SourceEditor`SourceEditor.SourceEditorView.editing.getter : Swift.Bool
    @nonobjc func unknow_186() {}//SourceEditor`SourceEditor.SourceEditorView.editing.setter : Swift.Bool
    @nonobjc func unknow_187() {}//SourceEditor`SourceEditor.SourceEditorView.editing.materializeForSet : Swift.Bool
    @nonobjc func unknow_188() {}
    @nonobjc func unknow_189() {}
    @nonobjc func unknow_190() {}
    @nonobjc func unknow_191() {}
    @nonobjc func unknow_192() {}
    @nonobjc func unknow_193() {}
    @nonobjc func unknow_194() {}
    @nonobjc func unknow_195() {}//SourceEditor`SourceEditor.SourceEditorView.contentSize.getter : CoreGraphics.CGFloat
    @nonobjc func unknow_196() {}
    @nonobjc func unknow_197() {}
    @nonobjc func unknow_198() {}//SourceEditor`SourceEditor.SourceEditorView.(updateContentSize in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> ()
    @nonobjc func unknow_199() {}//SourceEditor`SourceEditor.SourceEditorView.updateContentSizeIfNeeded() -> ()
    @nonobjc func unknow_1a0() {}//SourceEditor`SourceEditor.SourceEditorView.(updateContentOffsetIfNeeded in _21FB12A7D498BCC8AE8B7D65E086EAF9)() -> ()
    @nonobjc func unknow_1a1() {}
    @nonobjc func unknow_1a2() {}
    @nonobjc func unknow_1a3() {}
    @nonobjc func unknow_1a4() {}
    @nonobjc func unknow_1a5() {}
    @nonobjc func unknow_1a6() {}
    @nonobjc func unknow_1a7() {}
    @nonobjc func unknow_1a8() {}//IDEPegasusSourceEditor`IDEPegasusSourceEditor.SourceCodeEditorView.contentViewDidFinishLayout() -> ()
    @nonobjc func unknow_1a9() {}
    @nonobjc func unknow_1b0() {}
    @nonobjc func unknow_1b1() {}
    @nonobjc func unknow_1b2() {}
    @nonobjc func unknow_1b3() {}
    @nonobjc func unknow_1b4() {}
    @nonobjc func unknow_1b5() {}
    @nonobjc func unknow_1b6() {}
    @nonobjc func unknow_1b7() {}
    @nonobjc func unknow_1b8() {}
    @nonobjc func unknow_1b9() {}
    @nonobjc func unknow_1c0() {}
    @nonobjc func unknow_1c1() {}
    @nonobjc func unknow_1c2() {}
    @nonobjc func unknow_1c3() {}
    @nonobjc func unknow_1c4() {}
    @nonobjc func unknow_1c5() {}
    @nonobjc func unknow_1c6() {}
    @nonobjc func unknow_1c7() {}
    @nonobjc func unknow_1c8() {}
    @nonobjc func unknow_1c9() {}
    @nonobjc func unknow_1d0() {}
    @nonobjc func unknow_1d1() {}
    @nonobjc func unknow_1d2() {}
    @nonobjc func unknow_1d3() {}
    @nonobjc func unknow_1d4() {}
    @nonobjc func unknow_1d5() {}
    @nonobjc func unknow_1d6() {}
    @nonobjc func unknow_1d7() {}
    @nonobjc func unknow_1d8() {}
    @nonobjc func unknow_1d9() {}
    @nonobjc func unknow_1e0() {}
    @nonobjc func unknow_1e1() {}
    @nonobjc func unknow_1e2() {}
    @nonobjc func unknow_1e3() {}
    @nonobjc func unknow_1e4() {}
    @nonobjc func unknow_1e5() {}
    @nonobjc func unknow_1e6() {}
    @nonobjc func unknow_1e7() {}
    @nonobjc func unknow_1e8() {}
    @nonobjc func unknow_1e9() {}
    @nonobjc func unknow_1f0() {}
    @nonobjc func unknow_1f1() {}
    @nonobjc func unknow_1f2() {}
    @nonobjc func unknow_1f3() {}
    @nonobjc func unknow_1f4() {}
    @nonobjc func unknow_1f5() {}
    @nonobjc func unknow_1f6() {}
    @nonobjc func unknow_1f7() {}
    @nonobjc func unknow_1f8() {}
    @nonobjc func unknow_1f9() {}
    
    //    @objc dynamic func xvim_concludeDragOperation(_ sender: NSDraggingInfo?) {
    //        xvim_concludeDragOperation(sender)
    //        logger.debug?.write()
    //    }
    //    @objc dynamic func xvim_performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    //        let x = xvim_performDragOperation(sender)
    //        logger.debug?.write()
    //        return x
    //    }
    //    @objc dynamic func xvim_prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    //        let x = xvim_prepareForDragOperation(sender)
    //        logger.debug?.write()
    //        return x
    //    }
    
    //
    //
    //
    //    @objc override dynamic func rightMouseUp(with event: NSEvent) {
    ////        xvim_rightMouseUp(event)
    //        logger.debug?.write(event)
    //    }
    //
    //    @objc override dynamic func rightMouseDown(_ event: NSEvent) {
    ////        xvim_rightMouseDown(event)
    //        logger.debug?.write(event)
    //    }
    
    //    @objc dynamic func xvim_mouseDragged(_ event: NSEvent) {
    ////        logger.debug?.write(event)
    //
    //
    //        //NSEvent: type=LMouseDragged loc=(55.0625,524.395) time=1035298.3 flags=0x80020 win=0x10a23f590 winNum=21652 ctxt=0x0 evNum=-6145 click=1 buttonNumber=0 pressure=1 deltaX=0.000000 deltaY=0.000000 deviceID:0x300000014400000 subtype=NSEventSubtypeTouch
    //        //NSEvent: type=LMouseDragged loc=(782.656,38.0156) time=1035301.2 flags=0x80020 win=0x10a23f590 winNum=21652 ctxt=0x0 evNum=-6145 click=1 buttonNumber=0 pressure=1 deltaX=0.000000 deltaY=0.000000 deviceID:0x300000014400000 subtype=NSEventSubtypeTouch
    //
    //        let nv = NSEvent.mouseEvent(with: .leftMouseDragged, location: event.locationInWindow, modifierFlags: [], timestamp: 98, windowNumber: 0, context: nil, eventNumber: 0, clickCount: 2, pressure: 1)
    //        xvim_mouseDragged(nv!)
    //    }
    //    @objc dynamic func xvim_mouseUp(_ event: NSEvent) {
    ////        logger.debug?.write(event)
    //
    //        //NSEvent: type=LMouseUp loc=(782.656,38.0156) time=1035301.5 flags=0x80020 win=0x10a23f590 winNum=21652 ctxt=0x0 evNum=-6145 click=0 buttonNumber=0 pressure=0 deviceID:0x300000014400000 subtype=NSEventSubtypeTouch
    //
    //        let nv = NSEvent.mouseEvent(with: .leftMouseUp, location: event.locationInWindow, modifierFlags: [], timestamp: 98, windowNumber: 0, context: nil, eventNumber: 0, clickCount: 0, pressure: 0)
    //        xvim_mouseUp(nv!)
    //    }
    //    @objc dynamic func xvim_mouseDown(_ event: NSEvent) {
    ////        logger.debug?.write(event)
    //
    //        //open class func mouseEvent(with type: NSEvent.EventType, location: NSPoint, modifierFlags flags: NSEvent.ModifierFlags, timestamp time: TimeInterval, windowNumber wNum: Int, context unusedPassNil: NSGraphicsContext?, eventNumber eNum: Int, clickCount cNum: Int, pressure: Float) -> NSEvent?
    //
    //
    //        //NSEvent: type=LMouseDown loc=(55.0625,525.098) time=1035298.2 flags=0x80020 win=0x10a23f590 winNum=21652 ctxt=0x0 evNum=-6145 click=1 buttonNumber=0 pressure=1 deviceID:0x300000014400000 subtype=NSEventSubtypeTouch
    //
    //        let nv = NSEvent.mouseEvent(with: .leftMouseDown, location: event.locationInWindow, modifierFlags: [], timestamp: 99, windowNumber: 0, context: nil, eventNumber: 0, clickCount: 2, pressure: 1)
    //        xvim_mouseDown(nv!)
    //    }
    
    @objc dynamic func xvim_doCommandBySelector(_ sel: Selector) {
        xvim_doCommandBySelector(sel)
        
        logger.debug?.write(sel)
    }
    
    //    @objc dynamic override func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
    //
    //        logger.debug?.write(aSelector, object)
    //        return super.perform(aSelector, with: object)
    //    }
    
    
    @NSManaged var scrollView: NSScrollView // SourceEditor.SourceEditorScrollView
    @NSManaged var contentView: SourceEditorContentView // SourceEditor.SourceEditorContentView
    
    //    @objc dynamic func xvim_keyUp(_ event: NSEvent) {
    //        return self.xvim_window.map {
    //            return $0.xvim_keyUp(event).map {
    //                return self.xvim_keyUp($0)
    //            }
    //        } ?? self.xvim_keyUp(event)
    //    }
    //
    @objc dynamic func xvim_keyDown(_ event: NSEvent) {
        return self.xvim_window.map {
            return $0.keyDown(event).map {
                return self.xvim_keyDown($0)
            }
        } ?? self.xvim_keyDown(event)
    }

    //SourceEditor`SourceEditor.SourceEditorView.selectTextRange(Swift.Optional<SourceEditor.SourceEditorRange>, scrollPlacement: Swift.Optional<SourceEditor.ScrollPlacement>, alwaysScroll: Swift.Bool) -> ():
    //SourceEditor.SourceEditorView.insertTexts(Swift.Array<Swift.String>, replacementRanges: Swift.Array<SourceEditor.SourceEditorRange>, options: SourceEditor.TextInsertionOptions) -> ()

    @objc dynamic func xvim_selectionDidChange(_ notification: Notification) {
        guard let window = xvim_window else {
            return
        }
        
//        @_silgen_name("_XNeovim_sxx_setter")
//        @_silgen_name("_XNeovim_sxx_getter")
        
        selection().map {
            switch $0 {
            case .single(let range, let modifiers):
                let startRow = range.start.line
                let startColumn = range.start.col
                
                window.selection = .init(cursor: .init(row: startRow + 1, column: startColumn))
                
                logger.debug?.write(range, modifiers)

            case .multiple(let ranges, let modifiers):
                
                logger.debug?.write(ranges, modifiers)
            }
        }
        
//        let selection = contentView.accessibilitySelectedTextRange()
//        let start = selection.lowerBound
//        //let end = selection.upperBound
//
//        guard start != NSNotFound else {
//            return
//        }
//
//        let startRow = contentView.accessibilityLine(for: start)
//        let startRange = contentView.accessibilityRange(forLine: startRow)
//        let startColumn = max(min(start - startRange.lowerBound, startRange.length - 2), 0)

        // update
        //window.selection = .init(cursor: .init(row: startRow + 1, column: startColumn))
        
//        logger.debug?.write(notification)
//        logger.debug?.write(contentView.accessibilitySelectedTextRanges())
    }
    
//    @objc dynamic func xvim_insertText(_ text: Any) {
//        xvim_insertText(text)
//        logger.debug?.write()
//    }
//
//    @objc dynamic func xvim_insertText(_ text: Any, replacementRange: NSRange) {
//        xvim_insertText(text, replacementRange: replacementRange)
//        logger.debug?.write()
//    }


//    override func viewWillMove(toSuperview newSuperview: NSView?) {
//        super.viewWillMove(toSuperview: newSuperview)
//
//        logger.debug?.write(self)
//        logger.debug?.write(newSuperview)
//    }
}


internal class SourceEditorContentView: NSView {
    //@interface _TtC12SourceEditor23SourceEditorContentView : NSView <CALayerDelegate>
    //{
    //    // Error parsing type: , name: contentLayer
    //    // Error parsing type: , name: underlayLayer
    //    // Error parsing type: , name: overlayLayer
    //    // Error parsing type: , name: visibleLineRange
    //    // Error parsing type: , name: layoutManager
    //    // Error parsing type: , name: fullBleedFrame
    //    // Error parsing type: , name: accessoryMargins
    //    // Error parsing type: , name: contentMargins
    //    // Error parsing type: , name: responderProxy
    //    }
    //
    //    + (BOOL)isCompatibleWithResponsiveScrolling;
    //+ (double)caretInsetBottom;
    //+ (double)caretInsetTop;
    //+ (double)caretWidth;
    
    //- (CDUnknownBlockType).cxx_destruct;
    //- (BOOL)becomeFirstResponder;
    //@property(nonatomic, readonly) BOOL acceptsFirstResponder;
    //@property(nonatomic) __weak NSResponder *responderProxy; // @synthesize responderProxy;
    //- (void)setNeedsLayout;
    //- (void)layoutIfNeeded;
    //- (void)layoutSublayersOfLayer:(id)arg1;
    //- (id)initWithCoder:(id)arg1;
    //- (id)init;
    //- (id)initWithFrame:(struct CGRect)arg1;
    //- (void)viewDidChangeBackingProperties;
    //- (BOOL)isFlipped;
    //- (void)prepareContentInRect:(struct CGRect)arg1;
    //@property(nonatomic, readonly) double layoutScale;
    //@property(nonatomic, readonly) struct NSEdgeInsets layoutMargins;
    //@property(nonatomic) struct NSEdgeInsets contentMargins; // @synthesize contentMargins;
    //@property(nonatomic) struct NSEdgeInsets accessoryMargins; // @synthesize accessoryMargins;
    //@property(nonatomic, readonly) struct CGRect documentRect;
    //@property(nonatomic, readonly) CALayer *overlayLayer; // @synthesize overlayLayer;
    //@property(nonatomic, readonly) CALayer *underlayLayer; // @synthesize underlayLayer;
    //@property(nonatomic, readonly) CALayer *contentLayer; // @synthesize contentLayer;
    
    //- (struct CGRect)accessibilityFrameForRange:(struct _NSRange)arg1;
    //- (id)accessibilityStringForRange:(struct _NSRange)arg1;
    //- (struct _NSRange)accessibilityRangeForLine:(long long)arg1;
    
    //- (long long)accessibilityLineForIndex:(long long)arg1;
    //- (long long)accessibilityInsertionPointLineNumber;
    //- (void)setAccessibilityVisibleCharacterRange:(struct _NSRange)arg1;
    //- (struct _NSRange)accessibilityVisibleCharacterRange;
    //- (long long)accessibilityNumberOfCharacters;
    //- (struct _NSRange)accessibilitySharedCharacterRange;
    //- (id)accessibilitySharedTextUIElements;
    //- (id)accessibilityAttributedStringForRange:(struct _NSRange)arg1;
    //- (void)setAccessibilitySelectedText:(id)arg1;
    //- (id)accessibilitySelectedText;
    //- (id)accessibilitySelectedTextRanges;
    //- (void)setAccessibilitySelectedTextRange:(struct _NSRange)arg1;
    //- (struct _NSRange)accessibilitySelectedTextRange;
    //- (void)setAccessibilityValue:(id)arg1;
    //- (id)accessibilityValue;
    //- (id)accessibilityLabel;
    //- (id)accessibilityChildren;
    //- (id)accessibilityRole;
    //- (BOOL)isAccessibilityElement;
    //- (struct CGRect)contentViewRectForLineLayer:(id)arg1;
    //- (double)distanceFromNearestVisibleLineToLineAtIndex:(long long)arg1;
    //@property(nonatomic, readonly) NSString *debugDescription;
    //@property(nonatomic, readonly) NSString *description;
    //- (id)lineLayerForVisibleLine:(long long)arg1;
    //- (id)closestLineLayerToPoint:(struct CGPoint)arg1;
    //- (id)lineLayersInRect:(struct CGRect)arg1;
    //- (id)lineLayerAtPoint:(struct CGPoint)arg1;
    //- (double)ensureLineVisible:(long long)arg1 maxHeight:(double)arg2;
    //- (double)adjustFirstVisibleLineForBounds:(struct CGRect)arg1;
    //- (void)updateAuxView:(id)arg1 with:(struct CGRect)arg2 floating:(BOOL)arg3;
    //- (void)addAuxView:(id)arg1 floating:(BOOL)arg2;
    //@property(nonatomic, readonly) _TtC12SourceEditor21SourceEditorLineLayer *lastVisibleLineLayer;
    //@property(nonatomic, readonly) _TtC12SourceEditor21SourceEditorLineLayer *firstVisibleLineLayer;
    //@property(nonatomic, readonly) struct NSEdgeInsets layoutBoundsVisibleInsets;
    //@property(nonatomic, readonly) struct CGRect fullBleedLayoutBounds;
    //@property(nonatomic, readonly) struct CGRect layoutBounds;
    //
    //// Remaining properties
    //@property(nonatomic, readonly) BOOL flipped;
    //
    //@end
    //@NSManaged func accessibilityLineForIndex(_ index: Int) -> Int
}

//extension SourceEditorView: EmulationResponder {
//
//    @NSManaged func string() -> String?
//    @NSManaged func lineCount() -> Int
//
//    func xvim_selectedTextRange() -> NSRange {
//        return contentView.accessibilitySelectedTextRange()
//    }
//    func xvim_setSelectedTextRange(_ range: NSRange) {
//        return contentView.setAccessibilitySelectedTextRange(range)
//    }
//}

internal class SourceEditorCursorLayer: CAShapeLayer {
    
//    override var path: CGPath? {
//        set {
//            return super.path = newValue?.mutableCopy().map {
//                var frame = $0.boundingBox
//                frame.size.width = 8
//                $0.addRect(frame)
//                return $0
//            }
//        }
//        get {
//            return super.path
//        }
//    }
//    override var opacity: Float {
//        set {
//            return super.opacity = newValue / 2
//        }
//        get {
//            return super.opacity
//        }
//    }
}

//__attribute__((visibility("hidden")))
//@interface _TtC12SourceEditor11CursorLayer : CAShapeLayer
//@end
//
//__attribute__((visibility("hidden")))
//@interface _TtC12SourceEditor14SelectionLayer : CAShapeLayer
//@end
//

//@objc class SourceEditorView: NSView {
//
//    //        + (id)identifierCharacters;
//    //        + (id)defaultMenu;
//    //        //- (CDUnknownBlockType).cxx_destruct;
//    //        //@property(nonatomic, readonly) NSString *description;
//    //        //@property(nonatomic, readonly) _TtC12SourceEditor29AnnotationsAccessibilityGroup *annotationsAccessibilityGroup;
//    //        - (void)contentViewDidFinishLayout;
//    //        - (void)removeContentVerticalShiftEffect:(BOOL)arg1;
//    //        - (void)setContentVerticalShiftEffect:(double)arg1;
//    //        @property(nonatomic, readonly) NSColor *tintColor;
//    //        @property(nonatomic, readonly) long long lineCount;
//    //        - (void)updateContentSizeIfNeeded;
//    //        @property(nonatomic) double contentSize; // @synthesize contentSize;
//    //        - (void)invalidateContentSize;
//    //        @property(nonatomic) BOOL contentSizeIsValid; // @synthesize contentSizeIsValid;
//    //        - (void)viewDidEndLiveResize;
//    //        - (void)viewWillStartLiveResize;
//    //        @property(nonatomic) BOOL isInLiveResize; // @synthesize isInLiveResize;
//    //        @property(nonatomic) BOOL editing; // @synthesize editing;
//    //        - (void)dataSourceEndEditTransaction;
//    //        - (void)dataSourceBeginEditTransaction;
//    //        - (void)dataSourceDidDeleteLines:(id)arg1;
//    //        - (void)dataSourceDidInsertLines:(id)arg1;
//    //        - (id)closestLineLayerToPoint:(struct CGPoint)arg1;
//    //        - (id)lineLayersInRect:(struct CGRect)arg1;
//    //        - (id)lineLayerAtPoint:(struct CGPoint)arg1;
//    //        - (void)applyScrollStateWithLine:(long long)arg1 offset:(double)arg2;
//    //        @property(nonatomic) BOOL continueKillRing; // @synthesize continueKillRing;
//    //        @property(nonatomic) BOOL markedEditTransaction; // @synthesize markedEditTransaction;
//    //        - (BOOL)shouldSuppressCodeCompletion;
//    //        - (void)showCodeCompletionSuggestionList;
//    //        - (void)queueCodeCompletionWithExplicitly:(BOOL)arg1;
//    //        - (void)codeCompletionAvailabilityChangedWithDuringReload:(BOOL)arg1;
//    //        - (void)overrideCompletionDisplayWithShouldDisplay:(BOOL)arg1;
//    //        @property(nonatomic) BOOL shouldProvideCodeCompletionInCurrentRange;
//    //        @property(nonatomic) BOOL currentListShownExplicitly; // @synthesize currentListShownExplicitly;
//    //        @property(nonatomic) BOOL isCodeCompletionEnabled; // @synthesize isCodeCompletionEnabled;
//    //        @property(nonatomic, readonly) BOOL isShowingCodeCompletion;
//    //        @property(nonatomic, readonly) BOOL escapeKeyTriggersCodeCompletion;
//    //        - (void)selectionWillChange;
//    //        @property(nonatomic) BOOL isEditingEnabled; // @synthesize isEditingEnabled;
//    //        @property(nonatomic) BOOL delimiterHighlightEnabled;
//    //        @property(nonatomic, readonly) NSLayoutYAxisAnchor *findPanelTopAnchor;
//    //        - (void)pushFindConfigurationForFindQuery;
//    //        - (void)pullFindConfigurationForFindQuery;
//    //        - (void)performTextFinderAction:(id)arg1;
//    //        - (void)performFindPanelAction:(id)arg1;
//    //        @property(nonatomic) BOOL findResultNeedUpdate; // @synthesize findResultNeedUpdate;
//    //        @property(nonatomic) BOOL textFindPanelDisplayed; // @synthesize textFindPanelDisplayed;
//    //        - (void)unregisterDraggingExtensionWithIdentifier:(id)arg1;
//    //        //@property(nonatomic, readonly) _TtC12SourceEditor30SourceEditorViewDraggingSource *draggingSource; // @synthesize draggingSource;
//    //        //@property(nonatomic, retain) _TtC12SourceEditor18SourceEditorGutter *gutter; // @synthesize gutter;
//    //        @property(nonatomic) BOOL allowLineAnnotationAnimations;
//    //        - (void)expandLineAnnotationsOnLine:(long long)arg1 animated:(BOOL)arg2;
//    //        - (id)mouseCursorForStructuredSelectionWith:(id)arg1;
//    //        - (void)resetCursorRects;
//    //        - (struct CGRect)contentRectForCursor;
//    //        - (void)invalidateCursorRects;
//    //        @property(nonatomic) BOOL automaticallyAdjustsContentMargins; // @synthesize automaticallyAdjustsContentMargins;
//    //        - (void)queueTrimTrailingWhitespace;
//    //        - (void)setupStructuredEditingController;
//    //        - (id)editorViewSnapshotsIn:(id)arg1;
//    //        @property(nonatomic, readonly) NSLayoutConstraint *contentViewHeightLimitConstraint; // @synthesize contentViewHeightLimitConstraint;
//    //        @property(nonatomic, readonly) NSLayoutConstraint *contentViewHeightConstraint; // @synthesize contentViewHeightConstraint;
//    //        @property(nonatomic, readonly) NSLayoutConstraint *contentViewWidthLimitConstraint; // @synthesize contentViewWidthLimitConstraint;
//    //        @property(nonatomic, readonly) NSLayoutConstraint *contentViewWidthConstraint; // @synthesize contentViewWidthConstraint;
//    //        - (BOOL)_wantsKeyDownForEvent:(id)arg1;
//    //        - (void)updateSelectionManagerIsActive;
//    //        - (BOOL)resignFirstResponder;
//    //        - (BOOL)becomeFirstResponder;
//    //        @property(nonatomic, readonly) BOOL acceptsFirstResponder;
//    //        - (void)viewDidMoveToWindow;
//    //        - (BOOL)isFlipped;
//    //        - (void)dealloc;
//    //        - (id)initWithCoder:(id)arg1;
//    //        - (id)initWithFrame:(struct CGRect)arg1;
//    //        - (id)initWithCoder:(id)arg1 sourceEditorScrollViewClass:(Class)arg2;
//    //        - (id)initWithFrame:(struct CGRect)arg1 sourceEditorScrollViewClass:(Class)arg2;
//
//
//    //        @property(nonatomic) double contentViewOffset; // @synthesize contentViewOffset;
//    //        - (void)mouseExited:(id)arg1;
//    //        - (void)mouseEntered:(id)arg1;
//    //        - (void)mouseMoved:(id)arg1;
//    //        - (void)rightMouseUp:(id)arg1;
//    //        - (void)mouseUp:(id)arg1;
//    //        - (void)mouseDragged:(id)arg1;
//    //        - (void)rightMouseDown:(id)arg1;
//    //        - (void)mouseDown:(id)arg1;
//    //        @property(nonatomic, readonly) id accessibilityFocusedUIElement;
//    //        - (long long)characterIndexForPoint:(struct CGPoint)arg1;
//    //        - (struct CGRect)firstRectForCharacterRange:(struct _NSRange)arg1 actualRange:(struct _NSRange *)arg2;
//    //        - (id)validAttributesForMarkedText;
//    //        - (id)attributedSubstringForProposedRange:(struct _NSRange)arg1 actualRange:(struct _NSRange *)arg2;
//    //        - (BOOL)hasMarkedText;
//    //        - (struct _NSRange)markedRange;
//    //        - (struct _NSRange)selectedRange;
//    //        - (void)unmarkText;
//    //        - (void)setMarkedText:(id)arg1 selectedRange:(struct _NSRange)arg2 replacementRange:(struct _NSRange)arg3;
//    //        - (void)insertText:(id)arg1 replacementRange:(struct _NSRange)arg2;
//    //        - (void)insertText:(id)arg1;
//    //        - (id)menuForEvent:(id)arg1;
//    //        - (void)selectWord:(id)arg1;
//    //        - (void)selectLine:(id)arg1;
//    //        - (void)selectParagraph:(id)arg1;
//    //        - (void)selectAll:(id)arg1;
//    //        - (void)scrollToEndOfDocument:(id)arg1;
//    //        - (void)scrollToBeginningOfDocument:(id)arg1;
//    //        - (void)scrollLineDown:(id)arg1;
//    //        - (void)scrollLineUp:(id)arg1;
//    //        - (void)scrollPageDown:(id)arg1;
//    //        - (void)scrollPageUp:(id)arg1;
//    //        - (void)centerSelectionInVisibleArea:(id)arg1;
//    //        - (void)pageUpAndModifySelection:(id)arg1;
//    //        - (void)pageDownAndModifySelection:(id)arg1;
//    //        - (void)pageUp:(id)arg1;
//    //        - (void)pageDown:(id)arg1;
//    //        - (long long)linesPerPage;
//    //        - (void)moveToEndOfDocumentAndModifySelection:(id)arg1;
//    //        - (void)moveToBeginningOfDocumentAndModifySelection:(id)arg1;
//    //        - (void)moveToEndOfDocument:(id)arg1;
//    //        - (void)moveToBeginningOfDocument:(id)arg1;
//    //        - (void)moveParagraphBackwardAndModifySelection:(id)arg1;
//    //        - (void)moveParagraphForwardAndModifySelection:(id)arg1;
//    //        - (void)moveToEndOfParagraphAndModifySelection:(id)arg1;
//    //        - (void)moveToBeginningOfParagraphAndModifySelection:(id)arg1;
//    //        - (void)moveToEndOfParagraph:(id)arg1;
//    //        - (void)moveToBeginningOfParagraph:(id)arg1;
//    //        - (void)moveToEndOfTextAndModifySelection:(id)arg1;
//    //        - (void)moveToEndOfText:(id)arg1;
//    //        - (void)moveToBeginningOfTextAndModifySelection:(id)arg1;
//    //        - (void)moveToBeginningOfText:(id)arg1;
//    //        - (void)moveToRightEndOfLineAndModifySelection:(id)arg1;
//    //        - (void)moveToLeftEndOfLineAndModifySelection:(id)arg1;
//    //        - (void)moveToRightEndOfLine:(id)arg1;
//    //        - (void)moveToLeftEndOfLine:(id)arg1;
//    //        - (void)moveToEndOfLineAndModifySelcection:(id)arg1;
//    //        - (void)moveToBeginningOfLineAndModifySelection:(id)arg1;
//    //        - (void)moveToEndOfLine:(id)arg1;
//    //        - (void)moveToBeginningOfLine:(id)arg1;
//    //        - (void)moveExpressionBackwardAndModifySelection:(id)arg1;
//    //        - (void)moveExpressionForwardAndModifySelection:(id)arg1;
//    //        - (void)moveExpressionBackward:(id)arg1;
//    //        - (void)moveExpressionForward:(id)arg1;
//    //        - (void)moveSubWordBackwardAndModifySelection:(id)arg1;
//    //        - (void)moveSubWordForwardAndModifySelection:(id)arg1;
//    //        - (void)moveSubWordBackward:(id)arg1;
//    //        - (void)moveSubWordForward:(id)arg1;
//    //        - (void)moveWordLeftAndModifySelection:(id)arg1;
//    //        - (void)moveWordRightAndModifySelection:(id)arg1;
//    //        - (void)moveWordLeft:(id)arg1;
//    //        - (void)moveWordRight:(id)arg1;
//    //        - (void)moveWordBackwardAndModifySelection:(id)arg1;
//    //        - (void)moveWordForwardAndModifySelection:(id)arg1;
//    //        - (void)moveWordBackward:(id)arg1;
//    //        - (void)moveWordForward:(id)arg1;
//    //        - (void)moveDownAndModifySelection:(id)arg1;
//    //        - (void)_moveDownAndModifySelectionBy:(long long)arg1;
//    //        - (void)moveUpAndModifySelection:(id)arg1;
//    //        - (void)_moveUpAndModifySelectionBy:(long long)arg1;
//    //        - (void)moveDown:(id)arg1;
//    //        - (void)_moveDownBy:(long long)arg1;
//    //        - (void)moveUp:(id)arg1;
//    //        - (void)_moveUpBy:(long long)arg1;
//    //        - (void)moveLeftAndModifySelection:(id)arg1;
//    //        - (void)moveRightAndModifySelection:(id)arg1;
//    //        - (void)moveLeft:(id)arg1;
//    //        - (void)moveRight:(id)arg1;
//    //        - (void)moveBackwardAndModifySelection:(id)arg1;
//    //        - (void)moveForwardAndModifySelection:(id)arg1;
//    //        - (void)moveBackward:(id)arg1;
//    //        - (void)moveForward:(id)arg1;
//    //        - (void)unfoldAllComments:(id)arg1;
//    //        - (void)foldAllComments:(id)arg1;
//    //        - (void)unfoldAllMethods:(id)arg1;
//    //        - (void)foldAllMethods:(id)arg1;
//    //        - (void)unfoldAll:(id)arg1;
//    //        - (void)unfold:(id)arg1;
//    //        - (void)fold:(id)arg1;
//    //        - (void)balance:(id)arg1;
//    //        - (void)selectStructure:(id)arg1;
//    //        - (int)syntaxTypeWithLocation:(unsigned long long)arg1 effectiveRange:(struct _NSRange *)arg2;
//    //        - (void)shiftRight:(id)arg1;
//    //        - (void)shiftLeft:(id)arg1;
//    //        - (BOOL)indentSelectionWithAllowUnindent:(BOOL)arg1;
//    //        - (void)indentSelection:(id)arg1;
//    //        - (void)moveCurrentLineDown:(id)arg1;
//    //        - (void)moveCurrentLineUp:(id)arg1;
//    //        - (void)complete:(id)arg1;
//    //        - (void)swapWithMark:(id)arg1;
//    //        - (void)selectToMark:(id)arg1;
//    //        - (void)deleteToMark:(id)arg1;
//    //        - (void)setMark:(id)arg1;
//    //        - (void)yankAndSelect:(id)arg1;
//    //        - (void)yank:(id)arg1;
//    //        - (void)capitalizeWord:(id)arg1;
//    //        - (void)lowercaseWord:(id)arg1;
//    //        - (void)uppercaseWord:(id)arg1;
//    //        - (void)transpose:(id)arg1;
//    //        - (void)deleteToEndOfText:(id)arg1;
//    //        - (void)deleteToBeginningOfText:(id)arg1;
//    //        - (void)deleteToEndOfParagraph:(id)arg1;
//    //        - (void)deleteToBeginningOfParagraph:(id)arg1;
//    //        - (void)deleteToEndOfLine:(id)arg1;
//    //        - (void)deleteToBeginningOfLine:(id)arg1;
//    //        - (void)deleteExpressionBackward:(id)arg1;
//    //        - (void)deleteExpressionForward:(id)arg1;
//    //        - (void)deleteSubWordBackward:(id)arg1;
//    //        - (void)deleteSubWordForward:(id)arg1;
//    //        - (void)deleteWordBackward:(id)arg1;
//    //        - (void)deleteWordForward:(id)arg1;
//    //        - (void)deleteBackwardByDecomposingPreviousCharacter:(id)arg1;
//    //        - (void)deleteBackward:(id)arg1;
//    //        - (void)deleteForward:(id)arg1;
//    //        - (void)delete:(id)arg1;
//    //        - (void)insertDoubleQuoteIgnoringSubstitution:(id)arg1;
//    //        - (void)insertSingleQuoteIgnoringSubstitution:(id)arg1;
//    //        - (void)insertContainerBreak:(id)arg1;
//    //        - (void)insertLineBreak:(id)arg1;
//    //        - (void)insertTabIgnoringFieldEditor:(id)arg1;
//    //        - (void)insertNewlineIgnoringFieldEditor:(id)arg1;
//    //        - (void)insertParagraphSeparator:(id)arg1;
//    //        - (void)insertNewline:(id)arg1;
//    //        - (void)insertBacktab:(id)arg1;
//    //        - (void)insertTab:(id)arg1;
//    //        - (BOOL)shouldPerformActionAfterOptionallyDismissingCodeCompletion:(SEL)arg1;
//    //        - (void)doCommandBySelector:(SEL)arg1;
//    //        - (BOOL)validateMenuItem:(id)arg1;
//    //        - (void)flagsChanged:(id)arg1;
//
//    //        @NSManaged func keyDown(with event: NSEvent)
//
//    //        - (void)concludeDragOperation:(id)arg1;
//    //        - (BOOL)performDragOperation:(id)arg1;
//    //        - (BOOL)prepareForDragOperation:(id)arg1;
//    //        - (void)draggingExited:(id)arg1;
//    //        - (unsigned long long)draggingUpdated:(id)arg1;
//    //        - (unsigned long long)draggingEntered:(id)arg1;
//    //        - (BOOL)performDragOperation:(unsigned long long)arg1 from:(id)arg2 with:(id)arg3 at:(struct CGPoint)arg4;
//    //        - (unsigned long long)dragOperationFor:(id)arg1 draggingLocation:(struct CGPoint)arg2 sourceOperationMask:(unsigned long long)arg3;
//    //        - (unsigned long long)dragOperationForDraggingInfo:(id)arg1;
//    //        @property(nonatomic, readonly) NSArray *defaultDragTypes;
//    //        - (BOOL)readSelectionFromPasteboard:(id)arg1;
//    //        - (BOOL)writeSelectionToPasteboard:(id)arg1 types:(id)arg2;
//    //        - (id)validRequestorForSendType:(id)arg1 returnType:(id)arg2;
//    //        - (void)pasteAsPlainText:(id)arg1;
//    //        - (void)pasteAndPreserveFormatting:(id)arg1;
//    //        - (void)paste:(id)arg1;
//    //        - (void)cut:(id)arg1;
//    //        - (void)copy:(id)arg1;
//
//    // Remaining properties
//    // @property(nonatomic, readonly) BOOL flipped;
//}
//
//@objc class SourceCodeEditorView: SourceEditorView {


//
//    //        + (BOOL)appSupportsActionMonitoring;
//    //        + (id)identifierCharacters;
//    //        //- (CDUnknownBlockType).cxx_destruct;
//    //        - (void)didClickMarkForLine:(long long)arg1;
//    //        - (void)pushFindConfigurationForFindQuery;
//    //        - (void)pullFindConfigurationForFindQuery;
//    //        - (void)resignKeyWindow;
//    //        - (BOOL)resignFirstResponder;
//    //        - (void)viewWillMoveToWindow:(id)arg1;
//    //        - (void)removeFromSuperview;
//    //        - (unsigned long long)draggingEntered:(id)arg1;
//    //        - (BOOL)readSelectionFromPasteboard:(id)arg1;
//    //        - (void)selectPreviousPlaceholder:(id)arg1;
//    //        - (void)selectNextPlaceholder:(id)arg1;
//    //        - (id)menuForEvent:(id)arg1;
//    //        - (void)previousCompletion:(id)arg1;
//    //        - (void)nextCompletion:(id)arg1;
//    //        - (void)complete:(id)arg1;
//    //        - (void)setMarkedText:(id)arg1 selectedRange:(struct _NSRange)arg2 replacementRange:(struct _NSRange)arg3;
//    //        - (void)insertText:(id)arg1 replacementRange:(struct _NSRange)arg2;
//    //        - (void)doCommandBySelector:(SEL)arg1;
//    //        - (struct _NSRange)textCompletionSession:(id)arg1 replacementRangeForSuggestedRange:(struct _NSRange)arg2;
//    //        - (id)documentLocationForWordStartLocation:(unsigned long long)arg1;
//    //        - (id)contextForCompletionStrategiesAtWordStartLocation:(unsigned long long)arg1;
//    //        - (void)textCompletionSession:(id)arg1 didInsertCompletionItem:(id)arg2 range:(struct _NSRange)arg3;
//    //        - (struct _NSRange)performTextCompletionReplacementInRange:(struct _NSRange)arg1 withString:(id)arg2;
//    //        - (void)showFindIndicatorForRange:(struct _NSRange)arg1;
//    //        - (struct CGRect)frameContainingTextRange:(struct _NSRange)arg1;
//    //        - (struct CGRect)visibleTextRect;
//    //        - (void)scrollRangeToVisible:(struct _NSRange)arg1;
//    //        @property(nonatomic, readonly) NSScrollView *textCanvasScrollView;
//    //        - (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1;
//    //        - (struct _NSRange)wordRangeAtLocation:(unsigned long long)arg1;
//    //        - (BOOL)isCurrentlyDoingNonUserEditing;
//    //        @property(nonatomic) struct _NSRange selectedTextRange;
//    //        @property(nonatomic, readonly) double autoCompletionDelay;
//    //        @property(nonatomic, readonly) BOOL shouldSuppressTextCompletion;
//    //        @property(nonatomic, readonly) NSString *string;
//    //        //@property(nonatomic, readonly) DVTSourceCodeLanguage *language;
//    //        //@property(nonatomic, readonly) DVTTextCompletionDataSource *completionsDataSource;
//    //        //@property(nonatomic, retain) DVTTextCompletionController *completionController; // @synthesize completionController;
//    //        - (id)mouseCursorForStructuredSelectionWith:(id)arg1;
//    //        - (void)contentViewDidFinishLayout;
//    //        - (void)paste:(id)arg1;
//    //        - (void)viewDidMoveToSuperview;
//    //        - (void)dealloc;
//    //        //@property(nonatomic) __weak _TtC22IDEPegasusSourceEditor16SourceCodeEditor *hostingEditor; // @synthesize hostingEditor;
//    //        - (void)selectionWillChange;
//    //        - (id)initWithCoder:(id)arg1;
//    //        - (id)initWithFrame:(struct CGRect)arg1;
//    //        - (id)initWithCoder:(id)arg1 sourceEditorScrollViewClass:(Class)arg2;
//    //        - (id)initWithFrame:(struct CGRect)arg1 sourceEditorScrollViewClass:(Class)arg2;
//    //        // Remaining properties
//    //        @property(nonatomic, readonly) BOOL currentlyDoingNonUserEditing;
//}

private var __selectionLayoutOffset: Int?


