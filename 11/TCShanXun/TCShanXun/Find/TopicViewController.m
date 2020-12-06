//
//  TopicViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicNewsCell.h"

#import "TopicHeaderView.h"
#import "FavoriteView.h"

#import "ShareView.h"

#import "CommentViewController.h"
#import "ScourceViewController.h"



@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource,TopicNewsCellDelegate,FavoriteViewDelegate,ShareViewDelegate,UMengShareDelegate,MorePopViewDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)float offset;

@property(nonatomic, strong)UIImageView * navView;
@property(nonatomic, strong)UIVisualEffectView * effectView;
@property(nonatomic, strong)UIButton * backButton;
@property(nonatomic, strong)UIButton * moreButton;

@property(nonatomic, strong)UIView * navSubBoard;
@property(nonatomic, strong)UILabel * nameLabel;


@property(nonatomic, strong)UIImageView * topImageView;
@property(nonatomic, strong)UIVisualEffectView * topEffectView;

@property(nonatomic, strong)UIView * maskView;
@property(nonatomic, strong)UIButton * avatarButton;
@property(nonatomic, strong)UILabel * followLabel;

@property(nonatomic, strong)TopicHeaderView * headerView;

@property(nonatomic, assign)BOOL topicShare;

@property(nonatomic, strong)BListModel * shareModel;
@property(nonatomic, strong)TopicNewsCell * moreViewCell;

@end

@implementation TopicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self loadHeaderData];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    [self createNavView];
    [self loadData];
}

- (void)createNavView {
    
    _navView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kStatusHeight + 44)];
    _navView.contentMode = UIViewContentModeScaleAspectFill;
    _navView.clipsToBounds = YES;
    _navView.userInteractionEnabled = YES;
    [self.view addSubview:_navView];
    
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _effectView.frame = _navView.bounds;
    _effectView.alpha = 0;
    [_navView addSubview:_effectView];
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusHeight, 50, 44)];
    [_backButton setImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backButton];
    
    _moreButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, kStatusHeight, 50, 44)];
    //_moreButton.hidden = YES;
    [_moreButton setImage:UIImageNamed(@"icon_share_white") forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_moreButton];

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, kStatusHeight+44, kWidth-120, 44)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = 1;
    _nameLabel.font = UIFontBSys(17);
    [_navView addSubview:_nameLabel];

    
}

- (void)backButtonMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonMethod:(UIButton *)button {
    _topicShare = YES;
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:_topicModel];
}


- (void)loadHeaderData {
    
    NSDictionary * param = nil;
    
    if ([UserManager shared].isLogin) {
        param = @{
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  @"topicid":_topicID,
                  };
    }else {
        param = @{
                  @"topicid":_topicID,
                  };
    }
    
    [HttpRequest get_RequestWithURL:TOPIC_INFO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if (self.topicModel == nil) self.topicModel = [TopicModel new];
                [self.topicModel setValuesForKeysWithDictionary:dic[@"data"]];
                [self.headerView loadDataWithModel:self.topicModel];
                [self updateInfo];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}

- (void)updateInfo {
    _nameLabel.text = _topicModel.name;
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_topicModel.icon]];
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_topicModel.icon] forState:UIControlStateNormal];
    
    if (_topicModel.num_follow.intValue == 0) {
        _followLabel.text = @"";
    }else {
        _followLabel.text = [NSString stringWithFormat:@"%@人关注",_topicModel.num_follow];
    }
    if(_topicModel.if_guanzhu.intValue == 1){
        //关注
        self.model.if_guanzhu = @"1";
        self.info.if_guanzhu = @"1";
    }else{
        self.model.if_guanzhu = @"0";
        self.info.if_guanzhu = @"0";
    }
    
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(243, 243, 243);
    [_tableView registerClass:[TopicNewsCell class] forCellReuseIdentifier:@"TopicNewsCell"];
    _tableView.contentInset = UIEdgeInsetsMake(kStatusHeight+44+100, 0, kBottomInsets, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView =  _headerView = [[TopicHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 153)];
    
    weakObj(self);
    _headerView.updateFrame = ^{
        selfWeak.tableView.tableHeaderView =  selfWeak.headerView;
    };
    _headerView.updateFollow = ^{
        [selfWeak updateInfo];
    };
    

    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(kStatusHeight+44+100), kWidth, kStatusHeight+44+100)];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.backgroundColor = RGBColor(180, 180, 180);
    _topImageView.clipsToBounds = YES;
    [_tableView addSubview:_topImageView];
    
    _topEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _topEffectView.frame = _topImageView.bounds;
    _topEffectView.alpha = 0.25;
    [_topImageView addSubview:_topEffectView];
    
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0,-50, kWidth, 100)];
    _maskView.backgroundColor = [UIColor clearColor];
    [_tableView addSubview:_maskView];
    
    _followLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2., 12, kWidth/2.-15, 38)];
    _followLabel.textColor = [UIColor whiteColor];
    _followLabel.textAlignment = 2;
    _followLabel.font = [UIFont systemFontOfSize:14];
    [_maskView addSubview:_followLabel];
    
    _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(kWidth-100), 0, 100, 100)];
    _avatarButton.backgroundColor = [UIColor whiteColor];
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarButton.cornerRadius = 50.;
    [_avatarButton addTarget:self action:@selector(avatarButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_maskView addSubview:_avatarButton];

    
    
    [self addFooterRefresh];
    
}

