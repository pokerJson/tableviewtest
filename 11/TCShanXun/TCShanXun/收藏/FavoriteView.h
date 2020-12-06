//
//  FavoriteView.h
//  News
//
//  Created by FANTEXIX on 2018/7/20.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoriteView;
@protocol FavoriteViewDelegate <NSObject>
@optional
- (void)favoriteViewSelectedAtIndex:(int)index;

@end

@interface FavoriteView : UIView

@property(nonatomic, weak)id<FavoriteViewDelegate> delegate;
@property(nonatomic, copy)void(^loginMethod)(void);
- (void)showWithY:(float)y object:(id)model;
- (void)dismiss;

@end
