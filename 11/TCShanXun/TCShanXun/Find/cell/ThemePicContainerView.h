//
//  ThemePicContainerView.h
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

/*
 
  +++++++++++++++++++++
  容器 图片的
 */
#import <UIKit/UIKit.h>
@class FIndMessageTableViewCell;
@protocol ThemePicContainerViewDlegate<NSObject>
//- (void)picMethod:(FIndMessageTableViewCell *)cell atIndex:(int)index;
- (void)picXXXXX:(long)index;
@end

typedef void(^ThemePicContainerViewBlock)(NSIndexPath *index);

@interface ThemePicContainerView : UIView


@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, copy) ThemePicContainerViewBlock picBlock;
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, assign) id<ThemePicContainerViewDlegate> delegate;


@end
