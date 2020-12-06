//
//  TodayNewCell.m
//  TodayExtension
//
//  Created by FANTEXIX on 2018/9/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TodayNewCell.h"
#import "TodayModel.h"
#import "TodayHeader.h"


@interface TodayNewCell ()
@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;
@end

@implementation TodayNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = [UIFont systemFontOfSize:11];
    _detailLabel.textColor = RGBAColor(130, 130, 130, 1);
    [self.contentView addSubview:_detailLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(sWidth - 88, 15, 80, 80);
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.layer.masksToBounds = YES;
}

- (void)loadDataWithModel:(TodayModel *)model {
    NSString * urlStr = [model.picsArr.firstObject[@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [[SDImageCache sharedImageCache] clearMemory];
    }];
    
    float titleHeight = [model.content boundingRectWithSize:CGSizeMake(sWidth - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size.height;
    //NSLog(@"%f",titleHeight);
    if (titleHeight > 45) {
        titleHeight = 45;
    }
    float y = (sHeight - titleHeight - 8 - 15)*0.5;
    
    _titleLabel.frame = CGRectMake(8, y, sWidth - 115, titleHeight);
    _titleLabel.text = model.content;
    
    _detailLabel.frame = CGRectMake(8, _titleLabel.frame.origin.y + titleHeight + 8, sWidth - 115, 15);
    //_detailLabel.text = [NSString stringWithFormat:@"%i次观看",model.num_play];
    
    
    
}

@end
