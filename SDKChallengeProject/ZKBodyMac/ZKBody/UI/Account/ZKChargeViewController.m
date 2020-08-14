//
//  ZKChargeViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/23.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKChargeViewController.h"
#import "ZKChargeItem.h"

#import "ZKWechatPayViewController.h"

#import <StoreKit/StoreKit.h>


@interface ZKChargeViewController ()<NSCollectionViewDataSource, NSCollectionViewDelegate, NSTextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger payIndex;
@property (nonatomic, strong) ZKChargeItem *pickedChargeItem;

@property (nonatomic, strong) ZKChargeItem *inputChargeItem;


@property (nonatomic, strong) NSArray *products;

@end

@implementation ZKChargeViewController

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response API_AVAILABLE(ios(3.0), macos(10.7)){
    
    self.products = response.products;
    NSSortDescriptor *sortDescripttor1 = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
    self.products = [response.products sortedArrayUsingDescriptors:@[sortDescripttor1]];
     dispatch_async(dispatch_get_main_queue(), ^{
                     [self.chargeCollection reloadData];
                     [self selectFirst];
                   });
    
    
}

// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            // Call the appropriate custom method for the transaction state.
            //支付中
            case SKPaymentTransactionStatePurchasing:
                break;
            //支付失败
            case SKPaymentTransactionStateFailed:
                break;
            //支付成功
            case SKPaymentTransactionStatePurchased:{
            //结束本次交易
            // //支付完成后调用（建议验证支付凭证有效后再调用）
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //获取支付凭证
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];
 
                NSString *countString = [transaction.payment.productIdentifier stringByReplacingOccurrencesOfString:@"com.zkbody.energy" withString:@""];
                
                NSDictionary *dic = @{@"10":@"148", @"20":@"288", @"50":@"698", @"200":@"2598", @"9":@"128", @"40":@"548"};
                
                
                [[ZKService sharedService] verifyReceipt:receiptStr payAmount:dic[countString] success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    if ([responseObject[@"status"] intValue] == 1) {
                        [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:nil];
                        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    }
                    else if ([responseObject[@"errorcode"] intValue] == 4){
                        [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:nil];
                        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
                
            }
                break;
            //支付被恢复
            case SKPaymentTransactionStateRestored:
                break;
            //支付延迟（这种情况我还没有碰到过）
            case SKPaymentTransactionStateDeferred:
                break;
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.chargeCollection.dataSource = self;
    self.chargeCollection.delegate = self;
    
    [self.chargeCollection registerNib:[[NSNib alloc] initWithNibNamed:@"ZKChargeItem" bundle:[NSBundle mainBundle]] forItemWithIdentifier:@"ZKChargeItem"];
    
    
    self.chargeArray = @[@(10), @(20), @(50), @(200)];
    
    
    [self.chargeCollection addSubview:self.highlightView];
    _highlightView.wantsLayer = YES;
    _highlightView.layer.borderWidth = 1.5;
    _highlightView.layer.borderColor = [NSColor colorFromHexString:@"#007EFF"].CGColor;
    self.highlightView.hidden = YES;
       
//    [self selectFirst];
    
    [self.view addSubview:self.payhighlightView];
    _payhighlightView.wantsLayer = YES;
    _payhighlightView.layer.borderWidth = 1.5;
    _payhighlightView.layer.borderColor = [NSColor colorFromHexString:@"#007EFF"].CGColor;
    
    self.wechatButton.wantsLayer = YES;
    self.wechatButton.layer.borderWidth = 1.0;
    self.wechatButton.layer.borderColor = [NSColor colorFromHexString:@"#FF979797"].CGColor;
    
    if (@available(macOS 10.14, *)) {
        [self.payButton setContentTintColor:[NSColor whiteColor]];
    } else {
        // Fallback on earlier versions
    }
    
    
    //商品ID数组
    NSArray *productIdArray = @[@"com.zkbody.energy9",
//                                @"com.zkbody.energy20",
                                @"com.zkbody.energy40"];
    NSSet *productIdSet = [NSSet setWithArray:productIdArray];
    
    //创建商品信息获取请求
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
    
    //设置代理 <SKProductsRequestDelegate>
    productsRequest.delegate = self;
    
    //开始请求
    [productsRequest start];
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
}

