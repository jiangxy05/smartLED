//
//  SPKCore.m
//  Spark IOS
//
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "SPKCore.h"

@interface SPKCore ()


@end

@implementation SPKCore

- (id)init
{
    if (self = [super init]) {
        _color = UIColorFromRGB(0xFFFFFF);
        _name = [self generateName];
        _state = SPKCoreStateUnknown;
        _connected = TRUE;
        _sensorStatus = 0;
        _intensity = 1;
        _connected = TRUE;
        
    }

    return self;
}

- (void)reset
{
    
}

#pragma mark - Private Methods

- (void)configurePins
{
    
}

- (NSString *)generateName
{
    
    return @"SmallFish";
}

@end
