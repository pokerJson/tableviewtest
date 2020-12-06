//
//  FollowedTopicCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowedTopicCell.h"
#import "TopicModel.h"

@interface FollowedTopicCell ()

@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UILabel * timeLabel;


@end

@implementation FollowedTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, self.height);
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
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 44, 44)];
    _avatarImageView.cornerRadius = 22.;
    [self addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageView.right+10, _avatarImageView.y, sWidth-84, 18)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = 0;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageView.right+10, _avatarImageView.bottom-15, sWidth-84, 15)];
    _timeLabel.textColor = RGBColor(200, 200, 200);
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)loadDataWithModel:(TopicModel *)model {
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    _nameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"最近更新:%@",[self dateFormat:model.creattime.integerValue]];
    
}

- (NSString *)dateFormat:(NSInteger)timeStamp {
    timeStamp= timeStamp/1000;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate: detailDate];
}


@end
