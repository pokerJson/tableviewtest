//
//  UITabBar+RedDot.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/9/26.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (RedDot)

- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
- (BOOL)hasRedHot:(int)index;

@end

NS_ASSUME_NONNULL_END
