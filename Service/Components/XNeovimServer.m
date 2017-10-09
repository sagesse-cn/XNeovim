//
//  XNeovimServer.m
//  XNeovim
//
//  Created by SAGESSE on 10/6/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovim.h"
#import "XNeovimServer+Internal.h"

FOUNDATION_STATIC_INLINE String xnvim_string(NSString* string) {
    return (String) {
        .data = (char*)string.UTF8String,
        .size = (int)strlen(string.UTF8String)
    };
}

void server_dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
void server_dispatch_async(dispatch_queue_t queue, dispatch_block_t block);


@interface XNeovimServer () {
    XNeovimServerScreen* _screen;
    XNeovimServerScreen* _defaultScreen;
}

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) XNeovimServerWindow* window; ///< Current window.
@property (nonatomic, strong) XNeovimServerView* view; ///< Current view.

@end

@implementation XNeovimServer


+ (instancetype)shared {
    static id server;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        server = [[self alloc] init];
    });
    return server;
}

- (instancetype)init {
    self = [super init];
    
    self.queue = dispatch_queue_create("com.rudedogg.xneovim.server", nil);
    self.semaphore = dispatch_semaphore_create(0);
    self->_defaultScreen = [[XNeovimServerScreen alloc] init];
    
    return self;
}

/// Start agent server
- (void)start {
    dispatch_async(self.queue, ^{
        // We declare nvim_main because it's not declared in any header files of neovim
        int nvim_main(int argc, char **argv);
        
        // Get ${RESOURCE_PATH_OF_XPC_BUNDLE}/runtime path
        NSString* path = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"runtime"];
        
        // Set $VIMRUNTIME to ${RESOURCE_PATH_OF_XPC_BUNDLE}/runtime
        setenv("VIMRUNTIME", path.fileSystemRepresentation, true);
        
        // Set $LANG to en_US.UTF-8 such that the copied text to the system clipboard is not garbled.
        setenv("LANG", "en_US.UTF-8", true);
        
        // Lock the current thread until the start-up success
        dispatch_async(dispatch_queue_create("com.rudedogg.xneovim.server.main", nil), ^{
            // launch parameters
            int argc = 1;
            char **argv = nil;
            
            NSArray<NSString*>* args = @[];
            
            @autoreleasepool {
                argc = (int) args.count + 1;
                argv = (char **) malloc((argc + 1) * sizeof(char *));
                
                argv[0] = "nvim";
                
                for (int i = 0; i < args.count; i++) {
                    argv[i + 1] = (char *) args[(NSUInteger) i].UTF8String;
                }
            }
            
            // launch
            nvim_main(argc, argv);
            
            // free
            free(argv);
        });
        
        // Wait the UI initialization has been completed
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        // Using current screen
        self.window = [[XNeovimServerWindow alloc] initWithHandle:curtab->handle screen:nil];
        self.view = [[XNeovimServerView alloc] initWithHandle:curwin->handle window:self.window];
    });
}

/// Stop agent server
- (void)stop {
    dispatch_async(self.queue, ^{
        
    });
}

//- (XNeovimServiceTab*)tabWithURL:(NSURL*)URL {
//
//    NSString* cmd = [NSString stringWithFormat:@"tabnew %@", URL.path ?: @""];
//
//    [self command:cmd];
//
//    return nil;
//}


//        editor.document.fileURL.flatMap {
//            var path = $0.path
//            if editor.document.fileType == "com.apple.dt.playground" {
//                path += "/Contents.swift"
//            }
//            service.command(.init(string: "edit +let\\ uuid=\"abc\" \(path)"))
//        }


- (void)input:(NSString*)keys {
    server_dispatch_async(self.queue, ^{
        nvim_input(xnvim_string(keys));
    });
}

- (void)command:(NSString*)command {
    server_dispatch_async(self.queue, ^{
        Error err = ERROR_INIT;
        
        
        nvim_command(xnvim_string(command), &err);
        
        if (ERROR_SET(&err)) {
            WLOG("ERROR while executing command %s: %s", command.UTF8String, err.msg);
        }
    });
}

- (void)feedkeys:(NSString*)keys {
    server_dispatch_async(self.queue, ^{
        //nvim_feedkeys(<#String keys#>, <#String mode#>, <#CarbonBoolean escape_csi#>)
    });
}

