//
//  LEDCell.h
//  SOLO
//
//  Created by Lei Zheng on 4/2/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface LEDCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ledImage;
@property (weak, nonatomic) IBOutlet UILabel *ledName;
@property (weak, nonatomic) IBOutlet UILabel *lightReading;
@property (weak, nonatomic) IBOutlet UILabel *UVReading;
@property (weak, nonatomic) IBOutlet UILabel *tempReading;
@property (nonatomic) BOOL status;
@property (nonatomic) BOOL isGroup;

@end
