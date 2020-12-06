//
//  NotiCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "NotiCell.h"
#import "NotiModel.h"

@interface NotiCell ()

@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;
@property(nonatomic, strong)UIButton * followButton;
@property(nonatomic, strong)UILabel * timeLabel;

@property(nonatomic, strong)NotiModel * model;

@end

@implementation NotiCell

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
    
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.cornerRadius = 25.;
    [self addSubview:_avatarImageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.textColor = RGBColor(200, 200, 200);
    _detailLabel.textAlignment = 0;
    _detailLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_detailLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = RGBColor(200, 200, 200);
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_timeLabel];
    
    
    UIImage * lan = [UIImage imageWithColor:RGBColor(60, 180, 245) imageSize:CGRectMake(0, 0, 5, 5)];
    UIImage * hui = [UIImage imageWithColor:RGBColor(226, 224, 226) imageSize:CGRectMake(0, 0, 5, 5)];
    _followButton = [[UIButton alloc]init];
    _followButton.cornerRadius = 15.;
    _followButton.titleLabel.font = UIFontSys(13);
    [_followButton setBackgroundImage:lan forState:UIControlStateNormal];
    [_followButton setBackgroundImage:hui forState:UIControlStateSelected];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    
//    _titleLabel.backgroundColor = [UIColor greenColor];
//    _detailLabel.backgroundColor = [UIColor redColor];
//    _timeLabel.backgroundColor = [UIColor greenColor];
}

- (void)followButtonMethod:(UIButton *)button {
    
    if (button.selected == NO) {
        //关注
        //userid 用户id
        //token accessToken
        //topicid 主题id
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"uid":_model.uid,
                                 };
        [HttpRequest get_RequestWithURL:FOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = YES;
                        self.model.if_guanzhu = @"1";
                    }else if ([dic[@"msg"] isEqualToString:@"用户已关注"]) {
                        self.followButton.selected = YES;
                        self.model.if_guanzhu = @"1";
                    }
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
        
    }else {
        //取消
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"uid":_model.uid,
                                 };
        [HttpRequest get_RequestWithURL:UNFOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    self.followButton.selected = NO;
                    self.model.if_guanzhu = @"0";
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)loadDataWithModel:(NotiModel *)model {
    _model = model;
    
    NSMutableAttributedString * titleAtt = [[NSMutableAttributedString alloc]initWithString:model.nick];
    
    [titleAtt addAttribute:NSForegroundColorAttributeName value:RGBColor(100, 100, 100) range:NSMakeRange(0, model.nick.length-4)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:RGBColor(150, 150, 150) range:NSMakeRange(model.nick.length-4, 4)];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, model.nick.length)];
    _titleLabel.attributedText = titleAtt;
    _titleLabel.frame = CGRectMake(75, 20, sWidth-180, model.contentHeight);
    
    _detailLabel.frame =  CGRectMake(75, _titleLabel.bottom, sWidth-180, 20);
    _detailLabel.text = [NSString stringWithFormat:@"%@人关注TA",model.num_followers];
    
    _avatarImageView.frame = CGRectMake(15,20 +(model.contentHeight+20-50)/2. , 50, 50);
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    
    _followButton.frame = CGRectMake(sWidth - 100, _avatarImageView.top + 10, 80, 30);
    
    _timeLabel.frame = CGRectMake(15, sHeight-30, sWidth-30, 20);
    _timeLabel.text =  [self dateFormat:model.createtime.integerValue];
    

    if (_model.if_guanzhu.intValue == 0) {
        _followButton.selected = NO;
    }else {
        _followButton.selected = YES;
    }
    
    
}

- (NSString *)dateFormat:(NSInteger)timeStamp {
    timeStamp= timeStamp/1000;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate: detailDate];
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
