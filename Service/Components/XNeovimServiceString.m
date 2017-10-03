//
//  XNeovimServiceString.m
//  XNeovimService
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

#import <objc/runtime.h>

#import "XNeovimServiceString.h"

NSString* xns_special_to_name(int key);
NSString* xns_modifier_to_name(NSEventModifierFlags modifier);

//FOUNDATION_STATIC_INLINE NSString* XNeovimServiceStringEventModifierFlags(NSEventModifierFlags modifierFlags) {
//
//    NSMutableString* result = NSMutableString.new;
//    
//    if (modifierFlags & NSEventModifierFlagControl) {
//        [result appendString:@"C-"];
//    }
//    
//    if (modifierFlags & NSEventModifierFlagOption) {
//        [result appendString:@"M-"];
//    }
//
//    if (modifierFlags & NSEventModifierFlagCommand) {
//        [result appendString:@"D-"];
//    }
//
//    if (modifierFlags & NSEventModifierFlagShift) {
//        [result appendString:@"S-"];
//    }
//    
//    if (result.length == 0) {
//        result = nil;
//    }
//
//    return result;
//}
//FOUNDATION_STATIC_INLINE NSString* XNeovimServiceStringEncoding(NSString* characters) {
//    
//    if (characters.length == 0) {
//        return characters;
//    }
//    
//    static struct {
//        int key;
//        char* name;
//    } mapping[] = {
//    };
//    

//
//    return characters;
//}

@implementation XNeovimServiceString {
    NSString* _contents;
}

- (instancetype)initWithEvent:(NSEvent*)event {
    
    //
    if (event.charactersIgnoringModifiers.length == 0) {
        return nil;
    }
    
//    NSString* special = xns_special_to_name([event.charactersIgnoringModifiers characterAtIndex:0]);
//    NSString* flag = xns_modifier_to_name([event modifierFlags]);
//
////    NSLog(@"%s, %@%@", __func__, flag, special);
    
    NSString* string = event.characters;
    
    return [self initWithPlain:string];
}

- (instancetype)initWithPlain:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"\\<"];
    
    return [self initWithString:string];
}

- (instancetype)initWithString:(NSString*)string {
    self = [super init];
    self->_contents = string;
    return self;
}

- (NSString*)contents {
    return _contents;
}
//}
//- (instancetype)initWithPlain:(NSString*)string {
//    
//}
//
//+ (Class)class {
//    return NSString.class;
//}

@end


static struct { int k; char* n; } _key_name_table[] = {
	{ NSUpArrowFunctionKey, "Up" },
	{ NSDownArrowFunctionKey, "Down" },
	{ NSLeftArrowFunctionKey, "Left" },
	{ NSRightArrowFunctionKey, "Right" },
	{ NSInsertFunctionKey, "Insert" },
    { 0x7F, "BS" }, // "delete"-key
    { NSDeleteFunctionKey, "Del" }, // "Fn+delete"-key
	{ NSHomeFunctionKey, "Home" },
	{ NSBeginFunctionKey, "Begin" },
	{ NSEndFunctionKey, "End" },
	{ NSPageUpFunctionKey, "PageUp" },
	{ NSPageDownFunctionKey, "PageDown" },
	{ NSHelpFunctionKey, "Help" },
	{ NSF1FunctionKey, "F1" },
	{ NSF2FunctionKey, "F2" },
	{ NSF3FunctionKey, "F3" },
	{ NSF4FunctionKey, "F4" },
	{ NSF5FunctionKey, "F5" },
	{ NSF6FunctionKey, "F6" },
	{ NSF7FunctionKey, "F7" },
	{ NSF8FunctionKey, "F8" },
	{ NSF9FunctionKey, "F9" },
	{ NSF10FunctionKey, "F10" },
	{ NSF11FunctionKey, "F11" },
	{ NSF12FunctionKey, "F12" },
	{ NSF13FunctionKey, "F13" },
	{ NSF14FunctionKey, "F14" },
	{ NSF15FunctionKey, "F15" },
	{ NSF16FunctionKey, "F16" },
	{ NSF17FunctionKey, "F17" },
	{ NSF18FunctionKey, "F18" },
	{ NSF19FunctionKey, "F19" },
	{ NSF20FunctionKey, "F20" },
	{ NSF21FunctionKey, "F21" },
	{ NSF22FunctionKey, "F22" },
	{ NSF23FunctionKey, "F23" },
	{ NSF24FunctionKey, "F24" },
	{ NSF25FunctionKey, "F25" },
	{ NSF26FunctionKey, "F26" },
	{ NSF27FunctionKey, "F27" },
	{ NSF28FunctionKey, "F28" },
	{ NSF29FunctionKey, "F29" },
	{ NSF30FunctionKey, "F30" },
	{ NSF31FunctionKey, "F31" },
	{ NSF32FunctionKey, "F32" },
	{ NSF33FunctionKey, "F33" },
	{ NSF34FunctionKey, "F34" },
	{ NSF35FunctionKey, "F35" },
	{ 0x09, "Tab"},
	{ 0x19, "Tab"}
};

NSString* xns_special_to_name(int key) {
    for (int i = sizeof(_key_name_table) / sizeof(*_key_name_table); i-- > 0 ; /* empty */) {
        if (_key_name_table[i].k == key) {
            return @(_key_name_table[i].n);
        }
    }
    return nil;
}

NSString* xns_modifier_to_name(NSEventModifierFlags modifier) {
    NSMutableString* name = [NSMutableString stringWithCapacity:8];
    
    if ((modifier & NSEventModifierFlagControl)) {
        [name appendString:@"C-"];
    }
    
    if ((modifier & NSEventModifierFlagOption)) {
        [name appendString:@"M-"];
    }
    
    if ((modifier & NSEventModifierFlagCommand)) {
        [name appendString:@"D-"];
    }
    
    if ((modifier & NSEventModifierFlagShift)) {
        [name appendString:@"S-"];
    }
    
    if (name.length == 0) {
        name = nil;
    }
    
    return name;
}
