//
//  ZKProjectsListViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKProjectsListViewController.h"
#import "ZKProjectItem.h"
#import "ZKProjectViewController.h"

@interface ZKProjectsListViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (nonatomic, strong) IBOutlet NSCollectionView *collectionView;

@property (nonatomic, strong) NSArray *projects;

@end

@implementation ZKProjectsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
   
    
    self.projectsType = 0;


    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
}

-(void)refreshWithType:(NSInteger)type{
    
    self.projectsType = type;
    
    NSArray *typeArray =@[@(1), @(3), @(14)];
    
    [[ZKService sharedService] getProjectsWithType:typeArray[self.projectsType] pageNum:@(1) pageSize:nil keyword:nil viewType:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([responseObject[@"status"] intValue] == 1) {
            self.projects = responseObject[@"data"][@"list"];
            [self.collectionView reloadData];
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
    }];
    
    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section API_AVAILABLE(macos(10.11)){
    
    return self.projects.count;
}


- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(macos(10.11)){
    

    ZKProjectItem *item = [collectionView makeItemWithIdentifier:@"ZKProjectItem" forIndexPath:indexPath];
    
    NSDictionary *data = [self.projects objectAtIndex:indexPath.item];
    item.icon.imageScaling = NSImageScaleAxesIndependently;
    item.name.stringValue = data[@"name"];
    [item.icon downloadImageFromURL:data[@"coverUrl"] withPlaceholderImage:[NSImage imageNamed:@"image_placeholder"]];
    NSString *location = [data objectOrNilForKey:@"location"];
    if (!location) {
        location = @"";
    }
    item.location.stringValue = location;
    
    NSString *kongxian = @"空闲: ";
    NSString *deviceCount = [NSString stringWithFormat:@"%@", data[@"availableDeviceCount"]];
    NSString *finalString = [kongxian stringByAppendingString:deviceCount];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [NSFont systemFontOfSize:12.0f],
                                       NSForegroundColorAttributeName : [NSColor lightGrayColor],
                                       }
                              range:NSMakeRange(0, kongxian.length)];
    [attributedString setAttributes:@{
        NSFontAttributeName : [NSFont systemFontOfSize:12.0f],
                                      NSForegroundColorAttributeName : [NSColor colorFromHexString:@"#FF333333"],
                                      } range:NSMakeRange(kongxian.length, deviceCount.length)];
   
    
    item.device.attributedStringValue = attributedString;
    
    
    return item;
}


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPath{
    
    NSIndexPath *path = [indexPath anyObject];
    NSDictionary *data = [self.projects objectAtIndex:path.item];
    
    ZKProjectViewController *projectViewController = [[ZKProjectViewController alloc] init];
    projectViewController.project = [ZKModelProject modelFromDic:data];
    [self.navigationController pushViewController:projectViewController animated:YES];
    
    [self addEvent:[NSString stringWithFormat:@"选了%@", projectViewController.project.name]];
    
    [self.collectionView reloadData];
    
}

@end
