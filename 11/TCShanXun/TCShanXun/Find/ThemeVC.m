//
//  ThemeVC.m
//  News
//
//  Created by dzc on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemeVC.h"
#import "FIndMessageTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "FindMessageInfo.h"
#import "AddCollectionView.h"
#import "CommentViewController.h"
#import "FimeMessageSourceViewController.h"


#define HeaderImageViewHeight (kStatusHeight + 100)
#define HeaderHeight (HeaderImageViewHeight + 200)

@interface ThemeVC ()<UITableViewDelegate,UITableViewDataSource,ShareViewDelegate,FIndMessageTableViewCellDlegate,AddCollectionViewDelegate>{
    float _historyY;
    int tmp;

}
//xxxxxx
@property(nonatomic, strong)FIndMessageTableViewCell * moreViewCell;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;

@property(strong, nonatomic) UIView *headerView;// headerview
@property(strong, nonatomic) UIImageView *headerImageView;//背景图片
@property(strong, nonatomic)UIVisualEffectView *imageEffectView;

//top 导航栏
@property (strong, nonatomic) UIImageView *topView;
@property(nonatomic, strong)UIVisualEffectView *topEffectView;
@property(nonatomic, strong)UILabel *topTitle;
@property(nonatomic, strong)UIButton *shareBt;

//头像 遮罩层 关注数
@property (strong, nonatomic) UIImageView *iconImagView;
@property (strong, nonatomic) UILabel *attentionNumber;
@property (strong, nonatomic) UIView *eeeeev;

//标题 创建者等
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *authorIcon;
@property (strong, nonatomic) UILabel *chuangjianzhe;
@property (strong, nonatomic) UILabel *author;
@property (strong, nonatomic) UILabel *contentLabel;//有的没有创建者只有一个说明
@property (strong, nonatomic) UIButton *attentionBT;

@property(nonatomic, strong)UILabel *bottomLine;

@property(nonatomic, strong)NSDictionary * topicDic;

@end

