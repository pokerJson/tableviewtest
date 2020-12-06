//
//  UIImage+Extend.h
//  NvYou
//
//  Created by FANTEXIX on 2018/4/28.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)


+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;


+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGRect)rect;


- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;

+ (UIImage *)grayscaleImageForImage:(UIImage*)image rgb:(float)rgb;
+ (UIImage *)transColorForImage:(UIImage*)image  rgb:(NSArray *)rgb;

@end
