//
//  UIView+Frame.m
//  NewsClient
//
//  Created by FANTEXIX on 2018/6/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UIView+Frame.h"
#import <objc/runtime.h>

static char kFCCActionHandlerTapBlockKey;
static char kFCCActionHandlerTapGestureKey;
static char kFCCActionHandlerPressBlockKey;
static char kFCCActionHandlerPressGestureKey;

@implementation UIView (Frame)


- (void)setOrigin:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}
- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setSize:(CGSize) size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}
- (CGSize)size {
    return self.frame.size;
}


- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}
- (CGFloat)x {
    return self.frame.origin.x;
}


- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}
- (CGFloat)y {
    return self.frame.origin.y;
}



- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}
- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}
- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setTop:(CGFloat)top {
    [self setY:top];
}
- (CGFloat)top {
    return self.y;
}


- (void)setLeft:(CGFloat)left {
    [self setX:left];
}
- (CGFloat)left {
    return self.x;
}


- (void)setBottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.x, bottom - self.height, self.width, self.height);
}
- (CGFloat)bottom {
    return self.y + self.height;
}


- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}
- (CGFloat)right {
    return self.x + self.width;
}


- (void)setTapBlock:(void (^)(void))block {
    
    UITapGestureRecognizer * gesture = objc_getAssociatedObject(self, &kFCCActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kFCCActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kFCCActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kFCCActionHandlerTapBlockKey);
        if (action) action();
    }
}

- (void)setPressBlock:(void (^)(void))block {
    
    UILongPressGestureRecognizer * gesture = objc_getAssociatedObject(self, &kFCCActionHandlerPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kFCCActionHandlerPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kFCCActionHandlerPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForPressGesture:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^action)(void) = objc_getAssociatedObject(self, &kFCCActionHandlerPressBlockKey);
        if (action) action();
    }
}

@end
