//
//  BaseViewController.h
//  SOLO
//
//  Created by Lei Zheng on 2/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (CGFloat)keyboardHeightAdjust;
- (void)dismissKeyboard;
- (void)setViewMovedUp:(BOOL)movedUp;

@property (nonatomic) UIToolbar* keyboardDoneButtonView;

@property (nonatomic) bool keyboardStatus;

@end
