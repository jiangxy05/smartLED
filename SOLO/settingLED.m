//
//  settingLED.m
//  SOLO
//
//  Created by Lei Zheng on 3/14/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "settingLED.h"
#import "SensorSwitchCell.h"

@interface settingLED ()
@property (strong, nonatomic) IBOutlet UITableView *settingLED;
- (IBAction)clickUpdate:(id)sender;

@end

@implementation settingLED

- (IBAction)clickUpdate:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.settingLED registerNib:[UINib nibWithNibName:@"SensorSwitchCell" bundle:nil] forCellReuseIdentifier:@"sensorSwitchCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.settingLED setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        return (self.settingLED.frame.size.height)/3;
    }
    else{

        return (self.settingLED.frame.size.height)/6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SensorSwitchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"sensorSwitchCell"];
    if (cell == nil)
    {
        cell = [[SensorSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"sensorSwitchCell"];
        
        
    }
    
    switch (indexPath.section) {
        case 0:
            cell.label1.text=@"light sensor";
            cell.label2.text=@"light threshold";
            cell.label3.hidden=YES;
            cell.label4.hidden=YES;
            cell.slider2.hidden=YES;
            cell.slider3.hidden=YES;
            break;
        case 1:
            cell.label1.text=@"UV Sensor";
            cell.label2.text=@"UV threshold";
            cell.label3.hidden=YES;
            cell.label4.hidden=YES;
            cell.slider2.hidden=YES;
            cell.slider3.hidden=YES;
            break;
            
        case 2:
            
            cell.label1.text=@"motion sensor";
            cell.label2.text=@"light lasting time";
            cell.label3.hidden=YES;
            cell.label4.hidden=YES;
            cell.slider2.hidden=YES;
            cell.slider3.hidden=YES;
            break;
            
        case 3:
            cell.label1.text=@"thermo sensor";
            cell.label2.text=@"outdoor high temp";
            cell.label3.text=@"outdoor low temp";
            cell.label4.text=@"highest LED temp";
            cell.slider2.hidden=NO;
            cell.slider3.hidden=NO;
            break;
            
        default:
            break;
    }
    
    
    return cell;
}
#pragma mark - Table view data source





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
