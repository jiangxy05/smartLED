//
//  LoginViewController.h
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *UserPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *UserPassword;
@property (weak, nonatomic) IBOutlet UIButton *BtnLogin;
@property (weak, nonatomic) IBOutlet UILabel *ErrMsg;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingSpin;
- (IBAction)ClickRegister:(id)sender;
- (IBAction)ClickForgetPW:(id)sender;
- (IBAction)ClickLogin:(id)sender;

@end
