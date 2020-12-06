//
//  ShareView.h
//  News
//
//  Created by FANTEXIX on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShareView;
@protocol ShareViewDelegate <NSObject>
@optional
- (void)shareViewSelectedAtIndex:(int)index;
@end


@interface ShareView : UIView

@property(nonatomic, weak)id<ShareViewDelegate> delegate;

- (void)showWithShortcutOptions:(NSArray *)oArr object:(id)model;
- (void)dismiss;


@end
