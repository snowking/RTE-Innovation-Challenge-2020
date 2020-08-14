//
//  ZKProjectsListViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKViewController.h"

@interface ZKProjectsListViewController : ZKViewController

@property (nonatomic) NSInteger projectsType;

-(void)refreshWithType:(NSInteger)type;

@end


