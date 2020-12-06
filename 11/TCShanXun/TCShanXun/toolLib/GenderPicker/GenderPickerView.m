//
//  GenderPickerView.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/2/28.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "GenderPickerView.h"
#import "AppDelegate.h"

@interface GenderButton : UIButton

@end

@implementation GenderButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 30, contentRect.size.width, 60);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, contentRect.size.height - 50, contentRect.size.width, 35);
}

@end




@interface GenderPickerView ()

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * backView;
@property(nonatomic, strong)UIButton * cancelButton;
@property(nonatomic, assign)NSInteger popHeight;

@property(nonatomic, strong)GenderButton * maleButton;
@property(nonatomic, strong)GenderButton * femaleButton;



@end


@implementation GenderPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _maskButton = [[UIButton alloc]initWithFrame:self.bounds];
        _maskButton.alpha = 0;
        _maskButton.backgroundColor = RGBAColor(0, 0, 0, 0.45);
        [_maskButton addTarget:self action:@selector(maskButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_maskButton];
        
    }
    return self;
}

- (void)maskButtonClicked:(UIButton *)button {
    [self dismiss];
}

- (void)show {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        _maskButton.alpha = 1;
        _backView.frame = CGRectMake(0, kScreenHeight - _popHeight, kScreenWidth, _popHeight);
    }];
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        _maskButton.alpha = 0;
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _popHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissGenderPickerView:)]) {
            [self.delegate dismissGenderPickerView:self];
        }
    }];
}

- (void)showWithDate:(NSDate *)date {
    [self addSubviews];
    [self show];
}


- (void)addSubviews {
    
    _popHeight = 200;
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, _popHeight)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _popHeight - 60, kScreenWidth, 10)];
    bgView.backgroundColor = RGBColor(247, 247, 247);
    [_backView addSubview:bgView];
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _popHeight-50, kScreenWidth, 50)];
    _cancelButton.titleLabel.font = UIFontSys(18);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:RGBColor(83, 112, 157) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_backView addSubview:_cancelButton];
    
    
    _maleButton = [[GenderButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, 140)];
    _maleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _maleButton.titleLabel.font = UIFontSys(18);
    _maleButton.titleLabel.textAlignment = 1;
    [_maleButton setImage:UIImageNamed(@"profile_gender_btn_male_normal") forState:UIControlStateNormal];
    [_maleButton setTitle:@"男" forState:UIControlStateNormal];
    [_maleButton setTitleColor:RGBColor(104, 189, 252) forState:UIControlStateNormal];
    [_maleButton addTarget:self action:@selector(genderButtonClicked:) forControlEvents:UIControlEventTouchDown];
    _maleButton.tag = 70001;
    [_backView addSubview:_maleButton];
    
    
    _femaleButton = [[GenderButton alloc]initWithFrame:CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/2.0, 140)];
    _femaleButton.titleLabel.font = UIFontSys(18);
    _femaleButton.titleLabel.textAlignment = 1;
    _femaleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_femaleButton setImage:UIImageNamed(@"profile_gender_btn_female_normal") forState:UIControlStateNormal];
    [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
    [_femaleButton setTitleColor:RGBColor(246, 107, 162) forState:UIControlStateNormal];
    [_femaleButton addTarget:self action:@selector(genderButtonClicked:) forControlEvents:UIControlEventTouchDown];
    _femaleButton.tag = 70000;
    [_backView addSubview:_femaleButton];
    
     
}

- (void)cancelButtonClicked:(UIButton *)button {
    [self dismiss];
}

- (void)genderButtonClicked:(GenderButton *)button {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(genderPickerView:gender:)]) {
        [self.delegate genderPickerView:self gender:(button.tag-70000)];
    }
    
    [self dismiss];
}


@end
