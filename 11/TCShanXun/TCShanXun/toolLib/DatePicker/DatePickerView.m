//
//  DatePickerView.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/2/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "DatePickerView.h"
#import "AppDelegate.h"

@interface DatePickerView ()

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * backView;
@property(nonatomic, assign)float height;
@property(nonatomic, strong)UIButton * cancelButton;
@property(nonatomic, strong)UIButton * finishButton;

@property(nonatomic, strong)UIDatePicker * picker;
@property(nonatomic, strong)NSDateFormatter * dateFormatter;

@property(nonatomic, strong)NSDate * defautDate;

@end

@implementation DatePickerView

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
        _backView.frame = CGRectMake(0, kScreenHeight - _height, kScreenWidth, _height);
    }];
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        _maskButton.alpha = 0;
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissDatePickerView:)]) {
            [self.delegate dismissDatePickerView:self];
        }
    }];
}

- (void)showWithDate:(NSDate *)date {
    _defautDate = date;
    [self addSubviews];
    [self show];
}


- (void)addSubviews {
    
    _height = 256;
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, _height)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    bgView.backgroundColor = RGBColor(247, 247, 247);
    [_backView addSubview:bgView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth-200, 45)];
    titleLabel.text = @"选择生日";
    titleLabel.font = UIFontSys(20);
    titleLabel.textAlignment = 1;
    [_backView addSubview:titleLabel];
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_backView addSubview:_cancelButton];
    
    _finishButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 0, 80, 45)];
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_backView addSubview:_finishButton];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, _height-45)];
    [_picker setDatePickerMode:UIDatePickerModeDate];
    [_picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    if (!_defautDate) {
        _defautDate = [_dateFormatter dateFromString:@"2000-01-01"];
    }
    
    [_picker setDate:_defautDate];
    
    [_backView addSubview:_picker];
    
}

- (void)cancelButtonClicked:(UIButton *)button {
    [self dismiss];
}

- (void)finishButtonClicked:(UIButton *)button {
    [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:date:)]) {
        [self.delegate datePickerView:self date:_picker.date];
    }
}



@end
