//
//  XNeovimServerView.h
//  XNeovim
//
//  Created by SAGESSE on 10/4/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNeovimServerView;
@class XNeovimServerWindow;
@class XNeovimServerSelection;

@protocol XNeovimServerViewDelegate <NSObject>

- (void)serverView:(XNeovimServerView*)serverView selectionDidChange:(XNeovimServerSelection*)selection;

- (void)serverView:(XNeovimServerView*)serverView modeDidChange:(NSInteger)mode;


@end

@interface XNeovimServerView : NSObject

@property (nonatomic, weak) id<XNeovimServerViewDelegate> delegate;
@property (nonatomic, weak, readonly) XNeovimServerWindow* window;

@property (nonatomic, strong) XNeovimServerSelection* selection;


- (void)openWithURL:(NSURL*)URL;

@end
