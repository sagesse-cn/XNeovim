//
//  XNeovimServerInput.h
//  XNeovimService
//
//  Created by SAGESSE on 10/6/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol XNeovimServerInput <NSObject>

+ (NSString*)inputWithEvent:(NSEvent*)event;
+ (NSString*)inputWithPlainText:(NSString*)event;

@end

@interface NSString (XNeovimServerInput) <XNeovimServerInput>

+ (NSString*)inputWithEvent:(NSEvent*)event;
+ (NSString*)inputWithPlainText:(NSString*)event;

@end

