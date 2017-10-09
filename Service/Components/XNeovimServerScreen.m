//
//  XNeovimServerScreen.m
//  XNeovim
//
//  Created by SAGESSE on 10/4/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServer+Internal.h"

@interface XNeovimServerScreen() {
    NSInteger _handle;
    XNeovimServer* _server;
    NSMutableArray<XNeovimServerWindow*>* _windows;
}

@end

@implementation XNeovimServerScreen

- (instancetype)init {
    self = [super init];
    self->_windows = [[NSMutableArray alloc] init];
    return self;
}

- (void)become {
    NSLog(@"%s", __func__);
}
- (void)resign {
    NSLog(@"%s", __func__);
}

// MARK: Internal

/// Fetch a window, if not exists create it
- (XNeovimServerWindow*)windowWithHandle:(NSInteger)handle {
    // With the handle search has created the window
    for (XNeovimServerWindow* window in _windows) {
        if (window.handle == handle) {
            return window;
        }
    }
    // not found, create it
    XNeovimServerWindow* window = [[XNeovimServerWindow alloc] initWithHandle:handle screen:self];
    
    // add to cache
    [_windows addObject:window];
    
    return window;
}

- (XNeovimServer*)server {
    return _server;
}

@end
