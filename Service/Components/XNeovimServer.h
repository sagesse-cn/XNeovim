//
//  XNeovimServer.h
//  XNeovim
//
//  Created by SAGESSE on 10/6/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <XNeovimService/XNeovimServerInput.h>

#import <XNeovimService/XNeovimServerView.h>
#import <XNeovimService/XNeovimServerWindow.h>
#import <XNeovimService/XNeovimServerScreen.h>

/// An vim agent server.
@interface XNeovimServer : NSObject

/// Can't create, use `XNeovimServer.shared` method.
- (instancetype _Nonnull)init NS_UNAVAILABLE;

@property (class, nonnull, readonly) XNeovimServer* shared; ///< shared server

//@property (strong, nonnull, readonly) XNeovimServerScreen* screen; ///< current screen.
@property (strong, nonnull, readonly) XNeovimServerWindow* window; ///< Current window.
@property (strong, nonnull, readonly) XNeovimServerView* view; ///< Current view.

/// Start and stop the service.
- (void)start;
- (void)stop;

- (void)input:(NSString<XNeovimServerInput>* _Nonnull)keys;
- (void)command:(NSString<XNeovimServerInput>* _Nonnull)command;
- (void)feedkeys:(NSString<XNeovimServerInput>* _Nonnull)keys;

@end


