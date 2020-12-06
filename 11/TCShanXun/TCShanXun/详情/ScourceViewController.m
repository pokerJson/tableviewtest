//
//  ScourceViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ScourceViewController.h"
#import <WebKit/WebKit.h>
#import "CommentViewController.h"
#import "RelationView.h"

@interface ScourceViewController ()<ShareViewDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)WKWebView * webView;


@property(nonatomic, strong)UIView * bottomView;
@property(nonatomic, strong)UIButton * shareButton;
@property(nonatomic, strong)ITButton * likeButton;
@property(nonatomic, strong)ITButton * commentButton;
@property(nonatomic, strong)UIButton * collectionButton;
@property(nonatomic, strong)UIButton * arrowButton;

@property(nonatomic, strong)UIProgressView * progressView;


@property(nonatomic, strong)UIView * relationBgView;
@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, strong)NSTimer * scrollTimer;
@property(nonatomic, strong)NSMutableArray * dataArr;


@end

@implementation ScourceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_commentButton setTitle:_model.num_comment forState:UIControlStateNormal];
}

- (void)startFullScreen {
    NSLog(@"startFullScreen");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)endFullScreen {
    NSLog(@"endFullScreen");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSMutableArray * mArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if ([mArr[mArr.count-2] isKindOfClass:[ScourceViewController class]]) {
        [mArr removeObjectAtIndex:mArr.count-2];
        self.navigationController.viewControllers = mArr;
    }
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navRightButton.hidden = YES;
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    self.navTitleLabel.text = _model.source_site;
    
    if (![Reachability shared].reachable) [KKHUD showMiddleWithErrorStatus:@"没有网络"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];

    [self createMiddle];
    
    [self createBottom];
    
    [self loadData];
}


- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)createMiddle {
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.mediaPlaybackRequiresUserAction = YES;
    config.allowsInlineMediaPlayback = NO;
    config.mediaPlaybackAllowsAirPlay = YES;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height-kBottomInsets-44-50) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth,1.5)];
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.progressTintColor = RGBColor(252, 145, 108);
    [self.view addSubview:_progressView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.rec_url]]];
    
    
    
    _relationBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _webView.bottom, kWidth, 50)];
    _relationBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_relationBgView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth-75, 50)];
    _scrollView.backgroundColor = RGBColor(255, 255, 255);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_relationBgView addSubview:_scrollView];
    
    _dataArr = [[NSMutableArray alloc]init];
    
    _scrollTimer = [MSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    [_scrollTimer setFireDate:[NSDate distantFuture]];
    
    UIView * shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    shadowLine.backgroundColor = RGBColor(175, 175, 175);
    [_relationBgView addSubview:shadowLine];
    
}

- (void)timerMethod:(NSTimer *)timer {
    NSInteger currentPage = _scrollView.contentOffset.x /_scrollView.width;
    if (currentPage == 0) {
        //当前页为0时,滚动到下一页 不带动画不触发协议方法
        [_scrollView setContentOffset:CGPointMake(_scrollView.width*(currentPage + 1), 0) animated:NO];
    }else {
        //带动画触发协议方法
        [_scrollView setContentOffset:CGPointMake(_scrollView.width*(currentPage + 1), 0) animated:YES];
    }
}



- (void)loadData {
    
    NSDictionary * param = nil;
    if ([UserManager shared].isLogin) {
        param = @{
                  @"id":_ID,
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  };
    }else {
        param = @{
                  @"id":_ID,
                  };
    }
    
    [HttpRequest get_RequestWithURL:NEWS_INFO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if (self.model == nil) self.model = [BListModel new];
                [self.model setValuesForKeysWithDictionary:dic[@"data"]];
                [self updateData];
                
                NSArray * arr = dic[@"data"][@"relationnews"];
                
                for (int i = 0; i < arr.count; i++) {
                    BListModel * model = [BListModel new];
                    [model setValuesForKeysWithDictionary:arr[i]];
                    [self.dataSource addObject:model];
                }
                
                [self loadRelationViewData];

            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}


- (void)updateData {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.rec_url]]];
    
    [[UserActionReport shared]newsPost:_model.ID ext:_model.ext];
    
    self.navTitleLabel.text = _model.source_site;
    
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


/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}



