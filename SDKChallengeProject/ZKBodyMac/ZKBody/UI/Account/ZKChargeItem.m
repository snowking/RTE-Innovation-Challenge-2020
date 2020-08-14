//
//  ZKChargeItem.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/23.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKChargeItem.h"
#import "Colours.h"

@interface ZKChargeItem ()

@end

@implementation ZKChargeItem

- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [NSColor colorFromHexString:@"#FF979797"].CGColor;
    
    
}

@end
