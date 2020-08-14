//
//  ZKNavigationController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKNavigationBar.h"

@class ZKViewController;

@interface ZKNavigationController : NSViewController

- (instancetype)initWithRootViewController:(ZKViewController *)rootViewController;

- (void)pushViewController:(ZKViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (void)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.

-(void)popToRootViewControllerAnimated:(BOOL)animated;


@property(nonatomic,strong) ZKViewController *topViewController; // The top view controller on the stack.
@property(nonatomic,strong) ZKViewController *rootViewController;
@property(nonatomic,strong) ZKViewController *visibleViewController; // Return modal view controller if it exists. Otherwise the top view controller.

@property(nonatomic,strong) NSMutableArray<__kindof ZKViewController *> *viewControllers; // The current view controller stack.

@property (nonatomic, strong) ZKNavigationBar *navigationBar;

@end


