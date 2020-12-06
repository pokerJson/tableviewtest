//
//  MSTimer.m
//  Videos
//
//  Created by fantexix on 2017/5/29.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "MSTimer.h"

@interface MSTimer ()

@property(nonatomic, weak)id aTarget;
@property(nonatomic, assign)SEL aSelector;

@end

@implementation MSTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    
    MSTimer * sTimer = [[MSTimer alloc]init];
    sTimer.aTarget = aTarget;
    sTimer.aSelector = aSelector;
    
    return [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:sTimer selector:@selector(timerMethod:) userInfo:userInfo repeats:yesOrNo];
}

- (void)timerMethod:(NSTimer *)timer {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_aTarget performSelector:_aSelector withObject:timer];
#pragma clang diagnostic pop
}

@end

