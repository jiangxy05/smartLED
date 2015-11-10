//
//  AddLedCell.h
//  SOLO
//
//  Created by Lei Zheng on 4/26/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLedCellDelegate <NSObject>
@required
- (void) claimLed: (NSString *)ledID;
@end

@interface AddLedCell : UITableViewCell
{
    id <AddLedCellDelegate> delegate;}
@property (weak, nonatomic) IBOutlet UILabel *ledID;

@property (weak, nonatomic) IBOutlet UITextField *ledDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnClaim;
- (IBAction)clickClaim:(id)sender;
@property (retain) id delegate;

@end

