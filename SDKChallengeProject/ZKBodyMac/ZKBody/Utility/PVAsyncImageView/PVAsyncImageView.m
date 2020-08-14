//
//  PVAsyncImageView.m
//
//  Created by Pedro Vieira on 7/11/12
//  Copyright (c) 2012 Pedro Vieira. ( https://twitter.com/W1TCH_ )
//  All rights reserved.
//

#import "PVAsyncImageView.h"


@implementation NSString (BPAuto)
- (NSString *)imageUrlAddWidth:(CGFloat)width {
  
    NSRange jpgRange = [self rangeOfString:@".jpg"];
    NSRange pngRange = [self rangeOfString:@".png"];
    if (jpgRange.location == NSNotFound && pngRange.location == NSNotFound) {
        return self;
    }
    NSInteger index = jpgRange.location == NSNotFound?pngRange.location:jpgRange.location;
    NSMutableString *newUrl = [self mutableCopy];
    [newUrl insertString:[NSString stringWithFormat:@"_%ld",(long)width] atIndex:index];
    return newUrl;
}
@end

@interface PVAsyncImageView ()
    @property (readwrite) BOOL isLoadingImage;
    @property (readwrite) BOOL userDidCancel;
    @property (readwrite) BOOL didFailLoadingImage;
@end


@implementation PVAsyncImageView

- (void)downloadImageFromURL:(NSString *)url{
    [self downloadImageFromURL:url withPlaceholderImage:nil errorImage:nil andDisplaySpinningWheel:NO];
}

- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img{
    [self downloadImageFromURL:url withPlaceholderImage:img errorImage:img andDisplaySpinningWheel:NO];
}

- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img andErrorImage:(NSImage *)errorImg{
    [self downloadImageFromURL:url withPlaceholderImage:img errorImage:errorImg andDisplaySpinningWheel:NO];
}


