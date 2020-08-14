//
//  ZKNavigationBar.m
//  ZKBody
//
//  Created by King on 2019/11/22.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKNavigationBar.h"
#import "ZKService.h"


@interface ZKNavigationBar ()

@property (nonatomic, strong) NSButton *loginButton;

@property (nonatomic, strong) NSView *menuButtonView;
@property (nonatomic, strong) NSButton *energyButton;

@end


@implementation ZKNavigationBar


-(instancetype)initWithFrame:(NSRect)frameRect{
    
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        
        NSVisualEffectView *visual = [[NSVisualEffectView alloc] initWithFrame:NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)];
        visual.blendingMode = NSVisualEffectBlendingModeWithinWindow;
        [self addSubview:visual];
        
        
        self.backButtonContainer = [[NSView alloc] initWithFrame:NSMakeRect(80, 0, 100, frameRect.size.height)];
        [self addSubview:self.backButtonContainer];
        
        [[ZKService sharedService] addObserver:self forKeyPath:@"user" options:NSKeyValueObservingOptionNew context:nil];
        
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self updateBar];
}

//实际方法调用都是在ViewController那边，这里纯粹定义消除警告用
-(void)loginButtonClicked:(id)sender{
}
-(void)homeButtonClicked:(id)sender{
}
-(void)systemButtonClicked:(id)sender{
}
-(void)logoutButtonClicked:(id)sender{
}

-(NSButton*)loginButton{
    
    
    if (!_loginButton) {
        _loginButton = [NSButton buttonWithTitle:@"登录BODY" target:self.viewController action:@selector(loginButtonClicked:)];
        
        _loginButton.frame = NSMakeRect(CGRectGetMaxX(self.frame)-85-40, 6, 95, 24);
        _loginButton.bordered = NO;
        _loginButton.wantsLayer = YES;
        _loginButton.layer.borderWidth = 1.0;
        _loginButton.layer.cornerRadius = 12;
        _loginButton.layer.borderColor = [NSColor whiteColor].CGColor;
        if (@available(macOS 10.14, *)) {
            _loginButton.contentTintColor = [NSColor whiteColor];
        } else {
            // Fallback on earlier versions
        }
        _loginButton.font = [NSFont systemFontOfSize:12];

    }
    
    
    return _loginButton;
}

-(NSView *)menuButtonView{
    
    if (!_menuButtonView) {
        
        _menuButtonView = [[NSView alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(self.frame)-220, 0, 220, self.frame.size.height)];
        
        NSButton *button = [NSButton buttonWithImage:[NSImage imageNamed:@"icon_home"] target:self.viewController action:@selector(homeButtonClicked:)];
        [_menuButtonView addSubview:button];
        button.frame = NSMakeRect(0, 6, 40, 24);
        button.bordered = NO;
        
        button = [NSButton buttonWithTitle:[NSString stringWithFormat:@"%.1f", [ZKService sharedService].user.energyAmount.floatValue] image:[NSImage imageNamed:@"icon_energy"] target:self.viewController action:@selector(systemButtonClicked:)];
        [_menuButtonView addSubview:button];
        button.frame = NSMakeRect(50, 6, 80, 24);
        self.energyButton = button;
        button.bordered = NO;
        
        button = [NSButton buttonWithImage:[NSImage imageNamed:@"icon_logout"] target:self.viewController action:@selector(logoutButtonClicked:)];
        [_menuButtonView addSubview:button];
        button.frame = NSMakeRect(140, 6, 40, 24);
        button.bordered = NO;
        
        
    }

    return _menuButtonView;
}

-(void)updateBar{
    
    if ([ZKService sharedService].token) {
        //已经登录
        if (_loginButton) {
            [self.loginButton removeFromSuperview];
            self.loginButton = nil;
        }
        [self addSubview:self.menuButtonView];
        [self.energyButton setTitle:[NSString stringWithFormat:@"%.1f", [ZKService sharedService].user.energyAmount.floatValue]];
        
    }
    else{
        //未登录
        if (_menuButtonView) {
            [self.menuButtonView removeFromSuperview];
            self.menuButtonView = nil;
        }
        
        [self addSubview:self.loginButton];
        
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
