//
//  ZKWindowController.m
//  ZKBody
//
//  Created by King on 2019/9/25.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKWindowController.h"



@interface ZKWindowController ()<NSWindowDelegate>

@end

@implementation ZKWindowController

-(IBAction)closeButtonClick:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZKBodyTerminate" object:nil];
    
    [[NSApplication sharedApplication] terminate:nil];
}


-(void)keyDown:(NSEvent *)event{
    
}

-(void)keyUp:(NSEvent *)event{
    
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize{
    
    return sender.frame.size;
}

- (BOOL)windowShouldClose:(id)sender{
    [self closeButtonClick:nil];
    return YES;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.delegate = self;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
