//
//  ZKPlayViewController.h
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"

#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtmKit/AgoraRtmKit.h>

#import <Carbon/Carbon.h>

@interface ZKPlayViewController : ZKViewController <AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate>

@property (nonatomic, strong) NSDictionary *order;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) AgoraRtmKit *rtmKit;

@property (nonatomic, strong) NSView *remoteVideo;
@property (nonatomic, strong) AgoraRtmChannel *channel;

@property (nonatomic, strong) NSString *bodyName;
@property (nonatomic, strong) NSString *bodyChannel;
@property (nonatomic, strong) NSString *deviceID;

@property (nonatomic, strong) NSView *bodyStateView;
@property (nonatomic, strong) NSTextField *bodyStateField;

@property (nonatomic, strong) NSDate *gameStartDate;
@property (nonatomic, strong) NSDate *quitDate;
@property (nonatomic) BOOL played;

@property (nonatomic) NSTimeInterval timeinter;

@property (nonatomic, strong) NSImage *photoImage;
@property (nonatomic, strong) NSImage *videoStartImage;
@property (nonatomic, strong) NSImage *videoStopImage;


-(void)fieldInit:(NSTextField*)field;

-(void)sendMessage:(NSString*)message;

-(void)loginWithUser:(NSString*)user;
-(void)loginWithChannel:(NSString*)channel;

-(void)logout;

@end

