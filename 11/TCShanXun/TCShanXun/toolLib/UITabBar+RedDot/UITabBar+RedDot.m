//
//  UITabBar+RedDot.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/9/26.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UITabBar+RedDot.h"

@implementation UITabBar (RedDot)

- (void)showBadgeOnItemIndex:(int)index {
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index+0.55) / 4.;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.08 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    badgeView.layer.cornerRadius = badgeView.frame.size.width/2;
    
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index {
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

- (BOOL)hasRedHot:(int)index {
    
    BOOL has = NO;
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            has = YES;
            break;
        }
    }
    return has;
}


@end
