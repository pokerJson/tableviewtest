//
//  AddCollectionView.h
//  News
//
//  Created by dzc on 2018/7/20.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCollectionViewDelegate <NSObject>
@optional
- (void)uninterestedViewSelectedAtIndex:(int)index;

@end

@interface AddCollectionView : UIView

@property(nonatomic, weak)id<AddCollectionViewDelegate> delegate;

@property(nonatomic, copy)void(^loginMethod)(void);

- (void)showWithY:(float)y object:(id)model;

- (void)dismiss;
@end
