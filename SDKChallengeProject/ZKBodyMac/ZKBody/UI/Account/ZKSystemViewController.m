//
//  ZKSystemViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKSystemViewController.h"
#import "ViewController.h"
#import "ZKChargeViewController.h"
//#import "ZKChargeWeViewController.h"
#import "ZKChargeHistoryViewController.h"
#import "ZKPlayHistoryViewController.h"

#import "ZKMediaViewController.h"

@interface ZKSystemViewController ()

@end

@implementation ZKSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.phoneField.stringValue = [[[ZKService sharedService] user] phone];
    
    self.inviteCodeField.stringValue = [[[ZKService sharedService] user] inviteCode];
    
    self.line.wantsLayer = YES;
    self.line.layer.backgroundColor = [NSColor colorFromHexString:@"#E2E2E2"].CGColor;
    
    self.energyField.stringValue = [NSString stringWithFormat:@"%.1f", [ZKService sharedService].user.energyAmount.floatValue];
    NSDictionary *infoDictionary=[[NSBundle mainBundle]infoDictionary];
    
    
    self.versionInfo.stringValue = [NSString stringWithFormat:@"Copyright © 峥空® 2017-2020 版本:%@ Build:%@, 联系微信:18602195219", [infoDictionary objectForKey:@"CFBundleShortVersionString"], [infoDictionary objectForKey:@"CFBundleVersion"]];
    
}

-(void)viewWillLayout{
    [super viewWillLayout];
    
    self.closeView.wantsLayer = YES;
    if([self isDarkMode]){
        self.closeView.layer.backgroundColor = [NSColor colorFromHexString:@"#342620"].CGColor;
    }else{
        self.closeView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
}

-(void)viewWillAppear{
    [super viewWillAppear];
    
    self.phoneField.stringValue = [[[ZKService sharedService] user] phone];
    
    self.inviteCodeField.stringValue = [[[ZKService sharedService] user] inviteCode];
}

-(void)viewDidAppear{
    [super viewDidAppear];
    
    self.energyField.stringValue = [NSString stringWithFormat:@"%.1f", [ZKService sharedService].user.energyAmount.floatValue];
}

-(IBAction)chargeButtonClicked:(id)sender{
    
//    if ([[[ZKService sharedService].user phone] isEqualToString:@"18069586919"]) {
        ZKChargeViewController *viewController = [[ZKChargeViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [self addEvent:@"点击充值按钮"];
//    }
//    else{
//        ZKChargeWeViewController *viewController = [[ZKChargeWeViewController alloc] init];
//        [self.navigationController pushViewController:viewController animated:YES];
//        [self addEvent:@"点击充值按钮"];
//
//    }
    
    
    
}

-(IBAction)chargeListButtonClicked:(id)sender{
    
    ZKChargeHistoryViewController *viewController = [[ZKChargeHistoryViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [self addEvent:@"点击充值记录按钮"];
    
    
}

-(IBAction)playListButtonClicked:(id)sender{
    
    ZKPlayHistoryViewController *play = [[ZKPlayHistoryViewController alloc] init];
    [self.navigationController pushViewController:play animated:YES];
    [self addEvent:@"点击消费记录按钮"];
}

-(IBAction)mediaButtonClicked:(id)sender{
    ZKMediaViewController *media = [[ZKMediaViewController alloc] init];
    [self.navigationController pushViewController:media animated:YES];
    [self addEvent:@"点击媒体按钮"];
}

@end
