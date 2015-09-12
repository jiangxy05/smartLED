//
//  PersonListViewController.h
//  SOLO
//
//  Created by Lei Zheng on 2/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *PersonTable;

-(IBAction)backFromLedOperation:(UIStoryboardSegue *)segue;
@end
