//
//  XNeovim.h
//  XNeovim
//
//  Created by SAGESSE on 10/3/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#ifndef XNeovim_h
#define XNeovim_h

#import <Foundation/Foundation.h>

// FileInfo and Boolean are #defined by Carbon and NeoVim:
// Since we don't need the Carbon versions of them, we rename
// them.
#define Boolean CarbonBoolean
#define FileInfo CarbonFileInfo

#import <nvim/vim.h>
#import <nvim/api/vim.h>
#import <nvim/ui.h>
#import <nvim/ui_bridge.h>
#import <nvim/ex_getln.h>
#import <nvim/fileio.h>
#import <nvim/undo.h>
#import <nvim/mouse.h>
#import <nvim/screen.h>
#import <nvim/edit.h>
#import <nvim/syntax.h>
#import <nvim/api/window.h>

#import <nvim/vim.h>
#import <nvim/main.h>

void xnvim_service_start(NSArray* args);
void xnvim_service_stop(void);

void xnvim_service_sync(dispatch_block_t block);
void xnvim_service_async(dispatch_block_t block);

#endif /* XNeovim_h */
