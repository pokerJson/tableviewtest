//
//  PersonInfoCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PersonInfoCell.h"

@interface PersonInfoCell ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * content;
@property(nonatomic, strong)UIImageView * detailImageView;

@end

@implementation PersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, self.height);
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
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];

    
    
    
    _detailImageView = [[UIImageView alloc]init];
    _detailImageView.image = UIImageNamed(@"ic_common_arrow_right");
    [self addSubview:_detailImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarImageView.frame = CGRectMake(sWidth-100, (sHeight-60)/2., 60, 60);
    _content.frame =  CGRectMake(_titleLabel.right+50, 0, sWidth-(_titleLabel.right+50)-40, sHeight);
    _detailImageView.frame = CGRectMake(sWidth-25, (sHeight-12)/2., 7, 12);
}

- (void)loadDataWithModel:(NSDictionary *)model {
    _titleLabel.text = model[@"title"];
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(15, 0, _titleLabel.width, sHeight);
    
    [_avatarImageView removeFromSuperview];
    [_content removeFromSuperview];
    
    if ([model[@"type"] isEqualToString:@"0"]) {
        
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(sWidth, (sHeight-60)/2., 60, 60)];
        _avatarImageView.cornerRadius = 10;
//        _avatarImageView.borderColor = RGBColor(200, 200, 200);
//        _avatarImageView.borderWidth = 0.5;
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
        [self addSubview:_avatarImageView];
        
    }else {
        
        _content = [[UILabel alloc]init];
        _content.text = model[@"content"];
        _content.textColor = RGBColor(150, 150, 150);
        _content.textAlignment = 2;
        _content.font = [UIFont systemFontOfSize:14];
        [self addSubview:_content];
        
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
