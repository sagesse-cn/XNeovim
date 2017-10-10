//
//  rd_get_func_impl.c
//  SWRoute
//  
//  Copyright © 2014 Dmitry Rodionov <i.am.rodionovd@gmail.com>
//  This work is free. You can redistribute it and/or modify it under the
//  terms of the Do What The Fuck You Want To Public License, Version 2,
//  as published by Sam Hocevar. See the COPYING file for more details.

#include <stdint.h>

#define kObjectFieldOffset sizeof(uintptr_t)

typedef struct swift_closure_descriptor {
    uintptr_t *original_type_ptr;
#if defined(__x86_64__)
    uintptr_t *unknown0;
#else
    uintptr_t *unknown0, *unknown1;
#endif
    uintptr_t *self;
    uintptr_t function_address;
} swift_closure_x_object;

struct swift_closure_object {
    uintptr_t *original_type_ptr;
#if defined(__x86_64__)
    uintptr_t *unknown0;
#else
    uintptr_t *unknown0, *unknown1;
#endif
    uintptr_t function_address;
    struct swift_closure_descriptor *descriptor;
};

uintptr_t _rd_get_func_impl(void *func)
{
    struct swift_closure_object *obj = (struct swift_closure_object *)*(uintptr_t *)(func + kObjectFieldOffset);
    
    if (obj->descriptor != NULL) {
        return obj->descriptor->function_address;
    }
    return obj->function_address;
}
