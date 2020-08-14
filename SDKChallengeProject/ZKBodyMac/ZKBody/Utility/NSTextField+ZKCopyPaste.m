//
//  NSTextField+ZKCopyPaste.m
//  ZKBody
//
//  Created by King on 2019/12/24.
//  Copyright © 2019 King. All rights reserved.
//

#import "NSTextField+ZKCopyPaste.h"

#import <AppKit/AppKit.h>


@implementation NSTextField (ZKCopyPaste)


- (BOOL)performKeyEquivalent:(NSEvent *)event
{
    if (([event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagCommand) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"z"]) {
            return [NSApp sendAction:@selector(keyDown:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];

}

@end
