
//
//  DataTipsView.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "DataTipsView.h"

@interface DataTipsView ()

@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, strong)UILabel * label;
@property(nonatomic, strong)UIButton * button;

@property(nonatomic, strong)NSDictionary * model;

@end

@implementation DataTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    

    
}

- (void)addSubviews {
 
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHalf(sWidth-100), kHalf(sHeight), 100, 0)];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, kHalf(sHeight), sWidth, 0)];
    _label.textColor = RGBColor(131, 131, 131);
    _label.textAlignment = 1;
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:15];
    [self addSubview:_label];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(sWidth-60), kHalf(sHeight), 60, 0)];
    _button.cornerRadius = 15.;
    _button.borderWidth = 1;
    _button.borderColor = RGBColor(150, 150, 150);
    _button.titleLabel.font = [UIFont systemFontOfSize:13];
    [_button setTitleColor:RGBColor(150, 150, 150) forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
}



- (void)buttonMethod:(UIButton *)button {
    if (_callBack) {
        _callBack(@{});
    }
}

- (void)loadDataWithModel:(NSDictionary *)model {
    _model = model;
    
    _imageView.image = UIImageNamed(_model[@"img"]);
    _label.attributedText = [self attributed:_model[@"label"] lineSpace:5];
    [_button setTitle:_model[@"btn"] forState:UIControlStateNormal];
    
    if (_model[@"img"]) {
        _imageView.frame = CGRectMake(kHalf(sWidth-100), kHalf(sHeight)-180, 100, 100);
        _label.frame = CGRectMake(0, kHalf(sHeight)-70, sWidth, 40);
        _button.frame = CGRectMake(kHalf(sWidth-90), kHalf(sHeight)-20, 90, 30);
    }else {
        _imageView.frame = CGRectMake(kHalf(sWidth-100), kHalf(sHeight)-180, 100, 0);
        _label.frame = CGRectMake(0, kHalf(sHeight)-80, sWidth, 50);
        _button.frame = CGRectMake(kHalf(sWidth-80), kHalf(sHeight), 80, 0);
    }
    
}

- (NSAttributedString *)attributed:(NSString *)string lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    return attributedString;
}


@end
