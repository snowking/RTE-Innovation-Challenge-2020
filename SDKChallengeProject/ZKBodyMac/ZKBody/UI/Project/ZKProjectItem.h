//
//  ZKProjectItem.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PVAsyncImageView.h"


@interface ZKProjectItem : NSCollectionViewItem

@property (nonatomic, strong) IBOutlet NSTextField *name;
@property (nonatomic, strong) IBOutlet PVAsyncImageView *icon;
@property (nonatomic, strong) IBOutlet NSTextField *device;

@property (nonatomic, strong) IBOutlet NSTextField *location;

@end