- (void)setSelection:(XNeovimServerSelection*)selection {
    server_dispatch_async(self.queue, ^{
        // Because they don't need the UI operation, so the update directly
        curwin->w_cursor.lnum = (linenr_T)selection.start.row;
        curwin->w_cursor.col = (colnr_T)selection.start.column;
        
        // Must update w_curswant, or move up/down will lead to the cursor position error
        curwin->w_curswant = (colnr_T)selection.start.column;
       
        // Must update last_cursormoved, or move up/down will lead to the cursor will ignore
        last_cursormoved = curwin->w_cursor;
    });
}

// MARK: Getter & Setter

- (XNeovimServerScreen*)screen {
    if (_screen == nil) {
        _screen = _defaultScreen;
    }
    return _screen;
}
//- (XNeovimServerScreen*)currentScreen {
//    if (_currentScreen == nil) {
//        _currentScreen = self.mainScreen;
//    }
//    return _currentScreen;
//}

@end

// MARK: Callbacks


static void server_ui_scheduler(Event event, void *d) {
    loop_schedule(&main_loop, event);
}

static void server_ui_main(UIBridgeData *bridge, UI *ui) {
    XNeovimServer* server = (__bridge_transfer XNeovimServer*)ui->data;
    
    // configure the UI default
    bridge->ui->width = 120;
    bridge->ui->height = 40;
    bridge->bridge.width = 120;
    bridge->bridge.height = 40;
    
    CONTINUE(bridge);
    
    // The UI initialization has been completed
    dispatch_semaphore_signal(server.semaphore);
}

static void server_ui_resize(UI *ui __unused, Integer width, Integer height) {
    NSLog(@"%s %zd/%zd", __func__, width, height);
}

static void server_ui_clear(UI *ui __unused) {
    NSLog(@"%s %zd, %zd", __func__, ui_current_row(), ui_current_col());
    
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdClear];
}

static void server_ui_eol_clear(UI *ui __unused) {
    NSLog(@"%s %zd, %zd", __func__, ui_current_row(), ui_current_col());
    
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdEolClear];
}

static void server_ui_cursor_goto(UI *ui __unused, Integer row, Integer col) {
//    NSLog(@"%s %zd, %zd", __func__, curwin->w_cursor.lnum, curwin->w_cursor.col);
    
    //    _put_row = row;
    //    _put_column = col;
    //
    //    NSInteger values[] = {
    //        row, col,
    //        (NSInteger) curwin->w_cursor.lnum, curwin->w_cursor.col + 1
    //    };
    //
    //    DLOG("%d:%d - %d:%d - %d:%d", values[0], values[1], values[2], values[3]);
    //
    //    NSData *data = [[NSData alloc] initWithBytes:values length:(4 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetPosition data:data];
    //    [data release];
}

static void server_ui_update_menu(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetMenu];
}

static void server_ui_busy_start(UI *ui __unused) {
    NSLog(@"%s", __func__);
}

static void server_ui_busy_stop(UI *ui __unused) {
    NSLog(@"%s", __func__);
}

static void server_ui_mouse_on(UI *ui __unused) {
    NSLog(@"%s", __func__);
}

static void server_ui_mouse_off(UI *ui __unused) {
    NSLog(@"%s", __func__);
}

static void server_ui_mode_info_set(UI *ui __unused, Boolean enabled __unused,
                                    Array cursor_styles __unused) {
    // yet noop
}

static void server_ui_mode_change(UI *ui __unused, String mode_str __unused, Integer mode) {
    NSLog(@"%s %s/%zd", __func__, mode_str.data, mode);
}

static void server_ui_set_scroll_region(UI *ui __unused, Integer top, Integer bot,
                                        Integer left, Integer right) {
    //
    //    NSInteger values[] = {top, bot, left, right};
    //    NSData *data = [[NSData alloc] initWithBytes:values length:(4 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetScrollRegion data:data];
    //    [data release];
}

static void server_ui_scroll(UI *ui __unused, Integer count) {
    //    NSInteger value = count;
    //    NSData *data = [[NSData alloc] initWithBytes:&value length:(1 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdScroll data:data];
    //    [data release];
}

