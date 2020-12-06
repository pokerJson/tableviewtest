//
//  UIView+Extend.h
//  NvYou
//
//  Created by FANTEXIX on 2018/5/23.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (Extend)
@property(nonatomic, assign)float cornerRadius;
@property(nonatomic, assign)float borderWidth;
@property(nonatomic, strong)UIColor * borderColor;
@end


//获取视图的控制器
@interface UIView (UIViewController)
- (UIViewController *)viewController;
@end


NS_ASSUME_NONNULL_END
