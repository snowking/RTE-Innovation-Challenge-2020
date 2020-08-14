//
//  ZKMicroscopeViewController.m
//  ZKBody
//
//  Created by King on 2019/12/19.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKMicroscopeViewController.h"

@interface ZKMicroscopeViewController ()

@property (nonatomic, strong) NSView *glassesBackground;
@property (nonatomic, strong) NSView *highlightView;

@property (nonatomic) CGFloat xglassOffset;


@property (nonatomic, strong) NSView *cameraControlView;
@property (nonatomic, strong) IBOutlet NSButton *shootPhotoButton;
@property (nonatomic, strong) NSTextField *capacityField;
@property (nonatomic, strong) NSButton *switchPhotoVideoButton;
@property (nonatomic, strong) NSTextField *recordingTimeField;

@property (nonatomic) NSInteger cameraMode;
@property (nonatomic) BOOL isRecordingVideo;
@property (nonatomic) NSInteger recordingTime;

@property (nonatomic) NSInteger photoCapacity;
@property (nonatomic) NSInteger videoCapacity;

@end

@implementation ZKMicroscopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.photoCapacity = 20;
    self.videoCapacity = 60;
    
    self.controlBarEffectView.wantsLayer = YES;
    self.controlBarEffectView.layer.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    
    [self.view addSubview:self.controlBarView];
    
    NSArray *sliders = @[self.xSlider, self.ySlider, self.focalLengthSliderTiny, self.focalLengthSliderBig];
    self.sliders = sliders;
    
    for (int i=0; i<sliders.count; i++) {
        [self modifySlider:sliders[i]];
        [sliders[i] setTag:i];
    }
    
    
    [self hideSlider];
    
    self.cameraMode = 0;
    
    [self configCameraControlView];
}



-(void)hideSlider{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(realHide) object:nil];
    
    [self performSelector:@selector(realHide) withObject:nil afterDelay:5.0];
    
}

-(void)showSlider{
    for (NSSlider *slider in self.sliders) {
        slider.hidden = NO;
    }
    [self hideSlider];
}

-(void)realHide{
        
    for (NSSlider *slider in self.sliders) {
        slider.hidden = YES;
    }
}

-(void)sendMessage:(NSString*)message{
    
    if (!message || [message length]<=0) {
        return;
    }
    AgoraRtmMessage *agoraMessage = [[AgoraRtmMessage alloc] initWithText:message];
    [self.rtmKit sendMessage:agoraMessage toPeer:self.bodyName completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
        
    }];
    NSLog(@"%@", message);
}

-(IBAction)controlButtonClicked:(id)sender{
    
    NSButton *button = sender;
    if (button.tag == 4) {
        [self showAlertWithText:@"如有问题请联系微信18602195219"];
    }
    else{
        [self showSlider];
    }

}

-(void)modifySlider:(NSSlider*)slider{
    
    slider.target = self;
    slider.action = @selector(sliderChanged:);
    slider.continuous = YES;
}

-(void)sliderChanged:(NSSlider*)slider{
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now-self.timeinter > 0.1) {
        self.timeinter = now;
    }
    else{
        return;
    }
    
    NSLog(@"%@", @(slider.floatValue));
    [self sendMessage:[NSString stringWithFormat:@"z%.2f,%.2f,%0.2f,;", self.xSlider.floatValue+self.xglassOffset, self.ySlider.floatValue, self.focalLengthSliderBig.intValue+self.focalLengthSliderTiny.floatValue]];
    
    [self hideSlider];
    
}

-(void)viewWillDisappear{
    [super viewWillDisappear];

    if (self.played) {
        AgoraRtmMessage *agoraMessage = [[AgoraRtmMessage alloc] initWithText:@"quit"];
        [self.rtmKit sendMessage:agoraMessage toPeer:self.bodyName completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            [self logout];
        }];
    }
    else{
        [self logout];
    }
}

