//
//  UIView+Frame.h
//  NewsClient
//
//  Created by FANTEXIX on 2018/6/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (void)setOrigin:(CGPoint) point;
- (CGPoint)origin;

- (void)setSize:(CGSize) size;
- (CGSize)size;

- (void)setX:(CGFloat)x;
- (CGFloat)x;

- (void)setY:(CGFloat)y;
- (CGFloat)y;

- (void)setWidth:(CGFloat)width;
- (CGFloat)width;

- (void)setHeight:(CGFloat)height;
- (CGFloat)height;


- (void)setTop:(CGFloat)top;
- (CGFloat)top;

- (void)setLeft:(CGFloat)left;
- (CGFloat)left;

- (void)setBottom:(CGFloat)bottom;
- (CGFloat)bottom;

- (void)setRight:(CGFloat)right;
- (CGFloat)right;


- (void)setTapBlock:(void (^)(void))block;
- (void)setPressBlock:(void (^)(void))block;

@end