-(IBAction)payButtonClicked:(id)sender{
    
    [self addEvent:@"点击去支付"];
    
    SKProduct *product = self.products[self.selectedIndex];
    
    
    
    //创建支付对象 product为用户选择的商品的SKProduct对象
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    
    //设置购买数量
    payment.quantity = 1;
    
    //可记录一个字符串，用于帮助苹果检测不规则支付活动
    //payment.applicationUsername = [self encryptionString:userName];
    
    //将支付加入支付队列
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    
    
    
//    [[ZKService sharedService] generateWXQrcodeWithAmount:self.chargeArray[self.selectedIndex] success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        if ([[responseObject objectOrNilForKey:@"status"] intValue] == 1) {
//            //code_url, order_id
//            NSString *url = [[responseObject objectOrNilForKey:@"data"] objectOrNilForKey:@"code_url"];
//            self.orderID = [[responseObject objectOrNilForKey:@"data"] objectOrNilForKey:@"order_id"];
//
//            ZKWechatPayViewController *controller = [[ZKWechatPayViewController alloc] init];
//            controller.amount = self.chargeArray[self.selectedIndex];
//            controller.codeURL = url;
//            controller.orderID = self.orderID;
//            [self presentViewControllerAsSheet:controller];
//
//        }
//        else{
//            [self showAlertWithText:[responseObject objectOrNilForKey:@"msg"]];
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        [self showAlertWithText:error.localizedDescription];
//    }];
    
}

-(IBAction)paymentButtonClicked:(id)sender{
    
    NSButton *button = sender;
    self.payIndex = button.tag;
    self.payhighlightView.frame = button.frame;
    
}

-(void)selectFirst{
    [self collectionView:self.chargeCollection didSelectItemsAtIndexPaths:[NSSet setWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
}

-(void)viewDidAppear{
    
    [super viewDidAppear];
    
    
    [self paymentButtonClicked:self.wechatButton];
}


- (void)controlTextDidBeginEditing:(NSNotification *)obj{
    
    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section API_AVAILABLE(macos(10.11)){
    
    return self.products.count;
}


- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(macos(10.11)){
    

    ZKChargeItem *item = [collectionView makeItemWithIdentifier:@"ZKChargeItem" forIndexPath:indexPath];
    
    SKProduct *product = [self.products objectAtIndex:indexPath.item];
    NSString *countString = [product.productIdentifier stringByReplacingOccurrencesOfString:@"com.zkbody.energy" withString:@""];
    NSInteger energyCount = [countString integerValue];
    
    
    if (energyCount<=0) {
        self.inputChargeItem = item;
        item.countField.cell.editable = NO;
        item.countField.delegate = self;
        NSString *inputCount = @"填写个数";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:inputCount];
        
        [attributedString setAttributes:@{
                NSFontAttributeName : [NSFont systemFontOfSize:30.0f],
                                              NSForegroundColorAttributeName : [NSColor lightGrayColor],
                                              } range:NSMakeRange(0, inputCount.length)];
        
        [attributedString setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, inputCount.length)];
        
        item.countField.placeholderAttributedString = attributedString;
        
        
    }
    else{
        NSString *unit = @"个";
        NSString *count = [NSString stringWithFormat:@"%@", @(energyCount)];
        NSString *finalString = [NSString stringWithFormat:@"%@%@%@", unit,count,unit];
         
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
        
        [attributedString setAttributes:@{
                NSFontAttributeName : [NSFont systemFontOfSize:14.0f],
                                              NSForegroundColorAttributeName : [NSColor clearColor],
                                              } range:NSMakeRange(0, unit.length)];
           
         [attributedString setAttributes: @{
                                            NSFontAttributeName : [NSFont boldSystemFontOfSize:48.0f],
                                            NSForegroundColorAttributeName : [self isDarkMode]?[NSColor whiteColor]:[NSColor colorFromHexString:@"#FF333333"],
                                            }
                                   range:NSMakeRange(unit.length, count.length)];
         [attributedString setAttributes:@{
             NSFontAttributeName : [NSFont systemFontOfSize:14.0f],
                                           NSForegroundColorAttributeName : [self isDarkMode]?[NSColor whiteColor]:[NSColor colorFromHexString:@"#FF333333"],
                                           } range:NSMakeRange(count.length+unit.length, unit.length)];
        [attributedString setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, finalString.length)];
         
        item.countField.attributedStringValue = attributedString;
    }
    
    
    
    
    item.moneyField.stringValue = [NSString stringWithFormat:@"%@ %@", product.price, product.priceLocale.currencySymbol];
    
    
    return item;
}


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPath{

    NSIndexPath *path = [indexPath anyObject];
    
    self.selectedIndex = path.item;
    
    ZKChargeItem *item = [collectionView makeItemWithIdentifier:@"ZKChargeItem" forIndexPath:path];
    [item setHighlightState:NSCollectionViewItemHighlightForSelection];
    
    self.highlightView.hidden = NO;
    self.highlightView.frame = item.view.frame;
    SKProduct *product = [self.products objectAtIndex:path.item];
    [self addEvent:[NSString stringWithFormat:@"选择%@%@", product.price, product.priceLocale.currencySymbol]];
    
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths API_AVAILABLE(macos(10.11)){
}



@end
