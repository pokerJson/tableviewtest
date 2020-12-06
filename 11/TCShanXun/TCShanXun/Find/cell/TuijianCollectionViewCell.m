//
//  TuijianCollectionViewCell.m
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TuijianCollectionViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@implementation TuijianCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor greenColor];
        self.backgroundColor = RGBColor(222, 222, 222);
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews
{
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;

    _iconView = [[UIImageView alloc]init];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 10;

    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"appstrore家却家哈哈哈哈哈福克斯浪蝶狂蜂东方时空大家对方就能看电视";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    _attentionLabel = [[UILabel alloc]init];
    _attentionLabel.text = @"118834人关注";
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    _attentionLabel.font = [UIFont systemFontOfSize:12.0];
    
    _attentionBT = [UIButton new];
    [_attentionBT addTarget:self action:@selector(attentionBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionBT setBackgroundImage:UIImageNamed(@"ic_common_checkmark_blue") forState:UIControlStateNormal];
    [_attentionBT setBackgroundImage:UIImageNamed(@"ic_common_checkmark_rounded") forState:UIControlStateSelected];
    
    NSArray *views= @[_backView,_iconView,_titleLabel,_attentionLabel,_attentionBT];
    [self.contentView sd_addSubviews:views];

    UIView *contentView = self.contentView;
    _backView.sd_layout.leftSpaceToView(contentView, 5).topSpaceToView(contentView, 5).widthIs(150).heightIs(190);
    _iconView.sd_layout.leftSpaceToView(contentView, (self.frame.size.width-50)/2).topSpaceToView(contentView, 20).widthIs(50).heightIs(50);
    _titleLabel.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(_iconView, 10).widthIs(self.frame.size.width-20).heightIs(40);
    _attentionLabel.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(_titleLabel, 10).widthIs(self.frame.size.width).heightIs(15);
    _attentionBT.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(_attentionLabel, 10).widthIs(self.frame.size.width-20).heightIs(20);
    
}
- (void)layoutSubviews{
    
}
- (void)attentionBTClick:(UIButton *)bt
{
    NSLog(@"关注");
    _attentionBT.selected = !bt.selected;
    self.attentionBT_Block(self);
    
    
}

@end
