//
//  RegisterViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "RegisterViewController.h"
#import "SOLO.h"
#import "SPKWebClient.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RegisterPhoneNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.RegisterPhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    
    self.RegisterPW.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.RegisterPW.leftViewMode = UITextFieldViewModeAlways;
    
    self.RegisterPhoneNumber.inputAccessoryView=self.keyboardDoneButtonView;
    self.RegisterPW.inputAccessoryView=self.keyboardDoneButtonView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionError:) name:kSPKWebClientConnectionError object:nil];
    
    [self.BtnRegister setTitle:@"Register" forState:UIControlStateNormal];
    self.BtnRegister.enabled = YES;
    self.RegisterPhoneNumber.enabled = YES;
    self.RegisterPW.enabled = YES;
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //   [[NSNotificationCenter defaultCenter] removeObserver:self name:kSPKWebClientConnectionError object:nil];
}

- (void)dismissKeyboard
{
    if (self.RegisterPhoneNumber.isFirstResponder) {
        [self.RegisterPhoneNumber resignFirstResponder];
    } else if (self.RegisterPW.isFirstResponder) {
        [self.RegisterPW resignFirstResponder];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ClickLogin:(id)sender {
    
    [self performSegueWithIdentifier:@"login" sender:nil];
}
- (IBAction)ClickRegister:(id)sender {
    
    self.RegisterPhoneNumber.enabled = NO;
    self.RegisterPW.enabled = NO;
    
    [self.BtnRegister setTitle:@"SIGNING UP..." forState:UIControlStateNormal];
    
    SOLOUser *user = [SOLO sharedInstance].user;
    user.userId = self.RegisterPhoneNumber.text;
    user.password = self.RegisterPW.text;
    [SOLO sharedInstance].attemptedLogin = NO;
    
//    [self spinSpinner:YES];
    
    [[SOLO sharedInstance].webClient register:^(NSString *authToken) {
        user.token = authToken;
        user.firstTime = YES;
        [user store];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self spinSpinner:NO];
            self.ErrMsg.text = @"";
            [self performSegueWithIdentifier:@"loading" sender:sender];
        });
    } failure:^(NSString *failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self spinSpinner:NO];
            self.RegisterPhoneNumber.enabled = YES;
            self.RegisterPW.enabled = YES;
            [self.BtnRegister setTitle:@"SIGN UP" forState:UIControlStateNormal];
            
            if (!failure) {
                self.ErrMsg.text = @"Email and/or password invalid";
            } else {
                self.ErrMsg.text = failure;
            }
            
        });
    }];

}
@end
