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

@property (nonatomic, assign) BOOL runing;

@end

@implementation XNeovimService

- (void)start {
    @synchronized(self) {
        // If the service is running, ignored
        if (self.runing) {
            return;
        }
        self.runing = true;
        
        // start service
        xnvim_service_start(nil);
    }
}

- (void)stop {
    @synchronized(self) {
        // If the service is running, ignored
        if (!self.runing) {
            return;
        }
        self.runing = false;

        // stop service
        xnvim_service_stop();
    }
}

- (void)input:(XNeovimServiceString*)keys {
    xnvim_service_async(^{
        nvim_input(keys.nString);
    });
}

- (void)command:(XNeovimServiceString*)command {
    xnvim_service_async(^{
        Error err = ERROR_INIT;
        
        nvim_command(command.nString, &err);
        
        if (ERROR_SET(&err)) {
            WLOG("ERROR while executing command %s: %s", command.contents.UTF8String, err.msg);
        }
    });
}

- (void)feedkeys:(XNeovimServiceString*)keys {
}

@end
