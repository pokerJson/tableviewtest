//
//  PersonViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PersonViewController.h"
#import "TopicCell.h"
#import "PersonHeaderView.h"
#import "PersonModel.h"

#import "TopicModel.h"

#import "ThemeVC.h"
#import "TopicViewController.h"

#import "ModifyIconController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,ShareViewDelegate,UMengShareDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)float offset;

@property(nonatomic, strong)UIImageView * navView;
@property(nonatomic, strong)UIVisualEffectView * effectView;
@property(nonatomic, strong)UIButton * backButton;
@property(nonatomic, strong)UIButton * moreButton;
@property(nonatomic, strong)UILabel * navMaskView;

@property(nonatomic, strong)UIView * avatarBgView;
@property(nonatomic, strong)UIImageView * avatarImageView;
@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UILabel * followLabel;
@property(nonatomic, strong)UIButton * followButton;

@property(nonatomic, strong)UIImageView * topImageView;
@property(nonatomic, strong)UIVisualEffectView * topEffectView;
@property(nonatomic, strong)PersonHeaderView * headerView;
@property(nonatomic, strong)UIButton * avatarButton;

@property(nonatomic, assign)BOOL isSelf;

@end

@implementation PersonViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self loadHeaderData];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_uid) _uid = [NSString stringWithFormat:@"%@",_uid];
    
    if ([UserManager shared].isLogin) {
        if (_uid && ![_uid isEqualToString:[UserManager shared].userInfo.uid]) {
            _isSelf = NO;
        }else {
            _isSelf = YES;
            _uid = [UserManager shared].userInfo.uid;
        }
    }else {
        _isSelf = NO;
    }
    
    [self createTableView];
    [self createNavView];
    [self loadData];
}

- (void)loadHeaderData {
    
    NSDictionary * param = @{
                           @"userid":[UserManager shared].userInfo.uid,
                           @"token":[UserManager shared].userInfo.accessToken,
                           @"uid":_uid,
                           };
    
    [HttpRequest get_RequestWithURL:BOKE_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if(self.personModel == nil) self.personModel = [PersonModel new];
                [self.personModel setValuesForKeysWithDictionary:dic[@"data"]];
                self.personModel.isSelf = self.isSelf;
                [self.headerView loadDataWithModel:self.personModel];
                [self updateInfo];
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];

    
}

- (void)updateInfo {
    
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_personModel.bgpic]];
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_personModel.icon] forState:UIControlStateNormal];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_personModel.icon]];
    
    _nameLabel.text = _personModel.nick;
    
    if (_isSelf) {
        
        CGFloat width = [_personModel.nick boundingRectWithSize:CGSizeMake(kWidth-30,34) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil].size.width;
        if (width > 150) width = 150;
        float x = floor((_avatarBgView.width-(44+width))/2.);
        _avatarImageView.frame = CGRectMake(x, 5, 34, 34);
        _nameLabel.frame = CGRectMake(_avatarImageView.right+10, 5, width, 34);
        _followLabel.hidden = YES;
        _followButton.hidden = YES;
        
    }else {
        
        _followLabel.text = [NSString stringWithFormat:@"%@人关注",_personModel.num_followers];
        
        if (_personModel.if_guanzhu.intValue == 0) {
            _followButton.selected = NO;
        }else {
            _followButton.selected = YES;
        }
    }
    
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
    
    _navMaskView = [[UILabel alloc]initWithFrame:_navView.bounds];
    _navMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [_navView addSubview:_navMaskView];
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusHeight, 50, 44)];
    [_backButton setImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backButton];
    
    _moreButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, kStatusHeight, 50, 44)];
    _moreButton.hidden = YES;
    [_moreButton setImage:UIImageNamed(@"icon_share_white") forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_moreButton];
    
    
    _avatarBgView = [[UIView alloc]initWithFrame:CGRectMake(60, kStatusHeight+44, kWidth-120, 44)];
    [_navView addSubview:_avatarBgView];

    
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 34, 34)];
    _avatarImageView.cornerRadius = 17.;
    _avatarImageView.image = UIImageNamed(@"placeholder_register_bg");
    [_avatarBgView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, _avatarImageView.y, _avatarBgView.width-120, 17)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = 0;
    _nameLabel.font = UIFontBSys(14);
    [_avatarBgView addSubview:_nameLabel];
    
    if (_isSelf) return;
    
    _followLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, _nameLabel.bottom, _avatarBgView.width-120, 17)];
    _followLabel.textColor = [UIColor whiteColor];
    _followLabel.textAlignment = 0;
    _followLabel.font = UIFontSys(12);
    [_avatarBgView addSubview:_followLabel];
    
    UIImage * lan = [UIImage imageWithColor:RGBColor(60, 180, 245) imageSize:CGRectMake(0, 0, 5, 5)];
    UIImage * hui = [UIImage imageWithColor:RGBColor(226, 224, 226) imageSize:CGRectMake(0, 0, 5, 5)];
    _followButton = [[UIButton alloc]initWithFrame:CGRectMake(_avatarBgView.width-55, (_avatarBgView.height-26)/2., 55, 26)];
    _followButton.cornerRadius = 13.;
    _followButton.titleLabel.font = UIFontSys(12);
    [_followButton setBackgroundImage:lan forState:UIControlStateNormal];
    [_followButton setBackgroundImage:hui forState:UIControlStateSelected];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_avatarBgView addSubview:_followButton];

}

