//
//  ZKDroneViewController.m
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKDroneViewController.h"



#import "ZKDroneControlHelpViewController.h"
#import "ZKVirtualStickView.h"


@interface ZKPoint : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@end

@implementation ZKPoint



@end

@interface ZKBody : NSObject <MKAnnotation>

@property (nonatomic, strong) NSNumber *satelliteCount;
@property (nonatomic, strong) NSNumber *GPSSignalLevel;
@property (nonatomic, strong) NSNumber *aircraftLatitude;
@property (nonatomic, strong) NSNumber *aircraftLongitude;
@property (nonatomic, strong) NSNumber *aircraftAltitude;
@property (nonatomic, strong) NSNumber *heading;
@property (nonatomic, strong) NSNumber *altitude;
@property (nonatomic, strong) NSNumber *takeoffLocationAltitude;
@property (nonatomic, strong) NSNumber *speedH;
@property (nonatomic, strong) NSNumber *speedXY;
@property (nonatomic, strong) NSNumber *battery;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *bodyState;

@property (nonatomic, strong) NSNumber *pitch;
@property (nonatomic, strong) NSNumber *roll;
@property (nonatomic, strong) NSNumber *yaw;

@property (nonatomic, strong) NSNumber *windWarning;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSNumber *photoCapacity;
@property (nonatomic, strong) NSNumber *videoCapacity;

@property (nonatomic, strong) NSNumber *canTakePhoto;

@property (nonatomic, strong) NSNumber *isRecordingVideo;
@property (nonatomic, strong) NSNumber *recordingTime;

@property (nonatomic, strong) NSNumber *cameraMode;

@property (nonatomic, strong) NSNumber *gimbalPitch;
@property (nonatomic, strong) NSNumber *focalLength;

-(void)updateWithMessage:(NSString*)message;

@end

@implementation ZKBody

@synthesize coordinate;

-(void)updateWithMessage:(NSString*)message{
    
    NSArray *bodyState = [message componentsSeparatedByString:@","];
    
    self.satelliteCount =  @([(NSString*)bodyState[0] intValue]);
    self.GPSSignalLevel =  @([(NSString*)bodyState[1] intValue]);
    self.aircraftLatitude =  @([(NSString*)bodyState[2] doubleValue]);
    self.aircraftLongitude =  @([(NSString*)bodyState[3] doubleValue]);
    self.aircraftAltitude =  @([(NSString*)bodyState[4] floatValue]);
    self.heading =  @([(NSString*)bodyState[5] floatValue]);
    self.altitude =  @([(NSString*)bodyState[6] floatValue]);
    self.takeoffLocationAltitude =  @([(NSString*)bodyState[7] floatValue]);
    self.speedH =  @([(NSString*)bodyState[8] floatValue]);
    self.speedXY =  @([(NSString*)bodyState[9] floatValue]);
    self.battery =  @([(NSString*)bodyState[10] intValue]);
    self.distance =  @([(NSString*)bodyState[11] floatValue]);
    
    self.bodyState =  @([(NSString*)bodyState[12] intValue]);
    
    self.pitch =  @([(NSString*)bodyState[13] floatValue]);
    self.roll =  @([(NSString*)bodyState[14] floatValue]);
    self.yaw =  @([(NSString*)bodyState[15] floatValue]);
    
    self.windWarning =  @([(NSString*)bodyState[16] intValue]);
    
    
    self.photoCapacity = @([(NSString*)bodyState[17] intValue]);
    self.videoCapacity = @([(NSString*)bodyState[18] intValue]);
    
    self.canTakePhoto = @([(NSString*)bodyState[19] boolValue]);
    self.isRecordingVideo = @([(NSString*)bodyState[20] boolValue]);
    
    self.recordingTime = @([(NSString*)bodyState[21] intValue]);
    
    self.cameraMode = @([(NSString*)bodyState[22] intValue]);
    
    self.gimbalPitch = @([(NSString*)bodyState[23] intValue]);
    self.focalLength = @([(NSString*)bodyState[24] intValue]);
    
    if (self.aircraftLatitude.doubleValue<200) {
        self.coordinate = CLLocationCoordinate2DMake(self.aircraftLatitude.doubleValue, self.aircraftLongitude.doubleValue);
    }
    
}

@end

@interface ZKBodyView : MKAnnotationView

@property (nonatomic, strong) NSImageView *imageView;

@end

@implementation ZKBodyView



@end



@interface ZKDroneViewController () <MKMapViewDelegate, CAAnimationDelegate, ZKVirtualStickViewDelegate>




@property (nonatomic, strong) ZKBody *body;


@property (nonatomic, strong) NSView *flightDataView;
@property (nonatomic, strong) NSTextField *distanceField;
@property (nonatomic, strong) NSTextField *altitudeField;
@property (nonatomic, strong) NSTextField *speedHField;
@property (nonatomic, strong) NSTextField *speedXYField;