/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)avatarButtonMethod:(UIButton *)button {
    NSLog(@"avatarButtonMethod");
    
}

- (void)addFooterRefresh {
    self.offset = 1;
    weakObj(self);
    MJNewsFooter * header = [MJNewsFooter footerWithRefreshingBlock:^{
        selfWeak.offset++;
        [self loadData];
    }];
    _tableView.mj_footer = header;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = scrollView.contentOffset.y;
    //NSLog(@"%f",y);
    
    if (y <= -(kStatusHeight+44+100)) {
        CGRect rect = _topImageView.frame;
        rect.origin.y = y;
        rect.size.height = -y;
        _topImageView.frame = rect;
        _topEffectView.frame = _topImageView.bounds;
    }else if (y<=0) {
        _topImageView.frame = CGRectMake(0, y, kWidth, -y);
        _topEffectView.frame = _topImageView.bounds;
    }
    
    
    float maskHeight;
    if (y < -(kStatusHeight+44)-50) {
        maskHeight = 0;
    }else if (y >= -(kStatusHeight+44)-50 && y<= -(kStatusHeight+44)+50) {
        maskHeight = y - (-(kStatusHeight+44)-50);
    }else {
        maskHeight = 100;
    }
    
    CAShapeLayer * mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRect:_maskView.bounds];
    UIBezierPath * holePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kWidth, maskHeight)];
    [maskPath appendPath:holePath];
    mask.path = maskPath.CGPath;
    [_maskView.layer setMask:mask];
    
    
    if (y >= -(kStatusHeight + 44)) {
        _topEffectView.alpha = 1;
    }else if (y>=-(kStatusHeight+44+100) && y<-(kStatusHeight+44)) {
        _topEffectView.alpha = (1-(fabs(y)-(kStatusHeight + 44))/((kStatusHeight+44+100)-(kStatusHeight + 44.))*0.75);
    }else if (scrollView.contentOffset.y<-(kStatusHeight+44+100)) {
        _topEffectView.alpha = 0.25;
    }
    
    
    if (y >= -(kStatusHeight + 44)) {
        if (!_navView.image) _navView.image = _topImageView.image;
        _effectView.alpha = 1;
    }else {
        _navView.image = nil;
        _effectView.alpha = 0;
    }
    
    if (y >= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.nameLabel.frame = CGRectMake(60, kStatusHeight, kWidth-120, 44);
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.nameLabel.frame = CGRectMake(60, kStatusHeight+44, kWidth-120, 44);
        }];
    }
    
}


- (void)loadData {
    
    NSDictionary * param = nil;
    
    if ([UserManager shared].isLogin) {
        
        param = @{
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  @"topicid":_topicID,
                  @"p":@(self.offset),
                  @"n":@10,
                  };
        
    }else {
        
        param = @{
                  @"topicid":_topicID,
                  @"p":@(self.offset),
                  @"n":@10,
                  };
        
    }

    [HttpRequest get_RequestWithURL:TOPIC_NEWS_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                NSArray * arr = dic[@"data"];
                
                if (arr.count != 0) {
                    
                    for (int i = 0; i < arr.count; i++) {
                        BListModel * model = [BListModel new];
                        [model setValuesForKeysWithDictionary:arr[i]];
                        [self.dataSource addObject:[self handleModel:model]];
                    }
                    
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                    
                    return ;
                }
               
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }
        
        self.offset--;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
    
}


