//
//  PicView.h
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PicView;
@protocol PicViewDeletgate<NSObject>
@optional

- (void)picViewViewTap:(PicView *)picView;
- (void)picViewSingleTap:(PicView *)picView;
- (void)picViewDoubleTap:(PicView *)picView;

@end


@interface PicView : UIView

@property(nonatomic, weak)id<PicViewDeletgate> picDelegate;

@property(nonatomic, readonly)UIScrollView * scrollView;

@property(nonatomic, strong)YYAnimatedImageView * imageView;

- (void)loadDataWithModel:(id)model;

@end


