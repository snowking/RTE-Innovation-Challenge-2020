//
//  ZKLoginViewController.h
//  ZKBody
//
//  Created by King on 2019/12/5.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKViewController.h"

@interface ZKLoginViewController : ZKViewController <NSTextFieldDelegate>

@property (nonatomic, strong) IBOutlet NSTextField *phoneField;
@property (nonatomic, strong) IBOutlet NSSecureTextField *passwordField;

@property (nonatomic, strong) IBOutlet NSButton *loginButton;
@property (nonatomic, strong) IBOutlet NSButton *registerButton;

-(IBAction)loginButtonClicked:(id)sender;

-(IBAction)registerButtonClicked:(id)sender;

@end

