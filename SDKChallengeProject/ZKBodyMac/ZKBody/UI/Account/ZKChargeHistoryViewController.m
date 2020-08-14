//
//  ZKChargeHistoryViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/23.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKChargeHistoryViewController.h"

@interface ZKChargeHistoryViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZKChargeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [[ZKService sharedService] getChargeListWithpageNum:@(1) pageSize:@(10) orderID:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if ([[responseObject objectOrNilForKey:@"status"] intValue] == 1) {
            self.dataArray = responseObject[@"data"][@"list"];
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
//    [[ZKService sharedService] getEnergyListWithpageNum:@(1) pageSize:@(10) keyword:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//          
//    
//           
//       } failure:^(NSURLSessionDataTask *task, NSError *error) {
//           
//       }];
    
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return [self dataArray].count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50;
}
/* View Based TableView:
 Non-bindings: This method is required if you wish to turn on the use of NSViews instead of NSCells. The implementation of this method will usually call -[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self] in order to reuse a previous view, or automatically unarchive an associated prototype view for that identifier. The -frame of the returned view is not important, and it will be automatically set by the table. 'tableColumn' will be nil if the row is a group row. Returning nil is acceptable, and a view will not be shown at that location. The view's properties should be properly set up before returning the result.
 
 Bindings: This method is optional if at least one identifier has been associated with the TableView at design time. If this method is not implemented, the table will automatically call -[self makeViewWithIdentifier:[tableColumn identifier] owner:[tableView delegate]] to attempt to reuse a previous view, or automatically unarchive an associated prototype view. If the method is implemented, the developer can setup properties that aren't using bindings.
 
 The autoresizingMask of the returned view will automatically be set to NSViewHeightSizable to resize properly on row height changes.
 */
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7){
    
    NSDictionary *dic = [[self dataArray] objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    NSTableCellView *view = [tableView makeViewWithIdentifier:identifier owner:self];
    NSTextField *textCell = nil;
    if ([identifier isEqualToString:@"action"] || [identifier isEqualToString:@"login"] || [identifier isEqualToString:@"info"]){
        
    }else{
        textCell = [[view subviews] objectAtIndex:0];
    }
    
    if (!view){
        view = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 58)];
    }
    
   if ([identifier isEqualToString:@"action"] || [identifier isEqualToString:@"login"] || [identifier isEqualToString:@"info"]){
        NSButton *button = (NSButton*)view;
        button.tag = 100+row;
   }
   else if ([identifier isEqualToString:@"index"]){
       [textCell setStringValue:[NSString stringWithFormat:@"%@", @(row+1)]];
   }
    
   else {
       
       if ([dic objectForKey:identifier]) {
           
           if ([identifier isEqualToString:@"powerAmount"]) {
               [textCell setStringValue:[NSString stringWithFormat:@"+%@", [dic objectForKey:identifier]]];
           }
           else  if ([identifier isEqualToString:@"payAmount"]) {
               [textCell setStringValue:[NSString stringWithFormat:@"¥%@", [dic objectForKey:identifier]]];
           }
           else  if ([identifier isEqualToString:@"isPaid"]) {
               [textCell setStringValue:[[dic objectForKey:identifier] intValue]==1?@"已完成":@"未支付"];
           }
           else{
               [textCell setStringValue:[NSString stringWithFormat:@"%@", [dic objectForKey:identifier]]];
           }
           
       }
       else{
           [textCell setStringValue:@""];
       }
       
   }


    return view;
}


@end
