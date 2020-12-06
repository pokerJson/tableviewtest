//
//  FollowUnfoldCell.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/11/6.
//  Copyright © 2018 fantexix Inc. All rights reserved.
//

#import "FollowUnfoldCell.h"

@interface FollowUnfoldCell ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIView * separatorView;

@property(nonatomic, strong)UIImageView * arrowImageView;

@end


@implementation FollowUnfoldCell

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
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, sWidth-30, sHeight-10)];
    _titleLabel.textColor = RGBColor(117,152,192);
    _titleLabel.textAlignment = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(sWidth-40, 15, 16, 9)];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    _arrowImageView.image = UIImageNamed(@"Rectangle 18");
    [self addSubview:_arrowImageView];
    
    _separatorView = [[UIView alloc]init];
    _separatorView.backgroundColor = RGBColor(245,245,245);
    [self addSubview:_separatorView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _separatorView.frame = CGRectMake(0, self.height-10, sWidth, 10);
}

- (void)loadDataWithModel:(int)model {
    _titleLabel.text = [NSString stringWithFormat:@"还有%d篇更新",model];
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
