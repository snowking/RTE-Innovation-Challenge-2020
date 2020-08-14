//
//  ZKWaitViewController.h
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"



@interface ZKWaitViewController : ZKViewController

@property (nonatomic, strong) IBOutlet NSProgressIndicator *indicator;
@property (nonatomic, strong) IBOutlet NSTextField *waitField;
@property (nonatomic, strong) NSDictionary *order;

-(IBAction)cancelButtonClicked:(id)sender;

@end


