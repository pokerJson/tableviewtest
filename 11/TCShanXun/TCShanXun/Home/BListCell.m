//
//  BListCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BListCell.h"
#import "ThemeVC.h"
#import "TopicViewController.h"


@interface BListCell ()

@property(nonatomic, strong)UIButton * avatarButton;
@property(nonatomic, strong)UIButton * followButton;

@property(nonatomic, strong)UIButton * titleButton;

@property(nonatomic, strong)UILabel * topicLabel;
@property(nonatomic, strong)UILabel * viceTopicLabel;

@property(nonatomic, strong)UIButton * sourceButton;

@property(nonatomic, strong)UILabel * contentLabel;

@property(nonatomic, strong)UIButton * likeButton;
@property(nonatomic, strong)UIButton * commentButton;
@property(nonatomic, strong)UIButton * favoButton;
@property(nonatomic, strong)UIButton * shareButton;
@property(nonatomic, strong)UIButton * moreButton;


@property(nonatomic, strong)UIView * shadowLine;
@property(nonatomic, strong)UIView * separatorView;


@end

@implementation BListCell

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
    
    _imageViewArr = @[].mutableCopy;
}


- (void)addSubviews {
    
    _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 35, 35)];
    _avatarButton.cornerRadius = 17.5;
    _avatarButton.adjustsImageWhenHighlighted = NO;
    [_avatarButton addTarget:self action:@selector(topicMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_avatarButton];

    
    _followButton = [[UIButton alloc]initWithFrame:CGRectMake(14, 35, 16, 16)];
    _followButton.userInteractionEnabled = NO;
    [_followButton setImage:[UIImage imageNamed:@"info_follow"] forState:UIControlStateNormal];
    [_followButton setImage:[UIImage imageNamed:@"info_follow_pre"] forState:UIControlStateSelected];
    [self addSubview:_followButton];

    
    _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(_avatarButton.right+10, _avatarButton.top, 0, 34)];
    [_titleButton addTarget:self action:@selector(titleButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleButton];
    
    
    _topicLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarButton.right+10, _avatarButton.top, 88, 20)];
    _topicLabel.font = UIFontSys(14);
    _topicLabel.textColor = RGBColor(117, 117, 117);
    [self addSubview:_topicLabel];


    _viceTopicLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarButton.right+10, _topicLabel.bottom, sWidth-100, 15)];
    _viceTopicLabel.font = UIFontSys(12);
    _viceTopicLabel.textColor = RGBColor(133,137,140);
    [self addSubview:_viceTopicLabel];
    
    
    _sourceButton = [[UIButton alloc]initWithFrame:CGRectMake(sWidth-55, 15, 40, 35)];
    //_sourceButton.contentHorizontalAlignment = 2;
    _sourceButton.userInteractionEnabled = NO;
    _sourceButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_sourceButton setImage:[UIImage resizeImage:UIImageNamed(@"info_link") size:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    [_sourceButton setTitleColor:RGBColor(158,158,158)  forState:UIControlStateNormal];
    [self addSubview:_sourceButton];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = UIFontSys(16);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _shadowLine = [[UIView alloc]init];
    _shadowLine.backgroundColor = RGBColor(190, 190, 190);
    [self addSubview:_shadowLine];
    
    _likeButton = [[UIButton alloc]init];
    _likeButton.contentHorizontalAlignment = 1;
    _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_likeButton setImage:[UIImage imageNamed:@"info_love_pre"] forState:UIControlStateNormal];
    [_likeButton setTitleColor:RGBColor(158,158,158) forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"info_love"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    _commentButton = [[UIButton alloc]init];
    _commentButton.contentHorizontalAlignment = 1;
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_commentButton setImage:[UIImage imageNamed:@"info_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:RGBColor(158,158,158)  forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    _shareButton = [[UIButton alloc]init];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_shareButton setImage:[UIImage imageNamed:@"info_share"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    _favoButton = [[UIButton alloc]init];
    _favoButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_favoButton setImage:[UIImage imageNamed:@"info_h5_comment"] forState:UIControlStateNormal];
    [_favoButton setImage:[UIImage imageNamed:@"info_h5_comment_pre"] forState:UIControlStateSelected];
    [_favoButton addTarget:self action:@selector(favoButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_favoButton];
    
    
    _moreButton = [[UIButton alloc]init];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_moreButton setImage:[UIImage imageNamed:@"info_more"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    
    
    _separatorView = [[UIView alloc]init];
    _separatorView.backgroundColor = RGBColor(245,245,245);
    [self addSubview:_separatorView];
    
    
//    _likeButton.backgroundColor = [UIColor greenColor];
//    _commentButton.backgroundColor = [UIColor greenColor];
//    _shareButton.backgroundColor = [UIColor greenColor];
//    _sourceButton.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _shadowLine.frame = CGRectMake(15, self.height-52.4, sWidth-30, 0.4);
    
    float inset = (sWidth-100)/6.;
    
    _likeButton.frame = CGRectMake(inset, self.height-52, 60, 44);
    _commentButton.frame = CGRectMake(inset+(20+inset)*1, _likeButton.y, 60, 44);
    _favoButton.frame = CGRectMake(inset+(20+inset)*2-10, _likeButton.y, 40, 44);
    _shareButton.frame = CGRectMake(inset+(20+inset)*3-10, _likeButton.y, 40, 44);
    _moreButton.frame = CGRectMake(inset+(20+inset)*4-10, _likeButton.y, 40, 44);

    
    _separatorView.frame = CGRectMake(0, self.height-8, sWidth, 8);
}


- (void)sourceButtonMethod:(UIButton *)button {
 
}

- (void)moreButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreMethod:)]) {
        [self.delegate moreMethod:self];
    }
}

