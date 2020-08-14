//
//  RegisterViewController.h
//  ZKBody
//
//  Created by King on 2019/12/6.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKViewController.h"

@interface RegisterViewController : ZKViewController

@property (nonatomic, strong) IBOutlet NSTextField *phoneField;
@property (nonatomic, strong) IBOutlet NSTextField *codeField;
@property (nonatomic, strong) IBOutlet NSSecureTextField *passwordField;
@property (nonatomic, strong) IBOutlet NSTextField *inviteField;

@property (nonatomic, strong) IBOutlet NSButton *codeButton;


-(IBAction)codeButtonClicked:(id)sender;
-(IBAction)registerButtonClicked:(id)sender;
-(IBAction)agreementButtonClicked:(id)sender;


@end

