//
//  SPKCore.h
//  Spark IOS
//
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(uint8_t, SPKCoreState) {
    SPKCoreStateUnknown,
    SPKCoreStateHello,
    SPKCoreStateAttached,
    SPKCoreStateReady,
    SPKCoreStateAlreadyClaimed,
    SPKCoreStateFailed
};

@interface SPKCore : NSObject

@property (nonatomic, copy) NSData *coreId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSString *groupName;
@property (nonatomic, assign) SPKCoreState state;
@property (nonatomic, assign) UIColor *color;
@property (nonatomic, assign) NSInteger intensity;
@property (nonatomic, assign) NSInteger lightReading;
@property (nonatomic, assign) NSInteger UVReading;
@property (nonatomic, assign) NSInteger tempLed;
@property (nonatomic, assign) NSInteger tempLocal;

@property (nonatomic, assign) BOOL connected;

@property (nonatomic, assign) NSData *sensorStatus;
@property (nonatomic, assign) NSInteger lightThreshold;
@property (nonatomic, assign) NSInteger UVThreshold;
@property (nonatomic, assign) NSInteger motionTime;
@property (nonatomic, assign) NSInteger tempHigh;
@property (nonatomic, assign) NSInteger tempLow;
@property (nonatomic, assign) NSInteger tempLedHigh;


- (void)reset;

@end