- (void)likeButtonMethod:(UIButton *)button {
   
    if ([UserManager shared].isLogin) {
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
            return;
        }
        
        
        if (button.selected == NO) {
            
            NSDictionary * param = nil;
            
            if (_model.ext != nil) {
                param = @{
                          @"userid":[UserManager shared].userInfo.uid,
                          @"token":[UserManager shared].userInfo.accessToken,
                          @"newsid":_model.ID,
                          @"ext":_model.ext,
                          };
            }else {
                param = @{
                          @"userid":[UserManager shared].userInfo.uid,
                          @"token":[UserManager shared].userInfo.accessToken,
                          @"newsid":_model.ID,
                          };
            }
            
            
            [HttpRequest get_RequestWithURL:LIKE_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.likeButton.selected = YES;
                        self.model.if_love = @"1";
                        self.model.num_love = @(self.model.num_love.intValue+1).stringValue;
                        [self.likeButton setTitle:[NSString stringWithFormat:@"%@",self.model.num_love] forState:UIControlStateNormal];
                        
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
                                     @"newsid":_model.ID,
                                     };
            [HttpRequest get_RequestWithURL:UNLIKE_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.likeButton.selected = NO;
                        self.model.if_love = @"0";
                        if (self.model.num_love.intValue > 0) {
                            self.model.num_love = @(self.model.num_love.intValue-1).stringValue;
                        }
                        [self.likeButton setTitle:[NSString stringWithFormat:@"%@",self.model.num_love] forState:UIControlStateNormal];
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
- (void)commentButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentMethod:)]) {
        [self.delegate commentMethod:self];
    }
}
- (void)shareButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMethod:)]) {
        [self.delegate shareMethod:self];
    }
}

- (void)setSpe:(BOOL)spe {
    _spe = spe;
    _separatorView.hidden = spe;
}


