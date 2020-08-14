//
//  ZKHomeViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKHomeViewController.h"
#import "ViewController.h"

@interface ZKHomeViewController ()

@end

@implementation ZKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;

    PVAsyncImageView *imageView = [[PVAsyncImageView alloc] initWithFrame:self.view.bounds];
    imageView.imageScaling = NSImageScaleAxesIndependently;
    [self.view addSubview:imageView];
    [imageView downloadImageFromURL:@"http://shareskong.oss-cn-shanghai.aliyuncs.com/userstmp/5efzXjtxrlIy9lA9EvYpghr3ZwJXy6i8rp6qpJgp.png"];
    
    [self addTitle:@"无人机" icon:@"icon_drone" index:0];
    [self addTitle:@"显微镜" icon:@"icon_microscope" index:1];
    [self addTitle:@"天文望远镜" icon:@"icon_telescope" index:2];
    
    
}

-(void)buttonClicked:(id)sender{
    
    NSButton *button = sender;
    
    [self.root didChooseProjectsIndex:button.tag];
}

-(void)addTitle:(NSString*)title icon:(NSString*)imageName index:(NSInteger)index{
    
    NSButton *back = [NSButton buttonWithImage:[NSImage imageNamed:imageName] target:self action:@selector(buttonClicked:)];
    back.tag = index;
    back.frame = NSMakeRect(120+270*index, 109, 220, 342);
    back.wantsLayer = YES;
    back.bordered = NO;
    back.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.view addSubview:back];
    
    NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 50, back.frame.size.width, 26)];
    [back addSubview:titleField];
    titleField.stringValue = title;
    titleField.drawsBackground = YES;
    titleField.backgroundColor = [NSColor clearColor];
    titleField.bordered = NO;
    titleField.enabled = NO;
    titleField.alignment = NSTextAlignmentCenter;

    titleField.font = [NSFont systemFontOfSize:18];
    titleField.textColor = [NSColor colorFromHexString:@"#434343"];
    
    
    NSButton *borderButton = [NSButton buttonWithTitle:[NSString stringWithFormat:@"点击操控%@",title] target:self action:@selector(buttonClicked:)];
    borderButton.tag = index;
    if (@available(macOS 10.14, *)) {
        [borderButton setContentTintColor:[NSColor colorFromHexString:@"#999999"]];
    } else {
        // Fallback on earlier versions
    }
    borderButton.frame = NSMakeRect(35, 256, 150, 36);
    borderButton.bezelStyle = NSBezelStyleTexturedRounded;
    [back addSubview:borderButton];
    borderButton.bordered = NO;
    borderButton.wantsLayer = YES;
    borderButton.layer.borderWidth = 0.5;
    borderButton.layer.cornerRadius = 18;
    borderButton.layer.borderColor = [NSColor lightGrayColor].CGColor;
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
       [shadow setShadowBlurRadius:1.0f];
       [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
       [shadow setShadowColor:[NSColor darkGrayColor]];
       [back setShadow:shadow];
    
}

@end