static void server_ui_highlight_set(UI *ui __unused, HlAttrs attrs) {
    //    FontTrait trait = FontTraitNone;
    //    if (attrs.italic) {
    //        trait |= FontTraitItalic;
    //    }
    //    if (attrs.bold) {
    //        trait |= FontTraitBold;
    //    }
    //    if (attrs.underline) {
    //        trait |= FontTraitUnderline;
    //    }
    //    if (attrs.undercurl) {
    //        trait |= FontTraitUndercurl;
    //    }
    //    CellAttributes cellAttrs;
    //    cellAttrs.fontTrait = trait;
    //
    //    NSInteger fg = attrs.foreground == -1 ? _default_foreground : attrs.foreground;
    //    NSInteger bg = attrs.background == -1 ? _default_background : attrs.background;
    //
    //    cellAttrs.foreground = attrs.reverse ? bg : fg;
    //    cellAttrs.background = attrs.reverse ? fg : bg;
    //    cellAttrs.special = attrs.special == -1 ? _default_special
    //    : pun_type(unsigned int, attrs.special);
    //
    //    NSData *data = [[NSData alloc] initWithBytes:&cellAttrs length:sizeof(CellAttributes)];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetHighlightAttributes data:data];
    //    [data release];
}

static void server_ui_put(UI *ui __unused, String str) {
    //    NSLog(@"%s %s", __func__, str.data);
    //    NSString *string = [[NSString alloc] initWithBytes:str.data
    //                                                length:str.size
    //                                              encoding:NSUTF8StringEncoding];
    //    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    if (_marked_text != nil && _marked_row == _put_row && _marked_column == _put_column) {
    //
    //        DLOG("putting marked text: '%s'", string.cstr);
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdPutMarked data:data];
    //
    //    } else if (_marked_text != nil
    //               && str.size == 0
    //               && _marked_row == _put_row
    //               && _marked_column == _put_column - 1) {
    //
    //        DLOG("putting marked text cuz zero");
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdPutMarked data:data];
    //
    //    } else {
    //
    //        DLOG("putting non-marked text: '%s'", string.cstr);
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdPut data:data];
    //
    //    }
    //
    //    _put_column += 1;
    //
    //    [string release];
}

static void server_ui_bell(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdBell];
}

static void server_ui_visual_bell(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdVisualBell];
}

static void server_ui_flush(UI *ui __unused) {
    //    NSLog(@"%s", __func__);
}

static void server_ui_update_fg(UI *ui __unused, Integer fg) {
    //    NSInteger value[1];
    //
    //    if (fg == -1) {
    //        value[0] = _default_foreground;
    //        NSData *data = [[NSData alloc] initWithBytes:value length:(1 * sizeof(NSInteger))];
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetForeground data:data];
    //        [data release];
    //
    //        return;
    //    }
    //
    //    _default_foreground = fg;
    //
    //    value[0] = fg;
    //    NSData *data = [[NSData alloc] initWithBytes:value length:(1 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetForeground data:data];
    //    [data release];
}

static void server_ui_update_bg(UI *ui __unused, Integer bg) {
    //    NSInteger value[1];
    //
    //    if (bg == -1) {
    //        value[0] = _default_background;
    //        NSData *data = [[NSData alloc] initWithBytes:value length:(1 * sizeof(NSInteger))];
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetBackground data:data];
    //        [data release];
    //
    //        return;
    //    }
    //
    //    _default_background = bg;
    //    value[0] = bg;
    //    NSData *data = [[NSData alloc] initWithBytes:value length:(1 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetBackground data:data];
    //    [data release];
}

static void server_ui_update_sp(UI *ui __unused, Integer sp) {
    //    NSInteger value[2];
    //
    //    if (sp == -1) {
    //        value[0] = _default_special;
    //        NSData *data = [[NSData alloc] initWithBytes:&value length:(1 * sizeof(NSInteger))];
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetSpecial data:data];
    //        [data release];
    //
    //        return;
    //    }
    //
    //    _default_special = sp;
    //    value[0] = sp;
    //    NSData *data = [[NSData alloc] initWithBytes:&value length:(1 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetSpecial data:data];
    //    [data release];
}

static void server_ui_set_title(UI *ui __unused, String title) {
    //    if (title.size == 0) {
    //        return;
    //    }
    //
    //    NSString *string = [[NSString alloc] initWithCString:title.data encoding:NSUTF8StringEncoding];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetTitle
    //                                 data:[string dataUsingEncoding:NSUTF8StringEncoding]];
    //    [string release];
}

