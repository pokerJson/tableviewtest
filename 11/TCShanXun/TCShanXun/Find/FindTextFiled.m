//
//  FindTextFiled.m
//  News
//
//  Created by dzc on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindTextFiled.h"

@implementation FindTextFiled

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10; //像右边偏10
    return iconRect;
}
//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
}


@end
