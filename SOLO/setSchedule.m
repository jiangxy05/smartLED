//
//  setSchedule.m
//  SOLO
//
//  Created by Lei Zheng on 3/14/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "setSchedule.h"
#import "SelectDay.h"

@interface setSchedule ()

@property (nonatomic) UIButton *btn_del;

@end


@implementation setSchedule

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isEdit) {
        _btn_del=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btn_del addTarget:self action:@selector(clickDel) forControlEvents:UIControlEventTouchDown];
        [_btn_del setTitle:@"Delete" forState:UIControlStateNormal];
        _btn_del.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height*9/10, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/10);
        _btn_del.backgroundColor=[UIColor redColor];
        _btn_del.opaque=TRUE;
        [self.view addSubview:_btn_del];
        
        }
           // Do any additional setup after loading the view.
}

-(void)clickDel{
    
    [self performSegueWithIdentifier:@"delete" sender:nil];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect tableBounds = self.tableView.bounds;
    _btn_del.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height*9/10+tableBounds.origin.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/10);
    [self.view bringSubviewToFront:self.btn_del];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 || indexPath.section==1) {
        return 150;
    }
    else

        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2 && indexPath.row==0) {
        NSLog(@"hahah");
        [self performSegueWithIdentifier:@"selectDay" sender:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    if ([segue.identifier isEqualToString:@"selectDay"]) {
     
            SelectDay *tempController = (SelectDay *)segue.destinationViewController;
            if ([sender isKindOfClass:[UIButton class]]) {
                
                tempController.isEdit = TRUE;
            }
            else{
                
                tempController.isEdit = FALSE;
            }
                
    
    }
}


@end