@implementation ThemeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[_tableView reloadData];//更新
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArr = [[NSMutableArray alloc]init];
    tmp = 1;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self addTop];
    
    [self getData];

}
- (void)getData
{
//    接口url：http://www.yzpai.cn/news/topic/index
//    * 参数：
//    topicid topicid
    
    NSDictionary * param = nil;
    if ([UserManager shared].isLogin) {
        param = @{
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  @"topicid":self.iD,
                  };
    }else {
        param = @{
                  @"topicid":self.iD,
                  };
    }
    
    weakObj(self);

    [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/topic/index" URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                self.topicDic = dic[@"data"];
                [selfWeak.iconImagView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"icon"]] placeholderImage:nil];
                selfWeak.attentionNumber.text = [NSString stringWithFormat:@"%@人关注",dic[@"data"][@"num_follow"]];
                selfWeak.titleLabel.text = dic[@"data"][@"name"];
                selfWeak.contentLabel.text = dic[@"data"][@"description"];
                NSString *if_guanzhu = dic[@"data"][@"if_guanzhu"];
                [selfWeak.headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"icon"]] placeholderImage:UIImageNamed(@"mine_pic")];
                if ([if_guanzhu intValue] == 1) {
                    //关注的
                    selfWeak.attentionBT.selected = YES;
                }else{
                    selfWeak.attentionBT.selected = NO;
                }
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
    }];

    //    接口url：http://www.yzpai.cn/news/topic/news
    //    * 参数：
    //    topicid topicid
    //    p 第几页 默认1
    //    n 每页条数 默认10
    NSDictionary *parm = @{@"topicid":self.iD,
                           @"p":@1,
                           @"n":@10
                           };
    [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/topic/news" URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                [self.dataArr removeAllObjects];
                for (int i = 0; i<data.count; i++) {
                    FindMessageInfo *info = [[FindMessageInfo alloc]init];
                    [info setValuesForKeysWithDictionary:data[i]];
                    [self.dataArr addObject:info];
                }
                [self.tableView reloadData];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
    }];
    

}
- (void)loadMoreData
{
    tmp ++;
    NSDictionary *parm = @{@"topicid":self.iD,
                           @"p":@(tmp),
                           @"n":@10
                           };
    [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/topic/news" URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                if (data.count > 0) {
                    for (int i = 0; i<data.count; i++) {
                        FindMessageInfo *info = [[FindMessageInfo alloc]init];
                        [info setValuesForKeysWithDictionary:data[i]];
                        [self.dataArr addObject:info];
                    }
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];

                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
    }];

}
- (void)attentionBTClick:(UIButton *)bt
{
    if ([UserManager shared].isLogin) {
        weakObj(self);
        if (bt.selected) {
            //取消关注
            //        接口url：http://www.yzpai.cn/news/topic/unfollow
            //        * 参数：
            //        userid 用户id
            //        token accessToken
            //        topicid 主题id
            NSDictionary *parm = @{@"userid":[UserManager shared].userInfo.uid,
                                   @"token":[UserManager shared].userInfo.accessToken,
                                   @"topicid":self.iD
                                   };
            [HttpRequest get_RequestWithURL:UNFOLLOW_TOPIC_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    MLog(@"主题点击取消关注dic==%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        selfWeak.attentionBT.selected = NO;
                        selfWeak.model.if_guanzhu = @"0";
                        selfWeak.attentionNumber.text = [NSString stringWithFormat:@"%@人关注",@([self.topicDic[@"num_follow"] integerValue]-1).stringValue];
                        
                        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app.overallParam setObject:@"0" forKey:self.iD];
                        
                        if (self.bModel && self.bModel.topicid.integerValue == self.iD.integerValue) {
                            self.bModel.if_guanzhu = @"0";
                        }
                        
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
                
            }];
        }else{
            //关注
            NSDictionary *parm = @{@"userid":[UserManager shared].userInfo.uid,
                                   @"token":[UserManager shared].userInfo.accessToken,
                                   @"topicid":self.iD
                                   };
            [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/topic/follow" URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    MLog(@"主题点击dic==%@",dic);
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        selfWeak.attentionBT.selected = YES;
                        selfWeak.model.if_guanzhu = @"1";
                        selfWeak.attentionNumber.text = [NSString stringWithFormat:@"%@人关注",@([self.topicDic[@"num_follow"] integerValue]+1).stringValue];
                        
                        [app.overallParam setObject:@"1" forKey:self.iD];
                        
                        if (self.bModel && self.bModel.topicid.integerValue == self.iD.integerValue) {
                            self.bModel.if_guanzhu = @"1";
                        }
                        
                    }else if ([dic[@"msg"] isEqualToString:@"主题已关注"]){
                        selfWeak.attentionBT.selected = YES;
                        selfWeak.model.if_guanzhu = @"1";
                        
                        [app.overallParam setObject:@"1" forKey:self.iD];
                        
                        if (self.bModel && self.bModel.topicid.integerValue == self.iD.integerValue) {
                            self.bModel.if_guanzhu = @"1";
                        }
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
        [self presentViewController:nav animated:YES completion:nil];

    }

}

- (void)addTop
{
    //+++++++++++++++++++++++++++++++++
    //topview
    self.topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+kStatusHeight)];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    self.topView.userInteractionEnabled = YES;
    [self.view addSubview:self.topView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃视图
    _topEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    _topEffectView.frame = self.topView.bounds;
    _topEffectView.alpha = 0;
    [self.topView addSubview:_topEffectView];
    
    self.topTitle = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-200)/2, kStatusHeight+(44-20)/2, 200, 20)];
    self.topTitle.textAlignment = NSTextAlignmentCenter;
    self.topTitle.textColor = [UIColor whiteColor];
    self.topTitle.font = [UIFont systemFontOfSize:18];
    [self.topView addSubview:self.topTitle];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(5, kStatusHeight, 44, 44);
    but.adjustsImageWhenHighlighted = NO;
    [but setImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    [but addTarget:self action:@selector(gobackTp) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:but];
    
    _shareBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBt.frame = CGRectMake(kScreenWidth-49, kStatusHeight, 44, 44);
    _shareBt.adjustsImageWhenHighlighted = NO;
    [_shareBt setImage:UIImageNamed(@"icon_share_white") forState:UIControlStateNormal];
    [_shareBt addTarget:self action:@selector(sharebtCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_shareBt];
    
    /////_____++++++++++++++++++++++++
}
- (void)gobackTp
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sharebtCLick
{
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];

}
- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:nil atIndex:index viewController:self.navigationController];
}


