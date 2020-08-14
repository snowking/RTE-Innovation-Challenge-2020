//
//  ZKDroneControlHelpViewController.m
//  ZKBody
//
//  Created by King on 2019/12/18.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKDroneControlHelpViewController.h"

@interface ZKDroneControlHelpViewController ()

@end

@implementation ZKDroneControlHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.title = @"Body";
    
}
-(void)viewDidAppear{
    [super viewDidAppear];
    if (self.shouldAutoDissmiss) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self close];
        });
    }
}

-(void)viewWillLayout{
    [super viewWillLayout];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorFromHexString:@"#FF444444"].CGColor;
}

-(void)close{
    
    [self dismissController:nil];
}

@end
