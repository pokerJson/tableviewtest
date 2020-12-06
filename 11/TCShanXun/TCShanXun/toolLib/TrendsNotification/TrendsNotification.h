//
//  TrendsNotification.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/9/26.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendsNotification : NSObject

+ (instancetype)shared;

- (void)loadNotification;

@end

NS_ASSUME_NONNULL_END
