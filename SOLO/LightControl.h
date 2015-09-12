//
//  LightControl.h
//  SOLO
//
//  Created by Lei Zheng on 3/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "BaseViewController.h"
#import "ISColorWheel.h"
#import "OBShapedButton.h"

@interface LightControl : BaseViewController <ISColorWheelDelegate>
@property (strong,nonatomic) ISColorWheel *colorWheel;
@property (strong,nonatomic) UISlider *lightnessSlider;
- (IBAction)Switch_onoff:(id)sender;
- (IBAction)Switch_gray:(id)sender;
- (IBAction)Switch_color:(id)sender;
@property (weak, nonatomic) IBOutlet OBShapedButton *Btn_color;
@property (weak, nonatomic) IBOutlet OBShapedButton *Btn_gray;
@property (weak, nonatomic) IBOutlet OBShapedButton *Btn_on;

@end