- (BListModel *)handleModel:(BListModel *)model {
    
    CGFloat width = [model.topicname boundingRectWithSize:CGSizeMake(kWidth-100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    
    model.titleWidth = width;
    
    float ch = 0;
    float ph = 0;
    float vh = 0;
    
    model.des = [[model.des componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    
    if (![model.title isEqualToString:@""]) {
        if (![model.des isEqualToString:@""]) {
            if ([model.title isEqualToString:model.des]) {
                model.content = model.title;
            }else {
                model.content = [@[model.title,model.des] componentsJoinedByString:@"\n"];
            }
        }else {
            model.content  = model.title;
        }
    }else {
        model.content = model.des;
    }
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5];
    float contentHeight = [model.content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:style} context:nil].size.height;
    
    model.contentHeight = ceil(contentHeight);
    
    if (model.contentHeight != 0) ch = model.contentHeight+10;
    
    //图片
    if (![model.pic_urls isEqualToString:@""]) {
        model.picsArr = [NSJSONSerialization JSONObjectWithData:[model.pic_urls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }else {
        model.picsArr = @[];
    }
    
    if (model.picsArr.count == 0) {
        model.imageHeight = 0;
    }else if (model.picsArr.count==1) {
        
        if (model.type.intValue == 3) {
            model.imageHeight = ceil((kWidth-30)*9/16.);
        }else {
            model.imageHeight = 180;
        }
        
    }else {
        int num = model.picsArr.count%3 ?(int)model.picsArr.count/3+1 : (int)model.picsArr.count/3;
        model.imageHeight = (kWidth-40)/3.*num + 5*(num-1);
    }
    
    
    if (model.imageHeight != 0) ph = model.imageHeight+10;
    
    //视频
    if ([model.video_url isEqualToString:@""]) {
        model.videoHeight = 0;
    }else {
        model.videoHeight = ceil((kWidth - 30)*9/16.);
    }
    
    if (model.videoHeight != 0) vh = model.videoHeight+10;
    
    //总
    model.totalHeight = ceil(60+ch+ph+vh+44+8);
    
    return model;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopicNewsCell" forIndexPath:indexPath];
    cell.delegate  = self;
    
    BListModel * model = self.dataSource[indexPath.row];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = app.overallParam[model.topicid];
    if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScourceViewController * vc = [[ScourceViewController alloc]init];
    vc.ID = [self.dataSource[indexPath.row] ID];
    vc.model = self.dataSource[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BListModel * model = [self.dataSource objectAtIndex:indexPath.row];
    return model.totalHeight;
}


- (void)moreMethod:(TopicNewsCell *)cell {
    _moreViewCell = cell;
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect frame =[cell convertRect:cell.bounds toView:window];
    
    float y = frame.origin.y+cell.height-52;
    
    MorePopView * morePopView = [[MorePopView alloc]init];
    morePopView.delegate = self;
    
    NSArray * arr = @[
                      @"举报",
                      ];
    
    NSLog(@"%f",y);
    if (y - arr.count*50 - 10 > kStatusHeight + 44) {
        [morePopView showWithY:y-arr.count*50 option:arr];
    }else {
        [morePopView showWithY:y + 44 option:arr];
    }
    
}
- (void)morePopViewSelectedAtIndex:(int)index {
    
    if (![Reachability shared].reachable) {
        [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        return;
    }
    
    switch (index) {
        case 0:{
            [HttpRequest get_RequestWithURL:[NSString stringWithFormat:REPORT_URL,_moreViewCell.model.ID] URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        [KKHUD showBottomWithStatus:@"举报成功"];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)commentMethod:(TopicNewsCell *)cell {
    CommentViewController * vc = [[CommentViewController alloc]init];
    vc.ID = cell.model.ID;
    vc.bModel = cell.model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)shareMethod:(TopicNewsCell *)cell {
    _topicShare = NO;
    _shareModel = cell.model;
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
}

- (void)shareViewSelectedAtIndex:(int)index {
    if (_topicShare) {
        //话题分享
        NSLog(@"%@",_topicModel);
        UMengShare * share = [UMengShare share];
        [share shareTopicWithModel:_topicModel atIndex:index viewController:self.navigationController];
    }else {
        //新闻分享
        UMengShare * share = [UMengShare share];
        [share shareWithModel:_shareModel atIndex:index viewController:self.navigationController];
    }
    
}

- (void)picMethod:(TopicNewsCell *)cell atIndex:(int)index {
    
    if (cell.model.type.intValue == 3) {
        
        ScourceViewController * vc = [[ScourceViewController alloc]init];
        vc.ID = cell.model.ID;
        vc.model = cell.model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        [[UserActionReport shared]newsPost:cell.model.ID ext:cell.model.ext];
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIImageView * imageView = (UIImageView *)cell.imageViewArr[index];
        CGRect frame = [imageView convertRect:imageView.bounds toView:app.window];
        
        PicPreView * picView = [[PicPreView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [picView picArr:cell.model.picsArr atIndex:index fromRect:frame];
        [self.view addSubview:picView];
        
    }
    
}


@end
