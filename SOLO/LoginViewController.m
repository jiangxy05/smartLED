//
//  LoginViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "LoginViewController.h"
#import "SOLOUser.h"
#import "SOLO.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UserPhoneNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.UserPhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    self.UserPhoneNumber.inputAccessoryView=self.keyboardDoneButtonView;
    self.UserPassword.inputAccessoryView=self.keyboardDoneButtonView;
    self.UserPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.UserPassword.leftViewMode = UITextFieldViewModeAlways;
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
    
    [self.BtnLogin setTitle:@"LOG IN" forState:UIControlStateNormal];
    self.BtnLogin.enabled = YES;
    self.UserPhoneNumber.enabled = YES;
    self.UserPassword.enabled = YES;
    
    self.LoadingSpin.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
 //   [[NSNotificationCenter defaultCenter] removeObserver:self name:kSPKWebClientConnectionError object:nil];
}

- (void)dismissKeyboard
{
    if (self.UserPhoneNumber.isFirstResponder) {
        [self.UserPhoneNumber resignFirstResponder];
    } else if (self.UserPassword.isFirstResponder) {
        [self.UserPassword resignFirstResponder];
    }
}

- (void)connectionError:(NSNotification *)notifications
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.UserPhoneNumber.enabled = YES;
        self.UserPassword.enabled = YES;
        [self.BtnLogin setTitle:@"LOG IN" forState:UIControlStateNormal];
    });
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL r1 = NO;

    
    NSString *s = self.UserPhoneNumber.text;
    if (textField == self.UserPhoneNumber) {
        s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    
    s = self.UserPassword.text;
    if (textField == self.UserPassword) {
        s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    r1 = s.length > 0;
    
    self.BtnLogin.enabled = r1;
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == self.UserPhoneNumber) {
        [self.UserPassword becomeFirstResponder];
    } else {
        [self.UserPassword resignFirstResponder];
        [self ClickLogin:textField];
    }
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ClickRegister:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:nil];
}

- (IBAction)ClickForgetPW:(id)sender {
}

- (IBAction)ClickLogin:(id)sender {
    self.UserPhoneNumber.enabled = NO;
    self.UserPassword.enabled = NO;
    
    [self.BtnLogin setTitle:@"LOGGING IN..." forState:UIControlStateNormal];
    
    SOLOUser *user = [SOLO sharedInstance].user;
    user.userId = self.UserPhoneNumber.text;
    user.password = self.UserPassword.text;
    [SOLO sharedInstance].attemptedLogin = YES;
    
    [self spinSpinner:YES];
    
    [[SOLO sharedInstance].webClient login:^(NSString *authToken) {
        user.token = authToken;
        [user store];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self spinSpinner:NO];
            self.ErrMsg.text = @"";
            [self performSegueWithIdentifier:@"loading" sender:sender];
        });
    } failure:^(NSString *failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self spinSpinner:NO];
            
            self.UserPhoneNumber.enabled = YES;
            self.UserPassword.enabled = YES;
            
            self.ErrMsg.text = @"Username and/or password incorrect";
            
            [self.BtnLogin setTitle:@"LOG IN" forState:UIControlStateNormal];
        });
    }];

}

- (void)spinSpinner:(BOOL)go
{
    if (go) {
        self.LoadingSpin.hidden = NO;
        
        CABasicAnimation *rotation;
        rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = [NSNumber numberWithFloat:0];
        rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
        rotation.duration = 1.1; // Speed
        rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        [self.LoadingSpin.layer addAnimation:rotation forKey:@"Spin"];
    } else {
        self.LoadingSpin.hidden = YES;
        [self.LoadingSpin.layer removeAllAnimations];
    }
}




@end
