//
//  XNeovimServiceString+Bridge.m
//  XNeovimService
//
//  Created by SAGESSE on 10/3/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServiceString+Bridge.h"

@implementation XNeovimServiceString (Bridge)

- (String)nString {
        return (String) { .data = (char *) self.contents.UTF8String, .size = strlen(self.contents.UTF8String) };
}

@end


