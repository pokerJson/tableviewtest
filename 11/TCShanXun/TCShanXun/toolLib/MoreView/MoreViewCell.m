//
//  MoreViewCell.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/20.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "MoreViewCell.h"

@interface MoreViewCell ()

@property(nonatomic, strong)UILabel * titleLabel;

@end

@implementation MoreViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = 1;
    _titleLabel.textColor = RGBColor(80, 105, 144);
    _titleLabel.font = UIFontSys(18);
    [self addSubview:_titleLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, sWidth, sHeight);
}

- (void)loadDataWithModel:(NSString *)model {
    
    if ([model isEqualToString:@"删除"] || [model isEqualToString:@"停止关注"]) {
        _titleLabel.textColor = RGBColor(255, 69, 0);
    }else {
        _titleLabel.textColor = RGBColor(80, 105, 144);
    }
    
    _titleLabel.text = model;
}

@end
