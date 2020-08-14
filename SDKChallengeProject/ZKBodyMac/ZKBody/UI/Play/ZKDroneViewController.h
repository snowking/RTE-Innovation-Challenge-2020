//
//  ZKDroneViewController.h
//  ZKBody
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKPlayViewController.h"
#import "ZKSlider.h"
#import <MapKit/MapKit.h>

@interface ZKDroneViewController : ZKPlayViewController

@property (nonatomic, strong) IBOutlet NSButton *howToPlayButton;
@property (nonatomic, strong) IBOutlet NSButton *virtualSwitch;
@property (nonatomic, strong) IBOutlet NSButton *autoCruiseSwitch;
@property (nonatomic, strong) IBOutlet NSButton *FPVSwitch;

@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;

@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) NSArray *autoCruiseArray;
@property (nonatomic, assign) CLLocationCoordinate2D homeLocation;

@property (nonatomic, strong) NSDictionary *midPoint;
@property (nonatomic, strong) NSDictionary *endPoint;

@property (nonatomic, strong) IBOutlet ZKSlider *gimbalSlider;
@property (nonatomic, strong) IBOutlet ZKSlider *focalLengthSlider;



-(IBAction)focalLengthChanged:(id)sender;
-(IBAction)gimbalSliderChanged:(id)sender;

@end

