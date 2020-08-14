//
//  ZKWechatPayViewController.h
//  ZKBody
//
//  Created by King on 2019/12/24.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"



@interface ZKWechatPayViewController : ZKViewController

@property (nonatomic, strong) NSString *codeURL;
@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, strong) IBOutlet NSView *codeBackground;
@property (nonatomic, strong) IBOutlet NSImageView *codeView;

@property (nonatomic, strong) IBOutlet NSTextField *moneyField;



@end

