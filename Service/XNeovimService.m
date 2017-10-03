//
//  XNeovimService.m
//  XNeovimService
//
//  Created by SAGESSE on 10/1/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import "XNeovim.h"
#import "XNeovimService.h"

#import "XNeovimServiceString.h"
#import "XNeovimServiceString+Bridge.h"

@interface XNeovimService ()

@end

@implementation XNeovimService

- (void)start {
    xnvim_service_start(nil);
}

- (void)stop {
    xnvim_service_stop();
}

- (void)input:(XNeovimServiceString*)keys {
    xnvim_dispatch_async(^{
        nvim_input(keys.nString);
    });
}

- (void)command:(XNeovimServiceString*)command {
    xnvim_dispatch_async(^{
        Error err = ERROR_INIT;
        
        nvim_command(command.nString, &err);
        
        if (ERROR_SET(&err)) {
            WLOG("ERROR while executing command %s: %s", command.contents.UTF8String, err.msg);
        }
    });
}

- (void)feedkeys:(XNeovimServiceString*)keys {
}

- (void)setCursor:(NSInteger)row column:(NSInteger)column {
    xnvim_dispatch_async(^{
        Array position = ARRAY_DICT_INIT;
        
        position.size = 2;
        position.capacity = 2;
        position.items = xmalloc(2 * sizeof(Object));
        
        position.items[0] = (Object) {
            .type = kObjectTypeInteger,
            .data.integer = row
        };
        
        position.items[1] = (Object) {
            .type = kObjectTypeInteger,
            .data.integer = column
        };;
        
        Error err = ERROR_INIT;
        
        nvim_win_set_cursor(nvim_get_current_win(), position, &err);
//        // The above call seems to be not enough...
//        nvim_input((String) { .data="<ESC>", .size=5 });
        
        xfree(position.items);
    });

}

@end
