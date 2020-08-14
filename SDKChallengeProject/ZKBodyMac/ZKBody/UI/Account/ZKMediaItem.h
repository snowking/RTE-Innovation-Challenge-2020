//
//  ZKMediaItem.h
//  ZKBody
//
//  Created by King on 2020/2/26.
//  Copyright © 2020 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PVAsyncImageView.h"


@interface ZKMediaItem : NSCollectionViewItem

@property (nonatomic, strong) IBOutlet PVAsyncImageView *icon;
@property (nonatomic, strong) IBOutlet NSImageView *playView;

@end

