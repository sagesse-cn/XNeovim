//
//  XNeovimServerScreen+Internal.h
//  XNeovim
//
//  Created by SAGESSE on 10/9/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovimServer+Internal.h"

@interface XNeovimServerScreen (Internal)

/// Fetch a window, if not exists create it
- (XNeovimServerWindow*)windowWithHandle:(NSInteger)handle;

- (XNeovimServer*)server;

//- (NSArray<XNeovimServerWindow*>*)windows;

@end
