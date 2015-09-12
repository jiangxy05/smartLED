//
//  SOLOTimer.h
//  SOLO
//
//  Created by Lei Zheng on 4/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOLOTimer : NSObject

+ (SOLOTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

- (void)invalidate;
@end
