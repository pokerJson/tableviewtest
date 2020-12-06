//
//  MineViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "MineViewController.h"
#import "MineAvatarCell.h"
#import "MineNormalCell.h"


#import "BNavigationController.h"
#import "ReAndLoViewController.h"

#import "LoginViewController.h"



@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, strong)UIView * redDot;

@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [self trendsRedDot];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navLeftButton.hidden = YES;
    self.navRightButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trendsRedDot) name:@"TrendsNotification" object:nil];

    [self createTableView];
    [self loadData];
    
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)-kTabBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    _tableView.backgroundColor = RGBColor(246, 246, 246);
    
    [_tableView registerClass:[MineAvatarCell class] forCellReuseIdentifier:@"MineAvatarCell"];
    [_tableView registerClass:[MineNormalCell class] forCellReuseIdentifier:@"MineNormalCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 9.6, kWidth, 0.4)];
    line.backgroundColor = RGBColor(170, 170, 170);
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
    
    
}
- (void)loadData {
    
    NSArray * arr  = @[
                       @[
                           @{
                               @"img":@"",
                               @"title":@"个人页",
                               @"controllor":@"PersonViewController",
                               
                               },
                           ],
                       @[
                           @{
                               @"img":@"icon_mine_theme",
                               @"title":@"我关注的主题",
                               @"controllor":@"FollowedTopicViewController",
                               },
                           @{
                               @"img":@"icon_history",
                               @"title":@"我的足迹",
                               @"controllor":@"HistoryViewController",
                               },
                           @{
                               @"img":@"Artboard",
                               @"title":@"我的收藏",
                               @"controllor":@"CollectionViewController",
                               },
                           @{
                               @"img":@"icon_mine_information",
                               @"title":@"我的通知",
                               @"controllor":@"NotificationViewController",
                               },
                           ],
                       @[
                           @{
                               @"img":@"icon_mine_set",
                               @"title":@"设置",
                               @"controllor":@"SetViewController",
                               },
                           ],
                       ];
    
    [self.dataSource setArray:arr];
    
    //[_tableView reloadData];
}

/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        MineAvatarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MineAvatarCell" forIndexPath:indexPath];
        [cell loadDataWithModel:self.dataSource[indexPath.section][indexPath.row]];
        return cell;
        
    }else {
        
        MineNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MineNormalCell" forIndexPath:indexPath];
        [cell loadDataWithModel:self.dataSource[indexPath.section][indexPath.row]];
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 3) [self hideRedDot];
    
    if (indexPath.section != 2 && ![UserManager shared].isLogin) {
        
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else {
        
        NSString * vcStr = self.dataSource[indexPath.section][indexPath.row][@"controllor"];
        NSLog(@"%@",vcStr);
        Class class = NSClassFromString(vcStr);
        UIViewController * vc = [[class alloc] init];
        vc.title = self.dataSource[indexPath.section][indexPath.row][@"title"];
        vc.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 100;
    }else {
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footer = [[UIView alloc] init];
    
    UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    line0.backgroundColor = RGBColor(170, 170, 170);
    [footer addSubview:line0];
    
    if (section != self.dataSource.count-1) {
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9.6, kWidth, 0.4)];
        line1.backgroundColor = RGBColor(170, 170, 170);
        [footer addSubview:line1];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}



- (void)trendsRedDot {
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
    if (rootVC.myTabBar.subViews[3].dot) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        MineNormalCell * cell = (MineNormalCell *)[_tableView cellForRowAtIndexPath:indexPath];
        
        [_redDot removeFromSuperview];
        _redDot = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 8, 8)];
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 4;
        [cell addSubview:_redDot];
    }

}

- (void)hideRedDot {
    [_redDot removeFromSuperview];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
    rootVC.myTabBar.subViews[3].dot = NO;
    
}




@end
