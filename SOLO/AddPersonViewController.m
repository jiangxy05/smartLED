//
//  AddPersonViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/16/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "AddPersonViewController.h"
#import "SOLOTimer.h"
#import "SPKSmartConfig.h"

#import "SOLO.h"
#import "NSData+HexString.h"
#import "SPKCore.h"
#import "AddLedCell.h"

#import "FirstTimeConfig.h"

@interface AddPersonViewController () <AddLedCellDelegate>
@property (nonatomic, strong) SPKSmartConfig *smartConfig;
@property (nonatomic, strong) dispatch_queue_t timerQueue;
@property (nonatomic, strong) SOLOTimer *timer;
@property (nonatomic) NSUInteger LEDCount;
@end

@implementation AddPersonViewController

- (void) claimLed: (NSString *)ledID{
    
    NSLog(@"im here");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.smartConfig = [SOLO sharedInstance].smartConfig;
    self.timerQueue = dispatch_queue_create("networkSettingsTimer", DISPATCH_QUEUE_SERIAL);
    self.LEDCount = 0;
    [self.showCores registerNib:[UINib nibWithNibName:@"AddLedCell" bundle:nil] forCellReuseIdentifier:@"addLedCell"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreHello:) name:kSPKSmartConfigHelloCore object:[SOLO sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiChanged:) name:kSPKWebClientReachabilityChange object:nil];
    
    
    self.text_SSID.text = @"";
    self.text_PW.text = @"";
    self.label_err.text = @"";
    self.LEDCount = 0;
    
//    self.spinnerImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self handleWifi];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSPKSmartConfigHelloCore object:[SOLO sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSPKWebClientReachabilityChange object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[[SOLO sharedInstance] coresInState:SPKCoreStateAttached] count];
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddLedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addLedCell"];
    if (cell == nil) {
        cell = [[AddLedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addLedCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //SPKCore *c=[[SOLO sharedInstance] coresInState:SPKCoreStateAttached][indexPath.row];
    //cell.ledID.text=[NSString stringWithFormat:@"Led %@ is identified!", [c.coreId hexString]];
    cell.btnClaim.titleLabel.text=@"Claim";
    cell.delegate=self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)dismissKeyboard
{
    if (self.text_SSID.isFirstResponder) {
        [self.text_SSID resignFirstResponder];
    } else if (self.text_PW.isFirstResponder) {
        [self.text_PW resignFirstResponder];
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

- (IBAction)Click_Connect:(id)sender {
    if (self.smartConfig.isBroadcasting) {
//        [self spinSpinner:NO];
        
        [self.timer invalidate];
        [self.smartConfig stopTransmittingSettings];
        [self.smartConfig stopCoAPListening];
        [self.Btn_connect setTitle:@"CONNECT" forState:UIControlStateNormal];
        [self.Btn_connect setBackgroundImage:[UIImage imageNamed:@"connect-btn"] forState:UIControlStateNormal];
        self.text_SSID.enabled = YES;
        self.text_PW.enabled = YES;

    } else {

//        [self spinSpinner:YES];
        
        NSUInteger duration = 90.0;
#if TARGET_IPHONE_SIMULATOR
        duration = 20.0;
#endif
        self.timer = [SOLOTimer repeatingTimerWithTimeInterval:duration queue:self.timerQueue block:^{
            [self timedOut];
        }];
        
        [self.Btn_connect setTitle:@"STOP" forState:UIControlStateNormal];
        [self.Btn_connect setBackgroundImage:[UIImage imageNamed:@"not-found-btn"] forState:UIControlStateNormal];
        self.text_SSID.enabled = NO;
        self.text_PW.enabled = NO;
        
        NSString *ipAddress = [FirstTimeConfig getGatewayAddress];
        DDLogInfo(@"Using router address: %@", ipAddress);
//        NSString *aesKey = self.aesKeyButton.selected ? self.keyTextField.text : @"sparkdevices2013";
        [self.smartConfig configureWithPassword:self.text_PW.text aesKey:@"smallfishLED"];
        [self.smartConfig startTransmittingSettings];
        
#if TARGET_IPHONE_SIMULATOR
        uint8_t coreId[] = { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 };
        NSNotification *notification = [[NSNotification alloc] initWithName:kSPKSmartConfigHelloCore object:[SPKSpark sharedInstance].smartConfig userInfo:@{ @"coreId": [NSData dataWithBytes:coreId length:12] }];
        [[NSNotificationCenter defaultCenter] performSelectorInBackground:@selector(postNotification:) withObject:notification];
#endif
    }
}

#pragma mark - Notifications

- (void)wifiChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleWifi];
    });
}

- (void)coreHello:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.showCores reloadData];
    });
}

- (void)timedOut
{
    [self.timer invalidate];
    if ([SOLO sharedInstance].smartConfig.isBroadcasting) {
        [[SOLO sharedInstance].smartConfig stopTransmittingSettings];
        [[SOLO sharedInstance].smartConfig stopCoAPListening];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
 //       [self spinSpinner:NO];
    //    [self performSegueWithIdentifier:@"notfound" sender:nil];
    });
}

- (void)handleWifi
{
#if TARGET_IPHONE_SIMULATOR
    self.text_SSID.text = @"Simulator";
#else
    if ([FirstTimeConfig getSSID]) {
        self.text_SSID.text = [FirstTimeConfig getSSID];
        self.Btn_connect.enabled = YES;
    } else {
//        [self spinSpinner:NO];
        self.text_SSID.text = @"No Wifi";
        self.Btn_connect.enabled = NO;
        [[[UIAlertView alloc] initWithTitle:@"Smart Config Error" message:@"You must be connected to a Wi-Fi network to connect your Core." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
#endif
}


#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
@end
