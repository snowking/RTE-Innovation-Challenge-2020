//
//  ZKViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKService.h"
#import "Colours.h"
#import "ZKNavigationController.h"
#import "PVAsyncImageView.h"

@interface ZKViewController : NSViewController

@property (nonatomic, strong) ZKNavigationController *navigationController;

-(NSAlert*)showAlertWithText:(NSString*)text;
-(NSAlert*)showAlertWithText:(NSString*)text completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler;

-(void)addEvent:(NSString*)event;

-(BOOL)isDarkMode;

@end