-(UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, HeaderImageViewHeight)];
        _headerImageView.image = [UIImage imageNamed:@"Yosemite1"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        _imageEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        
        _imageEffectView.frame = _headerImageView.bounds;
        //设置模糊透明度
        _imageEffectView.alpha = 0.9f;
        [_headerImageView addSubview:_imageEffectView];
        
        //遮罩view
        self.eeeeev = [[UIView alloc]initWithFrame:CGRectMake(0, HeaderImageViewHeight - 50, kScreenWidth, 50)];
        self.eeeeev.backgroundColor = [UIColor clearColor];
        self.eeeeev.userInteractionEnabled = YES;
        self.eeeeev.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        [_headerImageView addSubview:self.eeeeev];
        //1
        self.attentionNumber = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 50-30, 120, 20)];
        self.attentionNumber.text = @"55664人关注";
        self.attentionNumber.textColor = [UIColor blackColor];
        self.attentionNumber.font = [UIFont systemFontOfSize:12.0];
        self.attentionNumber.textAlignment = NSTextAlignmentLeft;
        [self.eeeeev addSubview:self.attentionNumber];
        self.attentionNumber.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        //2
//        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(kScreenWidth-30, 80-30, 20, 20);
//        [but setBackgroundImage:UIImageNamed(@"ic_personaltab_activity_message_error") forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.eeeeev addSubview:but];
    }
    return _headerImageView;
}
-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.headerImageView];

        //1 头像HeaderHeight-160-5-80+30-50
        self.iconImagView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, HeaderImageViewHeight-50, 100, 100)];
        self.iconImagView.layer.masksToBounds = YES;
        self.iconImagView.layer.cornerRadius = self.iconImagView.bounds.size.width/2;
        [_headerView addSubview:self.iconImagView];
        
        //title HeaderImageViewHeight+60
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HeaderImageViewHeight+60, kScreenWidth, 25)];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = RGBColor(51, 51, 51);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"罪行热门的热哈哈哈是";
        [_headerView addSubview:self.titleLabel];
    
        //HeaderImageViewHeight+85
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, HeaderImageViewHeight+95, kScreenWidth-30, 40)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = 1;
        self.contentLabel.textColor = RGBColor(128, 128, 128);
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        [_headerView addSubview:self.contentLabel];
        //关注button
        
        //HeaderHeight-55
        self.attentionBT = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionBT.frame = CGRectMake((kScreenWidth-120)/2, HeaderHeight-55, 120, 24);
        self.attentionBT.layer.masksToBounds= YES;
        self.attentionBT.layer.cornerRadius = 12.;
        self.attentionBT.titleLabel.font = UIFontSys(14);
        [self.attentionBT setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow_pre") forState:UIControlStateNormal];
        [self.attentionBT setTitle:@"已关注" forState:UIControlStateSelected];
        [self.attentionBT setBackgroundImage:UIImageNamed(@"btn_perlist_follow") forState:UIControlStateSelected];
        [self.attentionBT addTarget:self action:@selector(attentionBTClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:self.attentionBT];
        self.attentionBT.selected = NO;
        
        //
        self.bottomLine =[[UILabel alloc]initWithFrame:CGRectMake(0, HeaderHeight-8, kScreenWidth, 8)];
        self.bottomLine.backgroundColor = RGBColor(245, 245, 245);
        [_headerView addSubview:self.bottomLine];
        
        
//        self.titleLabel.backgroundColor = [UIColor greenColor];
//        self.contentLabel.backgroundColor = [UIColor greenColor];
    }
    return _headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"---> %lf", scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= HeaderImageViewHeight - (kStatusHeight + 44)) {
        if (!self.topView.image) {
            self.topView.image = _headerImageView.image;
        }
        _topEffectView.alpha = 0.9;
    }else {
        self.topView.image = nil;
        _topEffectView.alpha = 0;
        
    }
    
    CGFloat headerImageY = offsetY;
    CGFloat headerImageH = HeaderImageViewHeight - offsetY;
    
    
    CGRect headerImageFrame = self.headerImageView.frame;
    headerImageFrame.origin.y = headerImageY;
    headerImageFrame.size.height = headerImageH;
    self.headerImageView.frame = headerImageFrame;
    _imageEffectView.frame = _headerImageView.bounds;
    
    //切割
    float maskHeight;
    if (offsetY < HeaderImageViewHeight-(kStatusHeight+44)-50) {
        maskHeight = 0;
    }else if (offsetY >= HeaderImageViewHeight-(kStatusHeight+44)-50 && offsetY<= HeaderImageViewHeight+20) {
        maskHeight = offsetY - (HeaderImageViewHeight-(kStatusHeight+44)-50);
    }else {
        maskHeight = 100;
    }
    CAShapeLayer * mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRect:_iconImagView.bounds];
    UIBezierPath * holePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, maskHeight)];
    [maskPath appendPath:holePath];
    mask.path = maskPath.CGPath;
    [_iconImagView.layer setMask:mask];
    
    //2
    CAShapeLayer * mask2 = [CAShapeLayer layer];
    [mask2 setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath2 = [UIBezierPath bezierPathWithRect:self.eeeeev.bounds];
    UIBezierPath * holePath2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, maskHeight)];
    [maskPath2 appendPath:holePath2];
    mask2.path = maskPath2.CGPath;
    [self.eeeeev.layer setMask:mask2];
    
    
    //标题
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - _historyY;
    _historyY = contentOffset;
    
    if (offset > 0 && contentOffset > 0 ) {
//        NSLog(@"上拉行为");
        if (offsetY >= 160) {
            self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 44);
            self.topTitle.text = self.titleLabel.text;
            self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 22);
            self.topTitle.hidden = NO;
        }
    }
    if (offset < 0 && distanceFromBottom > hight) {
//        NSLog(@"下拉行为");
        if (offsetY <= 160) {
            self.topTitle.text = self.titleLabel.text;
            self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 44);
            self.topTitle.hidden = YES;
        }
        
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id info = self.dataArr[indexPath.row];
    float hei = [self.tableView cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[FIndMessageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    return hei;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIndMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cel"];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.delegate = self;
    cell.index = indexPath;
    cell.info = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FimeMessageSourceViewController *fin = [[FimeMessageSourceViewController alloc]init];
    fin.model = _dataArr[indexPath.row];
    fin.rec_url = [self.dataArr[indexPath.row] rec_url];
    [self.navigationController pushViewController:fin animated:YES];
}
- (void)gotoFimeMessageSourceVC:(NSIndexPath *)index
{
    FimeMessageSourceViewController *fin = [[FimeMessageSourceViewController alloc]init];
    fin.rec_url = [self.dataArr[index.row] rec_url];
    fin.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fin animated:YES];
}
#pragma mark daili
- (void)noLogin
{
    BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)gotoCommentVC:(FIndMessageTableViewCell *)cell
{
    CommentViewController *com = [[CommentViewController alloc]init];
    com.info = cell.info;
    com.ID = cell.info.ID;
    [self.navigationController pushViewController:com animated:YES];
}
- (void)addColletion:(FIndMessageTableViewCell *)cell
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect frame =[cell convertRect:cell.bounds toView:window];
    
    float y = frame.origin.y;
    
    AddCollectionView * uninterestedView = [[AddCollectionView alloc]init];
    uninterestedView.delegate = self;
    
    weakObj(self);
    uninterestedView.loginMethod = ^{
        
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [selfWeak presentViewController:nav animated:YES completion:nil];
        
    };
    
    _moreViewCell = cell;
    
    if (y + 10 - 50 - 10 > kStatusHeight + 44) {
        [uninterestedView showWithY:y + 10 - 50 object:cell.info];
    }else {
        [uninterestedView showWithY:y + 45 object:cell.info];
    }

}
- (void)uninterestedViewSelectedAtIndex:(int)index {
    NSIndexPath *indexPath = [_tableView indexPathForCell:_moreViewCell];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}
- (void)shareBTClick:(NSIndexPath *)idnex
{
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];

}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(245, 245, 245);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FIndMessageTableViewCell class] forCellReuseIdentifier:@"cel"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//隐藏多余的cell
        MJRefreshAutoStateFooter * header = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
        _tableView.mj_footer = header;
        _tableView.mj_footer.automaticallyHidden = YES;
    }
    return _tableView;
}

#pragma mark 顶部右边那个按钮
- (void)gotoClick
{
    NSLog(@"gotoClick--gotoClick");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
