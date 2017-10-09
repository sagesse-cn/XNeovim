//
//  XNeovimServerPosition.h
//  XNeovimService
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNeovimServerPosition : NSObject

+ (instancetype)positionWithRow:(NSInteger)row column:(NSInteger)column;

@property (nonatomic, readonly) NSInteger row;
@property (nonatomic, readonly) NSInteger column;

@end