-(void)countDown{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.gameStartDate];
    
    NSString *stateMessage = @"观测中";
    
    float timeleft = [self.order[@"totalTime"] floatValue] - time;
    if (timeleft<0) {
        timeleft = 0;
    }
    stateMessage = [stateMessage stringByAppendingFormat:@"\n%.0f秒后结束", timeleft];
    
    self.bodyStateField.stringValue = stateMessage;
    
    if (time<[self.order[@"totalTime"] intValue]) {
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }
    else{//游戏时间到
        [[ZKService sharedService] sendMessageToKing:@"显微镜观测结束"];
        if ([self.navigationController topViewController] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(void)modifySwitchButtonUI{
    [self.switchPhotoVideoButton setImage:self.switchPhotoVideoButton.tag == 0?[NSImage imageNamed:@"icon_switchPhoto"]:[NSImage imageNamed:@"icon_switchVideo"]];
}

-(void)switchButtonClicked:(id)sender{
    
    if (self.switchPhotoVideoButton.tag == 0) {
        self.switchPhotoVideoButton.tag = 1;
    }
    else{
        self.switchPhotoVideoButton.tag = 0;
    }
    
    
    [self modifySwitchButtonUI];
    [self modifyShootButton];
    [self modifyCapacity];
    
}

-(void)modifyCapacity{
    
    NSUInteger mode = self.switchPhotoVideoButton.tag;
    if (mode == 0) {
       self.capacityField.stringValue = [NSString stringWithFormat:@"Capacity:%@", @(self.photoCapacity)];
    }
    else if (mode == 1) {
        self.capacityField.stringValue = [NSString stringWithFormat:@"Capacity:%@s", @(self.videoCapacity)];
    }
    
    
}


-(void)configCameraControlView{
    
    CGFloat height = 160.0;
    CGFloat totalWidth = 200.0;
    
    self.cameraControlView = [[NSView alloc] initWithFrame:NSMakeRect(NSWidth(self.view.frame)-totalWidth-10, NSHeight(self.view.frame)/2-height/2, totalWidth, height)];
    [self.view addSubview:self.cameraControlView];
    self.cameraControlView.wantsLayer = YES;
    
    CGFloat buttonWidth = 40;
    
    NSButton *button = [NSButton buttonWithImage:[NSImage imageNamed:@"icon_shoot"] target:self action:@selector(shootButtonClicked:)];
    [self.cameraControlView addSubview:button];
    button.frame = NSMakeRect(totalWidth-buttonWidth-20, height/2-buttonWidth/2, buttonWidth, buttonWidth);
    button.bordered = NO;
    
    self.shootPhotoButton = button;
    
    self.capacityField = [[NSTextField alloc] initWithFrame:NSMakeRect(button.frame.origin.x-10, button.frame.origin.y-25, buttonWidth+20, 20)];
    [self fieldInit:_capacityField];
    _capacityField.alignment = NSTextAlignmentCenter;
    [self.cameraControlView addSubview:_capacityField];
    self.capacityField.font = [NSFont boldSystemFontOfSize:6];
    self.capacityField.textColor = [NSColor whiteColor];
    
    self.recordingTimeField = [[NSTextField alloc] initWithFrame:NSMakeRect(button.frame.origin.x, NSMaxY(button.frame), buttonWidth, 10)];
    
    [self fieldInit:_recordingTimeField];
    _recordingTimeField.alignment = NSTextAlignmentCenter;
    [self.cameraControlView addSubview:_recordingTimeField];
    self.recordingTimeField.font = [NSFont boldSystemFontOfSize:6];
    self.recordingTimeField.textColor = [NSColor whiteColor];
    
    
    buttonWidth = 20;
    button = [NSButton buttonWithImage:[NSImage imageNamed:@"icon_switchPhoto"] target:self action:@selector(switchButtonClicked:)];
    [self.cameraControlView addSubview:button];
    button.frame = NSMakeRect(self.shootPhotoButton.frame.origin.x+10, height-buttonWidth-10, buttonWidth, buttonWidth);
    button.bordered = NO;
    
    self.switchPhotoVideoButton = button;
    
    self.switchPhotoVideoButton.tag = 0;
    
    [self modifyCapacity];
}

-(void)modifyShootButton{
    NSUInteger mode = self.switchPhotoVideoButton.tag;
    
    if (mode == 0) {
        [self.shootPhotoButton setImage:self.photoImage];
    }
    else if (mode == 1) {
        
        if (self.isRecordingVideo) {
            self.switchPhotoVideoButton.enabled = NO;
             [self.shootPhotoButton setImage:self.videoStopImage];
        }
        else{
            self.switchPhotoVideoButton.enabled = YES;
             [self.shootPhotoButton setImage:self.videoStartImage];
            
        }
    }
    
}

-(void)setRecordingTime:(NSInteger)recordingTime{
    
    _recordingTime = recordingTime;
    
    if (recordingTime>0) {
        NSUInteger recordTime = recordingTime;
        int minute = (recordTime % 3600) / 60;
        int second = (recordTime % 3600) % 60;
        self.recordingTimeField.stringValue = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    else{
        self.recordingTimeField.stringValue = @"";
    }
}

-(void)modifyRecordingTime{
    
    if (!self.isRecordingVideo) {
        return;
    }
   
    self.recordingTime = self.recordingTime+1;
    self.videoCapacity = self.videoCapacity-1;
    
    [self modifyCapacity];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self modifyRecordingTime];
    });
}