- (void)createBottom {
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-kBottomInsets-44, kWidth, kBottomInsets+44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];

    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-59, 0, 44, 44)];
    [_shareButton setImage:[UIImage imageNamed:@"info_share"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_shareButton];
    
    
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(_shareButton.x-59, 0, 44, 44)];
    _collectionButton.adjustsImageWhenHighlighted = NO;
    [_collectionButton setImage:UIImageNamed(@"info_h5_comment") forState:UIControlStateNormal];
    [_collectionButton setImage:UIImageNamed(@"info_h5_comment_pre") forState:UIControlStateSelected];
    [_collectionButton addTarget:self action:@selector(collectionButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_collectionButton];
    

    _commentButton = [[ITButton alloc]initWithFrame:CGRectMake(_collectionButton.x-65, 0, 65, 44)];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_commentButton setImage:[UIImage imageNamed:@"info_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:RGBColor(180, 180, 180)  forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_commentButton];
    
    
    _likeButton = [[ITButton alloc]initWithFrame:CGRectMake(_commentButton.x-80, 0, 70, 44)];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_likeButton setImage:[UIImage imageNamed:@"info_love_pre"] forState:UIControlStateNormal];
    [_likeButton setTitleColor:RGBColor(180, 180, 180) forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"info_love"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_likeButton];
    
    UIView * shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    shadowLine.backgroundColor = RGBColor(175, 175, 175);
    [_bottomView addSubview:shadowLine];


    if (_model.if_love.intValue == 0) {
        _likeButton.selected = NO;
    }else {
        _likeButton.selected = YES;
    }
    [_likeButton setTitle:_model.num_love forState:UIControlStateNormal];
    
    if (_model.if_fav.intValue == 0) {
        _collectionButton.selected = NO;
    }else {
        _collectionButton.selected = YES;
    }
    
}

- (void)loadRelationViewData {
    
    if (self.dataSource.count == 0) {
        
        _webView.frame = CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height-kBottomInsets-44);
        _relationBgView.hidden = YES;
        [_scrollTimer setFireDate:[NSDate distantFuture]];
        
    }else {
       
        //构建数据源  使视图能够左右轮播
        [_dataArr removeAllObjects];
        
        [_dataArr addObject:[self.dataSource lastObject]];
        [_dataArr addObjectsFromArray:self.dataSource];
        [_dataArr addObject:[self.dataSource firstObject]];
        
        _scrollView.contentSize = CGSizeMake(_scrollView.width * _dataArr.count, _scrollView.height);
        _scrollView.contentOffset = CGPointMake(_scrollView.width, 0);
        
        NSLog(@"%zd",self.dataSource.count);
        NSLog(@"%zd",_dataArr.count);
        
        for (int i = 0; i < _dataArr.count; i++) {
            RelationView * relationView = [[RelationView alloc]initWithFrame:CGRectMake(i*_scrollView.width, 0, _scrollView.width, _scrollView.height)];
            [relationView loadDataWithModel:_dataArr[i]];
            [_scrollView addSubview:relationView];
        }
        
        if (_dataArr.count <= 3) {
            _scrollView.scrollEnabled = NO;
        }else {
            //开启定时器
            [_scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            _scrollView.scrollEnabled = YES;
        }
        
    }

}

// 定时器暂停问题
// 开始拖拽 暂定定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_scrollTimer setFireDate:[NSDate distantFuture]];
}
// 拖拽完毕 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_dataArr.count > 3) {
        [_scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
}

//减速完毕
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //刷新填充数据
    [self refreshData:scrollView];
}

//动画移动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //刷新填充数据
    [self refreshData:scrollView];
}

//刷新填充数据
- (void)refreshData:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x /_scrollView.width;
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((_dataArr.count - 2)*_scrollView.width, 0) animated:NO];
        currentPage = _dataArr.count - 2;
    }
    if (currentPage == _dataArr.count - 1) {
        [scrollView setContentOffset:CGPointMake(_scrollView.width, 0) animated:NO];
        currentPage = 1;
    }
}


- (void)shareButtonMethod:(UIButton *)button {
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
}
- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:_model atIndex:index viewController:self.navigationController];
}


- (void)likeButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
            return;
        }
        
        if (button.selected == NO) {
            
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
    vc.bModel = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionButtonMethod:(UIButton *)button {
    
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





- (void)dealloc {
    if ([_scrollTimer isValid]) {
        [_scrollTimer invalidate];
    }
    _scrollTimer = nil;
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}


@end