- (void)backButtonMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonMethod:(UIButton *)button {
    
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:_personModel];
    
}
- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:nil atIndex:index viewController:self.navigationController];
}

- (void)followButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {

        if (button.selected == NO) {
            //关注
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"uid":_uid,
                                     };
            [HttpRequest get_RequestWithURL:FOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = YES;
                        self.personModel.if_guanzhu = @"1";
                        [self.headerView loadDataWithModel:self.personModel];
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
                                     @"uid":_uid,
                                     };
            [HttpRequest get_RequestWithURL:UNFOLLOW_PERSON_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.followButton.selected = NO;
                        self.personModel.if_guanzhu = @"0";
                        [self.headerView loadDataWithModel:self.personModel];
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


/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(243, 243, 243);
    [_tableView registerClass:[TopicCell class] forCellReuseIdentifier:@"TopicCell"];
    _tableView.contentInset = UIEdgeInsetsMake(260, 0, kBottomInsets, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView =  _headerView = [[PersonHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 214)];
    
    weakObj(self);
    _headerView.updateFrame = ^{
        selfWeak.tableView.tableHeaderView =  selfWeak.headerView;
    };
    _headerView.updateFollow = ^{
        [selfWeak updateInfo];
    };
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -260, kWidth, 260)];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.backgroundColor = RGBColor(180, 180, 180);
    _topImageView.userInteractionEnabled = YES;
    _topImageView.clipsToBounds = YES;
    [_tableView addSubview:_topImageView];
    [_topImageView setTapBlock:^{
        [selfWeak topImageViewTap];
    }];
    
    
    _topEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _topEffectView.frame = _topImageView.bounds;
    _topEffectView.userInteractionEnabled = NO;
    _topEffectView.alpha = 0.15;
    [_topImageView addSubview:_topEffectView];


    
    
    _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(15, -30, 80, 80)];
    _avatarButton.backgroundColor = [UIColor whiteColor];
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarButton.cornerRadius = 10.;
    [_avatarButton addTarget:self action:@selector(avatarButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_avatarButton];
    
    
    [self addFooterRefresh];
    
}
- (void)topImageViewTap {
    NSLog(@"topImageViewTap");
    
    if (!_isSelf) {
        return;
    }
    
    weakObj(self);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"更换背景图片" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           
                                                           ModifyIconController * vc = [[ModifyIconController alloc]init];
                                                           vc.type = @"0";
                                                           vc.icon = selfWeak.personModel.icon;
                                                           vc.model = selfWeak.personModel;
                                                           [self.navigationController  pushViewController:vc animated:YES];
                                                           
                                                           
                                                       }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];

    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
    
    if (y <= -260) {
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
    if (y < -(kStatusHeight+44)-30) {
        maskHeight = 0;
    }else if (y >= -(kStatusHeight+44)-30 && y<= -(kStatusHeight+44)+50) {
        maskHeight = y - (-(kStatusHeight+44)-30);
    }else {
        maskHeight = 80;
    }
    
    CAShapeLayer * mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRect:_avatarButton.bounds];
    UIBezierPath * holePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 80, maskHeight)];
    [maskPath appendPath:holePath];
    mask.path = maskPath.CGPath;
    [_avatarButton.layer setMask:mask];
    
    
    if (y >= -(kStatusHeight + 44)) {
        _topEffectView.alpha = 1;
    }else if (y>=-200 && y<-(kStatusHeight+44)) {
        _topEffectView.alpha = (1-(fabs(y)-(kStatusHeight + 44))/(200.-(kStatusHeight + 44.))*0.85);
    }else if (scrollView.contentOffset.y<-200) {
        _topEffectView.alpha = 0.15;
    }

    
    if (y >= -(kStatusHeight + 44)) {
        if (!_navView.image) _navView.image = _topImageView.image;
        _effectView.alpha = 1;
        _navMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }else {
        _navView.image = nil;
        _effectView.alpha = 0;
        _navMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    
    if (y >= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.avatarBgView.frame = CGRectMake(60, kStatusHeight, kWidth-120, 44);
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.avatarBgView.frame = CGRectMake(60, kStatusHeight+44, kWidth-120, 44);
        }];
    }
    
}


- (void)loadData {

    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"uid":_uid,
                             @"p":@(self.offset),
                             @"n":@10,
                             };
    
    [HttpRequest get_RequestWithURL:BOKE_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                NSArray * arr = dic[@"data"];
                
                if (arr.count != 0) {

                    for (NSDictionary * obj in arr) {
                        TopicModel * model = [TopicModel new];
                        [model setValuesForKeysWithDictionary:obj];
                        [self.dataSource addObject:model];
                    }
                    
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                    
                    return;
                }
                
                [self.tableView reloadData];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopicModel * model = self.dataSource[indexPath.row];
    
    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = model.ID;
    vc.topicModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
