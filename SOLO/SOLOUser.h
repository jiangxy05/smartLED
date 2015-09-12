//
//  SOLOUser.h
//  SOLO
//
//  Created by Lei Zheng on 2/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOLOUser : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL firstTime;
@property (nonatomic, strong) NSString *token;

- (BOOL)found;
- (void)store;
- (void)clear;


@end
