//
//  XNeovimServerView.m
//  XNeovim
//
//  Created by SAGESSE on 10/4/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServer+Internal.h"

@interface XNeovimServerView () {
    NSInteger _handle;
}
@end

@implementation XNeovimServerView

@synthesize window = _window;
@synthesize selection = _selection;

- (instancetype)initWithHandle:(NSInteger)handle window:(XNeovimServerWindow *)window {
    self = [super init];
    
    self->_handle = handle;
    self->_window = window;
    
    return self;
}
//
//+ (instancetype)viewWithHandle:(NSInteger)handle {
//    return [[self alloc] initWithHandle:handle];
//}
//- (instancetype)initWithHandle:(NSInteger)handle {
//    self = [super init];
//    self->_handle = handle;
//    return self;
//}
//
//- (void)rebind:(NSInteger)handle {
//    _handle = handle;
//}

//- (void)open:(NSURL*)URL {
//}

- (void)openWithURL:(NSURL*)URL {
        [XNeovimServer.shared command:[@"edit! " stringByAppendingString:URL.path]];
}
- (void)openWithHandle:(NSInteger)handle {
    NSLog(@"%s", __func__);
}

- (void)setSelection:(XNeovimServerSelection *)selection {
    _selection = selection;
    
    [XNeovimServer.shared setSelection:selection];
}

- (void)updateSelection:(XNeovimServerSelection*)selection {
    _selection = selection;
    
    [self.delegate serverView:self selectionDidChange:selection];
}

- (NSInteger)handle {
    return _handle;
}

- (void)setWindow:(XNeovimServerWindow *)window {
    _window = window;
}


@end
