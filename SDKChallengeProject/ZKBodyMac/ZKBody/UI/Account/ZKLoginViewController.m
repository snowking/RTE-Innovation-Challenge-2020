//
//  ZKLoginViewController.m
//  ZKBody
//
//  Created by King on 2019/12/5.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKService.h"
#import "RegisterViewController.h"

@interface ZKLoginViewController ()

@end

@implementation ZKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if (@available(macOS 10.14, *)) {
        [self.loginButton setContentTintColor:[NSColor whiteColor]];
    } else {
        // Fallback on earlier versions
    }
    
    self.registerButton.wantsLayer = YES;
    self.registerButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.registerButton.layer.borderColor = [NSColor systemBlueColor].CGColor;
    self.registerButton.layer.borderWidth = 1.0;
}

-(IBAction)registerButtonClicked:(id)sender{
    
    
    ZKModelUser *fakeUser = [[ZKModelUser alloc] init];
    fakeUser.phone = self.phoneField.stringValue;
    [ZKService sharedService].user = fakeUser;
    [self addEvent:@"进入注册"];
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self presentViewControllerAsSheet:registerViewController];
    
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    
    if ([fieldEditor.string length]<=0) {
        return YES;
    }
    
    if ([ZKService sharedService].token) {
        return YES;
    }
    
    [self loginButtonClicked:nil];
    
    return YES;
}

-(IBAction)loginButtonClicked:(id)sender{
    
    NSString *phone = self.phoneField.stringValue;
    NSString *password = self.passwordField.stringValue;
    
    ZKModelUser *fakeUser = [[ZKModelUser alloc] init];
    fakeUser.phone = phone;
    [ZKService sharedService].user = fakeUser;
    [self addEvent:@"登录"];
    
    
    if ([phone length] != 11) {
        
        [self showAlertWithText:@"请输入正确的手机"];
//        [self.phoneField becomeFirstResponder];
        return;
    }
    else if ([password length]<=0) {
        [self showAlertWithText:@"请输入密码"];
//        [self.passwordField becomeFirstResponder];
        return;
    }
    
    password = [[ZKService sharedService] MD5With:password];
    
    [[ZKService sharedService] loginWithUsername:phone password:password success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([responseObject[@"status"] intValue] == 1) {
            [[ZKService sharedService] setToken:responseObject[@"token"]];
            [[ZKService sharedService] saveUsername:phone password:password];
            
            [[ZKService sharedService] getMemberInfoWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
                [self dismissController:nil];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showAlertWithText:error.localizedDescription];
            }];
            
        }
        else{
              [self showAlertWithText:responseObject[@"msg"]];
        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertWithText:error.localizedDescription];
    }];
 
    
}

@end
