//
//  RegisterViewController.h
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
- (IBAction)ClickLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPW;
@property (weak, nonatomic) IBOutlet UIButton *BtnRegister;
- (IBAction)ClickRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ErrMsg;

@end
