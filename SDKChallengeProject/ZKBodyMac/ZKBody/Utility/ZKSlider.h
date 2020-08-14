//
//  ZKSlider.h
//  TestRotate
//
//  Created by King on 2020/3/10.
//  Copyright © 2020 King. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface ZKSlider : NSSlider

@property (nonatomic) BOOL doNotUpdate;
-(void)updateValue:(int)value;

@end

