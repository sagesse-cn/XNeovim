//
//  XNeovimServer+Internal.h
//  XNeovimService
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServer.h"

#import "XNeovimServerPosition.h"
#import "XNeovimServerSelection.h"

#import "XNeovimServerView+Internal.h"
#import "XNeovimServerWindow+Internal.h"
#import "XNeovimServerScreen+Internal.h"


@interface XNeovimServer (Internal)

- (void)setSelection:(XNeovimServerSelection*)selection;

@end