- (void)loadDataWithModel:(BListModel *)model {
    _model = model;
    
    for (UIView * obj in _imageViewArr) {
        [obj removeFromSuperview];
    }
    [_imageViewArr removeAllObjects];
    
    self.avatarButton.borderWidth = 0;
    weakObj(self);
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:model.topicicon] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        selfWeak.avatarButton.borderColor = RGBColor(235, 235, 235);
        selfWeak.avatarButton.borderWidth = 1;
    }];
    
    if (_model.if_guanzhu.intValue == 0) {
        _followButton.hidden = NO;
        _followButton.selected = NO;
    }else {
        _followButton.hidden = YES;
        _followButton.selected = YES;
    }
    
    _titleButton.frame = CGRectMake(_avatarButton.right+10, _avatarButton.top, model.titleWidth, 35);
    
    if ([model.showtype isEqualToString:@""] || model.showtype == nil) {
        _topicLabel.frame = CGRectMake(_avatarButton.right+10, _avatarButton.top, model.titleWidth, 35);
    }else {
        _topicLabel.frame = CGRectMake(_avatarButton.right+10, _avatarButton.top, model.titleWidth, 20);
    }
    _topicLabel.text = model.topicname;
    

    if ([model.dataType isEqualToString:@"1"]) {
        _topicLabel.frame = CGRectMake(_avatarButton.right+10, _avatarButton.top, model.titleWidth, 20);
        _viceTopicLabel.text = [NSString dateFormat:model.posttime.integerValue formatter:@"MM-dd HH:mm"];
    }else {
        _viceTopicLabel.text = model.showtype;
    }
    
    _contentLabel.frame = CGRectMake(15, _avatarButton.bottom+10, sWidth-30, model.contentHeight);
    _contentLabel.attributedText = [self attributed:model.content lineSpace:5];
    
    [_likeButton setTitle:[NSString stringWithFormat:@"%@",model.num_love] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%@",model.num_comment] forState:UIControlStateNormal];
    
    
    
    if (_model.if_love.intValue == 0) {
        _likeButton.selected = NO;
    }else {
        _likeButton.selected = YES;
    }
    
    if (_model.if_fav.intValue == 0) {
        _favoButton.selected = NO;
    }else {
        _favoButton.selected = YES;
    }
    
    
    
    if (model.picsArr.count == 1) {
        
        float rate = [model.picsArr.firstObject[@"width"] floatValue]/[model.picsArr.firstObject[@"height"] floatValue];
        float w = rate*model.imageHeight;
        if (isnan(w)) {
            NSMutableDictionary * dic = [model.picsArr.firstObject mutableCopy];
            [dic setObject:@"180" forKey:@"width"];
            [dic setObject:@"180" forKey:@"height"];
            model.picsArr = @[dic];
            w = 180;
        }
    
        
        float screenRate;
        if (IS_IPHONE_X) {
            screenRate = (kScreenHeight-kBottomInsets-kStatusHeight)/kScreenWidth;
        }else {
            screenRate = kScreenHeight/kScreenWidth;
        }
        float hRate = [model.picsArr.firstObject[@"height"] floatValue]/[model.picsArr.firstObject[@"width"] floatValue];

        
        
        if (model.type.intValue == 3) {
            w = sWidth-30;
        }else {
            if (w > sWidth-30) {
                w = sWidth-30;
            }
            if (!isnan(hRate) && hRate > screenRate) {
                w = 150;
            }
        }
        
        YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(15, _contentLabel.bottom+10, w, model.imageHeight)];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *urlStr = [model.picsArr.firstObject[@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageView yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation];
        imageView.tag  = 8800;
        [self addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        [imageView addGestureRecognizer:tap];
        [_imageViewArr addObject:imageView];
        
        if (model.type.intValue == 3) {
            
            UIImageView * playIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kHalf(imageView.width-50), kHalf(imageView.height-50), 50, 50)];
            playIcon.image = UIImageNamed(@"video_icon_play");
            [imageView addSubview:playIcon];
            
        }else {
           
            if ([model.picsArr.firstObject[@"small"]hasSuffix:@".gif"] || [model.picsArr.firstObject[@"small"] hasSuffix:@".GIF"] ) {
                UIImageView * gif = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width-35, imageView.height-24, 30, 19)];
                gif.image = UIImageNamed(@"icon_gif");
                [imageView addSubview:gif];
            }
            
            if (!isnan(hRate) && hRate >= 3) {
                UIImageView * longImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width-35, imageView.height-24, 30, 19)];
                longImage.image = UIImageNamed(@"icon_length");
                [imageView addSubview:longImage];
            }
        }
        
        
        
    }else if (model.picsArr.count > 1) {
        
        for (int i = 0; i < model.picsArr.count; i++) {
        
            
            YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(15+i%3*((sWidth-40)/3.+5), _contentLabel.bottom+10 + i/3*((sWidth-40)/3.+5), (sWidth-40)/3., (sWidth-40)/3.)];
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            NSString *urlStr = [model.picsArr[i][@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [imageView yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation];
            imageView.tag  = 8800 + i;
            [self addSubview:imageView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
            [imageView addGestureRecognizer:tap];
            [_imageViewArr addObject:imageView];
            
            
            if ([model.picsArr[i][@"small"]hasSuffix:@".gif"] || [model.picsArr[i][@"small"] hasSuffix:@".GIF"] ) {
                UIImageView * gif = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width-35, imageView.height-24, 30, 19)];
                gif.image = UIImageNamed(@"icon_gif");
                [imageView addSubview:gif];
            }
            
            
            float screenRate;
            if (IS_IPHONE_X) {
                screenRate = (kScreenHeight-kBottomInsets-kStatusHeight)/kScreenWidth;
            }else {
                screenRate = kScreenHeight/kScreenWidth;
            }
            float hRate = [model.picsArr[i][@"height"] floatValue]/[model.picsArr[i][@"width"] floatValue];
            
            if (!isnan(hRate) && hRate >= 3) {
                UIImageView * longImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width-35, imageView.height-24, 30, 19)];
                longImage.image = UIImageNamed(@"icon_length");
                [imageView addSubview:longImage];
            }
            
            
        }
        
    }
    
    
}