- (void)setImage:(NSImage *)image{
    if (image == nil) {
        [super setImage:image];
        return;
    }

    __weak PVAsyncImageView *weakSelf = self;
    NSImage *scaleToFillImage = [NSImage imageWithSize:self.bounds.size
                                               flipped:NO
                                        drawingHandler:^BOOL(NSRect dstRect) {

                                            NSSize imageSize = [image size];
                                            NSSize imageViewSize = weakSelf.bounds.size; // Yes, do not use dstRect.

                                            NSSize newImageSize = imageSize;

                                            CGFloat imageAspectRatio = imageSize.height/imageSize.width;
                                            CGFloat imageViewAspectRatio = imageViewSize.height/imageViewSize.width;

                                            if (imageAspectRatio < imageViewAspectRatio) {
                                                // Image is more horizontal than the view. Image left and right borders need to be cropped.
                                                newImageSize.width = imageSize.height / imageViewAspectRatio;
                                            }
                                            else {
                                                // Image is more vertical than the view. Image top and bottom borders need to be cropped.
                                                newImageSize.height = imageSize.width * imageViewAspectRatio;
                                            }

                                            NSRect srcRect = NSMakeRect(imageSize.width/2.0-newImageSize.width/2.0,
                                                                        imageSize.height/2.0-newImageSize.height/2.0,
                                                                        newImageSize.width,
                                                                        newImageSize.height);

                                            [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

                                            [image drawInRect:dstRect // Interestingly, here needs to be dstRect and not self.bounds
                                                     fromRect:srcRect
                                                    operation:NSCompositingOperationCopy
                                                     fraction:1.0
                                               respectFlipped:YES
                                                        hints:@{NSImageHintInterpolation: @(NSImageInterpolationHigh)}];

                                            return YES;
                                        }];

        [scaleToFillImage setCacheMode:NSImageCacheNever]; // Hence it will automatically redraw with new frame size of the image view.

        [super setImage:scaleToFillImage];
}
- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img errorImage:(NSImage *)errorImg andDisplaySpinningWheel:(BOOL)usesSpinningWheel{
    [self cancelDownload];
    
    self.isLoadingImage = YES;
    self.didFailLoadingImage = NO;
    self.userDidCancel = NO;
    
    self.image = img;
    errorImage = errorImg;
    imageDownloadData = [NSMutableData data];
#if !__has_feature(objc_arc)
	[ imageDownloadData retain ];
#endif
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    
    imageURLConnection = conn;
    
    if(usesSpinningWheel){
        
        //If the NSImageView size is 64+ height and 64+ width display Spinning Wheel 32x32
        if (self.frame.size.height >= 64 && self.frame.size.width >= 64){
            spinningWheel = [[NSProgressIndicator alloc] init];
            [spinningWheel setStyle:NSProgressIndicatorSpinningStyle];
            [self addSubview:spinningWheel];
            [spinningWheel setDisplayedWhenStopped:NO];
            [spinningWheel setFrame: NSMakeRect(self.frame.size.width * 0.5 - 16, self.frame.size.height * 0.5 - 16, 32, 32)];
            [spinningWheel setControlSize:NSControlSizeRegular];
            [spinningWheel startAnimation:self];
            
        //If not, and size between 63 and 16 height and 63 and 16 width display Spinning Wheel 16x16
        }else if((self.frame.size.height < 64 && self.frame.size.height >= 16) && (self.frame.size.width < 64 && self.frame.size.width >= 16)){
            spinningWheel = [[NSProgressIndicator alloc] init];
            [spinningWheel setStyle:NSProgressIndicatorSpinningStyle];
            [self addSubview:spinningWheel];
            [spinningWheel setDisplayedWhenStopped:NO];
            [spinningWheel setFrame: NSMakeRect(self.frame.size.width * 0.5 - 8, self.frame.size.height * 0.5 - 8, 16, 16)];
            [spinningWheel setControlSize:NSControlSizeSmall];
            [spinningWheel startAnimation:self];
        }
    }
}

- (void)cancelDownload{
    self.userDidCancel = YES;
    self.isLoadingImage = NO;
    self.didFailLoadingImage = NO;
    
    [self deleteToolTips];
    
    [spinningWheel stopAnimation:self];
    [spinningWheel removeFromSuperview];
    
    [imageURLConnection cancel];
    imageURLConnection = nil;
    imageDownloadData = nil;
    errorImage = nil;
    self.image = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageDownloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.isLoadingImage = NO;
    self.didFailLoadingImage = YES;
    self.userDidCancel = NO;
    
    [spinningWheel stopAnimation:self];
    [spinningWheel removeFromSuperview];
    
    imageDownloadData = nil;
    imageURLConnection = nil;
    
    self.image = errorImage;
    errorImage = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.didFailLoadingImage = NO;
    self.userDidCancel = NO;
    
    NSData *data = imageDownloadData;
    NSImage *img = [[NSImage alloc] initWithData:data];
    
    if(img){ //if NSData is from an image
        self.image = img;
        self.isLoadingImage = NO;
        
        [spinningWheel stopAnimation:self];
        [spinningWheel removeFromSuperview];
        imageDownloadData = nil;
        imageURLConnection = nil;
        errorImage = nil;
    }else{
        [self connection:nil didFailWithError:nil];
    }
}

-(void)setToolTipWhileLoading:(NSString *)ttip1 whenFinished:(NSString *)ttip2 andWhenFinishedWithError:(NSString *)ttip3{
    self.toolTipWhileLoading = ttip1;
    self.toolTipWhenFinished = ttip2;
    self.toolTipWhenFinishedWithError = ttip3;
}

- (void)deleteToolTips{
    self.toolTip = @"";
    self.toolTipWhileLoading = @"";
    self.toolTipWhenFinished = @"";
    self.toolTipWhenFinishedWithError = @"";
}


#pragma mark Mouse Enter Events to display tooltips
- (void)mouseEntered:(NSEvent *)theEvent{
    if (!self.userDidCancel){ //if the user didn't cancel the operation show the tooltips
        
        if (self.isLoadingImage){ //if is loading image
        
            if(self.toolTipWhileLoading != nil && ![self.toolTipWhileLoading isEqualToString:@""]){
                self.toolTip = self.toolTipWhileLoading;
            }else{
                self.toolTip = @"";
            }
            
        }else if(self.didFailLoadingImage){ //if connection did fail
            
            if(self.toolTipWhenFinishedWithError != nil && ![self.toolTipWhenFinishedWithError isEqualToString:@""]){
                self.toolTip = self.toolTipWhenFinishedWithError;
            }else{
                self.toolTip = @"";
            }
            
        }else if(!self.isLoadingImage){ //if it's not loading image
        
            if(self.toolTipWhenFinished != nil && ![self.toolTipWhenFinished isEqualToString:@""]){
                self.toolTip = self.toolTipWhenFinished;
            }else{
                self.toolTip = @"";
            }
            
        }
        
    }
}

- (void)updateTrackingAreas{
    if(trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
}

@end