static void server_ui_set_icon(UI *ui __unused, String icon) {
    //    if (icon.size == 0) {
    //        return;
    //    }
    //
    //    NSString *string = [[NSString alloc] initWithCString:icon.data encoding:NSUTF8StringEncoding];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdSetIcon
    //                                 data:[string dataUsingEncoding:NSUTF8StringEncoding]];
    //    [string release];
}

static void server_ui_stop(UI *ui __unused) {
    NSLog(@"%s", __func__);
}

// MARK: Dispatch

void server_dispatch_imp(void **argv) {
    ((__bridge_transfer dispatch_block_t)*argv)();
}

void server_dispatch_sync(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_sync(queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        loop_schedule(&main_loop, event_create(server_dispatch_imp, 1, (__bridge_retained void*)^{
            block();
            dispatch_semaphore_signal(semaphore);
        }));
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

void server_dispatch_async(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_async(queue, ^{
        loop_schedule(&main_loop, event_create(server_dispatch_imp, 1, (__bridge_retained void*)block));
    });
}

// MARK: Custom UI

// called by neovim
void custom_ui_start(void) {
    UI *ui = xcalloc(1, sizeof(UI));
    
    ui->rgb = true;
    ui->stop = server_ui_stop;
    ui->resize = server_ui_resize;
    ui->clear = server_ui_clear;
    ui->eol_clear = server_ui_eol_clear;
    ui->cursor_goto = server_ui_cursor_goto;
    ui->update_menu = server_ui_update_menu;
    ui->busy_start = server_ui_busy_start;
    ui->busy_stop = server_ui_busy_stop;
    ui->mouse_on = server_ui_mouse_on;
    ui->mouse_off = server_ui_mouse_off;
    ui->mode_info_set = server_ui_mode_info_set;
    ui->mode_change = server_ui_mode_change;
    ui->set_scroll_region = server_ui_set_scroll_region;
    ui->scroll = server_ui_scroll;
    ui->highlight_set = server_ui_highlight_set;
    ui->put = server_ui_put;
    ui->bell = server_ui_bell;
    ui->visual_bell = server_ui_visual_bell;
    ui->update_fg = server_ui_update_fg;
    ui->update_bg = server_ui_update_bg;
    ui->update_sp = server_ui_update_sp;
    ui->flush = server_ui_flush;
    ui->suspend = NULL;
    ui->set_title = server_ui_set_title;
    ui->set_icon = server_ui_set_icon;
    ui->data = (__bridge_retained void*)XNeovimServer.shared;
    
    ui_bridge_attach(ui, server_ui_main, server_ui_scheduler);
}

// called by neovim
void custom_ui_autocmds_groups(event_T event,
                               char_u *fname __unused,
                               char_u *fname_io __unused,
                               int group __unused,
                               bool force __unused,
                               buf_T *buf,
                               exarg_T *eap __unused) {

    // text change
    if (event == EVENT_TEXTCHANGED || event == EVENT_TEXTCHANGEDI) {
        NSLog(@"%s %d -> %zd:\"%s\"", __FUNCTION__, event, buf->b_ml.ml_line_lnum, buf->b_ml.ml_line_ptr);
        return;
    }
    
    switch (event) {
            
        case EVENT_CURSORMOVED:
        case EVENT_CURSORMOVEDI: {
            // Because the col index base of utf8, need to be convert to unicode
            NSInteger row = (NSInteger)curwin->w_cursor.lnum;
            NSInteger column = (NSInteger)mb_charlen_len(curbuf->b_ml.ml_line_ptr, curwin->w_cursor.col);
            
            XNeovimServerPosition* start = [XNeovimServerPosition positionWithRow:row column:column];
            XNeovimServerSelection* selection = [XNeovimServerSelection selectionWithStart:start end:start];
            
            NSLog(@"%s %d %zd:%zd", __func__, event, row, column);
            
            [XNeovimServer.shared.view updateSelection:selection];
            
            break;
        }
//        case EVENT_TABNEW: {
//            // Add a tabpage
//            //            [XNeovimService.shared.currentScreen bindWindowWithHandle:curtab->handle];
//            break;
//        }
//        case EVENT_TABCLOSED: {
//            // Remove a tabpage
//            //            [XNeovimService.shared.currentScreen unbindWindowWithHandle:curtab->handle];
//            break;
//        }
            //    EVENT_TABLEAVE = 75,
            //    EVENT_TABNEWENTERED = 77,
            
        default: {
            NSLog(@"%s %d -> %s", __FUNCTION__, event, fname ?: fname_io);
            break;
        }
    }
}




