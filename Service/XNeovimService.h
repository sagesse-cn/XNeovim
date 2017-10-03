//
//  XNeovimService.h
//  XNeovimService
//
//  Created by SAGESSE on 10/1/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for XNeovimService.
FOUNDATION_EXPORT double XNeovimServiceVersionNumber;

//! Project version string for XNeovimService.
FOUNDATION_EXPORT const unsigned char XNeovimServiceVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <XNeovimService/PublicHeader.h>

#import <XNeovimService/XNeovimServiceString.h>
#import <XNeovimService/XNeovimServiceWindow.h>

@interface XNeovimService: NSObject

- (void)start;
- (void)stop;

- (void)input:(XNeovimServiceString* _Nonnull)keys;
- (void)command:(XNeovimServiceString* _Nonnull)command;
- (void)feedkeys:(XNeovimServiceString* _Nonnull)keys;

- (void)setCursor:(NSInteger)row column:(NSInteger)column;

@end
