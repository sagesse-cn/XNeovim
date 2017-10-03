#!/usr/bin/env python

import os
import io
import re
from string import Template

if 'CONFIGURATION' in os.environ and os.environ['CONFIGURATION'] == 'Debug':
    if os.path.isfile('../headers/NeoVimAutoCommandEvent.generated.h') and os.path.isfile('../headers/NeoVimAutoCommandEvent.generated.m'):
        print("Files already there, exiting...")
        exit(0)

with io.open('./build/include/auevents_enum.generated.h', 'r') as auto_cmds_file:
    raw_auto_cmds = [line.strip() for line in auto_cmds_file.readlines() if re.match(r'^EVENT_', line.strip())]


def convert(line):
    result = re.match(r'^EVENT_(.*) = (.*)', line.replace(',', ''))
    return result.group(1), result.group(2)


auto_cmds = [convert(line) for line in raw_auto_cmds]
auto_cmds_impl_template = Template(
'''
@import Foundation;
#import "NeoVimAutoCommandEvent.generated.h"

NSString *neoVimAutoCommandEventName(NeoVimAutoCommandEvent event) {
  switch (event) {
${event_cases}
    default: return @"NON_EXISTING_EVENT";
  }
}
''')

impl = auto_cmds_impl_template.substitute(
    event_cases='\n'.join(
        ['    case NeoVimAutoCommandEvent{}: return @"{}";'.format(event[0], event[0]) for event in auto_cmds])
)
with io.open('SwiftNeoVim/NeoVimAutoCommandEvent.generated.m', 'w') as auto_cmds_impl_file:
    auto_cmds_impl_file.write(unicode(impl))

auto_cmds_header_template = Template(
'''
@import Foundation;

typedef NS_ENUM(NSUInteger, NeoVimAutoCommandEvent) {
${event_cases}
};

#define NumberOfAutoCommandEvents ${count}
extern NSString * __nonnull neoVimAutoCommandEventName(NeoVimAutoCommandEvent event);
''')

header = auto_cmds_header_template.substitute(
    event_cases='\n'.join(
        ['  NeoVimAutoCommandEvent{} = {},'.format(event[0], event[1]) for event in auto_cmds]
    ),
    count=str(len(auto_cmds))
)
with io.open('../headers/NeoVimAutoCommandEvent.generated.h', 'w') as auto_cmds_header_file:
    auto_cmds_header_file.write(unicode(header))
