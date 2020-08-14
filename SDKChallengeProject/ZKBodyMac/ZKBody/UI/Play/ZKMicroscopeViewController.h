//
//  ZKMicroscopeViewController.h
//  ZKBody
//
//  Created by King on 2019/12/19.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKPlayViewController.h"


@interface ZKMicroscopeViewController : ZKPlayViewController

@property (nonatomic, strong) IBOutlet NSView *controlBarView;
@property (nonatomic, strong) IBOutlet NSView *controlBarEffectView;

@property (nonatomic, strong) IBOutlet NSSlider *xSlider;
@property (nonatomic, strong) IBOutlet NSSlider *ySlider;
@property (nonatomic, strong) IBOutlet NSSlider *focalLengthSliderTiny;
@property (nonatomic, strong) IBOutlet NSSlider *focalLengthSliderBig;

@property (nonatomic, strong) NSArray *sliders;
@property (nonatomic, strong) NSArray *glassArray;


-(IBAction)controlButtonClicked:(id)sender;

@end


