//
//  SensorSwitchCell.h
//  SOLO
//
//  Created by Lei Zheng on 4/16/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SensorSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;

@end
