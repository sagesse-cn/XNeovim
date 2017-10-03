//
//  XNeovim.c
//  XNeovimService
//
//  Created by SAGESSE on 10/3/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovim.h"
#import "XNeovimService.h"

typedef struct {
    UIBridgeData *bridge;
    Loop *loop;
    
    bool stop;
} ServerUiData;

static ServerUiData *_server_ui_data;


//// Condition variable used by the XPC's init to wait till our custom UI initialization
//// is finished inside neovim
//static bool _is_ui_launched = false;


//static bool __xnvim_service_is_launch;

static uv_sem_t __xnvim_service_launch_sem;


static void set_ui_size(UIBridgeData *bridge, int width, int height) {
    bridge->ui->width = width;
    bridge->ui->height = height;
    bridge->bridge.width = width;
    bridge->bridge.height = height;
}

static void server_ui_scheduler(Event event, void *d) {
//    UI *ui = d;
//    ServerUiData *data = ui->data;
//    loop_schedule(data->loop, event);
        loop_schedule(&main_loop, event);
}

static void server_ui_main(UIBridgeData *bridge, UI *ui) {
//    Loop loop;
//    loop_init(&loop, NULL);
//
//    _server_ui_data = xcalloc(1, sizeof(ServerUiData));
//    ui->data = _server_ui_data;
//    _server_ui_data->bridge = bridge;
//    _server_ui_data->loop = &loop;
    
        set_ui_size(bridge, (int)120, (int)40);
    
//    _server_ui_data->stop = false;
    CONTINUE(bridge);
    
    
    uv_sem_post(&__xnvim_service_launch_sem);
    
//    while (!_server_ui_data->stop) {
//        loop_poll_events(&loop, -1);
//    }
//
//    ui_bridge_stopped(bridge);
//    loop_close(&loop, false);
//
//    xfree(_server_ui_data);
//    xfree(ui);
}

#pragma mark NeoVim's UI callbacks

static void server_ui_resize(UI *ui __unused, Integer width, Integer height) {
    //    NSInteger values[] = {width, height};
    //    NSData *data = [[NSData alloc] initWithBytes:values length:(2 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdResize data:data];
    //    [data release];
}

static void server_ui_clear(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdClear];
}

static void server_ui_eol_clear(UI *ui __unused) {
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
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdBusyStart];
}

static void server_ui_busy_stop(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdBusyStop];
}

static void server_ui_mouse_on(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdMouseOn];
}

static void server_ui_mouse_off(UI *ui __unused) {
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdMouseOff];
}

static void server_ui_mode_info_set(UI *ui __unused, Boolean enabled __unused,
                                    Array cursor_styles __unused) {
    // yet noop
}

static void server_ui_mode_change(UI *ui __unused, String mode_str __unused, Integer mode) {
    //    NSInteger value = mode;
    //    NSData *data = [[NSData alloc] initWithBytes:&value length:(1 * sizeof(NSInteger))];
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdModeChange data:data];
    //    [data release];
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
    //NSLog(@"%s %s", __func__, str.data);
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
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdFlush];
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
    //    [_neovim_server sendMessageWithId:NeoVimServerMsgIdStop];
    
    ServerUiData *data = (ServerUiData *) ui->data;
    data->stop = true;
}

#pragma mark Public
// called by neovim

void custom_ui_start(void) {
    NSLog(@"%s", __FUNCTION__);
    
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
    
    ui_bridge_attach(ui, server_ui_main, server_ui_scheduler);
}

