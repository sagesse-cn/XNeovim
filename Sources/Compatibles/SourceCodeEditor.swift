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




internal class SourceEditorView: NSView {
    
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
    
    //    //        - (void)mouseExited:(id)arg1;
    //    //        - (void)mouseEntered:(id)arg1;
    //    //        - (void)mouseMoved:(id)arg1;
    //    //        - (void)rightMouseUp:(id)arg1;
    //    //        - (void)mouseUp:(id)arg1;
    //    //        - (void)mouseDragged:(id)arg1;
    //    //        - (void)rightMouseDown:(id)arg1;
    //    //        - (void)mouseDown:(id)arg1;

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

    //    //        - (void)draggingExited:(id)arg1;//    //        - (unsigned long long)draggingUpdated:(id)arg1;//    //        - (unsigned long long)draggingEntered:(id)arg1;

//                - (void)concludeDragOperation:(id)arg1;
//                - (BOOL)performDragOperation:(id)arg1;
//                - (BOOL)prepareForDragOperation:(id)arg1;

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
    
    @objc dynamic func xvim_selectionDidChange(_ notification: Notification) {
        guard let window = xvim_window else {
            return
        }

        let selection = contentView.accessibilitySelectedTextRange()
        let start = selection.lowerBound
        //let end = selection.upperBound

        guard start != NSNotFound else {
            return
        }

        let startRow = contentView.accessibilityLine(for: start)
        let startRange = contentView.accessibilityRange(forLine: startRow)
        let startColumn = max(min(start - startRange.lowerBound, startRange.length - 2), 0)

        // update
        window.selection = .init(cursor: .init(row: startRow + 1, column: startColumn))
        
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
    
    override var path: CGPath? {
        set {
            return super.path = newValue?.mutableCopy().map {
                var frame = $0.boundingBox
                frame.size.width = 8
                $0.addRect(frame)
                return $0
            }
        }
        get {
            return super.path
        }
    }
    override var opacity: Float {
        set {
            return super.opacity = newValue / 2
        }
        get {
            return super.opacity
        }
    }
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


