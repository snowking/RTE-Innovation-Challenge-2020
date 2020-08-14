//
//  ZKChargeViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/23.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"



@interface ZKChargeViewController : ZKViewController

@property (nonatomic, strong) IBOutlet NSCollectionView *chargeCollection;
@property (nonatomic, strong) NSArray *chargeArray;

@property (nonatomic, strong) IBOutlet NSView *highlightView;
@property (nonatomic, strong) IBOutlet NSView *payhighlightView;

@property (nonatomic, strong) IBOutlet NSButton *wechatButton;
@property (nonatomic, strong) IBOutlet NSButton *payButton;

@property (nonatomic, strong) NSNumber *orderID;

-(IBAction)paymentButtonClicked:(id)sender;
-(IBAction)payButtonClicked:(id)sender;

@end


