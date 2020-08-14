//
//  RegisterViewController.m
//  ZKBody
//
//  Created by King on 2019/12/6.
//  Copyright © 2019 King. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZKService.h"
#import "NSTextField+ZKCopyPaste.h"

int countDownTime = 60;

@interface RegisterViewController ()<NSTextFieldDelegate>
@property (nonatomic) int count;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.phoneField.delegate = self;
    self.codeField.delegate = self;
    self.passwordField.delegate = self;
    self.inviteField.delegate = self;

    self.codeButton.wantsLayer = YES;
    self.codeButton.layer.borderWidth = 0.5;
    self.codeButton.layer.borderColor = [NSColor colorFromHexString:@"#007EFF"].CGColor;
    
}

-(void)countDown{
    
    if (self.count>0) {
        self.codeButton.enabled = NO;
        self.count = self.count-1;
        [self.codeButton setTitle:[NSString stringWithFormat:@"%d", self.count]];
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }
    else{
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码"];
        
    }
}

-(IBAction)codeButtonClicked:(id)sender{
    
    NSString *phone = self.phoneField.stringValue;
    
    ZKModelUser *fakeUser = [[ZKModelUser alloc] init];
    fakeUser.phone = phone;
    [ZKService sharedService].user = fakeUser;
    [self addEvent:@"获取验证码"];
    
    
    
    if ([phone length] != 11) {
        
        [self showAlertWithText:@"请输入正确的手机"];
        
        return;
    }
    
    self.count = countDownTime;
    [self countDown];
    [[ZKService sharedService] getSMSCodeWithPhone:phone type:@"1" success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            
        }
        else{
            [self showAlertWithText:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertWithText:error.localizedDescription];
    }];
    
    
    
}

-(IBAction)registerButtonClicked:(id)sender{
    
    NSString *phone = self.phoneField.stringValue;
    NSString *password = self.passwordField.stringValue;
    NSString *code = self.codeField.stringValue;
    NSString *invite = self.inviteField.stringValue;
    
    
    ZKModelUser *fakeUser = [[ZKModelUser alloc] init];
    fakeUser.phone = phone;
    [ZKService sharedService].user = fakeUser;
    [self addEvent:@"注册"];
    
    
    if ([phone length] != 11) {
        [self showAlertWithText:@"请输入正确的手机"];
        return;
    }
    else if ([code length]<=0) {
        [self showAlertWithText:@"请输入验证码"];
//        [self.codeField becomeFirstResponder];
        return;
    }
    else if ([password length]<=0) {
        [self showAlertWithText:@"请输入密码"];
//        [self.passwordField becomeFirstResponder];
        return;
    }
    
    [[ZKService sharedService] registerWithPhone:phone smsCode:code password:password invite:invite success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
           

            [[ZKService sharedService] setToken:responseObject[@"token"]];
            [[ZKService sharedService] saveUsername:phone password:password];
            [[ZKService sharedService] getMemberInfoWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
                [self.presentingViewController dismissController:nil];
                           
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

-(IBAction)agreementButtonClicked:(id)sender{
    
    ZKModelUser *fakeUser = [[ZKModelUser alloc] init];
    fakeUser.phone = self.phoneField.stringValue;
    [ZKService sharedService].user = fakeUser;
    [self addEvent:@"用户协议"];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://body.zkong.me/#/agreement"]];
    
}

//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
//    
//    if (control == self.inviteField) {
//        [self registerButtonClicked:control];
//    }
//
//    return YES;
//}



@end
