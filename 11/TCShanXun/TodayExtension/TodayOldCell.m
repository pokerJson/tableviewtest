//
//  TodayOldCell.m
//  TodayExtension
//
//  Created by FANTEXIX on 2018/9/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TodayOldCell.h"
#import "TodayModel.h"
#import "TodayHeader.h"


@interface TodayOldCell ()
@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;
@end

@implementation TodayOldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.frame = CGRectMake(0, 0, sWidth-60, sHeight);
        
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = [UIFont systemFontOfSize:11];
    _detailLabel.textColor = RGBAColor(130, 130, 130, 1);
    [self.contentView addSubview:_detailLabel];
    
    //    _titleLabel.backgroundColor = [UIColor blueColor];
    //    _detailLabel.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(sWidth - 60, 12, 65, 56);
}

- (void)loadDataWithModel:(TodayModel *)model {
    NSString * urlStr = [model.picsArr.firstObject[@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [[SDImageCache sharedImageCache] clearMemory];
    }];
    
    float titleHeight = [model.content boundingRectWithSize:CGSizeMake(sWidth - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    //NSLog(@"%f",titleHeight);
    if (titleHeight > 40) titleHeight = 40;
    float y = (sHeight - titleHeight - 3 - 15)*0.5;
    
    _titleLabel.frame = CGRectMake(0, y, sWidth - 90, titleHeight+1);
    _titleLabel.text = model.content;
    //NSLog(@"%@",model.title);
    _detailLabel.frame = CGRectMake(0, _titleLabel.frame.origin.y + titleHeight + 3, sWidth - 90, 15);
    //_detailLabel.text = [NSString stringWithFormat:@"%i次观看",model.num_play];
    
    
    
}

@end
