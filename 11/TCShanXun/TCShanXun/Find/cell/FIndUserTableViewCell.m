//
//  FIndUserTableViewCell.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FIndUserTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface FIndUserTableViewCell()

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLa;//jianjie
@property (nonatomic,strong)UIButton *attentionBT;//关注按钮

@end

@implementation FIndUserTableViewCell

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
    
    _contentLa = [UILabel new];
    _contentLa.text = @"1188人关注";
    _contentLa.textAlignment = NSTextAlignmentLeft;
    _contentLa.font = [UIFont systemFontOfSize:12.0];
    _contentLa.textColor = RGBColor(222, 222, 222);
    
    _attentionBT = [UIButton new];
    _attentionBT.cornerRadius = 12.;
    [_attentionBT setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow_pre") forState:UIControlStateNormal];
    _attentionBT.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow") forState:UIControlStateSelected];
    [_attentionBT setTitle:@"已关注" forState:UIControlStateSelected];
    _attentionBT.layer.masksToBounds = YES;
    _attentionBT.layer.cornerRadius = 11;
    [_attentionBT addTarget:self action:@selector(attentionBTClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSArray *views = @[_iconView,_titleLabel,_contentLa,_attentionBT];
    NSArray *views = @[_iconView,_titleLabel,_attentionBT];
    [self.contentView sd_addSubviews:views];
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
    
    UIView * contentView = self.contentView;
    _iconView.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(contentView, 10).widthIs(40).heightIs(40);
    _attentionBT.sd_layout.rightSpaceToView(contentView, 20).centerYEqualToView(contentView).widthIs(65).heightIs(24);
    _titleLabel.sd_layout.leftSpaceToView(_iconView, 10).rightSpaceToView(_attentionBT, 10).topEqualToView(_iconView).heightIs(24);
    _contentLa.sd_layout.leftEqualToView(_titleLabel).rightEqualToView(_titleLabel).bottomEqualToView(_iconView).heightIs(16);

    
}


- (void)attentionBTClick:(UIButton *)bt
{
//    接口url：http://www.yzpai.cn/my/followUser
//    * 参数：
//    userid 用户id
//    token accessToken
//    uid 关注的uid
    NSDictionary *parm = @{@"userid":[UserManager shared].userInfo.uid,
                           @"token":[UserManager shared].userInfo.accessToken,
                           @"uid":_info.userid
                           };
    if (bt.selected) {
        //取消关注
        [HttpRequest get_RequestWithURL:UNFOLLOW_PERSON_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"用户取消关注dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    self.attentionBT.selected = NO;
                    [self.delegate updataInfoWith:self.index withBool:@"0"];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
        }];
    }else{
        //关注
        [HttpRequest get_RequestWithURL:FOLLOW_PERSON_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"用户关注dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    self.attentionBT.selected = YES;
                    [self.delegate updataInfoWith:self.index withBool:@"1"];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
        }];

    }
}
- (void)setInfo:(PersonModel *)info
{
    _info = info;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:nil];
    _titleLabel.text = info.nick;
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = [app.overallParam objectForKey:info.userid];
    if ([info.if_guanzhu intValue] == 1 || if_guanzhu.intValue == 1) {
        //已经关注了
        _attentionBT.selected = YES;
    }else{
        _attentionBT.selected = NO;
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
