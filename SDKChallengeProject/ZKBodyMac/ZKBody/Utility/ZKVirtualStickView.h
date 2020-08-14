//
//  ZKVirtualStickView.h
//  TestRotate
//
//  Created by King on 2020/3/8.
//  Copyright © 2020 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@protocol ZKVirtualStickViewDelegate;

@interface ZKVirtualStickView : NSView

@property (nonatomic, strong) NSImageView *sticker;

@property (nonatomic, weak) id<ZKVirtualStickViewDelegate> delegate;

@property (nonatomic) CGPoint stickerPoint;

-(void)active;

@end


@protocol ZKVirtualStickViewDelegate <NSObject>

@optional
-(void)virtualStickView:(ZKVirtualStickView*)virtualStickView didBeginWithEvent:(NSEvent*)event;
-(void)virtualStickView:(ZKVirtualStickView*)virtualStickView stickMoveWithEvent:(NSEvent*)event;
-(void)virtualStickView:(ZKVirtualStickView*)virtualStickView didEndWithEvent:(NSEvent*)event;

-(void)virtualStickViewDidUpdate:(ZKVirtualStickView*)virtualStickView;


@end
