//
//  ZKPlayViewController.m
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKPlayViewController.h"
#import "ZKWaitViewController.h"


@interface ZKPlayViewController ()

@end

@implementation ZKPlayViewController

-(void)viewWillLayout{
    [super viewWillLayout];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorFromHexString:@"#FF444444"].CGColor;
    
    [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:nil];
}


-(void)loginWithUser:(NSString*)user{
    
    NSString *appid = @"ae7ed3528af64854984c48c0fd7e30fc";
    self.rtmKit = [[AgoraRtmKit alloc] initWithAppId:appid delegate:self];
    [self.rtmKit loginByToken:nil user:user completion:^(AgoraRtmLoginErrorCode errorCode) {
        
        [[ZKService sharedService] updateOrderWithID:self.order[@"id"] status:@(1) usedTime:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            ZKWaitViewController *wait = [[ZKWaitViewController alloc] init];
               wait.order = self.order;
               [self presentViewControllerAsSheet:wait];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
}

-(void)loginWithChannel:(NSString*)channel{
    
    for (NSViewController *controller in self.presentedViewControllers) {
        [self dismissViewController:controller];
    }
    
    NSString *appid = @"ae7ed3528af64854984c48c0fd7e30fc";
     
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
    [self.agoraKit disableAudio];
    [self.agoraKit enableVideo];
    
    [self.agoraKit enableLocalAudio:NO];
    [self.agoraKit enableLocalVideo:NO];
    
    [self.agoraKit joinChannelByToken:nil channelId:channel info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
   
    self.channel = [self.rtmKit createChannelWithId:channel delegate:self];
    [self.channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
    }];
   
}

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId{
    
    if ([peerId isEqualToString:@"body"]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[message.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
        
        self.bodyName = dic[@"rtmPeerId"];
        self.deviceID = dic[@"deviceId"];
        
        NSString *channel = dic[@"rtcChannel"];
        if (!channel || [channel length]<=0) {
            [[ZKService sharedService] sendMessageToKing:@"获取Channel异常"];
        }
        self.bodyChannel = channel;
        [self loginWithChannel:channel];
        
        [[ZKService sharedService] setPlaying:YES];
        
        [[ZKService sharedService] updateOrderWithID:self.order[@"id"] status:@(2) usedTime:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

-(void)sendMessage:(NSString*)message{
    
    if (!message || [message length]<=0) {
        return;
    }
    AgoraRtmMessage *agoraMessage = [[AgoraRtmMessage alloc] initWithText:message];
    [self.channel sendMessage:agoraMessage completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        
    }];
}

-(void)viewWillAppear{
    [super viewWillAppear];
    
}

-(void)logout{
    
    self.channel.channelDelegate = nil;
       [self.channel leaveWithCompletion:nil];
       
       [self.agoraKit leaveChannel:nil];
       [self.rtmKit logoutWithCompletion:nil];
}

-(void)viewDidDisappear{
    [super viewDidDisappear];
   
}

-(void)viewWillDisappear{
    [super viewWillDisappear];
    
    [[ZKService sharedService] setPlaying:NO];
    
    [[ZKService sharedService] updateOrderWithID:self.order[@"id"] status:@(10) usedTime:self.order[@"totalTime"] success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [[ZKService sharedService] getMemberInfoWithSuccess:nil failure:nil];
    
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZKBodyTerminate" object:nil];
    
}
-(void)terminateApp{
        
    [self viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
    self.photoImage = [NSImage imageNamed:@"icon_shoot"];
    self.videoStartImage = [NSImage imageNamed:@"icon_videoStart"];
    self.videoStopImage = [NSImage imageNamed:@"icon_videoStop"];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminateApp) name:@"ZKBodyTerminate" object:nil];
    
    self.remoteVideo = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 1000, 550)];
    self.remoteVideo.wantsLayer = YES;
    [self.view addSubview:self.remoteVideo];
    
    self.remoteVideo.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    
    
    [self configBodyStateView];
    
    [self loginWithUser:[ZKService sharedService].user.phone];
    
}

-(void)fieldInit:(NSTextField*)field{
    field.drawsBackground = YES;
    field.backgroundColor = [NSColor clearColor];
    field.bordered = NO;
    field.enabled = NO;
}

-(void)configBodyStateView{
    
    CGFloat height = 35;
    
    self.bodyStateView = [[NSView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-height-50, 130, height)];
    
    [self.view addSubview:_bodyStateView];
    NSView *effectView = [[NSView alloc] initWithFrame:self.bodyStateView.bounds];
    effectView.wantsLayer = YES;
    effectView.layer.backgroundColor = [NSColor blackColor].CGColor;
    effectView.alphaValue = 0.2;
    [self.bodyStateView addSubview:effectView];
    
    self.bodyStateField = [[NSTextField alloc] initWithFrame:CGRectMake(5, 1, 120, height-5)];
    [self fieldInit:_bodyStateField];
    [self.bodyStateView addSubview:self.bodyStateField];
    self.bodyStateField.stringValue = @"正在初始化";
    
    self.bodyStateField.textColor = [NSColor whiteColor];
    self.bodyStateField.font = [NSFont systemFontOfSize:10];
}

@end
