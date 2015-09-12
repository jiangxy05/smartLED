//
//  AddLedCell.m
//  SOLO
//
//  Created by Lei Zheng on 4/26/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "AddLedCell.h"

@implementation AddLedCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickClaim:(id)sender {
    if (self.delegate!=nil) {
        [self.delegate claimLed:self.ledID.text];
    }
    
}
@end
