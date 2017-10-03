//
//  XNeovimServiceString.h
//  XNeovimService
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface XNeovimServiceString : NSObject

- (instancetype)initWithEvent:(NSEvent*)event;
- (instancetype)initWithPlain:(NSString*)string;
- (instancetype)initWithString:(NSString*)string;

- (NSString*)contents;

@end
