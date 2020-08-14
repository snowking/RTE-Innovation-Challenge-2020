//
//  ZKImageSelectItem.m
//  ZKBody
//
//  Created by King on 2019/12/20.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKImageSelectItem.h"

@interface ZKImageSelectItem ()

@end

@implementation ZKImageSelectItem


-(instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:1.0f];
    [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadow setShadowColor:[NSColor lightGrayColor]];
    [self.view setShadow:shadow];
    
}

@end
