//
//  XNeovimServerView+Internal.h
//  XNeovim
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <XNeovimService/XNeovimServer.h>
#import <XNeovimService/XNeovimServerView.h>
#import <XNeovimService/XNeovimServerWindow.h>
#import <XNeovimService/XNeovimServerScreen.h>

@interface XNeovimServerView (Internal)


- (instancetype)initWithHandle:(NSInteger)handle window:(XNeovimServerWindow*)window;

- (NSInteger)handle;


- (void)openWithHandle:(NSInteger)handle;


//// Please create from `XNeovimWindow`
//- (instancetype)init NS_UNAVAILABLE;

//@property (nonatomic, readonly) NSInteger handle;
//
////@property (nonatomic, readonly) XNeovimServerWindow* window;
////@property (nonatomic, readonly) XNeovimBuffer* buffer;
//
//+ (instancetype)viewWithHandle:(NSInteger)handle;
//
//- (void)rebind:(NSInteger)handle;

- (void)setWindow:(XNeovimServerView *)window;

- (void)updateSelection:(XNeovimServerSelection*)selection;

@end
