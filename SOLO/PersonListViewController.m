//
//  PersonListViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "PersonListViewController.h"
#import "SWRevealViewController.h"
#import "LEDCell.h"
#import "SOLO.h"
#import "SPKCore.h"


@interface PersonListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end

@implementation PersonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.PersonTable registerNib:[UINib nibWithNibName:@"LEDCell" bundle:nil] forCellReuseIdentifier:@"LEDCell"];
    self.navigationItem.title=@"Lights";
    
    NSLog(@"start");
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuBtn setTarget: self.revealViewController];
        [self.menuBtn setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.PersonTable.allowsMultipleSelectionDuringEditing=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SOLO sharedInstance].groups.count+[[SOLO sharedInstance] coresInGroup:@"noGroup"].count-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height/5;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]
                                                title:@"Group"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]
                                                title:@"Disclaim"];
    
    return rightUtilityButtons;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDCell"];
    if (cell == nil) {
        cell = [[LEDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LEDCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row<=[[SOLO sharedInstance] coresInGroup:@"noGroup"].count) {
        
        SPKCore *core = [SOLO sharedInstance].cores[indexPath.row];
        cell.rightUtilityButtons=[self rightButtons];
        cell.delegate=self;
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
    }
    else{
        cell.isGroup = TRUE;
        cell.status = TRUE;
        
        
    }
        
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"Group button was pressed");
            //  NSIndexPath *cellIndexPath = [self.PersonTable indexPathForCell:cell];
            break;
        case 1:
        {
            // Disclaim button was pressed
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                           message:@"This is an alert."
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Disclaim" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LEDCell *cell = (LEDCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.status && (!cell.isGroup)) {
        
        [[SOLO sharedInstance] activateCore:[SOLO sharedInstance].cores[indexPath.row]];
        
        [[SOLO sharedInstance] activateGroup:@"noGroup"];
        
        [self performSegueWithIdentifier:@"userManager" sender:nil];
    }
    else if (cell.isGroup){
        
        [[SOLO sharedInstance] activateGroup:cell.description];
        [self performSegueWithIdentifier:@"detailedLedList" sender:nil];
    }
    
}

-(IBAction)backFromLedOperation:(UIStoryboardSegue *)segue{
    
    
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
