//
//  XNeovimServerSelection.h
//  XNeovimService
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServerPosition.h"

@interface XNeovimServerSelection : NSObject

+ (instancetype _Nonnull)selectionWithCursor:(XNeovimServerPosition* _Nonnull)position;
+ (instancetype _Nonnull)selectionWithStart:(XNeovimServerPosition* _Nonnull)start end:(XNeovimServerPosition* _Nonnull)end;
+ (instancetype _Nonnull)selectionWithStart:(XNeovimServerPosition* _Nonnull)start end:(XNeovimServerPosition* _Nonnull)end mode:(NSInteger)mode;

@property (nonatomic, readonly) NSInteger mode;
@property (nonatomic, readonly, nonnull) XNeovimServerPosition* start;
@property (nonatomic, readonly, nonnull) XNeovimServerPosition* end;

@end
