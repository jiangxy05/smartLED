//
//  LightControl.m
//  SOLO
//
//  Created by Lei Zheng on 3/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "LightControl.h"
#import "SOLO.h"
#import "SPKCore.h"

@interface LightControl ()



@end

@implementation LightControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    CGRect frame;
    frame.size.width=self.view.bounds.size.width*0.8;
    frame.size.height=frame.size.width;
    frame.origin=CGPointMake(self.view.bounds.size.width/2-frame.size.width/2, self.view.bounds.size.height/2-frame.size.height/2);
    
    self.colorWheel=[[ISColorWheel alloc] initWithFrame:frame];
    self.colorWheel.delegate=self;
    self.colorWheel.continuous=TRUE;
 //   self.colorWheel.currentColor=[SOLO sharedInstance].activeCore.color;
    self.colorWheel.currentColor=UIColorFromRGB(0xFFFFFF);
    
    [self.view addSubview:self.colorWheel];
  
    self.lightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * .1,self.view.bounds.size.height*0.1,                                self.view.bounds.size.width * .8,
                                                                      self.view.bounds.size.height * .2)];
    self.lightnessSlider.minimumValue = 0.0;
    self.lightnessSlider.maximumValue = 1.0;
//    self.lightnessSlider.value = [SOLO sharedInstance].activeCore.intensity;
    self.lightnessSlider.value = 1;
    self.lightnessSlider.continuous = true;
    [self.lightnessSlider addTarget:self action:@selector(changelightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.lightnessSlider];
    
    if (self.lightnessSlider.value==0) {
        self.Btn_on.enabled=TRUE;
        self.Btn_gray=FALSE;
        self.Btn_color=FALSE;
    }
    
    // Do any additional setup after loading the view.
}

- (void)changelightness:(UISlider*)sender
{
    [SOLO sharedInstance].activeCore.intensity=self.lightnessSlider.value;
    
    
    [[SOLO sharedInstance].webClient setLED:[SOLO sharedInstance].activeCore task:@"Light"
                                    success:^(NSUInteger value) {
                                        
                                    }
                                    failure:^(NSString *err) {
                                        
                                    }];
   
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    
    [SOLO sharedInstance].activeCore.color=self.colorWheel.currentColor;

    
    [[SOLO sharedInstance].webClient setLED:[SOLO sharedInstance].activeCore task:@"Light"
                                    success:^(NSUInteger value) {
                                        
                                    }
                                    failure:^(NSString *err) {
                                        
                                    }];

   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Switch_onoff:(id)sender {

    
    
}

- (IBAction)Switch_gray:(id)sender {
    if (self.Btn_gray.enabled) {
        self.Btn_gray.enabled = FALSE;
        self.Btn_color.enabled = YES;
    }
}

- (IBAction)Switch_color:(id)sender {
    if (self.Btn_color.enabled) {
        self.Btn_gray.enabled = YES;
        self.Btn_color.enabled = FALSE;
    }
}
@end