@property (nonatomic, strong) NSView *flightSignalView;
@property (nonatomic, strong) NSTextField *batteryField;
@property (nonatomic, strong) NSTextField *satelliteCountField;
@property (nonatomic, strong) NSImageView *GPSSignalImage;
@property (nonatomic, strong) NSImageView *networkQualityImageView;

@property (nonatomic, strong) NSView *cameraControlView;
@property (nonatomic, strong) IBOutlet NSButton *shootPhotoButton;
@property (nonatomic, strong) NSTextField *capacityField;
@property (nonatomic, strong) NSButton *switchPhotoVideoButton;
@property (nonatomic, strong) NSTextField *recordingTimeField;

@property (nonatomic, strong) NSDate *shootPhotoClickDate;
@property (nonatomic, strong) NSDate *autoCruiseClickDate;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSImageView *compassView;

@property (nonatomic) BOOL helpAlerted;

@property (nonatomic, strong) NSString *assistName;
@property (nonatomic, strong) NSString *assistChannel;

@property (nonatomic) NSInteger sendCount;

@property (nonatomic, strong) NSView *assistRemoteVideo;

@property (nonatomic) BOOL switched;

@property (nonatomic, strong) NSView *virtualStickView;
@property (nonatomic, strong) ZKVirtualStickView *leftStick;
@property (nonatomic, strong) ZKVirtualStickView *rightStick;


@property (nonatomic, strong) NSDictionary *bodyStateDic;

@property (nonatomic, strong) MKPolyline *line;
@property (nonatomic, strong) NSArray *annotationArray;


@end

@implementation ZKDroneViewController



-(IBAction)controlHelpButtonClicked:(id)sender{
    
    ZKDroneControlHelpViewController *controller = [[ZKDroneControlHelpViewController alloc] init];
    if (!sender) {
        controller.shouldAutoDissmiss = YES;
    }
    [self presentViewControllerAsModalWindow:controller];
}

- (void)virtualStickViewDidUpdate:(ZKVirtualStickView *)virtualStickView{
    
    NSDictionary *dataDic = @{@"x1":[NSString stringWithFormat:@"%.2f", self.leftStick.stickerPoint.x], @"y1":[NSString stringWithFormat:@"%.2f",self.leftStick.stickerPoint.y], @"x2":[NSString stringWithFormat:@"%.2f",self.rightStick.stickerPoint.x], @"y2":[NSString stringWithFormat:@"%.2f",self.rightStick.stickerPoint.y]};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic
                                    options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                      error:nil];
        
    NSString *contentString = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
    
    [self sendMessage:contentString];
     NSLog(@"%@", contentString);
}

-(void)virtualSwitchClicked:(id)sender{
    
    BOOL on = self.virtualSwitch.state;
    self.virtualStickView.hidden = !on;

}

-(void)FPVSwitchClicked:(id)sender{
    
    if (self.FPVSwitch.state == NSControlStateValueOn) {
        [self sendMessage:@"FPVON"];
    }
    else{
        [self sendMessage:@"FPVOFF"];
    }
}

-(void)autoCruiseClicked:(id)sender{
    
    self.autoCruiseClickDate = [NSDate date];
    self.autoCruiseSwitch.enabled = NO;
    
    if (self.autoCruiseSwitch.state == NSControlStateValueOn) {
        [self sendMessage:@"startAutoCruise"];
    }
    else{
        [self sendMessage:@"stopAutoCruise"];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
   
    
    self.body = [[ZKBody alloc] init];
    self.body.coordinate = CLLocationCoordinate2DMake(30.013453969470273, 120.61295975659178);
    
    self.shootPhotoClickDate = [NSDate date];
    self.autoCruiseClickDate = [NSDate date];
    
    [self configBodyDataView];
    [self configBodySignalView];
    
    [self.view addSubview:self.howToPlayButton];
    [self.view addSubview:self.virtualSwitch];
    [self.view addSubview:self.autoCruiseSwitch];
    [self.view addSubview:self.FPVSwitch];
    self.autoCruiseSwitch.hidden = YES;
    self.FPVSwitch.hidden = YES;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"虚拟摇杆" attributes:@{
    NSFontAttributeName : [NSFont systemFontOfSize:11.0f],
    NSForegroundColorAttributeName : [NSColor whiteColor],
    }];
    [self.virtualSwitch setAttributedTitle:title];
    
    [self.virtualSwitch setTarget:self];
    [self.virtualSwitch setAction:@selector(virtualSwitchClicked:)];
    
    title = [[NSAttributedString alloc] initWithString:@"自动巡航" attributes:@{
    NSFontAttributeName : [NSFont systemFontOfSize:11.0f],
    NSForegroundColorAttributeName : [NSColor whiteColor],
    }];
    
    [self.autoCruiseSwitch setAttributedTitle:title];
    
    [self.autoCruiseSwitch setTarget:self];
    [self.autoCruiseSwitch setAction:@selector(autoCruiseClicked:)];
    
    title = [[NSAttributedString alloc] initWithString:@"FPV" attributes:@{
    NSFontAttributeName : [NSFont systemFontOfSize:11.0f],
    NSForegroundColorAttributeName : [NSColor whiteColor],
    }];
    [self.FPVSwitch setAttributedTitle:title];
    [self.FPVSwitch setTarget:self];
    [self.FPVSwitch setAction:@selector(FPVSwitchClicked:)];

    self.played = NO;
    
    [self addKeyEvent];
    
    self.assistRemoteVideo = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 480, 270)];
    self.assistRemoteVideo.wantsLayer = YES;
    [self.view addSubview:self.assistRemoteVideo];
       
    self.assistRemoteVideo.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    
    [self configCameraControlView];
    

    CGFloat stickSize = 128.0;
     
     NSView *view = [[NSView alloc] initWithFrame:CGRectMake(500-149, 0, 298, 150)];
     [self.view addSubview:view];
     view.wantsLayer = YES;
