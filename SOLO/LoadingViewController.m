//
//  LoadingViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "LoadingViewController.h"
#import "SOLO.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [[SOLO sharedInstance].user clear];
    if (![[SOLO sharedInstance].user found]) {
        if ([[SOLO sharedInstance] attemptedLogin]) {
            [self performSegueWithIdentifier:@"login" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"register" sender:nil];
        }
    } else {
        

        [[SOLO sharedInstance].webClient cores:^(NSArray *cores) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (SPKCore *core in cores) {
                    
                    [[SOLO sharedInstance] addCore:core];
                    [[SOLO sharedInstance] activateCore:core];
                    
                }
               
                
                if ([SOLO sharedInstance].cores.count) {
                    [self performSegueWithIdentifier:@"deviceList" sender:nil];
                } else {
                    [self performSegueWithIdentifier:@"deviceList" sender:nil];
                }
            });
        } failure:^{
            NSLog(@"Problem getting list of cores");
        }];
        
        //get person list info from database
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showLogin
{
    [self performSegueWithIdentifier:@"login" sender:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
