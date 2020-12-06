//
//  UninterestedView.h
//  News
//
//  Created by FANTEXIX on 2018/7/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UninterestedView;
@protocol UninterestedViewDelegate <NSObject>
@optional
- (void)uninterestedViewSelectedAtIndex:(int)index;

@end

@interface UninterestedView : UIView

@property(nonatomic, weak)id<UninterestedViewDelegate> delegate;

@property(nonatomic, copy)void(^loginMethod)(void);

- (void)showWithY:(float)y object:(id)model;

- (void)dismiss;

@end