//     view.layer.backgroundColor = [NSColor yellowColor].CGColor;
     
     self.virtualStickView = view;
    view.hidden = YES;
            
     self.leftStick = [[ZKVirtualStickView alloc] initWithFrame:CGRectMake(10, 10, stickSize, stickSize)];
     _leftStick.delegate = self;
    [self.virtualStickView addSubview:self.leftStick];
         
     self.rightStick = [[ZKVirtualStickView alloc] initWithFrame:CGRectMake(160, 10, stickSize, stickSize)];
     _rightStick.delegate = self;
     [self.virtualStickView addSubview:self.rightStick];
    
    
    [self setupBodyStateDic];
    
    
    
}

-(void)setupBodyStateDic{
    self.bodyStateDic = @{
        @"201":@"飞行器已经开机，正在抬升飞行平台",
        @"202":@"开机完成",
        @"301":@"平台到达预定位置，准备起飞",
        @"302":@"起飞",
        @"303":@"正在前往安全飞行区域",
        @"304":@"准备返回安全飞行区域",
        @"401":@"到达安全区域，开始自由飞行",
        @"501":@"游戏时间到，开始返航",
        @"601":@"超出飞行边界，准备返回安全飞行区域",
        @"1001":@"正在返航",
        @"1002":@"返航中，游戏结束, 即将退出",
        @"1101":@"安全降落，飞行结束",
        @"1201":@"正在准备飞行器",
        @"2001":@"视觉定位飞机位置中，预计40秒后起飞",
        @"2101":@"已经确认飞机位置，准备开机，预计30秒后起飞",
        @"2201":@"机械臂正在接近飞机,预计60秒后起飞",
    };
    
    [[ZKService sharedService] getDroneStagesSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] == 1) {
            NSArray *array = responseObject[@"data"][@"list"];
            
            NSMutableDictionary *stateDic = [NSMutableDictionary dictionary];
            
            for (NSDictionary *dic in array) {
                
                NSString *key = [NSString stringWithFormat:@"%@%@",dic[@"no"], dic[@"statusNo"]];
                NSString *value = dic[@"description"];
                [stateDic setValue:value forKey:key];
            }
            
            self.bodyStateDic = stateDic;
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

-(void)switchChannel{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(realSwitch) object:nil];
    [self performSelector:@selector(realSwitch) withObject:nil afterDelay:2.0];
}

-(void)realSwitch{
    [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [self.assistRemoteVideo removeFromSuperview];
        self.assistRemoteVideo = nil;
        [self.agoraKit joinChannelByToken:nil channelId:self.bodyChannel info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
                   
        }];
    }];
}

-(void)updateWithBodyState{
    
    NSString *key = [NSString stringWithFormat:@"%@", self.body.bodyState];
    NSString *stateMessage = @"准备中";
    
    NSDictionary *dic = self.bodyStateDic;
    
    stateMessage = [dic objectForKey:key];
    
    if (self.body.bodyState.intValue == 1002 && self.played) {
        if (!self.quitDate) {
            self.quitDate = [NSDate date];
        }
        
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.quitDate];
        
        stateMessage = [stateMessage stringByAppendingFormat:@"%@", [NSNumber numberWithInt:3-time]];
        
        if (time>=3 && [self.navigationController topViewController] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.body.bodyState.intValue == 501){
        
    }
    else if (self.body.bodyState.intValue == 201){//切换rtc channel
        if (!self.switched) {
            self.switched = YES;
            [self switchChannel];
        }
       
    }
    else if (self.body.bodyState.intValue == 303){
        
        if(!self.helpAlerted){
            [self controlHelpButtonClicked:nil];
            self.helpAlerted = YES;
        }
        
    }
    else if (self.body.bodyState.intValue == 401){
        if (!self.gameStartDate) {
            self.gameStartDate = [NSDate date];
            self.played = YES;
            self.autoCruiseSwitch.hidden = NO;
            self.FPVSwitch.hidden = NO;
            self.sendCount = 0;
            [self preheatRTM];
        }
    
        stateMessage = [self addCountDown:stateMessage];
    }
    
    if ([[NSDate date] timeIntervalSinceDate:self.autoCruiseClickDate]<2){
        self.autoCruiseSwitch.enabled = NO;
    }
    else{
        
        self.autoCruiseSwitch.enabled = YES;
        
        if ([self.body.bodyState intValue] == 701 || [self.body.bodyState intValue] == 702) {
            [self.autoCruiseSwitch setState:NSControlStateValueOn];
            [self.mapView addOverlay:self.line];
            [self.mapView addAnnotations:self.annotationArray];
            stateMessage = [self addCountDown:stateMessage];
        }
        else{
            [self.autoCruiseSwitch setState:NSControlStateValueOff];
            [self.mapView removeOverlay:self.line];
            [self.mapView removeAnnotations:self.annotationArray];
        }
    }
    
    if (self.body.bodyState.intValue == 1002 && !self.played) {
        stateMessage = @"正在返航，等待开始";
    }
    
    self.bodyStateField.stringValue = stateMessage?stateMessage:@"准备中";
}

