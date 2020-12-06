//
//  FollowPersonCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowPersonCell.h"
#import "PersonModel.h"

@interface FollowPersonCell ()

@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLable;
@property(nonatomic, strong)UIButton * followButton;

@property(nonatomic, strong)PersonModel * model;

@end

@implementation FollowPersonCell

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
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.backgroundColor = RGBColor(200, 200, 200);
    _iconImageView.cornerRadius = 20.;
    [self addSubview:_iconImageView];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.textAlignment = 0;
    _titleLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLable];
    
    
    UIImage * lan = [UIImage imageWithColor:RGBColor(60, 180, 245) imageSize:CGRectMake(0, 0, 5, 5)];
    UIImage * hui = [UIImage imageWithColor:RGBColor(226, 224, 226) imageSize:CGRectMake(0, 0, 5, 5)];
    _followButton = [[UIButton alloc]init];
    _followButton.cornerRadius = 12.;
    _followButton.titleLabel.font = UIFontSys(12);
    [_followButton setBackgroundImage:lan forState:UIControlStateNormal];
    [_followButton setBackgroundImage:hui forState:UIControlStateSelected];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(15, kHalf(sHeight-40), 40, 40);
    _titleLable.frame = CGRectMake(_iconImageView.right+10, 0, sWidth-180, sHeight);
    _followButton.frame = CGRectMake(sWidth-70, (sHeight-24)/2., 55, 24);
}

- (void)followButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //关注
            //userid 用户id
            //token accessToken
            //topicid 主题id
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"uid":_model.userid,
                                     };
            [HttpRequest get_RequestWithURL:FOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = YES;
                        self.model.if_guanzhu = @"1";
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
                                     @"uid":_model.userid,
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
        
        
    }else {
        //未登陆
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self.viewController presentViewController:nav animated:YES completion:nil];
    }
    
}


- (void)loadDataWithModel:(PersonModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    _titleLable.text = model.nick;
    
    if (_model.if_guanzhu.intValue == 0) {
        _followButton.selected = NO;
    }else {
        _followButton.selected = YES;
    }
    
    
    if ([UserManager shared].isLogin && model.userid.integerValue == [UserManager shared].userInfo.uid.integerValue) {
        _followButton.hidden = YES;
    }else {
        _followButton.hidden = NO;
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
