//
//  MineNormalCell.m
//  NewsClient
//
//  Created by FANTEXIX on 2018/7/3.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "MineNormalCell.h"

@interface MineNormalCell ()

@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIImageView * detailImageView;

@end

@implementation MineNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, 44);
    self.backgroundColor = [UIColor whiteColor];
    
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
    _iconImageView = [[UIImageView alloc]init];
    [self addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, sWidth - 100, sHeight)];
    _titleLabel.font = UIFontSys(16);
    _titleLabel.textColor = RGBColor(51,51,51);
    [self addSubview:_titleLabel];
   
    _detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(sWidth-25, 16, 7, 12)];
    _detailImageView.image = UIImageNamed(@"ic_common_arrow_right");
    [self addSubview:_detailImageView];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(15, kHalf(sHeight-20), 20, 20);
    
    
    
}




- (void)loadDataWithModel:(NSDictionary *)model {
    
    _iconImageView.image = UIImageNamed(model[@"img"]);
    _titleLabel.text = model[@"title"];
}

@end
