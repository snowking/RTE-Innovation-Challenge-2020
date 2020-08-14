//
//  ZKNavigationController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKNavigationController.h"
#import "ZKViewController.h"

@interface ZKNavigationController ()

@property (nonatomic, strong) NSButton *backButton;

@end

@implementation ZKNavigationController

- (instancetype)initWithRootViewController:(ZKViewController *)rootViewController{
    
    
    self = [super init];
    if (self) {
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        self.rootViewController = rootViewController;
        rootViewController.navigationController = self;
        [self.view addSubview:rootViewController.view];
                
        self.backButton = [NSButton buttonWithImage:[NSImage imageNamed:@"icon_back"] target:self action:@selector(backButtonClicked:)];
        self.backButton.frame = NSMakeRect(0, 6, 40, 24);
        [self backButtonLogic];
    }

    return self;
}

-(void)backButtonClicked:(id)sender{
    
    if ([ZKService sharedService].playing) {
     
         NSAlert *alert = [[NSAlert alloc] init];
         alert.messageText = @"提示";
         alert.informativeText = @"确定退出当前页面?";
         alert.icon = [NSImage imageNamed:@"icon_alert"];
         [alert addButtonWithTitle:@"取消"];
         [alert addButtonWithTitle:@"确定"];
         [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:^(NSModalResponse returnCode) {
    
             if (returnCode == 1001) {
        [self popViewControllerAnimated:YES];
             }
         }];
     }
     else{
       [self popViewControllerAnimated:YES];
     }
   
}

-(ZKViewController*)topViewController{
    
    return [self.viewControllers lastObject];
}

-(ZKViewController*)visibleViewController{
    
    return [self.viewControllers lastObject];
}

-(void)backButtonLogic{
    
    for (NSView *view in self.navigationBar.backButtonContainer.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.viewControllers.count>=2) {
        [self.navigationBar.backButtonContainer addSubview:self.backButton];
    }

}

- (void)pushViewController:(ZKViewController *)viewController animated:(BOOL)animated{
    
    ZKViewController *top = [self topViewController];
    [top.view removeFromSuperview];
    
    [self.viewControllers addObject:viewController];
    viewController.navigationController = self;
    
    [self.view addSubview:viewController.view];
        
    [self backButtonLogic];
    
}// Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (void)popViewControllerAnimated:(BOOL)animated{

    ZKViewController *top = [self topViewController];
    top.navigationController = nil;
    [top.view removeFromSuperview];
    [self.viewControllers removeLastObject];
    
    top = [self topViewController];
    [self.view addSubview:top.view];
    
    [self backButtonLogic];
}

-(void)popToRootViewControllerAnimated:(BOOL)animated{
    
    while (self.viewControllers.count > 1) {
        ZKViewController *top = [self topViewController];
        top.navigationController = nil;
        [top.view removeFromSuperview];
        [self.viewControllers removeLastObject];
    }
    [self.view addSubview:self.rootViewController.view];
    [self backButtonLogic];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
