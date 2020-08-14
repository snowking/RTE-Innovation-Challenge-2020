//
//  ZKPlayHistoryViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/23.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"



@interface ZKPlayHistoryViewController : ZKViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) IBOutlet NSTableView *tableView;

@end


