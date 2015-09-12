//
//  scheduleList.m
//  SOLO
//
//  Created by Lei Zheng on 3/14/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "scheduleList.h"
#import "scheduleListCell.h"
#import "setSchedule.h"
@interface scheduleList ()

@property (strong, nonatomic) IBOutlet UITableView *scheduleList;

@end

@implementation scheduleList

- (void)viewDidLoad {
    [super viewDidLoad];
 

        // Do any additional setup after loading the view.
}

-(IBAction)unwindFromAddSchedule:(UIStoryboardSegue *)segue{
    
}



-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.scheduleList setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    scheduleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleList"];
    
    cell.switchOn.enabled=YES;
    
    cell.timeLabel.text=@"From 9pm to 6 am";
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"hit");
    [self performSegueWithIdentifier:@"setSchedule" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 
 if ([segue.identifier isEqualToString:@"setSchedule"]) {
 
     setSchedule *tempController = (setSchedule *)[segue.destinationViewController visibleViewController];
     if ([sender isKindOfClass:[UIButton class]]) {
         
         tempController.isEdit = FALSE;
     }
     else{
         
         tempController.isEdit = TRUE;
     }
 
 
 }
 }



@end