-(void)shootButtonClicked:(id)sender{
        
    NSUInteger mode = self.switchPhotoVideoButton.tag;
    if (mode == 0) {
        
        if (self.photoCapacity<=0) {
            return;
        }
        
        [self sendMessage:@"capture_photo"];
        self.photoCapacity = self.photoCapacity-1;
        [self modifyCapacity];
    }
    else if (mode == 1) {
        
        if (self.isRecordingVideo) {
            [self sendMessage:@"stop_record"];
            self.isRecordingVideo = NO;
            self.recordingTime = 0;
        }
        else{
            
            if (self.videoCapacity<=0) {
                return;
            }
            
            self.isRecordingVideo = YES;
            [self sendMessage:@"start_record"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self modifyRecordingTime];
            });
            
        }
        
        [self modifyShootButton];
    }
}


-(void)configGlasses{
    
    NSInteger count = self.glassArray.count;
    CGFloat width = count*(24+20);
    
    self.glassesBackground = [[NSView alloc] initWithFrame:NSMakeRect(self.view.frame.size.width-width, self.view.frame.size.height-60-24, width, 24)];
    [self.view addSubview:self.glassesBackground];
    self.glassesBackground.wantsLayer = YES;
    
    NSButton *button = nil;
    for (int i=0; i<count; i++) {
        
        NSDictionary *dic = [self.glassArray objectAtIndex:i];
        
        button = [[NSButton alloc] initWithFrame:NSMakeRect(i*(24+20), 0, 24, 24)];
        [self.glassesBackground addSubview:button];
        button.tag = i;
        button.target = self;
        button.action = @selector(glassButtonClicked:);
        button.wantsLayer = YES;
        button.layer.backgroundColor = [NSColor clearColor].CGColor;
        button.layer.cornerRadius = 2.0;
    
        PVAsyncImageView *imageView = [[PVAsyncImageView alloc] initWithFrame:button.bounds];
        [button addSubview:imageView];
        [imageView downloadImageFromURL:dic[@"thumbnail"]];
        
        imageView.wantsLayer = YES;
        imageView.layer.backgroundColor = [NSColor clearColor].CGColor;
        imageView.layer.borderColor = [NSColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.5;
        imageView.layer.cornerRadius = 2.0;
    }
    
    self.highlightView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 24, 24)];
    [self.glassesBackground addSubview:_highlightView];
    
    _highlightView.wantsLayer = YES;
    _highlightView.layer.borderWidth = 1.5;
    _highlightView.layer.cornerRadius = 2.0;
    _highlightView.layer.borderColor = [NSColor colorFromHexString:@"#007EFF"].CGColor;
    
}

-(void)glassButtonClicked:(NSButton*)button{
    
    self.highlightView.frame = button.frame;
    NSDictionary *dic = [self.glassArray objectAtIndex:button.tag];
    
    [self addEvent:[NSString stringWithFormat:@"切换载玻片%@", dic[@"name"]]];
    
    self.xglassOffset = [dic[@"offset"] floatValue];
    [self sliderChanged:nil];
}

#pragma Agora

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId{
    
    [super rtmKit:kit messageReceived:message fromPeer:peerId];
    
     if ([peerId isEqualToString:@"body"] && self.deviceID) {
         
         [[ZKService sharedService] getDeviceInfoWithDeviceID:self.deviceID success:^(NSURLSessionDataTask *task, id responseObject) {
             
             if ([responseObject[@"status"] intValue] == 1) {
                 NSDictionary *data = responseObject[@"data"];
                 
                 NSString *glassString = data[@"glasses"];
                 NSArray *glassArray = [NSJSONSerialization JSONObjectWithData:[glassString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
                 self.glassArray = glassArray;
                 
                 [self configGlasses];
             }
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
         }];
     }
    
    if ([self.bodyName isEqualToString:peerId]) {
 
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = self.remoteVideo;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    
    if (!self.gameStartDate) {
        self.gameStartDate = [NSDate date];
        self.played = YES;
        [self countDown];
    }
    
    AgoraRtmMessage *agoraMessage = [[AgoraRtmMessage alloc] initWithText:@"start"];
    [self.rtmKit sendMessage:agoraMessage toPeer:self.bodyName completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
        
        [self sliderChanged:nil];
        
    }];
    
    
    
    
}
    
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason{
    
}
    
-(void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode{
    
    
}
    
-(void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data{
    NSLog(@"%@", data);
}

- (void)channel:(AgoraRtmChannel * _Nonnull)channel messageReceived:(AgoraRtmMessage * _Nonnull)message fromMember:(AgoraRtmMember * _Nonnull)member{
    
    if ([member.userId isEqualToString:self.bodyName]) {
        NSLog(@"%@", message.text);
    }
}



@end
