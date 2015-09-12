//
//  BaseViewController.m
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, assign) CGFloat kbSizeHeight;

- (IBAction)doneClicked:(id)sender;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.keyboardStatus = FALSE;
    
    self.keyboardDoneButtonView = [[UIToolbar alloc] init];
    [self.keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [self.keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    

    // Do any additional setup after loading the view.
}

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyboardStatus = FALSE;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.keyboardStatus = FALSE;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.kbSizeHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    self.kbSizeHeight -= [self keyboardHeightAdjust];
    
    if (!self.keyboardStatus) {
        [self setViewMovedUp:YES];
        
    } else {
        [self setViewMovedUp:NO];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.keyboardStatus) {
        [self setViewMovedUp:NO];
    }
}

- (void)dismissKeyboard
{
    
}

- (CGFloat)keyboardHeightAdjust
{
    return 90.0;
}

#pragma mark - Methods

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= self.kbSizeHeight;
        rect.size.height += self.kbSizeHeight;
        self.keyboardStatus = TRUE;
    } else {
        // revert back to the normal state.
        rect.origin.y += self.kbSizeHeight;
        rect.size.height -= self.kbSizeHeight;
        self.keyboardStatus = FALSE;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void) setKeyboardStatus:(bool)keyboardStatus
{
    _keyboardStatus = keyboardStatus;
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
