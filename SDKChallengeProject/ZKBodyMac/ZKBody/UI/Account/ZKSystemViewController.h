//
//  ZKSystemViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKViewController.h"

@class ViewController;
@interface ZKSystemViewController : ZKViewController

@property (nonatomic, weak) ViewController *root;

@property (nonatomic, strong) IBOutlet NSTextField *phoneField;
@property (nonatomic, strong) IBOutlet NSTextField *energyField;

@property (nonatomic, strong) IBOutlet NSView *line;

@property (nonatomic, strong) IBOutlet NSView *closeView;


@property (nonatomic, strong) IBOutlet NSTextField *inviteCodeField;
@property (nonatomic, strong) IBOutlet NSTextField *versionInfo;


-(IBAction)chargeButtonClicked:(id)sender;
-(IBAction)chargeListButtonClicked:(id)sender;
-(IBAction)playListButtonClicked:(id)sender;

-(IBAction)mediaButtonClicked:(id)sender;

@end

