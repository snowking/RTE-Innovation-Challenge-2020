//
//  ZKVirtualStickView.m
//  TestRotate
//
//  Created by King on 2020/3/8.
//  Copyright © 2020 King. All rights reserved.
//

#import "ZKVirtualStickView.h"


@interface ZKVirtualStickView ()

@property (nonatomic) BOOL shouldUpdate;

@end



@implementation ZKVirtualStickView


-(instancetype)initWithFrame:(NSRect)frameRect{
    
    self = [super initWithFrame:frameRect];
    
    if (self) {
        self.wantsLayer = YES;
        self.layer.masksToBounds = NO;
        
        
        NSImageView *backImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.width)];
        backImageView.image = [NSImage imageNamed:@"icon_baseback"];
        backImageView.wantsLayer = YES;
        [self addSubview:backImageView];
        backImageView.layer.masksToBounds = NO;
        
        
        self.sticker = [[NSImageView alloc] initWithFrame:backImageView.bounds];
        [self addSubview:self.sticker];
        self.sticker.image = [NSImage imageNamed:@"icon_stick"];
        _sticker.wantsLayer = YES;
        _sticker.layer.masksToBounds = NO;
        
//        [self active];
        
        self.shouldUpdate = NO;
        
    }
    
    return self;
}
-(void)active{
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow|NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInActiveApp|NSTrackingInVisibleRect owner:self userInfo:nil];
    [self addTrackingArea:area];
    
}

-(void)mouseEntered:(NSEvent *)event{
  
}
-(void)mouseMoved:(NSEvent *)event{
    
}
-(void)mouseExited:(NSEvent *)event{
    self.sticker.frame = CGRectMake(0, 0, self.sticker.frame.size.width, self.sticker.frame.size.height);
}


-(CGPoint)stickerPointWithEvent:(NSEvent *)event{
    CGPoint point = [event locationInWindow];
    point = [event.window.contentView convertPoint:point toView:self];
    
    CGFloat x =point.x-self.frame.size.width/2;
    
    if (x<-self.frame.size.width/3) {
        x = -self.frame.size.width/3;
    }
    if (x>self.frame.size.width/3) {
        x = self.frame.size.width/3;
    }
    
    CGFloat y = point.y-self.frame.size.height/2;
    
    if (y<-self.frame.size.height/3) {
        y = -self.frame.size.height/3;
    }
    if (y>self.frame.size.height/3) {
        y = self.frame.size.height/3;
    }
    
    
    self.stickerPoint = CGPointMake(x*3/self.frame.size.width, -y*3/self.frame.size.height);
    
    return CGPointMake(x, y);
}

-(void)mouseDown:(NSEvent *)event{
    
    self.shouldUpdate = YES;
    [self update];
    CGPoint point = [self stickerPointWithEvent:event];
    self.sticker.frame = CGRectMake(point.x, point.y, self.sticker.frame.size.width, self.sticker.frame.size.height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(virtualStickView:didBeginWithEvent:)]) {
        [self.delegate virtualStickView:self didBeginWithEvent:event];
    }
    
}

- (void)mouseDragged:(NSEvent *)event{
    
    self.shouldUpdate = YES;
    
    CGPoint point = [self stickerPointWithEvent:event];
    self.sticker.frame = CGRectMake(point.x, point.y, self.sticker.frame.size.width, self.sticker.frame.size.height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(virtualStickView:stickMoveWithEvent:)]) {
        [self.delegate virtualStickView:self stickMoveWithEvent:event];
    }
    
}

-(void)mouseUp:(NSEvent *)event{
    
    self.shouldUpdate = NO;
    
     self.sticker.frame = CGRectMake(0, 0, self.sticker.frame.size.width, self.sticker.frame.size.height);
    
    self.stickerPoint = CGPointMake(0, 0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(virtualStickView:didEndWithEvent:)]) {
        [self.delegate virtualStickView:self didEndWithEvent:event];
    }
}


-(void)update{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(virtualStickViewDidUpdate:)]) {
    
    }
    else{
        return;
    }
    
    [self.delegate virtualStickViewDidUpdate:self];
    if (self.shouldUpdate) {
        [self performSelector:@selector(update) withObject:nil afterDelay:0.1];
    }
    
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
