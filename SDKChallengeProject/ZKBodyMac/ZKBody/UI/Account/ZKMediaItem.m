//
//  ZKMediaItem.m
//  ZKBody
//
//  Created by King on 2020/2/26.
//  Copyright © 2020 King. All rights reserved.
//

#import "ZKMediaItem.h"

@interface ZKMediaItem ()

@end

@implementation ZKMediaItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
       self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
       NSShadow *shadow = [[NSShadow alloc] init];
       [shadow setShadowBlurRadius:2.0f];
       [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
       [shadow setShadowColor:[NSColor lightGrayColor]];
       [self.view setShadow:shadow];
}

@end
