//
//  MineAvatarCell.m
//  NewsClient
//
//  Created by FANTEXIX on 2018/7/3.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "MineAvatarCell.h"

@interface MineAvatarCell ()

@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * tipLabel;

@property(nonatomic, strong)UIImageView * detailImageView;

@end

@implementation MineAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, 100);
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
    
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
    _avatarImageView.cornerRadius = 10.;
    [self addSubview:_avatarImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageView.right + 20, _avatarImageView.y+20, sWidth - 180, 20)];
    [self addSubview:_titleLabel];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.bottom, sWidth - 180, 25)];
    [self addSubview:_tipLabel];
    
    _detailImageView = [[UIImageView alloc]init];
    _detailImageView.image = UIImageNamed(@"ic_common_arrow_right");
    [self addSubview:_detailImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _detailImageView.frame =  CGRectMake(sWidth-25, (sHeight-12)/2., 7, 12);
    
}

- (void)loadDataWithModel:(id)model {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN"] boolValue]) {
    
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager shared].userInfo.icon]];
        _titleLabel.text = [UserManager shared].userInfo.nick;
        _titleLabel.textColor = RGBColor(34, 34, 34);
        _titleLabel.font = UIFontSys(18);
        
        _tipLabel.text = @"查看个人主页";
        _tipLabel.font = UIFontSys(14);
        _tipLabel.textColor = RGBColor(100, 100, 100);
        _tipLabel.height = 25;
        
    }else {
        
        _avatarImageView.image = UIImageNamed(@"mine_default_avatar");
        _titleLabel.text = @"点击登录账号";
        _titleLabel.textColor = RGBColor(51,51,51);
        _titleLabel.font = UIFontSys(16);
        
        _tipLabel.text = @"登录后,换手机也不怕丢数据";
        _tipLabel.font = UIFontSys(12);
        _tipLabel.textColor = RGBColor(132,132,132);
        _tipLabel.height = 20;
    }
    
    
}

@end
