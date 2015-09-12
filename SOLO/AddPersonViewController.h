//
//  AddPersonViewController.h
//  SOLO
//
//  Created by Lei Zheng on 2/16/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddPersonViewController : BaseViewController 
@property (weak, nonatomic) IBOutlet UITextField *text_SSID;
@property (weak, nonatomic) IBOutlet UITextField *text_PW;
@property (weak, nonatomic) IBOutlet UILabel *label_err;
@property (weak, nonatomic) IBOutlet UITableView *showCores;
@property (weak, nonatomic) IBOutlet UIButton *Btn_connect;
- (IBAction)Click_Connect:(id)sender;

@end
