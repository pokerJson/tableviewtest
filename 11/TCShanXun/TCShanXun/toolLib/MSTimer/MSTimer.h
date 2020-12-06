//
//  MSTimer.h
//  Videos
//
//  Created by fantexix on 2017/5/29.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MSTimer : NSTimer
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end
NS_ASSUME_NONNULL_END
