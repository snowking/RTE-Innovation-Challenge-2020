//
//  ZKWaitViewController.m
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKWaitViewController.h"

@interface ZKWaitViewController ()

@end

@implementation ZKWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.indicator startAnimation:nil];
    [self refreshQueue];
}

-(IBAction)cancelButtonClicked:(id)sender{
    
    
    [[ZKService sharedService] updateOrderWithID:self.order[@"id"] status:@(-1) usedTime:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [self dismissController:nil];
}

-(void)refreshQueue{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(refreshQueue) withObject:nil afterDelay:5.0];

    [[ZKService sharedService] getQueueWithProjectID:self.order[@"projectId"] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            self.waitField.stringValue = [NSString stringWithFormat:@"当前%@人观测中，排队%@人", responseObject[@"data"][@"observe"], responseObject[@"data"][@"queue"]];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end

