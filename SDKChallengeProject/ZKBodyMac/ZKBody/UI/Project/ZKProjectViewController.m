//
//  ZKProjectViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKProjectViewController.h"
#import "ZKDroneViewController.h"
#import "ZKImageSelectItem.h"
#import "ZKMicroscopeViewController.h"
#import "ZKLoginViewController.h"

@interface ZKProjectViewController () <NSTableViewDelegate, NSTableViewDataSource, NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (nonatomic, strong) NSNumber *playTime;
@property (nonatomic, strong) NSDictionary *order;

@end

@implementation ZKProjectViewController


-(void)viewWillAppear{
    [super viewWillAppear];
    [self refreshQueue];
    [self refreshDeviceList];
}

-(void)viewWillDisappear{
    [super viewWillDisappear];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)refreshDeviceList{
    
    [[ZKService sharedService] getDeviceListWithType:nil pageNum:@(1) pageSize:@(20) keyword:nil projectID:self.project.modelID success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
                  
            self.dataArray = responseObject[@"data"][@"list"];
            
                   [self.tableView reloadData];
               }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

-(IBAction)segmentClicked:(NSSegmentedControl*)sender{

    NSArray *durationArray = [self.project.durations componentsSeparatedByString:@","];
    
    self.playTime = @([durationArray[sender.selectedSegment] intValue]*60);
    
    [self addEvent:[NSString stringWithFormat:@"选择时长%@分钟", durationArray[sender.selectedSegment]]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self refreshProject];
    
    self.imageCollection.dataSource = self;
    self.imageCollection.delegate = self;
    
   
    self.line.wantsLayer = YES;
    self.line.layer.backgroundColor = [NSColor colorFromHexString:@"#E2E2E2"].CGColor;
    
    self.descriptionField.maximumNumberOfLines = 8;
    
    self.showImageView.wantsLayer = YES;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:2.0f];
    [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadow setShadowColor:[NSColor lightGrayColor]];

    [_showImageView setShadow:shadow];

    
    [self updateInfo];

    [self.scrollView.contentView scrollToPoint:NSMakePoint(0, 800)];
    
    if ([self.project.projectTypeID intValue] == 1) {
        [self.playButton setTitle:@"飞行"];
        self.segmentField.stringValue = @"驾驶时间:";
    }
    else{
        self.segmentField.stringValue = @"观测时间:";
    }
    
    NSString *durations = self.project.durations;
    NSArray *durationArray = [durations componentsSeparatedByString:@","];
    
    if (durationArray.count>0) {
        [self.segmentControl setSegmentCount:durationArray.count];
        
        for (int i=0; i<durationArray.count; i++) {
            [self.segmentControl setLabel:[NSString stringWithFormat:@"%@分钟",durationArray[i]] forSegment:i];
            if ([durationArray[i] intValue] == 5) {
                [self.segmentControl selectSegmentWithTag:i];
            }
        }
        
    }
    
    self.playTime = @(300);
    
    
    self.highlightView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 68, 46)];
       [self.imageCollection addSubview:self.highlightView];
       _highlightView.wantsLayer = YES;
       _highlightView.layer.borderWidth = 1.5;
       _highlightView.layer.borderColor = [NSColor colorFromHexString:@"#007EFF"].CGColor;
       
    
    [self collectionView:self.imageCollection didSelectItemsAtIndexPaths:[NSSet setWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
//
   
}

-(void)updateInfo{
    
    self.nameField.stringValue = self.project.name;
    self.descriptionField.stringValue = self.project.projectDescription;
    self.descriptionView.string = self.project.projectDescription;
    
    [self.showImageView downloadImageFromURL:self.project.images[0] withPlaceholderImage:[NSImage imageNamed:@"image_placeholder"]];
    
    NSString *kongxian = @"收费标准:   ";
    NSString *deviceCount = [NSString stringWithFormat:@"%@能量块/分钟", @([self.project.chargeStandard floatValue])];
    NSString *finalString = [kongxian stringByAppendingString:deviceCount];
     
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
     [attributedString setAttributes: @{
                                        NSFontAttributeName : [NSFont boldSystemFontOfSize:12.0f],
                                        NSForegroundColorAttributeName : [self isDarkMode]?[NSColor whiteColor] : [NSColor colorFromHexString:@"#FF333333"],
                                        }
                               range:NSMakeRange(0, kongxian.length)];
     [attributedString setAttributes:@{
         NSFontAttributeName : [NSFont systemFontOfSize:12.0f],
         NSForegroundColorAttributeName : [self isDarkMode]?[NSColor whiteColor] : [NSColor grayColor],
                                       } range:NSMakeRange(kongxian.length, deviceCount.length)];
    
     self.chargeField.attributedStringValue = attributedString;
    
    
    
}

-(void)refreshProject{
    
    [[ZKService sharedService] getProjectDetailWithID:self.project.modelID success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            self.project = [ZKModelProject modelFromDic:responseObject[@"data"]];
            
            [self updateInfo];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
-(void)refreshQueue{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(refreshQueue) withObject:nil afterDelay:5.0];
    
    [[ZKService sharedService] getQueueWithProjectID:self.project.modelID success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            
//            self.queueField.stringValue = [NSString stringWithFormat:@"*当前%@人观测中，排队%@人", responseObject[@"data"][@"observe"], responseObject[@"data"][@"queue"]];
            
            self.queueField.stringValue = [NSString stringWithFormat:@"*当前排队%@人", responseObject[@"data"][@"queue"]];

            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

-(void)loginButtonClicked:(id)sender{
    ZKLoginViewController *loginViewController = [[ZKLoginViewController alloc] init];
    [self presentViewControllerAsSheet:loginViewController];
    
    [self addEvent:@"点击首页登录按钮"];
    
}

-(IBAction)playButtonClicked:(id)sender{
    
    [self addEvent:@"Play按钮点击"];
    
    if ([self.project.projectTypeID intValue] != 1 && [self.project.projectTypeID intValue] != 3) {
        
        [self showAlertWithText:@"暂不支持"];
        
        return;
    }
    
    
//    if ([ZKService sharedService].token) {
//   
//    }else{
//        [self loginButtonClicked:nil];
//        return;
//    }
    
    
    
    
    [[ZKService sharedService] playWithProjectID:self.project.modelID projectName:self.project.name totalTime:self.playTime amount:@(self.playTime.intValue/60*self.project.chargeStandard.floatValue) success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            self.order = responseObject[@"data"];
            NSLog(@"%@", self.order);
            if ([self.project.projectTypeID intValue] == 1) {
                   ZKDroneViewController *player = [[ZKDroneViewController alloc] init];
                   player.order = self.order;
                   [self.navigationController pushViewController:player animated:YES];
            }
            else if ([self.project.projectTypeID intValue] == 3) {
                   ZKMicroscopeViewController *player = [[ZKMicroscopeViewController alloc] init];
                   player.order = self.order;
                   [self.navigationController pushViewController:player animated:YES];
            }
        }
        else{
            
            
            
            [self showAlertWithText:responseObject[@"msg"] completionHandler:^(NSModalResponse returnCode) {
                
                if ([responseObject[@"errorcode"] intValue] == 1001) {
                       [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://body.zkong.me"]];
                }
                else if ([responseObject[@"errorcode"] intValue] == 1002) {
                    
                }
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertWithText:error.localizedDescription];
    }];
    
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return [self dataArray].count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 58;
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
       
       if ([dic objectOrNilForKey:identifier]) {
           [textCell setStringValue:[NSString stringWithFormat:@"%@", [dic objectForKey:identifier]]];
       }
       else{
           [textCell setStringValue:@""];
       }
       
   }


    return view;
}


- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section API_AVAILABLE(macos(10.11)){
    
    return self.project.images.count;
}


- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(macos(10.11)){
    

    ZKImageSelectItem *item = [collectionView makeItemWithIdentifier:@"ZKImageSelectItem" forIndexPath:indexPath];
    
    NSString *image = [self.project.images objectAtIndex:indexPath.item];
    item.icon.imageScaling = NSImageScaleAxesIndependently;
    [item.icon downloadImageFromURL:image withPlaceholderImage:[NSImage imageNamed:@"image_placeholder"]];
    
    return item;
}


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPath{
    
    NSIndexPath *path = [indexPath anyObject];
    ZKImageSelectItem *item = [collectionView makeItemWithIdentifier:@"ZKImageSelectItem" forIndexPath:path];
    [item setHighlightState:NSCollectionViewItemHighlightForSelection];
    
    self.highlightView.frame = item.view.frame;
    
    NSString *image = [self.project.images objectAtIndex:path.item];

    [self.showImageView downloadImageFromURL:image withPlaceholderImage:[NSImage imageNamed:@"image_placeholder"]];
    
}


@end
