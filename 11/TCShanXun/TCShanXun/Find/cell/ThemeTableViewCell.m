//
//  ThemeTableViewCell.m
//  News
//
//  Created by dzc on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface ThemeTableViewCell()

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *attentionLabel;//关注数
@property (nonatomic,strong)UIButton *attentionBT;//关注按钮

@end

@implementation ThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{
    _iconView = [[UIImageView alloc]init];
    _iconView.image = UIImageNamed(@"ic_login_connect_weibo_connected");
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 5;
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"今天做啥呢你奶奶的";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    _attentionLabel = [UILabel new];
    _attentionLabel.text = @"1188人关注";
    _attentionLabel.textAlignment = NSTextAlignmentLeft;
    _attentionLabel.font = [UIFont systemFontOfSize:12.0];
    _attentionLabel.textColor = RGBColor(222, 222, 222);
    
    _attentionBT = [UIButton new];
    _attentionBT.cornerRadius = 12.;
    [_attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow_pre") forState:UIControlStateNormal];
    [_attentionBT setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow") forState:UIControlStateSelected];
    [_attentionBT setTitle:@"已关注" forState:UIControlStateSelected];
    _attentionBT.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_attentionBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_attentionBT addTarget:self action:@selector(attentionBTClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *views = @[_iconView,_titleLabel,_attentionLabel,_attentionBT];
    [self.contentView sd_addSubviews:views];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView * contentView = self.contentView;
    _iconView.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(contentView, 10).widthIs(40).heightIs(40);
    _attentionBT.sd_layout.rightSpaceToView(contentView, 20).centerYEqualToView(contentView).widthIs(65).heightIs(24);
    _titleLabel.sd_layout.leftSpaceToView(_iconView, 10).rightSpaceToView(_attentionBT, 10).topEqualToView(_iconView).heightIs(24);
    _attentionLabel.sd_layout.leftEqualToView(_titleLabel).rightEqualToView(_titleLabel).bottomEqualToView(_iconView).heightIs(16);
    
}

- (void)xxx
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:nil];

}
-(void)setImageWithModel:(ThemeModel *)model
{
   if (model == nil) {
       [_iconView setImage:[UIImage imageNamed:@"约单头像加载"]];
  }else{
      [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:nil];
    [model setIsLoad:YES];//加载网络图片//下载
  }
}
- (void)setModel:(ThemeModel *)model
{
    _model = model;
//    [_iconView sd_setImageWithURL:nil];
//    [self performSelector:@selector(xxx) withObject:nil afterDelay:0 inModes:@[NSDefaultRunLoopMode]];

//    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    _titleLabel.text = model.name;
    _attentionLabel.text = [NSString stringWithFormat:@"%@人关注",model.num_follow];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = [app.overallParam objectForKey:model.ID];
    if ([model.if_guanzhu intValue] == 1 || if_guanzhu.intValue == 1) {
        //已经关注
        _attentionBT.selected = YES;
    }else{
        _attentionBT.selected = NO;
    }

}
- (void)attentionBTClick:(UIButton *)but
{
    weakObj(self);
    if ([UserManager shared].isLogin) {
        if (but.selected) {
            //取消关注
            //        接口url：http://www.yzpai.cn/news/topic/unfollow
            //        * 参数：
            //        userid 用户id
            //        token accessToken
            //        topicid 主题id
            NSDictionary *parm = @{@"userid":[UserManager shared].userInfo.uid,
                                   @"token":[UserManager shared].userInfo.accessToken,
                                   @"topicid":_model.ID
                                   };
            [HttpRequest get_RequestWithURL:UNFOLLOW_TOPIC_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    MLog(@"主题点击取消关注dic==%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        selfWeak.attentionBT.selected = NO;
                        [selfWeak.delegate updataInfoWith:self.index withBool:@"0"];
                        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app.overallParam setObject:@"0" forKey:self.model.ID];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
                
            }];
        }else{
            //关注
            NSDictionary *parm = @{@"userid":[UserManager shared].userInfo.uid,
                                   @"token":[UserManager shared].userInfo.accessToken,
                                   @"topicid":_model.ID
                                   };
            [HttpRequest get_RequestWithURL:FOLLOW_TOPIC_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    MLog(@"主题点击dic==%@",dic);
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        selfWeak.attentionBT.selected = YES;
                        [selfWeak.delegate updataInfoWith:self.index withBool:@"1"];
                        [app.overallParam setObject:@"1" forKey:self.model.ID];
                    }else if ([dic[@"msg"] isEqualToString:@"主题已关注"]){
                        selfWeak.attentionBT.selected = YES;
                        [selfWeak.delegate updataInfoWith:self.index withBool:@"1"];
                        [app.overallParam setObject:@"1" forKey:self.model.ID];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
                
            }];
            
        }

    }else{
        //未登陆
        
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self.viewController presentViewController:nav animated:YES completion:nil];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
