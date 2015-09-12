//
//  SOLOTimer.m
//  SOLO
//
//  Created by Lei Zheng on 4/10/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "SOLOTimer.h"

@interface SOLOTimer ()

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) dispatch_source_t source;

@end

@implementation SOLOTimer

+ (SOLOTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    SOLOTimer *timer = [[SOLOTimer alloc] init];
    timer.block = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);
    dispatch_source_set_event_handler(timer.source, block);
    dispatch_resume(timer.source);
    return timer;
}

- (void)invalidate
{
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.block = nil;
}

- (void)dealloc
{
    [self invalidate];
}

- (void)fire
{
    self.block();
}

@end
