//
//  ZKProjectViewController.h
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"



@interface ZKProjectViewController : ZKViewController

@property (nonatomic, strong) ZKModelProject *project;

@property (nonatomic, strong) IBOutlet PVAsyncImageView *showImageView;

@property (nonatomic, strong) IBOutlet NSView *line;
@property (nonatomic, strong) IBOutlet NSView *shortLine;

@property (nonatomic, strong) IBOutlet NSTextField *queueField;

@property (nonatomic, strong) IBOutlet NSTextField *descriptionField;
@property (nonatomic, strong) IBOutlet NSTextView *descriptionView;

@property (nonatomic, strong) IBOutlet NSTextField *nameField;
@property (nonatomic, strong) IBOutlet NSTextField *chargeField;

@property (nonatomic, strong) IBOutlet NSTextField *timeField;

@property (nonatomic, strong) IBOutlet NSButton *playButton;

@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSView *header;
@property (nonatomic, strong) IBOutlet NSScrollView *scrollView;

@property (nonatomic, strong) IBOutlet NSSegmentedControl *segmentControl;
@property (nonatomic, strong) IBOutlet NSTextField *segmentField;

@property (nonatomic, strong) IBOutlet NSCollectionView *imageCollection;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSView *highlightView;

-(IBAction)playButtonClicked:(id)sender;
-(IBAction)segmentClicked:(NSSegmentedControl*)sender;


@end

