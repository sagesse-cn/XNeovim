//
//  XNeovimServerPosition.m
//  XNeovimService
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServerPosition.h"

@interface XNeovimServerPosition ()

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;

@end

@implementation XNeovimServerPosition

@synthesize hash = _hash;

+ (instancetype)positionWithRow:(NSInteger)row column:(NSInteger)column {
    XNeovimServerPosition* position = [[self alloc] init];
    position.row = row;
    position.column = column;
    position->_hash = (row << sizeof(NSUInteger) * 4) | column;
    return position;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:XNeovimServerPosition.class]) {
        XNeovimServerPosition* position = object;
        return self.row == position.row && self.column == position.column;
    }
    return [super isEqual:object];
}


@end
