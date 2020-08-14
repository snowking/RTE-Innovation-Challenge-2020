//
//  ZKWechatPayViewController.m
//  ZKBody
//
//  Created by King on 2019/12/24.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKWechatPayViewController.h"
#import "QRCode.h"

@interface ZKWechatPayViewController ()

@end

@implementation ZKWechatPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.codeBackground.wantsLayer = YES;
    self.codeBackground.layer.borderWidth = 1.0;
    self.codeBackground.layer.borderColor = [NSColor lightGrayColor].CGColor;
    self.codeBackground.layer.cornerRadius = 5.0;
    
    self.codeView.image = [QRCode qrImageWithContent:self.codeURL size:400];
    
    
    NSString *unit = @"¥";
    NSString *money = [NSString stringWithFormat:@"%@", @(self.amount.intValue*10)];
    NSString *count = [NSString stringWithFormat:@"(%@能量块)", self.amount];
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@", unit,money,count];
            
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
           
    [attributedString setAttributes:@{
                   NSFontAttributeName : [NSFont systemFontOfSize:24.0f],
                                                 NSForegroundColorAttributeName : [NSColor colorFromHexString:@"#FF333333"],
    } range:NSMakeRange(0, unit.length)];
              
    [attributedString setAttributes: @{
                    NSFontAttributeName : [NSFont boldSystemFontOfSize:48.0f],
                                               NSForegroundColorAttributeName : [NSColor colorFromHexString:@"#FF333333"],
                                               }
                              range:NSMakeRange(unit.length, money.length)];
            [attributedString setAttributes:@{
                NSFontAttributeName : [NSFont systemFontOfSize:12.0f],
                                              NSForegroundColorAttributeName : [NSColor colorFromHexString:@"#FF333333"],
            } range:NSMakeRange(money.length+unit.length, count.length)];
    
//    [attributedString setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, finalString.length)];
            
    self.moneyField.attributedStringValue = attributedString;
    
}

-(void)viewDidAppear{
    [super viewDidAppear];
    
    [self checkStatus];
    
    
    
}

-(void)checkStatus{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[ZKService sharedService] getChargeListWithpageNum:nil pageSize:nil orderID:self.orderID success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectOrNilForKey:@"status"] intValue] == 1) {
                   //code_url, order_id
            NSNumber *paid = [[responseObject objectOrNilForKey:@"data"] objectOrNilForKey:@"isPaid"];
            if ([paid intValue] == 1) { //支付成功
                [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:nil];
                [self dismissController:nil];
            }
            else{
                [self doNext];
            }
        }
        else{
            [self doNext];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self doNext];
    }];
    
}

-(void)doNext{
    [self performSelector:@selector(checkStatus) withObject:nil afterDelay:2.0];
}

@end
