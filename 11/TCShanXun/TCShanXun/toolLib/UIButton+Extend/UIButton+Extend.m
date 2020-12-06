//
//  UIButton+Extend.m
//  NvYou
//
//  Created by FANTEXIX on 2018/4/28.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UIButton+Extend.h"


@implementation UIButton (Extend)

- (instancetype)init {
    if (self = [super init]) {
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}

//显示小红点
- (void)showDot {
    //移除之前的小红点
    [self removeDot];
    
    CGRect tabFrame = self.imageView.frame;
    float w = tabFrame.size.width;
    
    //新建小红点
    UIView * badgeView = [[UIView alloc]init];
    badgeView.tag = 8888;
    badgeView.layer.cornerRadius = w*0.12;//圆形
    badgeView.layer.borderColor = [UIColor whiteColor].CGColor;
    badgeView.layer.borderWidth = 1;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    badgeView.frame = CGRectMake(tabFrame.origin.x + tabFrame.size.width * 0.86 - w*0.1,tabFrame.origin.y + tabFrame.size.height * 0.14 - w*0.14, w*0.24, w*0.24);
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideDot {
    //移除小红点
    [self removeDot];
}

//移除小红点
- (void)removeDot {
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 8888) {
            [subView removeFromSuperview];
        }
    }
}

- (void)showCommentDot {
    
    //移除之前的小红点
    [self removeCommentDot];
    
    CGRect tabFrame = self.imageView.frame;
    float w = tabFrame.size.width;
    
    //新建小红点
    UIView * badgeView = [[UIView alloc]init];
    badgeView.tag = 7888;
    badgeView.layer.cornerRadius = 5.;//圆形
    badgeView.layer.borderColor = [UIColor whiteColor].CGColor;
    badgeView.layer.borderWidth = 1;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    badgeView.frame = CGRectMake(tabFrame.origin.x + w* 0.75 ,0, 10,10);
    [self addSubview:badgeView];
    
}

//隐藏小红点
- (void)hideCommentDot {
    [self removeCommentDot];
}
//移除小红点
- (void)removeCommentDot {
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 7888) {
            [subView removeFromSuperview];
        }
    }
}

@end




@implementation ITButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    //float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(0.5, (height-20)/2., 20, 20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(28, 0, width-28, height);
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 1, 20, 20);
}

//无高亮
- (void)setHighlighted:(BOOL)highlighted {
}

@end


@implementation TIButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = 2;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(width-height, 0, height, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(0, 0, width-height-5, height);
}

//无高亮
- (void)setHighlighted:(BOOL)highlighted {
}

@end




@implementation NOHButton
//无高亮
- (void)setHighlighted:(BOOL)highlighted {
}
@end



@implementation NMButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.backgroundColor = [UIColor grayColor];
//        self.titleLabel.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(0, 0 , width-10, height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(width-8, 0, 8, height);
}

//无高亮
- (void)setHighlighted:(BOOL)highlighted {
}

@end


