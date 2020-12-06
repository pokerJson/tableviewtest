//
//  ThemeInfo.m
//  News
//
//  Created by dzc on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemeInfo.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;

extern CGFloat maxContentLabelHeight;


@implementation ThemeInfo
{
    CGFloat _lastContentWidth;
}
@synthesize contentstr = _contentstr;

- (void)setContentstr:(NSString *)contentstr
{
    _contentstr = contentstr;
}
- (NSString *)contentstr
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_contentstr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    
    return _contentstr;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end
