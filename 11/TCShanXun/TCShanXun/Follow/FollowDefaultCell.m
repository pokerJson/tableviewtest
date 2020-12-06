//
//  FollowDefaultCell.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowDefaultCell.h"

@interface FollowDefaultCell ()

@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIButton * followButton;
@property(nonatomic, strong)BListModel * model;

@end

@implementation FollowDefaultCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addSubviews {
    
    _iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(kHalf(sWidth-60), 10, 60, 60)];
    _iconImageView.cornerRadius = 30;
    [self addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, sWidth, 35)];
    _titleLabel.textColor = RGBColor(128, 128, 128);
    _titleLabel.textAlignment = 1;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_titleLabel];

    _followButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(sWidth-60), 115, 64, 28)];
    _followButton.cornerRadius = 5;
    _followButton.titleLabel.font = UIFontSys(14);
    _followButton.backgroundColor = RGBColor(255,77,32);
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)loadDataWithModel:(BListModel *)model {
    _model = model;
    _followButton.selected = NO;
    _followButton.backgroundColor = RGBColor(255,77,32);
    
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:model.topicicon] options:YYWebImageOptionSetImageWithFadeAnimation];
    _titleLabel.text = model.topicname;
    
}

- (void)followButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (_followButton.selected == NO) {
            //关注
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"topicid":_model.topicid,
                                     };
            [HttpRequest get_RequestWithURL:FOLLOW_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = YES;
                        self.followButton.backgroundColor = RGBColor(227,228,230);
                        self.model.if_guanzhu = @"1";
                        [app.overallParam setObject:@"1" forKey:self.model.topicid];
                        if (self.callBack) self.callBack(1);
                    }else if ([dic[@"msg"] isEqualToString:@"主题已关注"]){
                        self.followButton.selected = YES;
                        self.followButton.backgroundColor = RGBColor(227,228,230);
                        self.model.if_guanzhu = @"1";
                        [app.overallParam setObject:@"1" forKey:self.model.topicid];
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
                                     @"topicid":_model.topicid,
                                     };
            [HttpRequest get_RequestWithURL:UNFOLLOW_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = NO;
                        self.followButton.backgroundColor = RGBColor(255,77,32);
                        self.model.if_guanzhu = @"0";
                        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app.overallParam setObject:@"0" forKey:self.model.ID];
                        if (self.callBack) self.callBack(-1);
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




@end
