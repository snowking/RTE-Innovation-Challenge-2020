//
//  NSImage+ZKImage.m
//  ZKBody
//
//  Created by King on 2019/9/27.
//  Copyright © 2019 King. All rights reserved.
//

#import "NSImage+ZKImage.h"

#import <AppKit/AppKit.h>


@implementation NSImage (ZKImage)

-(NSImage*)rotageByDegrees:(CGFloat)degrees{
    
    NSImage *sourceImage = self;
       
    NSSize srcSize = [sourceImage size];
    float srcw = srcSize.width;
    float srch= srcSize.height;
        
    if((!sourceImage) || srcw == 0 || srch == 0){
        return nil;
    }
        
    NSRect rotateRect = NSMakeRect(0, 0, srcw, srch);
    
    NSImage *rotatedImage = [[NSImage alloc] initWithSize:srcSize];
        
    [rotatedImage lockFocus];
        
    NSAffineTransform *transform = [NSAffineTransform transform];
        
        //方法一：180度旋转
        //其实直接用下面的方法就可以了，但是查资料的过程发现旋转的资料也比较少，顺便就一起放出来了，有需要可以根据情况修改旋转角度
    float rotateDeg = degrees;
    
    [transform translateXBy:(0.5 * srcw) yBy: ( 0.5 * srch)];  //将坐标系原点移至图片中心点
        [transform rotateByDegrees:rotateDeg];//以图片中心为原点，旋转传入的度数
    [transform translateXBy:(-0.5 * srcw) yBy: (- 0.5 * srch)]; //将坐标系回复原状
        
        //水平镜像反转
    [transform scaleXBy:-1.0 yBy:1.0];
        
    [transform translateXBy:-srcw yBy:0];

        //方法二：竖直镜像反转
    //    [transform scaleXBy:1.0 yBy:-1.0];
    //
    //    [transform translateXBy:0 yBy:-srch];
        
    [transform concat];
        
    [sourceImage drawInRect:rotateRect fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
        
    [rotatedImage unlockFocus];

    return rotatedImage;

}




@end
