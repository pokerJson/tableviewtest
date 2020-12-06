//
//  MorePopView.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "MorePopView.h"

@interface MorePopView ()

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * boardView;
@property(nonatomic, strong)UIButton * collectionButton;

@property(nonatomic, strong)NSArray * optionArr;

@end

@implementation MorePopView

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
    [_maskButton addTarget:self action:@selector(maskButtonMethod:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_maskButton];
    
}
- (void)maskButtonMethod:(UIButton *)button {
    [self dismiss];
}

- (void)addSubviews {
    _boardView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0)];
    _boardView.backgroundColor = [UIColor whiteColor];
    _boardView.cornerRadius = 10;
    [self addSubview:_boardView];
}

- (void)showWithY:(float)y option:(NSArray *)optionArr {
    _optionArr = optionArr;
    _boardView.frame = CGRectMake(10, y, kScreenWidth-20, optionArr.count*50);
    
    for (int i = 0; i < optionArr.count; i++) {
        
        UIButton * button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 50*i, _boardView.width, 50)];
        button.contentHorizontalAlignment = 1;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i+88888;
        [button setBackgroundImage:[UIImage imageWithColor:RGBColor(240, 240, 240) imageSize:CGRectMake(0, 0, 5, 5)] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:optionArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_boardView addSubview:button];
        
        
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 50*i, _boardView.width-30, 0.4)];
            line.backgroundColor = RGBColor(170, 170, 170);
            [_boardView addSubview:line];
        }
        
    }
    
    [self show];
}

- (void)buttonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(morePopViewSelectedAtIndex:)]) {
        [self.delegate morePopViewSelectedAtIndex:(int)button.tag-88888];
        [self dismiss];
    }
}


- (void)show {
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskButton.alpha = 1;
        self.boardView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.boardView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
