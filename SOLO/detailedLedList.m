//
//  detailedLedList.m
//  SOLO
//
//  Created by Lei Zheng on 5/1/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "detailedLedList.h"
#import "SOLO.h"
#import "LEDCell.h"

@interface detailedLedList ()

@end

@implementation detailedLedList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height/5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *groupName=[SOLO sharedInstance].activeGroup;
    return [[SOLO sharedInstance] coresInGroup:groupName].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LEDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDCell"];
    if (cell == nil) {
        cell = [[LEDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LEDCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *groupName=[SOLO sharedInstance].activeGroup;

    SPKCore *core = [[SOLO sharedInstance] coresInGroup:groupName][indexPath.row];
    cell.isGroup = FALSE;
    
    cell.lightReading.text=[NSString stringWithFormat:@"%@", core.name];
    cell.UVReading.text=[NSString stringWithFormat:@"%d/%d", core.lightReading,core.UVReading];
    cell.tempReading.text=[NSString stringWithFormat:@"%dF/%dF", core.tempLed,core.tempLocal];
    cell.ledImage.image=[UIImage imageNamed:@"bulb_40.png"];
    cell.ledImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.ledImage.clipsToBounds=YES;
    
    if (!core.connected) {
        cell.backgroundColor=[UIColor grayColor];
        cell.status=FALSE;
    }
    else
        cell.status=TRUE;


    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LEDCell *cell = (LEDCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.status) {
        NSString *groupName=[SOLO sharedInstance].activeGroup;
        SPKCore *core = [[SOLO sharedInstance] coresInGroup:groupName][indexPath.row];
        [[SOLO sharedInstance] activateCore:core];
        
        [self performSegueWithIdentifier:@"ledOperation" sender:nil];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
