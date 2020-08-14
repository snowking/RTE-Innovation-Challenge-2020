//
//  ViewController.m
//  ZKBody
//
//  Created by King on 2019/9/25.
//  Copyright © 2019 King. All rights reserved.
//

#import "ViewController.h"




#import "ZKNavigationBar.h"
#import "ZKLoginViewController.h"

#import "ZKHomeViewController.h"
#import "ZKProjectsListViewController.h"
#import "ZKSystemViewController.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface ViewController ()

@property (nonatomic, strong) NSView *welcomeView;
@property (nonatomic, strong) ZKNavigationBar *navigationBar;
@property (nonatomic, strong) ZKNavigationController *playNavigationController;

@property (nonatomic, strong) NSView *contentView;

@property (nonatomic, strong) ZKSystemViewController *systemViewController;
@property (nonatomic, strong) ZKNavigationController *systemNavigationController;

@end

@implementation ViewController


-(NSView*)welcomeView{
    if (!_welcomeView) {
        _welcomeView = [[NSView alloc] initWithFrame:self.view.bounds];
        _welcomeView.wantsLayer = YES;
        _welcomeView.layer.backgroundColor = [NSColor colorFromHexString:@"#FF1D1E1F"].CGColor;
        
        NSImage *logo = [NSImage imageNamed:@"zklogo"];
        NSImageView *logoView = [[NSImageView alloc] initWithFrame:NSMakeRect(CGRectGetMidX(self.view.bounds)-logo.size.width/2, CGRectGetMidY(self.view.bounds)-logo.size.height/2, logo.size.width, logo.size.height)];
        logoView.image = logo;
        [_welcomeView addSubview:logoView];
    }
    return _welcomeView;
}

-(NSView*)contentView{
    
    if (!_contentView) {
        _contentView = [[NSView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_contentView];
    }

    return _contentView;
    
}


-(ZKNavigationBar*)navigationBar{
    
    if (!_navigationBar) {
        
        CGFloat barHeight = 40.0;
        
        CGFloat y = CGRectGetMaxY(self.view.bounds)-barHeight;
        
        if (![NSApp respondsToSelector:@selector(effectiveAppearance)]) {
            y -= 20;
        }
        
        _navigationBar = [[ZKNavigationBar alloc] initWithFrame:NSMakeRect(0, y, CGRectGetMaxX(self.view.bounds), barHeight)];
        
        _navigationBar.viewController = self;
    }
    return _navigationBar;
}

-(instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)loginButtonClicked:(id)sender{
    ZKLoginViewController *loginViewController = [[ZKLoginViewController alloc] init];
    [self presentViewControllerAsSheet:loginViewController];
    
    [self addEvent:@"点击首页登录按钮"];
    
}

-(void)doGoHomePage{
    [self.playNavigationController popToRootViewControllerAnimated:YES];
    [self.contentView addSubview:self.playNavigationController.view];
    if (_systemNavigationController) {
        [self.systemNavigationController.view removeFromSuperview];
    }
    [self addEvent:@"点击Home按钮"];
}
-(void)doGoSystemPage{
    [self.playNavigationController.view removeFromSuperview];
    
    [self.systemNavigationController popToRootViewControllerAnimated:YES];
    [self.contentView addSubview:self.systemNavigationController.view];
    
    [self addEvent:@"点击系统设置按钮"];
    
}

-(void)playingCheckWithAction:(SEL)action{
    
    if ([ZKService sharedService].playing) {
    
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"提示";
        alert.informativeText = @"确定退出当前页面?";
        alert.icon = [NSImage imageNamed:@"icon_alert"];
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:^(NSModalResponse returnCode) {
   
            if (returnCode == 1001) {
                SuppressPerformSelectorLeakWarning(
                [self performSelector:action];
                                                   );
            }
        }];
    }
    else{
        SuppressPerformSelectorLeakWarning(
        [self performSelector:action];
                                           );
    }
    
    
}

-(void)homeButtonClicked:(id)sender{
    
    [self playingCheckWithAction:@selector(doGoHomePage)];
    
}
-(void)systemButtonClicked:(id)sender{
    
    [self playingCheckWithAction:@selector(doGoSystemPage)];
    
}

-(void)logoutButtonClicked:(id)sender{
    
    NSAlert *alert = [[NSAlert alloc] init];
         alert.messageText = @"提示";
         alert.informativeText = @"确定登出?";
         alert.icon = [NSImage imageNamed:@"icon_alert"];
         [alert addButtonWithTitle:@"取消"];
         [alert addButtonWithTitle:@"确定"];
         [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:^(NSModalResponse returnCode) {
    
             if (returnCode == 1001) {
                   [self addEvent:@"点击登出按钮"];
                   [self homeButtonClicked:nil];
                   [[ZKService sharedService] cleanUser];
             }
         }];
  
}

-(void)didChooseProjectsIndex:(NSInteger)index{
    
    [self addEvent:index==0?@"点击无人机":(index==1?@"点击显微镜":@"点击天文望远镜")];
    if ([ZKService sharedService].token) {
        ZKProjectsListViewController *projectList = [[ZKProjectsListViewController alloc] init];
        [self.playNavigationController pushViewController:projectList animated:YES];
        [projectList refreshWithType:index];
    }else{
        [self loginButtonClicked:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    
    [self contentView];
    [self.view addSubview:self.welcomeView];
    
    NSDictionary *user = [[ZKService sharedService] getUsernameAndPassword];
    if (user) {
        
        NSString *phone = user[@"username"];
        NSString *password = user[@"password"];
        [[ZKService sharedService] loginWithUsername:phone password:password success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"status"] intValue] == 1) {
                [[ZKService sharedService] setToken:responseObject[@"token"]];
                [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
            else{
                
            }
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        
    }
    else{
        
    }
    
    [self performSelector:@selector(showHomeView) withObject:nil afterDelay:1.0];
    
}

-(ZKNavigationController*)playNavigationController{
    
    if (!_playNavigationController) {
        
        ZKHomeViewController *home = [[ZKHomeViewController alloc] init];
        home.root = self;
        
        _playNavigationController = [[ZKNavigationController alloc] initWithRootViewController:home];
        _playNavigationController.navigationBar = self.navigationBar;
        
        
    }
    return _playNavigationController;
}

-(ZKNavigationController*)systemNavigationController{
    
    if (!_systemNavigationController) {
        ZKSystemViewController *system = [[ZKSystemViewController alloc] init];
        system.root = self;
        _systemNavigationController = [[ZKNavigationController alloc] initWithRootViewController:system];
        _systemNavigationController.navigationBar = self.navigationBar;
        
    }
    
    return _systemNavigationController;
}

-(void)showHomeView{
    
    [self.welcomeView removeFromSuperview];
    self.welcomeView = nil;
    
    [self.view addSubview:self.navigationBar];
    
    [self.contentView addSubview:self.playNavigationController.view];
    
    [self.navigationBar updateBar];
    
    
    
}




-(void)showPlayView{
    
  
    
}




- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
