//
//  ScrollSwitch.h
//  ScrollSwitch
//
//  Created by fantexix on 2018/6/15.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ScrollSwitch;
@protocol ScrollSwitchDelegate <NSObject>
@optional
- (void)scrollSwitch:(ScrollSwitch *)scrollSwitch selectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface ScrollSwitch : UIView

@property(nonatomic, weak)id<ScrollSwitchDelegate> delegate;

/** 是否包含状态栏*/
@property(nonatomic, assign)BOOL hasStatusBar;
/** 额外视图*/
@property(nonatomic, strong)UIView * addonsView;
/** 标签栏可否滚动*/
@property(nonatomic, assign)float tabBarHeight;
/** 标签栏可否滚动*/
@property(nonatomic, assign)BOOL tabBarScroll;
/** 页面可否滚动*/
@property(nonatomic, assign)BOOL pageScroll;

@property(nonatomic, assign)BOOL addonsAutoAnimation;

@property(nonatomic, assign)float offset;

- (void)scrollOffset:(float)offset interval:(float)interval;


- (void)showAddonsView;
- (void)hideAddonsView;

- (void)titleArr:(NSArray *)titleArr loadViewBlock:(void(^)(UIScrollView * scrollView,NSInteger index))loadViewBlock currentIndexBlock:(void(^)(UIScrollView * scrollView,NSInteger index))currentIndexBlock;

@end