-(NSString*)addCountDown:(NSString*)message{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.gameStartDate];
    NSInteger timeleft = [self.order[@"totalTime"] integerValue] - time;
    if (timeleft<0) {
        timeleft = 0;
    }

    NSUInteger recordTime = timeleft;
    int minute = (recordTime % 3600) / 60;
    int second = (recordTime % 3600) % 60;
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    return [message stringByAppendingFormat:@" %@", timeString];
    
}

-(void)preheatRTM{
    
    if (self.sendCount<10) {
        [self sendMessage:@"k"];
        [self performSelector:@selector(preheatRTM) withObject:nil afterDelay:0.1];
    }
    else if (self.sendCount == 10){
        [self sendMessage:@"u"];
    }
    
    self.sendCount = self.sendCount+1;
    
    
}

#pragma Agora


-(void)loginWithChannel:(NSString*)channel{
    
    for (NSViewController *controller in self.presentedViewControllers) {
        [self dismissViewController:controller];
    }
    
    NSString *appid = @"ae7ed3528af64854984c48c0fd7e30fc";
    
    self.assistName = [self.bodyName stringByAppendingString:@"_assist"];
    self.assistChannel = [self.bodyChannel stringByAppendingString:@"_assist"];
     
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
    [self.agoraKit disableAudio];
    [self.agoraKit enableVideo];
    
    [self.agoraKit enableLocalAudio:NO];
    [self.agoraKit enableLocalVideo:NO];
    
    [self.agoraKit joinChannelByToken:nil channelId:self.assistChannel info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
    
   
    self.channel = [self.rtmKit createChannelWithId:channel delegate:self];
    [self.channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
    }];
   
}

