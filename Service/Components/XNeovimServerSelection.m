//
//  XNeovimServerSelection.m
//  XNeovimService
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServerSelection.h"

@interface XNeovimServerSelection ()

@property (assign, nonatomic) NSInteger mode;
@property (strong, nonatomic) XNeovimServerPosition* start;
@property (strong, nonatomic) XNeovimServerPosition* end;

@end

@implementation XNeovimServerSelection

@synthesize hash = _hash;

+ (instancetype)selectionWithCursor:(XNeovimServerPosition*)position {
    return [self selectionWithStart:position end:position];
}
+ (instancetype)selectionWithStart:(XNeovimServerPosition*)start end:(XNeovimServerPosition*)end {
    return [self selectionWithStart:start end:end mode:0];
}
+ (instancetype)selectionWithStart:(XNeovimServerPosition*)start end:(XNeovimServerPosition*)end mode:(NSInteger)mode {
    XNeovimServerSelection* selection = [[self alloc] init];
    selection.mode = mode;
    selection.start = start;
    selection.end = end;
    selection->_hash = ((start.hash << sizeof(NSUInteger) * 4) | end.hash) + 3 + mode;
    return selection;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:XNeovimServerSelection.class]) {
        XNeovimServerSelection* selection = object;
        return [self.start isEqual:selection.start] && [self.end isEqual:selection.end] && self.mode == selection.mode;
    }
    return [super isEqual:object];
}

@end
