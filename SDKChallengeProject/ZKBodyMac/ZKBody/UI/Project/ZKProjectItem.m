//
//  ZKProjectItem.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKProjectItem.h"
#import "Colours.h"

@interface ZKProjectItem ()



@end

@implementation ZKProjectItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:2.0f];
    [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadow setShadowColor:[NSColor lightGrayColor]];
    [self.view setShadow:shadow];
    
    self.name.textColor = [NSColor colorFromHexString:@"#434343"];
    self.name.maximumNumberOfLines = 0;
}

@end
