//
//  UIViewController+Extend.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UIViewController+Extend.h"
#include <objc/runtime.h>

static char kFantexTextFieldKey;

@implementation UIViewController (Extend)

- (void)setKTextField:(UITextField *)kTextField {
    objc_setAssociatedObject(self, &kFantexTextFieldKey, kTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITextField *)kTextField {
    return objc_getAssociatedObject(self, &kFantexTextFieldKey);
}



@end
