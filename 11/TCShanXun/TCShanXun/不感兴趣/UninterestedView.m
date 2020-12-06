//
//  UninterestedView.m
//  News
//
//  Created by FANTEXIX on 2018/7/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UninterestedView.h"
#import "AppDelegate.h"

#import "BListModel.h"

@interface UninterestedView ()

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * bgView;
@property(nonatomic, strong)UIButton * uninterestedButton;
@property(nonatomic, strong)UIButton * reportButton;
@end

@implementation UninterestedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    _maskButton = [[UIButton alloc]initWithFrame:self.bounds];
    _maskButton.alpha = 0;
    _maskButton.backgroundColor = RGBAColor(0, 0, 0, 0.45);
    [_maskButton addTarget:self action:@selector(maskButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_maskButton];
    
}

- (void)maskButtonClicked:(UIButton *)button {
    [self dismiss];
}

- (void)addSubviews {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.cornerRadius = 10;
    [self addSubview:_bgView];
    
    _uninterestedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bgView.width, 50)];
    _uninterestedButton.contentHorizontalAlignment = 1;
    _uninterestedButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _uninterestedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    _uninterestedButton.adjustsImageWhenHighlighted = NO;
    [_uninterestedButton setBackgroundImage:[UIImage imageWithColor:RGBColor(240, 240, 240) imageSize:CGRectMake(0, 0, 5, 5)] forState:UIControlStateHighlighted];
    _uninterestedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_uninterestedButton setTitle:@"不感兴趣" forState:UIControlStateNormal];
    [_uninterestedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_uninterestedButton addTarget:self action:@selector(uninterestedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_uninterestedButton];
    
    
    
    _reportButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, _bgView.width, 50)];
    _reportButton.contentHorizontalAlignment = 1;
    _reportButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _reportButton.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    _reportButton.adjustsImageWhenHighlighted = NO;
    [_reportButton setBackgroundImage:[UIImage imageWithColor:RGBColor(240, 240, 240) imageSize:CGRectMake(0, 0, 5, 5)] forState:UIControlStateHighlighted];
    _reportButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [_reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reportButton addTarget:self action:@selector(reportButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_reportButton];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 50, _bgView.width-30, 0.4)];
    line.backgroundColor = RGBColor(170, 170, 170);
    [_bgView addSubview:line];
}


- (void)uninterestedButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uninterestedViewSelectedAtIndex:)]) {
        [self.delegate uninterestedViewSelectedAtIndex:0];
        [self dismiss];
    }

}

- (void)reportButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uninterestedViewSelectedAtIndex:)]) {
        [self.delegate uninterestedViewSelectedAtIndex:1];
        [self dismiss];
    }
}



- (void)showWithY:(float)y object:(BListModel *)model {
    _bgView.frame = CGRectMake(10, y, kScreenWidth-20, 100);
    
    [self show];
}

- (void)show {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskButton.alpha = 1;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
