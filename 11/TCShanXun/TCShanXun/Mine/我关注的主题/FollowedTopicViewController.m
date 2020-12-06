//
//  FollowedTopicViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowedTopicViewController.h"
#import "TopicModel.h"
#import "FollowedTopicCell.h"

#import "ThemeVC.h"
#import "TopicViewController.h"

#import "DataTipsView.h"

@interface FollowedTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, assign)int offset;

@property(nonatomic, strong)DataTipsView * dataTipsView;

@end

@implementation FollowedTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    [self createTableView];
    
    _dataTipsView = [[DataTipsView alloc]initWithFrame:_tableView.bounds];
    _dataTipsView.hidden = YES;
    weakObj(self);
    _dataTipsView.callBack = ^(NSDictionary *param) {
        [selfWeak.tableView.mj_header beginRefreshing];
    };
    [_tableView addSubview:_dataTipsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.offset = 1;
    [self loadData];
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)isHaveData {
    if (self.dataSource.count != 0) {
        _dataTipsView.hidden = YES;
    }else {
        if ([Reachability shared].reachable) {
            [_dataTipsView loadDataWithModel:@{@"label":@"关注感兴趣的主题后\n可以在这里浏览和管理"}];
        }else {
            [_dataTipsView loadDataWithModel:@{@"img":@"icon_nonetwork",
                                               @"label":@"啊哦,网络不太顺畅呦~",
                                               @"btn":@"重新加载",
                                               }];
        }
        _dataTipsView.hidden = NO;
    }
}



- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(246, 246, 246);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomInsets, 0);
    [_tableView registerClass:[FollowedTopicCell class] forCellReuseIdentifier:@"FollowedTopicCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

    [self addHeaderRefresh];
    [self addFooterRefresh];
}

- (void)addHeaderRefresh {
    self.offset = 1;
    weakObj(self);
    MJRefreshStateHeader * header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        selfWeak.offset = 1;
        [selfWeak loadData];
    }];
    _tableView.mj_header = header;
}
- (void)addFooterRefresh {
    weakObj(self);
    MJNewsFooter * header = [MJNewsFooter footerWithRefreshingBlock:^{
        selfWeak.offset++;
        [selfWeak loadData];
    }];
    _tableView.mj_footer = header;
}


- (void)loadData {
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"p":@(self.offset),
                             @"n":@20,
                             };
    
    [HttpRequest get_RequestWithURL:FOLLOW_TOPIC_LIST_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
            
                NSArray * arr = dic[@"data"];
                
                if (arr.count != 0) {
                    
                    if (!self.tableView.mj_footer.isRefreshing) {
                        [self.dataSource removeAllObjects];
                    }
                    for (NSDictionary * obj in arr) {
                        TopicModel * model = [TopicModel new];
                        [model setValuesForKeysWithDictionary:obj];
                        [self.dataSource addObject:model];
                    }
                    [self isHaveData];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                    
                    return;
                }
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }
        
        [self isHaveData];
        if (self.tableView.mj_footer.isRefreshing) {
            self.offset--;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        
    }];
    
}

/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowedTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FollowedTopicCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopicModel * model = self.dataSource[indexPath.row];

    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = model.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath){
        
        TopicModel * model = self.dataSource[indexPath.row];

        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"topicid":model.ID,
                                 };
        
        [HttpRequest get_RequestWithURL:UNFOLLOW_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app.overallParam setObject:@"0" forKey:model.ID];
                    
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [self isHaveData];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }];
    
    return @[action];
}


@end
