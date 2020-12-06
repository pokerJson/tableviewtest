//
//  FimeMessageSourceViewController.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FimeMessageSourceViewController.h"
#import <WebKit/WebKit.h>
#import "CommentViewController.h"
#import "FindMessageInfo.h"
@interface FimeMessageSourceViewController ()<ShareViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic, strong)WKWebView * webView;


@property(nonatomic, strong)UIView * bottomView;
@property(nonatomic, strong)ITButton * likeButton;
@property(nonatomic, strong)ITButton * commentButton;
@property(nonatomic, strong)UIButton * collectionButton;
@property(nonatomic, strong)UIButton * arrowButton;

@end

@implementation FimeMessageSourceViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (_model.if_fav.intValue == 0) {
        _collectionButton.selected = NO;
    }else {
        _collectionButton.selected = YES;
    }
    
    [_commentButton setTitle:_model.num_comment forState:UIControlStateNormal];
    
    if (_model.if_love.intValue == 0) {
        _likeButton.selected = NO;
    }else {
        _likeButton.selected = YES;
    }
    
    [_likeButton setTitle:_model.num_love forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    [self.navRightButton setImage:UIImageNamed(@"info_share") forState:UIControlStateNormal];
    self.navTitleLabel.text = self.model.source_site;
    
    WKWebViewConfiguration *con = [[WKWebViewConfiguration alloc]init];
    con.mediaPlaybackAllowsAirPlay = YES;
    con.mediaPlaybackRequiresUserAction = NO;
    con.allowsInlineMediaPlayback = YES;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height-kBottomInsets-44) configuration:con];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_rec_url]]];
    [self.view addSubview:_webView];
    
    
    [self createBottom];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightMethod:(UIButton *)button {
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
}

- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:nil atIndex:index viewController:self.navigationController];
}



- (void)createBottom {
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-kBottomInsets-44, kWidth, kBottomInsets+44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    
    _arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 44, 44)];
    [_arrowButton setImage:[UIImage imageNamed:@"Artboard"] forState:UIControlStateNormal];
    [_arrowButton addTarget:self action:@selector(arrowButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_arrowButton];
    
    
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-54, 0, 34, 44)];
    [_collectionButton setImage:[UIImage grayscaleImageForImage:UIImageNamed(@"Artboard") rgb:200] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"Artboard"] forState:UIControlStateSelected];
    [_collectionButton addTarget:self action:@selector(collectionButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_collectionButton];
    
    
    _commentButton = [[ITButton alloc]initWithFrame:CGRectMake(_collectionButton.x-70, 0, 70, 44)];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_commentButton setImage:[UIImage imageNamed:@"info_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:RGBColor(180, 180, 180)  forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_commentButton];
    
    
    _likeButton = [[ITButton alloc]initWithFrame:CGRectMake(_commentButton.x-75, 0, 70, 44)];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_likeButton setImage:[UIImage imageNamed:@"info_love_pre"] forState:UIControlStateNormal];
    [_likeButton setTitleColor:RGBColor(180, 180, 180) forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"info_love"] forState:UIControlStateSelected];
//    [_likeButton setBackgroundImage:UIImageNamed(@"ic_messages_like_selected_shining") forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_likeButton];
    
    
    
    UIView * shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    shadowLine.backgroundColor = RGBColor(175, 175, 175);
    [_bottomView addSubview:shadowLine];
    
    
}

- (void)arrowButtonMethod:(UIButton *)button {
    
}


- (void)likeButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //点赞
            //userid 用户id
            //token accessToken
            //newsid 消息id
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"newsid":_model.ID,
                                     };
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
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    
}
- (void)commentButtonMethod:(UIButton *)button {
    
    CommentViewController * vc = [CommentViewController new];
    vc.ID = _model.ID;
    vc.info = _model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //收藏
            //userid 用户id
            //token accessToken
            //newsid 消息id
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"newsid":_model.ID,
                                     };
            
            [HttpRequest get_RequestWithURL:FAVO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        
                        self.model.if_fav = @"1";
                        self.collectionButton.selected = YES;
                        
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
                        self.collectionButton.selected = NO;
                        
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
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}

@end
