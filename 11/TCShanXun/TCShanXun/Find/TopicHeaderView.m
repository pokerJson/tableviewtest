//
//  TopicHeaderView.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TopicHeaderView.h"
#import "FollowView.h"

@interface TopicHeaderView ()

@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UILabel * signatureLabel;
@property(nonatomic, strong)UIButton * followButton;
@property(nonatomic, strong)UIView * shadowLine;

@property(nonatomic, strong)TopicModel * model;

@end

@implementation TopicHeaderView

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
    
    UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(kHalf(sWidth-98), -48, 96, 96)];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    shadowView.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    shadowView.layer.borderColor = shadowView.layer.shadowColor;
    shadowView.layer.borderWidth = 0.000001;
    shadowView.layer.cornerRadius = 48.;
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 15;
    shadowView.layer.shadowOffset = CGSizeZero;
    [self addSubview:shadowView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, sWidth-30, 25)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = 1;
    _nameLabel.font = UIFontBSys(20);
    [self addSubview:_nameLabel];
    
    _signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _nameLabel.bottom+10, sWidth-30, 0)];
    _signatureLabel.font = UIFontSys(14);
    _signatureLabel.textColor = RGBColor(119, 119, 119);
    _signatureLabel.textAlignment = 1;
    _signatureLabel.numberOfLines = 0;
    [self addSubview:_signatureLabel];

    
    _followButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(sWidth-88), sHeight-58, 88, 35)];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _followButton.cornerRadius = 5;
    [_followButton setBackgroundImage:UIImageNamed(@"btn_theme_follow_pre") forState:UIControlStateNormal];
    [_followButton setBackgroundImage:UIImageNamed(@"btn_theme_follow") forState:UIControlStateSelected];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];

    
    _shadowLine = [[UIView alloc]init];
    _shadowLine.backgroundColor = RGBColor(245, 245, 245);
    [self addSubview:_shadowLine];
    
//    _nameLabel.backgroundColor = [UIColor greenColor];
//    _signatureLabel.backgroundColor = [UIColor greenColor];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _followButton.frame = CGRectMake(kHalf(sWidth-88), sHeight-58, 88, 35);
    _shadowLine.frame = CGRectMake(0, self.height-8, sWidth, 8);
}

- (void)loadDataWithModel:(TopicModel *)model {
    _model = model;
    
    _nameLabel.text = model.name;
    
    if (![_model.des isEqualToString:@""] && _updateFrame) {

        CGFloat height = [_model.des boundingRectWithSize:CGSizeMake(sWidth-30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        height = ceil(height);
        _signatureLabel.frame = CGRectMake(15, _nameLabel.bottom+10, sWidth-30, height);
        _signatureLabel.text = _model.des;
        
        self.frame = CGRectMake(0, 0, sWidth, 153+height+12);
        
        _updateFrame();
    }
    
    if ([model.if_guanzhu intValue]) {
        _followButton.selected = YES;
    }else {
        _followButton.selected = NO;
    }
    
    
}
- (void)followButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //关注
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"topicid":_model.ID,
                                     };
            [HttpRequest get_RequestWithURL:FOLLOW_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = YES;
                        self.model.if_guanzhu = @"1";
                        self.model.num_follow = @(self.model.num_follow.integerValue+1).stringValue;
                        [app.overallParam setObject:@"1" forKey:self.model.ID];
                        if (self.updateFollow) self.updateFollow();
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
                                     @"topicid":_model.ID,
                                     };
            [HttpRequest get_RequestWithURL:UNFOLLOW_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = NO;
                        self.model.if_guanzhu = @"0";
                        self.model.num_follow = @(self.model.num_follow.integerValue-1).stringValue;
                        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app.overallParam setObject:@"0" forKey:self.model.ID];
                        if (self.updateFollow) self.updateFollow();
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
