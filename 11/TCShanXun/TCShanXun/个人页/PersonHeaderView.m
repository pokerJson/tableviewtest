//
//  PersonHeaderView.m
//  News
//
//  Created by FANTEXIX on 2018/7/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PersonHeaderView.h"
#import "PersonModel.h"
#import "FollowView.h"
#import "FollowPersonViewController.h"
#import "PersonInfoViewController.h"

@interface PersonHeaderView ()

@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UIButton * followButton;
@property(nonatomic, strong)UIButton * editButton;
@property(nonatomic, strong)UILabel * signatureLabel;

@property(nonatomic, strong)UIView * shadowLine;

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIView * line;

@property(nonatomic, strong)FollowView * followView;
@property(nonatomic, strong)FollowView * followedView;

@property(nonatomic, strong)PersonModel * model;

@end


@implementation PersonHeaderView

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
    
    UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 76, 48)];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    shadowView.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    shadowView.layer.borderColor = shadowView.layer.shadowColor;
    shadowView.layer.borderWidth = 0.000001;
    shadowView.layer.cornerRadius = 10;
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 15;
    shadowView.layer.shadowOffset = CGSizeZero;
    [self addSubview:shadowView];

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, sWidth-120, 30)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = 0;
    _nameLabel.font = UIFontBSys(20);
    [self addSubview:_nameLabel];

    _signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _nameLabel.bottom+10, sWidth-30, 0)];
    _signatureLabel.font = UIFontSys(14);
    _signatureLabel.textColor = RGBColor(119, 119, 119);
    _signatureLabel.numberOfLines = 0;
    [self addSubview:_signatureLabel];
    
    UIImage * lan = [UIImage imageWithColor:RGBColor(60, 180, 245) imageSize:CGRectMake(0, 0, 5, 5)];
    UIImage * hui = [UIImage imageWithColor:RGBColor(226, 224, 226) imageSize:CGRectMake(0, 0, 5, 5)];
    _followButton = [[UIButton alloc]initWithFrame:CGRectMake(sWidth - 103, 15, 88, 36)];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _followButton.cornerRadius = 18.;
    _followButton.hidden = YES;
    [_followButton setBackgroundImage:lan forState:UIControlStateNormal];
    [_followButton setBackgroundImage:hui forState:UIControlStateSelected];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];

    _editButton = [[UIButton alloc]initWithFrame:CGRectMake(sWidth - 103, 15, 88, 36)];
    _editButton.borderColor = RGBColor(60, 180, 245);
    _editButton.borderWidth = 1;
    _editButton.hidden = YES;
    _editButton.backgroundColor = [UIColor whiteColor];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _editButton.cornerRadius = 18.;
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:RGBColor(60, 180, 245) forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editButton];
    
    weakObj(self);
    _followView = [[FollowView alloc]init];
    _followView.tapMethod = ^{
        [selfWeak followVC:YES];
    };
    [self addSubview:_followView];
    
    _followedView = [[FollowView alloc]init];
    _followedView.tapMethod = ^{
        [selfWeak followVC:NO];
    };
    [self addSubview:_followedView];

    _shadowLine = [[UIView alloc]init];
    _shadowLine.backgroundColor = RGBColor(243, 243, 243);
    [self addSubview:_shadowLine];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = RGBColor(150, 150, 150);
    _titleLabel.textAlignment = 0;
    _titleLabel.font = UIFontSys(15);
    [self addSubview:_titleLabel];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = RGBColor(175, 175, 175);
    [self addSubview:_line];
    
    
//    _nameLabel.backgroundColor = [UIColor greenColor];
//    _signatureLabel.backgroundColor = [UIColor greenColor];
//    _followView.backgroundColor = [UIColor greenColor];
}


- (void)followButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //关注
            //userid 用户id
            //token accessToken
            //uid 关注的uid
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
                                     @"uid":_model.userid,
                                     };
            [HttpRequest get_RequestWithURL:UNFOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = NO;
                        self.model.if_guanzhu = @"0";
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
- (void)editButtonMethod:(UIButton *)button {
    
    PersonInfoViewController * vc = [PersonInfoViewController new];
    vc.model = _model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _followView.frame = CGRectMake(0, self.height-114, sWidth/2., 60);
    _followedView.frame = CGRectMake(sWidth/2., self.height-114, sWidth/2., 60);
    _shadowLine.frame = CGRectMake(0, self.height-54, sWidth, 10);
    _titleLabel.frame = CGRectMake(15, self.height-44, sWidth-30, 44);
    _line.frame = CGRectMake(0, self.height-0.4, sWidth, 0.4);
}

- (void)loadDataWithModel:(PersonModel *)model {
    _model = model;
    
    _nameLabel.text = model.nick;
    
    if (model.isSelf) {
        _followButton.hidden = YES;
        _editButton.hidden = NO;
    }else {
        _followButton.hidden = NO;
        _editButton.hidden = YES;
    }

    if (model.isSelf) {
        _titleLabel.text = @"我在以下话题蹦迪";
        _followView.tab = @"我关注的人";
        _followedView.tab = @"关注我的人";
    }else {
        _titleLabel.text = @"TA在以下话题蹦迪";
        _followView.tab = @"TA关注的人";
        _followedView.tab = @"关注TA的人";
    }
    
    _followView.num = [NSString stringWithFormat:@"%@",model.num_followings];
    _followedView.num = [NSString stringWithFormat:@"%@",model.num_followers];
    
    if ([model.if_guanzhu intValue]) {
        _followButton.selected = YES;
    }else {
        _followButton.selected = NO;
    }
    
    
    if (![_model.signature isEqualToString:@""] && _updateFrame) {
        
        CGFloat height = [_model.signature boundingRectWithSize:CGSizeMake(sWidth-30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        height = ceil(height);
        _signatureLabel.frame = CGRectMake(15, _nameLabel.bottom+10, sWidth-30, height);
        _signatureLabel.text = _model.signature;
        
        self.frame = CGRectMake(0, 0, sWidth, 214+height+10);

        _updateFrame();
    }

}

- (void)followVC:(BOOL)follow {
    
    if ([UserManager shared].isLogin) {
        
        FollowPersonViewController * vc =  [FollowPersonViewController new];
        vc.isSelf = _model.isSelf;
        vc.follow = follow;
        vc.uid = _model.userid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self.viewController presentViewController:nav animated:YES completion:nil];
        
    }
    
    
}



@end
