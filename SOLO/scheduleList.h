//
//  scheduleList.h
//  SOLO
//
//  Created by Lei Zheng on 3/14/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "BaseViewController.h"

@interface scheduleList : UITableViewController <UITableViewDelegate>
-(IBAction)unwindFromAddSchedule:(UIStoryboardSegue *)segue;
@end
