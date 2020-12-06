//
//  BindCell.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/22.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BindCell.h"

@interface BindCell ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * content;
@property(nonatomic, strong)UIImageView * detailImageView;

@end

@implementation BindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)addSubviews {
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = RGBColor(80, 80, 80);
    _titleLabel.textAlignment = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    _content = [[UILabel alloc]init];
    _content.textColor = RGBColor(150, 150, 150);
    _content.textAlignment = 2;
    _content.font = [UIFont systemFontOfSize:14];
    [self addSubview:_content];
    
    _detailImageView = [[UIImageView alloc]init];
    _detailImageView.image = UIImageNamed(@"ic_common_arrow_right");
    [self addSubview:_detailImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(15, 0, 200, sHeight);
    _content.frame =  CGRectMake(_titleLabel.right+10, 0, sWidth-(_titleLabel.right+10)-30, sHeight);
    _detailImageView.frame = CGRectMake(sWidth-18, (sHeight-12)/2., 7, 12);
}

- (void)loadDataWithModel:(NSDictionary *)model {
    _titleLabel.text = model[@"title"];
    
    if ([model[@"type"] isEqualToString:@"PHONE"] && ![model[@"ifBind"] isEqualToString:@"0"]) {
        _titleLabel.text = [NSString stringWithFormat:@"%@:%@",model[@"title"],model[@"ifBind"]];
    }

    if ([model[@"type"] isEqualToString:@"PHONE"]) {
        _content.text = [model[@"ifBind"] isEqualToString:@"0"] ? @"绑定手机号码": @"修改手机号";
    }else if ([model[@"type"] isEqualToString:@"0"]) {
        _content.text = nil;
    }else {
        _content.text = [model[@"ifBind"] isEqualToString:@"0"] ? @"点击绑定":@"已绑定";;
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [UIView animateWithDuration:0.25 animations:^{
        if(highlighted)
            self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        else
            self.contentView.backgroundColor = [UIColor whiteColor];
    }];
}

@end
