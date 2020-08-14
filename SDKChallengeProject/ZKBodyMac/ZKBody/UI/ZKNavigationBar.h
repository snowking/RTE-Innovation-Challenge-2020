//
//  ZKNavigationBar.h
//  ZKBody
//
//  Created by King on 2019/11/22.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ZKNavigationBar : NSView


@property (nonatomic, assign) NSViewController *viewController;
@property (nonatomic, strong) NSView *backButtonContainer;


-(void)updateBar;


@end