-(void)modifyCruise{
    

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *coordinateArray = self.autoCruiseArray;
    int i = 0;
    MKMapPoint points[coordinateArray.count];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(30, 120);
    
    for (NSDictionary *pointDic in coordinateArray) {
        
        NSDictionary *coordinateDic = [pointDic objectForKey:@"lnglat"];
        
        CLLocation *c = [[CLLocation alloc] initWithLatitude:[coordinateDic[@"lat"] doubleValue] longitude:[coordinateDic[@"lng"] doubleValue]];
        points[i] = MKMapPointForCoordinate(c.coordinate);
        point = CLLocationCoordinate2DMake([coordinateDic[@"lat"] doubleValue], [coordinateDic[@"lng"] doubleValue]);
        ZKPoint *zkpoint = [[ZKPoint alloc] init];
        zkpoint.coordinate = point;
        i++;
        
        zkpoint.title = [NSString stringWithFormat:@"%@", @(i)];
        [array addObject:zkpoint];
  
        CGFloat altitude = [[pointDic objectForKey:@"height"] floatValue];
        if (altitude>0) {
        }
        
    }
    
    self.annotationArray = array;

    MKPolyline *poly = [MKPolyline polylineWithPoints:points count:coordinateArray.count];
    self.line = poly;
    
}

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId{
    
    [super rtmKit:kit messageReceived:message fromPeer:peerId];
    
    if ([peerId isEqualToString:@"body"] && self.deviceID) {
        
        [[ZKService sharedService] getDeviceInfoWithDeviceID:self.deviceID success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = responseObject;
            if ([dic[@"status"] intValue] == 1) {
                NSDictionary *info = dic[@"data"];
                       
                NSString *verticalScope = info[@"verticalScope"];
                NSArray *verticalArray = [verticalScope componentsSeparatedByString:@","];
                if ([verticalArray count]>=2) {
                    self.minHeight = [verticalArray[0] floatValue];
                    self.maxHeight = [verticalArray[1] floatValue];
                }
                
                NSString *ccsString = [info objectOrNilForKey:@"ccsPath"];
                if (ccsString) {
                    NSArray *ccsArray = [NSJSONSerialization JSONObjectWithData:[ccsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
                    if (ccsArray) {
                        self.autoCruiseArray = ccsArray;
                        [self modifyCruise];
                    }
                }
                
                NSString *homeString = [info objectOrNilForKey:@"flyPathStart"];
                if (homeString) {
                    NSDictionary *homeDic = [NSJSONSerialization JSONObjectWithData:[homeString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
                    NSArray *homeLocation = homeDic[@"lnglat"];
                    if (homeLocation) {
                        self.homeLocation = CLLocationCoordinate2DMake([homeLocation[1] doubleValue], [homeLocation[0] doubleValue]);
                        self.body.coordinate = self.homeLocation;
                        [self.mapView setRegion:MKCoordinateRegionMake(self.body.coordinate, MKCoordinateSpanMake(0.01, 0.01))];
                    }
                }
                
                NSString *midPointString = [info objectOrNilForKey:@"flyPathMiddle"];
                if (midPointString) {
                    NSDictionary *midDic = [NSJSONSerialization JSONObjectWithData:[midPointString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
                    if (midDic) {
                        self.midPoint = midDic;
                    }
                }
                
                NSString *endPointString = [info objectOrNilForKey:@"flyPathEnd"];
                if (endPointString) {
                    NSDictionary *endDic = [NSJSONSerialization JSONObjectWithData:[endPointString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
                    if (endDic) {
                        self.endPoint = endDic;
                    }
                }
                
                       
                NSString *horizontalScope = info[@"horizontalScope"];
                NSArray *coordinateArray = [NSJSONSerialization JSONObjectWithData:[horizontalScope dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
     
                MKMapPoint points[coordinateArray.count];
                
                for (int i=0; i<coordinateArray.count; i++) {
                    NSDictionary *coordinate = coordinateArray[i];
                    CLLocation *c = [[CLLocation alloc] initWithLatitude:[coordinate[@"lat"] doubleValue] longitude:[coordinate[@"lng"] doubleValue]];
                    points[i] = MKMapPointForCoordinate(c.coordinate);
                }
 
                MKPolygon *poly = [MKPolygon polygonWithPoints:points count:coordinateArray.count];
                [self.mapView addOverlay:poly];
            }
                
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                   
        }];
    }
    
    
    if ([self.bodyName isEqualToString:peerId]) {
        
        self.body.bodyState = @([(NSString*)message.text intValue]);
        [self updateWithBodyState];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = [self.bodyChannel integerValue] == uid?self.remoteVideo:self.assistRemoteVideo;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    
}
    
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason{
    
}
    
-(void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode{
    
    
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine networkQuality:(NSUInteger)uid txQuality:(AgoraNetworkQuality)txQuality rxQuality:(AgoraNetworkQuality)rxQuality{
    
    if (uid == 0) {
        self.networkQualityImageView.image = [NSImage imageNamed:[NSString stringWithFormat:@"GPS%@", @(MIN(MAX(6-rxQuality, 0), 5))]];
    }
    
}
    
-(void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data{
    NSLog(@"%@", data);
}

- (void)channel:(AgoraRtmChannel * _Nonnull)channel messageReceived:(AgoraRtmMessage * _Nonnull)message fromMember:(AgoraRtmMember * _Nonnull)member{
    
    if ([member.userId isEqualToString:self.bodyName]) {
        NSLog(@"%@", message.text);
        
        [self.body updateWithMessage:message.text];
        
        [self updateBodyInfo];
        [self updateWithBodyState];
    }
}


-(NSAttributedString*)flightDataStringWithKey:(NSString*)key value:(NSNumber*)value andUnit:(NSString*)unit{
    
    key = [key stringByAppendingString:@" "];
    NSString *valueString = value?[NSString stringWithFormat:@"%@", value]:@"N/Λ";
    NSString *cellTitleString = [NSString stringWithFormat:@"%@%@",key, valueString];
    
    if (unit) {
        unit = [@" " stringByAppendingString:unit];
        cellTitleString = [cellTitleString stringByAppendingString:unit];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cellTitleString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [NSFont systemFontOfSize:10.0f],
                                       NSForegroundColorAttributeName : [NSColor whiteColor],
                                       }
                              range:NSMakeRange(0, key.length)];
    [attributedString setAttributes:@{
        NSFontAttributeName : [NSFont systemFontOfSize:key.length<=2?20.0f:14.0f],
                                      NSForegroundColorAttributeName : [NSColor whiteColor],
                                      } range:NSMakeRange(key.length, valueString.length)];
    
    if (unit) {
        [attributedString setAttributes:@{
        NSFontAttributeName : [NSFont systemFontOfSize:10.0f],
                                      NSForegroundColorAttributeName : [NSColor whiteColor],
        } range:[cellTitleString rangeOfString:unit]];
    }
    
    return attributedString;
}


-(void)modifyField:(NSTextField*)field{
    
    [self fieldInit:field];
    [self.flightDataView addSubview:field];
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
    
    self.shootPhotoClickDate = [NSDate date];
    
    [self modifySwitchButtonUI];
    
    
    NSString *switchString = [NSString stringWithFormat:@"switch%@", self.switchPhotoVideoButton.tag == 0?@"photo":@"video"];
    [self sendMessage:switchString];
    
     [self addEvent:switchString];
}

-(IBAction)focalLengthChanged:(id)sender{

    int value = self.focalLengthSlider.intValue*10;
    [self sendMessage:[NSString stringWithFormat:@"FL%@", @(value)]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.focalLengthSlider.doNotUpdate = NO;
    });
    
}
-(IBAction)gimbalSliderChanged:(id)sender{
    
    int value = self.gimbalSlider.intValue;
    [self sendMessage:[NSString stringWithFormat:@"gimbal%@", @(value)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gimbalSlider.doNotUpdate = NO;
    });
    
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

    self.shootPhotoButton.enabled = NO;
    
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
    
    self.switchPhotoVideoButton.enabled = NO;
    self.switchPhotoVideoButton.tag = 0;
    
    
    [self.cameraControlView addSubview:self.focalLengthSlider];
    
    [self.cameraControlView addSubview:self.gimbalSlider];
    
    
    
}


-(void)configBodySignalView{
    
    CGFloat height = 35.0;
    CGFloat totalWidth = 200.0;
    
    self.flightSignalView = [[NSView alloc] initWithFrame:CGRectMake(NSWidth(self.view.frame)-totalWidth-10, NSHeight(self.view.frame)-height-10-40, totalWidth, height)];
//    self.flightSignalView.wantsLayer = YES;
//    self.flightSignalView.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.flightSignalView.alphaValue = 0.8;
    [self.view addSubview:self.flightSignalView];
    
    self.batteryField = [[NSTextField alloc] initWithFrame:CGRectMake(NSWidth(self.flightSignalView.frame)-10-25, -10, 60, height)];
    [self modifyField:self.batteryField];
    [self.flightSignalView addSubview:self.batteryField];
    self.batteryField.font = [NSFont systemFontOfSize:13];
    self.batteryField.textColor = [NSColor whiteColor];
    self.batteryField.stringValue = @"N/Λ";
    
    NSImageView *batteryIcon = [NSImageView imageViewWithImage:[NSImage imageNamed:@"batteryicon"]];
    [self.flightSignalView addSubview:batteryIcon];
    batteryIcon.frame = CGRectMake(self.batteryField.frame.origin.x-25, 7, 20, 20);
    
    
    self.satelliteCountField = [[NSTextField alloc] initWithFrame:CGRectMake(30, -10, 60, height)];
    [self modifyField:self.satelliteCountField];
    [self.flightSignalView addSubview:self.satelliteCountField];
    self.satelliteCountField.font = [NSFont systemFontOfSize:5];
    self.satelliteCountField.textColor = [NSColor whiteColor];

    NSImageView *satelliteIcon = [NSImageView imageViewWithImage:[NSImage imageNamed:@"satelliteicon"]];
    [self.flightSignalView addSubview:satelliteIcon];
    satelliteIcon.frame = CGRectMake(10, 7, 20, 20);
    
    
    self.GPSSignalImage = [[NSImageView alloc] initWithFrame:CGRectMake(35, 7, 20, 20)];
    [self.flightSignalView addSubview:self.GPSSignalImage];
    self.GPSSignalImage.image = [NSImage imageNamed:@"GPS0"];
    
    NSImageView *hdIcon = [NSImageView imageViewWithImage:[NSImage imageNamed:@"icon_hd"]];
    [self.flightSignalView addSubview:hdIcon];
    hdIcon.frame = CGRectMake(70, 7, 30, 20);
    
    self.networkQualityImageView = [[NSImageView alloc] initWithFrame:CGRectMake(105, 7, 20, 20)];
    [self.flightSignalView addSubview:self.networkQualityImageView];
    self.networkQualityImageView.image = [NSImage imageNamed:@"GPS0"];
    
    
}

-(void)configBodyDataView{
    
    CGFloat fieldWidth = 120.0f;
    CGFloat fieldHeight = 40.0f;
    
    self.flightDataView = [[NSView alloc] initWithFrame:CGRectMake(20, 0, 300, 100)];
    self.flightDataView.wantsLayer = YES;
//    self.flightDataView.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.flightDataView.alphaValue = 0.5;
    [self.view addSubview:_flightDataView];
    
    
    self.distanceField = [[NSTextField alloc] initWithFrame:CGRectMake(10, 40, fieldWidth, fieldHeight)];
    [self modifyField:self.distanceField];
    self.distanceField.attributedStringValue = [self flightDataStringWithKey:@"D" value:nil andUnit:nil];
    
    self.altitudeField = [[NSTextField alloc] initWithFrame:CGRectMake(110, 40, fieldWidth, fieldHeight)];
    [self modifyField:self.altitudeField];
    self.altitudeField.attributedStringValue = [self flightDataStringWithKey:@"H" value:nil andUnit:nil];
    
    self.speedHField = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, fieldWidth, fieldHeight)];
    [self modifyField:self.speedHField];
    self.speedHField.attributedStringValue = [self flightDataStringWithKey:@"H.S" value:nil andUnit:nil];
    
    self.speedXYField = [[NSTextField alloc] initWithFrame:CGRectMake(110, 0, fieldWidth, fieldHeight)];
    [self modifyField:self.speedXYField];
    self.speedXYField.attributedStringValue = [self flightDataStringWithKey:@"V.S" value:nil andUnit:nil];
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 210, 10, 200, 100)];
    [self.view addSubview:self.mapView];
    [self.mapView setDelegate:self];
    
//    [self.mapView addAnnotation:self.body];
    [self.mapView setRegion:MKCoordinateRegionMake(self.body.coordinate, MKCoordinateSpanMake(0.7, 0.7))];
    
    self.compassView = [[NSImageView alloc] initWithFrame:NSMakeRect(self.mapView.frame.origin.x+50, self.mapView.frame.origin.y, 100, 100)];
    self.compassView.image = [NSImage imageNamed:@"icon_compass"];
    
    [self.view addSubview:self.compassView];
    self.compassView.wantsLayer = YES;
    
    
}

-(void)updateBodyInfo{

    self.distanceField.attributedStringValue = [self flightDataStringWithKey:@"D" value:self.body.distance andUnit:@"m"];
    self.altitudeField.attributedStringValue = [self flightDataStringWithKey:@"H" value:self.body.altitude andUnit:@"m"];
    self.speedHField.attributedStringValue = [self flightDataStringWithKey:@"H.S" value:self.body.speedXY andUnit:@"km/h"];
    self.speedXYField.attributedStringValue = [self flightDataStringWithKey:@"V.S" value:self.body.speedH andUnit:@"m/s"];
    
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.body.coordinate, MKCoordinateSpanMake(0.007, 0.007))];
//    [self mapView:self.mapView viewForAnnotation:self.body];
    
    self.compassView.frame = NSMakeRect(self.mapView.frame.origin.x+100, self.mapView.frame.origin.y+50, 100, 100);
    self.compassView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.compassView.layer.affineTransform = CGAffineTransformMakeRotation((180-self.body.yaw.floatValue)*M_PI/180);
    

    self.batteryField.stringValue = [NSString stringWithFormat:@"%@%%", self.body.battery];
    
    self.satelliteCountField.stringValue = [NSString stringWithFormat:@"%@", self.body.satelliteCount];
    
    self.GPSSignalImage.image = [NSImage imageNamed:[NSString stringWithFormat:@"GPS%@", self.body.GPSSignalLevel]];
    
    
    if ([[NSDate date] timeIntervalSinceDate:self.shootPhotoClickDate]<1){
        self.shootPhotoButton.enabled = NO;
        self.switchPhotoVideoButton.enabled = NO;
    }
    else{
        
        NSUInteger mode = [self.body.cameraMode intValue];
        if (mode == 0) {
            if (self.switchPhotoVideoButton.tag == 1) {
                self.switchPhotoVideoButton.tag = 0;
                [self modifySwitchButtonUI];
            }
            
            self.shootPhotoButton.enabled = self.body.canTakePhoto.boolValue;
            self.switchPhotoVideoButton.enabled = YES;
            
            if (self.shootPhotoButton.image != self.photoImage) {
                self.shootPhotoButton.image = self.photoImage;
            }
            
        }
        else if (mode == 1){
            if (self.switchPhotoVideoButton.tag == 0) {
                self.switchPhotoVideoButton.tag = 1;
                [self modifySwitchButtonUI];
            }
            
            self.switchPhotoVideoButton.enabled = !self.body.isRecordingVideo.boolValue;
            self.shootPhotoButton.enabled = YES;
            
            
            if (self.body.isRecordingVideo.boolValue) {
                if (self.shootPhotoButton.image != self.videoStopImage) {
                    self.shootPhotoButton.image = self.videoStopImage;
                }
            }
            else{
                if (self.shootPhotoButton.image != self.videoStartImage) {
                    self.shootPhotoButton.image = self.videoStartImage;
                }
            }
        }
    }

    
    NSUInteger mode = [self.body.cameraMode intValue];
    if (mode == 0) {
       self.capacityField.stringValue = [NSString stringWithFormat:@"Capacity:%@", self.body.photoCapacity];
    }
    else if (mode == 1) {
        self.capacityField.stringValue = [NSString stringWithFormat:@"Capacity:%@s", self.body.videoCapacity];
    }
    
    if (self.body.recordingTime.intValue>0) {
        NSUInteger recordTime = self.body.recordingTime.integerValue;
        int minute = (recordTime % 3600) / 60;
        int second = (recordTime % 3600) % 60;
        self.recordingTimeField.stringValue = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    else{
        self.recordingTimeField.stringValue = @"";
    }
    
    
    [self.gimbalSlider updateValue:[self.body.gimbalPitch intValue]];
    
    [self.focalLengthSlider updateValue:[self.body.focalLength intValue]/10];
    
    

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0){
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        MKPolygonRenderer *view = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        view.lineWidth = 3;
        view.strokeColor = [[NSColor greenColor] colorWithAlphaComponent:0.7];
        view.fillColor = [[NSColor blueColor] colorWithAlphaComponent:0.2];
        
        return view;
    }
    else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *view = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline*)overlay];
        view.lineWidth = 1.5;
        view.lineDashPhase = 5.0;
        NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:5] , [NSNumber numberWithInt:5], nil];
        view.lineDashPattern = array;
        view.strokeColor = [[NSColor whiteColor] colorWithAlphaComponent:0.7];
        
        return view;
    }
    return nil;
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
  
        static NSString  *key1 = @"Annotation";
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout = NO;
            
            CGFloat width = 10.0;
            
            NSView *circle = [[NSView alloc] initWithFrame:CGRectMake(-width, -width, width*2, width*2)];
            [annotationView addSubview:circle];
            circle.wantsLayer = YES;
            
            circle.layer.backgroundColor = [NSColor whiteColor].CGColor;
            circle.layer.cornerRadius = width;
            circle.layer.borderWidth = 1.0;
            circle.layer.borderColor = [NSColor lightGrayColor].CGColor;
            
            
            NSTextField *title = [[NSTextField alloc] initWithFrame:CGRectMake(-width, -width+2, width*2, width*2)];
            [annotationView addSubview:title];
            title.cell.alignment = NSTextAlignmentCenter;
        title.drawsBackground = YES;
        title.backgroundColor = [NSColor clearColor];
        title.bordered = NO;
        title.enabled = YES;
            title.textColor = [NSColor blackColor];
            
            
            
        }
        
        annotationView.annotation = annotation;
    
    NSTextField *field = [[annotationView subviews] lastObject];
    field.stringValue = annotation.title;
    
