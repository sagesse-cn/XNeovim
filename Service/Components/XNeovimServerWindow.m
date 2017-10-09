//
//  XNeovimServerWindow.m
//  XNeovim
//
//  Created by SAGESSE on 10/4/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServer+Internal.h"

@interface XNeovimServerWindow () {
    
    NSInteger _handle;
    __weak XNeovimServerScreen* _screen;
    
    NSMutableArray<XNeovimServerView*>* _views;
}
@end

@implementation XNeovimServerWindow

//@synthesize handle = _handle;

- (instancetype)initWithHandle:(NSInteger)handle screen:(XNeovimServerScreen*)screen {
    self = [super init];
    
    self->_handle = handle;
    self->_screen = screen;
    
    return self;
}

//- (instancetype)initWithHandle:(NSInteger)handle {
//    self = [super init];
//    self->_handle = handle;
//    self->_views = [[NSMutableArray alloc] init];
//    return self;
//}
//+ (instancetype)windowWithHandle:(NSInteger)handle {
//    return [[self alloc] initWithHandle:handle];
//}
//
//
//- (void)addView:(XNeovimServerView*)view {
//    [_views addObject:view];
//}
//- (void)removeView:(XNeovimServerView*)view {
//    [_views removeObject:view];
//}
//
//- (XNeovimServerView*)viewWithHandle:(NSInteger)handle {
//    // With the handle search has created the view
//    for (XNeovimServerView* view in _views) {
//        if (view.handle == handle) {
//            return view;
//        }
//    }
//    // not found
//    return nil;
//}
//
//- (void)rebind:(NSInteger)handle {
//    _handle = handle;
//}

- (NSInteger)handle {
    return _handle;
}

@end