- (void)tapMethod:(UITapGestureRecognizer *)tap {
    NSLog(@"%zd",tap.view.tag-8800);
    if (self.delegate && [self.delegate respondsToSelector:@selector(picMethod:atIndex:)]) {
        [self.delegate picMethod:self atIndex:(int)(tap.view.tag-8800)];
    }

}


- (void)topicMethod:(UIButton *)button {
    
    if (_model.if_guanzhu.intValue == 0) {

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
                            self.model.if_guanzhu = @"1";
                            [app.overallParam setObject:@"1" forKey:self.model.topicid];
                            if (self.reloadBlock) self.reloadBlock();
                            [KKHUD showBottomWithStatus:@"关注成功"];
                            
                        }else if ([dic[@"msg"] isEqualToString:@"主题已关注"]){
                            self.followButton.selected = YES;
                            self.model.if_guanzhu = @"1";
                            [app.overallParam setObject:@"1" forKey:self.model.topicid];
                            if (self.reloadBlock) self.reloadBlock();
                            [KKHUD showBottomWithStatus:@"关注成功"];
                            
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
        
    }else {
        
        TopicViewController * vc = [[TopicViewController alloc]init];
        vc.topicID = _model.topicid;
        vc.bModel = _model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }

}

- (void)favoButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
            return;
        }
        
        if (button.selected == NO) {
            //收藏
            //userid 用户id
            //token accessToken
            //newsid 消息id
            NSDictionary * param = nil;
            if (_model.ext != nil) {
                param =  @{
                           @"userid":[UserManager shared].userInfo.uid,
                           @"token":[UserManager shared].userInfo.accessToken,
                           @"newsid":_model.ID,
                           @"ext":_model.ext,
                           };
            }else {
                param =  @{
                           @"userid":[UserManager shared].userInfo.uid,
                           @"token":[UserManager shared].userInfo.accessToken,
                           @"newsid":_model.ID,
                           };
            }
            
            [HttpRequest get_RequestWithURL:FAVO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.model.if_fav = @"1";
                        self.favoButton.selected = YES;
                        [KKHUD showBottomWithStatus:@"收藏成功"];
                        
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
                                     @"newsid":_model.ID,
                                     };
            
            [HttpRequest get_RequestWithURL:UNFAVO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.model.if_fav = @"0";
                        self.favoButton.selected = NO;
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

- (void)titleButtonMethod:(UIButton *)button {
    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = _model.topicid;
    vc.bModel = _model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


- (NSAttributedString *)attributed:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    return attributedString;
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
