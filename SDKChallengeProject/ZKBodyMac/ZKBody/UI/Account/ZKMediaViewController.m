//
//  ZKMediaViewController.m
//  ZKBody
//
//  Created by King on 2020/2/26.
//  Copyright © 2020 King. All rights reserved.
//

#import "ZKMediaViewController.h"
#import "ZKMediaItem.h"

@interface ZKMediaViewController ()<NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (nonatomic, strong) IBOutlet NSCollectionView *collectionView;

@end

@implementation ZKMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    if (!self.mediaArray) {
        
        self.mediaArray = [NSMutableArray array];
        
        [[ZKService sharedService] getMediaListWithpageNum:nil pageSize:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([[responseObject objectOrNilForKey:@"status"] intValue] == 1) {
                
                 NSArray *array = responseObject[@"data"];
                 for (NSDictionary *mediaDic in array) {
                     NSArray *photArray = [mediaDic objectOrNilForKey:@"photo"];
                     if ([photArray isKindOfClass:[NSArray class]] && [photArray count]>0) {
                         
                         for (NSString *obj in photArray) {
                             if (![obj isEqualToString:@"null"]) {
                                 [self.mediaArray addObject:obj];
                             }
                             
                         }
                         
                         
                     }
                     
                     NSArray *videoArray = [mediaDic objectOrNilForKey:@"video"];
                     if ([videoArray isKindOfClass:[NSArray class]] && [videoArray count]>0) {
                         for (NSString *obj in videoArray) {
                             if (![obj isEqualToString:@"null"]) {
                                 [self.mediaArray addObject:obj];
                             }
                             
                         }
                     }
                     
                 }
                          
                [self.collectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        
        
    }
    
    
}


- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section API_AVAILABLE(macos(10.11)){
    
    return self.mediaArray.count;
}


- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(macos(10.11)){
    

    ZKMediaItem *item = [collectionView makeItemWithIdentifier:@"ZKMediaItem" forIndexPath:indexPath];

    NSString *url = [self.mediaArray objectAtIndex:indexPath.item];
    
    NSString *mediaURL = nil;
    
    if ([url containsString:@".mp4"]) {
        
        item.playView.hidden = NO;
        
        mediaURL = [url stringByAppendingFormat:@"?x-oss-process=video/snapshot,t_0,f_jpg,w_%@,h_%@,m_fast", @(item.icon.frame.size.width*2), @(0)];
    }
    else{
        mediaURL = [url stringByAppendingFormat:@"?x-oss-process=image/resize,l_%@", @(item.icon.frame.size.width*2)];
        item.playView.hidden = YES;
    }
    
    item.icon.imageScaling = NSImageScaleAxesIndependently;
    [item.icon downloadImageFromURL:mediaURL withPlaceholderImage:[NSImage imageNamed:@"image_placeholder"]];

    
    return item;
}


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPath{
    
    NSIndexPath *path = [indexPath anyObject];
    NSString *mediaURL = [self.mediaArray objectAtIndex:path.item];
    
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mediaURL]];
    
}


@end
