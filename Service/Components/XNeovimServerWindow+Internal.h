//
//  XNeovimServerWindow+Internal.h
//  XNeovim
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <XNeovimService/XNeovimServer.h>
#import <XNeovimService/XNeovimServerView.h>
#import <XNeovimService/XNeovimServerWindow.h>
#import <XNeovimService/XNeovimServerScreen.h>

@interface XNeovimServerWindow (Internal)

- (instancetype)initWithHandle:(NSInteger)handle screen:(XNeovimServerScreen*)screen;

- (NSInteger)handle;

- (void)rebindWithHandle:(NSInteger)handle;
- (XNeovimServerView*)viewWithHandle:(NSInteger)handle;

//@property (nonatomic, readonly) NSInteger handle;
//@property (nonatomic, readonly) NSArray<XNeovimServerView*>* views;
//
//+ (instancetype)windowWithHandle:(NSInteger)handle;
//
//- (void)addView:(XNeovimServerView*)view;
//- (void)removeView:(XNeovimServerView*)view;
//
//
//- (void)rebind:(NSInteger)handle;




@end
