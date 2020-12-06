//
//  UIView+Extend.m
//  NvYou
//
//  Created by FANTEXIX on 2018/5/23.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UIView+Extend.h"
#import <objc/runtime.h>

static char kFantexCornerRadiusKey;
static char kFantexBorderWidthKey;
static char kFantexBorderColorKey;

@implementation UIView (Extend)

//圆角
- (void)setCornerRadius:(float)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    objc_setAssociatedObject(self, &kFantexCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
}

- (float)cornerRadius {
    return [objc_getAssociatedObject(self, &kFantexCornerRadiusKey) floatValue];
}

//边框宽度
- (void)setBorderWidth:(float)borderWidth {
    self.layer.borderWidth = borderWidth;
    objc_setAssociatedObject(self, &kFantexBorderWidthKey, @(borderWidth), OBJC_ASSOCIATION_ASSIGN);

}
- (float)borderWidth {
    return [objc_getAssociatedObject(self, &kFantexBorderWidthKey) floatValue];
}

//边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    objc_setAssociatedObject(self, &kFantexBorderColorKey, borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, &kFantexBorderColorKey);
}

@end



@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    for (UIView * next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end