//    annotationView.toolTip = annotation.title;
        
        return annotationView;
        

    
}

-(void)shootButtonClicked:(id)sender{
    
    self.shootPhotoClickDate = [NSDate date];
    self.shootPhotoButton.enabled = NO;
    
    NSUInteger mode = [self.body.cameraMode intValue];
    if (mode == 0) {
        [self sendMessage:@"photo"];
    }
    else if (mode == 1) {
        [self sendMessage:@"video"];
    }
    
    [self addEvent:@"Shoot Button"];
    
}

-(void)viewDidDisappear{
    [super viewDidDisappear];
}

-(void)viewWillDisappear{
    
    [super viewWillDisappear];
    
    if (self.bodyName) {
        AgoraRtmMessage *agoraMessage = [[AgoraRtmMessage alloc] initWithText:@"quit"];
        [self.rtmKit sendMessage:agoraMessage toPeer:self.bodyName completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
             [self logout];
        }];
    }
    else{
        [self logout];
    }
         
    
  
}

-(void)keyDown:(NSEvent *)event{
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now-self.timeinter > 0.1) {
        self.timeinter = now;
    }
    else{
        return;
    }

    NSDictionary *dic = @{@"13":@"w",@"1":@"s",@"0":@"a",@"2":@"d",@"12":@"q",@"14":@"e",@"6":@"z",@"8":@"c",@"38":@"j",@"37":@"l",@"46":@"m",@"34":@"i",@"40":@"k",@"3":@"f",@"4":@"h",@"5":@"g",@"15":@"r",@"17":@"t"};
    
    NSString *key = [NSString stringWithFormat:@"%d", event.keyCode];
    NSString *value = [dic valueForKey:key];
    NSString *st = @"u";
    if (value) {
        st = value;
    }
    
    [self sendMessage:st];
}

-(void)keyUp:(NSEvent *)event{

    NSDictionary *dic = @{@"13":@"w",@"1":@"s",@"0":@"a",@"2":@"d",@"6":@"z",@"8":@"c",@"38":@"j",@"37":@"l",@"46":@"m",@"34":@"i",@"40":@"k"};
    
    NSString *key = [NSString stringWithFormat:@"%d", event.keyCode];
    NSString *value = [dic valueForKey:key];
    
    if (value) {
        [self sendMessage:@"u"];
    }
    
    
    
}

-(void)addKeyEvent{
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull e) {
             
               [self keyDown:e];
               return e;
           }];
           
           [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp handler:^NSEvent * _Nullable(NSEvent * _Nonnull e) {
             
               [self keyUp:e];
               return e;
           }];
}

@end
