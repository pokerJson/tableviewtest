//
//  MorePopView.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MorePopView;
@protocol MorePopViewDelegate <NSObject>
@optional
- (void)morePopViewSelectedAtIndex:(int)index;

@end

@interface MorePopView : UIView

@property(nonatomic, weak)id<MorePopViewDelegate> delegate;

@property(nonatomic, copy)void(^callBlock)(NSDictionary * param);

- (void)showWithY:(float)y option:(NSArray *)optionArr;

- (void)dismiss;

@end
