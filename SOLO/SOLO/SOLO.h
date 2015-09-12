//
//  SOLO.h
//  SOLO
//
//  Created by Lei Zheng on 2/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOLOUser.h"
#import "SPKWebClient.h"
#import "SPKSmartConfig.h"
#import "SPKCore.h"


/*
 This is the main class for the application. It should only used as a singleton
 and any class should feel free to access it. There is no initialization needs
 to be done on it.
 */

@interface SOLO : NSObject

@property (nonatomic, readonly) SOLOUser *user;
@property (nonatomic, assign) BOOL attemptedLogin;
@property (nonatomic, readonly) SPKWebClient *webClient;
@property (nonatomic, readonly) SPKSmartConfig *smartConfig;
@property (nonatomic, readonly) SPKCore *activeCore;
@property (nonatomic, readonly) NSString *activeGroup;

+ (SOLO *)sharedInstance;

- (void)clearCores;
- (NSArray *)cores;
- (NSArray *)groups;
- (void)addCore:(SPKCore *)core;
- (void)addGroup:(NSString *)groupName;
- (NSArray *)coresInState:(SPKCoreState)state;
- (NSArray *)coresInGroup:(NSString *)groupName;
- (void)activateCore:(SPKCore *)core;
- (void)activateGroup:(NSString *)groupName;


@end
