//
//  MoreView.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/20.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreView;
@protocol MoreViewDelegate <NSObject>

@optional
- (void)moreView:(MoreView *)moreView selectedAtIndex:(int)index;
- (void)dismissMoreView:(MoreView *)moreView;
@end

@interface MoreView : UIView

@property(nonatomic, weak)id<MoreViewDelegate>  delegate;

- (void)showWithData:(NSArray *)oArr object:(id)model;

- (void)dismiss;

@end
