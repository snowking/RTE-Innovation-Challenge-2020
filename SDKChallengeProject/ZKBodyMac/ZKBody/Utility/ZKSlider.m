//
//  ZKSlider.m
//  TestRotate
//
//  Created by King on 2020/3/10.
//  Copyright © 2020 King. All rights reserved.
//

#import "ZKSlider.h"

@interface ZKSlider ()



@end

@implementation ZKSlider

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)updateValue:(int)value{
    
    if (self.doNotUpdate) {
        return;
    }
    
    self.intValue = value;
    
}

-(void)mouseDown:(NSEvent *)event{
    
    self.doNotUpdate = YES;
    
    [super mouseDown:event];
}

@end
