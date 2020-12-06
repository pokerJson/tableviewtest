//
//  SetViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "LicenseViewController.h"
#import "AboutViewController.h"
#import "AssistViewController.h"
#import "BindViewController.h"
#import "ReAndLoViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;


@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"设置";
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    
    [self createTableView];
    [self loadData];
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    _tableView.backgroundColor = RGBColor(246, 246, 246);
    
    [_tableView registerClass:[SetCell class] forCellReuseIdentifier:@"SetCell"];
    
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
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height-0.4, kWidth, 0.4)];
    line.backgroundColor = RGBColor(170, 170, 170);
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
    
    
}
- (void)loadData {
    
    NSArray * arr  = @[
                       @[
                           @{
                               @"img":@"",
                               @"title":@"账号设置",
                               @"controllor":@"",
                               },
                           @{
                               @"img":@"",
                               @"title":@"显示设置",
                               @"controllor":@"",
                               },
                           @{
                               @"img":@"",
                               @"title":@"隐私设置",
                               @"controllor":@"",
                               },
                           ],
                       @[
                           @{
                               @"img":@"ic_personal_tab_my_topic",
                               @"title":@"用户协议",
                               @"controllor":@"",
                               },
                           @{
                               @"img":@"ic_personal_tab_collection",
                               @"title":@"检查更新",
                               @"controllor":@"",
                               },
                           @{
                               @"img":@"ic_personal_tab_support_center",
                               @"title":@"版本号",
                               @"controllor":@"",
                               },
                           ],
                       @[
                           @{
                               @"img":@"ic_personal_tab_custom_topic",
                               @"title":@"清理缓存",
                               @"controllor":@"",
                               },
                           @{
                               @"img":@"ic_personal_tab_custom_topic",
                               @"title":@"给立刻评分",
                               @"controllor":@"",
                               },
                           ],
                       ];
    
    
    NSArray * arrr = nil;
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN"] boolValue]) {
//
//        @{
//          @"img":@"",
//          @"title":@"账号与绑定",
//          @"controllor":@"3",
//          @"type":@"1",
//          },
        
        arrr =  @[
                  @[
                      
                      @{
                          @"img":@"",
                          @"title":@"清除缓存",
                          @"controllor":@"0",
                          @"type":@"0",
                          },
                      @{
                          @"img":@"",
                          @"title":@"意见反馈",
                          @"controllor":@"1",
                          @"type":@"1",
                          },
                      @{
                          @"img":@"",
                          @"title":@"关于闪讯",
                          @"controllor":@"2",
                          @"type":@"1",
                          },
                      @{
                          @"img":@"",
                          @"title":@"退出登录",
                          @"controllor":@"4",
                          @"type":@"0",
                          },
                      ],
                  ];
        
    }else {
        
        arrr =  @[
                  @[
                      
                      @{
                          @"img":@"",
                          @"title":@"清除缓存",
                          @"controllor":@"0",
                          @"type":@"0",
                          },
                      @{
                          @"img":@"",
                          @"title":@"意见反馈",
                          @"controllor":@"1",
                          @"type":@"1",
                          },
                      @{
                          @"img":@"",
                          @"title":@"关于闪讯",
                          @"controllor":@"2",
                          @"type":@"1",
                          },
                      ],
                  ];
        
    }
    
    
    
    [self.dataSource setArray:arrr];
    
    [_tableView reloadData];
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
    
    SetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * str = self.dataSource[indexPath.section][indexPath.row][@"controllor"];
    
    switch (str.intValue) {
        case 3: {
            
            if ([UserManager shared].isLogin) {
                BindViewController * vc = [[BindViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                
                BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
                nav.navigationBar.hidden = YES;
                [self presentViewController:nav animated:YES completion:nil];
                
            }
        }
            break;
        case 0: {
            
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{}];
            [_tableView reloadData];
            [KKHUD showMiddleWithStatus:@"清理完毕"];
        }
            break;
        case 1: {
            
            AssistViewController * vc = [[AssistViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            
            AboutViewController * vc = [[AboutViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:@"LOGIN"];
            [userDefaults synchronize];
            
            NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
            [shared setBool:NO forKey:@"LOGIN"];
            [shared synchronize];
            
            
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSArray * arr = app.overallParam.allKeys;
            for (NSString * obj in arr) {
                [app.overallParam setObject:@"0" forKey:obj];
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footer = [[UIView alloc] init];
    
    UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    line0.backgroundColor = RGBColor(170, 170, 170);
    [footer addSubview:line0];
    
    if (section != self.dataSource.count-1) {
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 53.6, kWidth, 0.4)];
        line1.backgroundColor = RGBColor(170, 170, 170);
        [footer addSubview:line1];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 54;
}


@end