void custom_ui_autocmds_groups(event_T event,
                               char_u *fname __unused,
                               char_u *fname_io __unused,
                               int group __unused,
                               bool force __unused,
                               buf_T *buf,
                               exarg_T *eap __unused) {
    
    // cursor change
    if (event == EVENT_CURSORMOVED || event == EVENT_CURSORMOVEDI) {
        NSLog(@"%s %d -> %zd:%zd", __FUNCTION__, event, curwin->w_cursor.lnum, curwin->w_cursor.col);
        return;
    }
    
    // text change
    if (event == EVENT_TEXTCHANGED || event == EVENT_TEXTCHANGEDI) {
        NSLog(@"%s %d -> %zd:\"%s\"", __FUNCTION__, event, buf->b_ml.ml_line_lnum, buf->b_ml.ml_line_ptr);
        return;
    }
    
    NSLog(@"%s %d -> %s", __FUNCTION__, event, fname ?: fname_io);
    

    
    //
    //    @autoreleasepool {
    //        DLOG("got event %d for file %s in group %d.", event, fname, group);
    //
    //        if (event == EVENT_DIRCHANGED) {
    //            send_cwd();
    //            return;
    //        }
    //
    //        if (event == EVENT_COLORSCHEME) {
    //            send_colorscheme();
    //            return;
    //        }
    //
    //        if (event == EVENT_TEXTCHANGED
    //            || event == EVENT_TEXTCHANGEDI
    //            || event == EVENT_BUFWRITEPOST
    //            || event == EVENT_BUFLEAVE)
    //        {
    //            send_dirty_status();
    //        }
    //
    //        NSUInteger eventCode = event;
    //
    //        NSMutableData *data;
    //        if (buf == NULL) {
    //            data = [[NSMutableData alloc] initWithBytes:&eventCode length:sizeof(NSInteger)];
    //        } else {
    //            NSInteger bufHandle = buf->handle;
    //
    //            data = [[NSMutableData alloc] initWithCapacity:(sizeof(NSInteger) + sizeof(NSInteger))];
    //            [data appendBytes:&eventCode length:sizeof(NSInteger)];
    //            [data appendBytes:&bufHandle length:sizeof(NSInteger)];
    //        }
    //
    //        [_neovim_server sendMessageWithId:NeoVimServerMsgIdAutoCommandEvent data:data];
    //
    //        [data release];
    //    }
}

#pragma mark Other

dispatch_queue_t xnvim_service_main_queue() {
    static dispatch_once_t once;
    static dispatch_queue_t queue;
    dispatch_once(&once, ^{
        queue = dispatch_queue_create("com.rudedogg.xneovim.service", nil);
    });
    return queue;
}


void xnvim_service_dispatch_imp(void **argv) {
    ((__bridge_transfer dispatch_block_t)*argv)();
}

void xnvim_service_sync(dispatch_block_t block) {
    dispatch_sync(xnvim_service_main_queue(), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        loop_schedule(&main_loop, event_create(xnvim_service_dispatch_imp, 1, (__bridge_retained void*)^{
            block();
            dispatch_semaphore_signal(semaphore);
        }));
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}
void xnvim_service_async(dispatch_block_t block) {
    dispatch_async(xnvim_service_main_queue(), ^{
        loop_schedule(&main_loop, event_create(xnvim_service_dispatch_imp, 1, (__bridge_retained void*)block));
    });
}

void xnvim_service_start(NSArray<NSString*>* args) {
    dispatch_async(xnvim_service_main_queue(), ^{
        // We declare nvim_main because it's not declared in any header files of neovim
        int nvim_main(int argc, char **argv);
        
        // Get ${RESOURCE_PATH_OF_XPC_BUNDLE}/runtime path
        NSString* path = [[[NSBundle bundleForClass:XNeovimService.class] resourcePath] stringByAppendingPathComponent:@"runtime"];
        
        // Set $VIMRUNTIME to ${RESOURCE_PATH_OF_XPC_BUNDLE}/runtime
        setenv("VIMRUNTIME", path.fileSystemRepresentation, true);
        
        // Set $LANG to en_US.UTF-8 such that the copied text to the system clipboard is not garbled.
        setenv("LANG", "en_US.UTF-8", true);
        
        // Lock the current thread until the start-up success
        uv_sem_init(&__xnvim_service_launch_sem, 0);
        dispatch_async(dispatch_queue_create("com.rudedogg.xneovim.service.main", nil), ^{
            // launch parameters
            int argc = 1;
            char **argv = nil;
            
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
        uv_sem_wait(&__xnvim_service_launch_sem);
    });
}
void xnvim_service_stop() {
    dispatch_async(xnvim_service_main_queue(), ^{
    });
}


