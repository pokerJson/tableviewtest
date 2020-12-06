//
//  NotificationViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotiCell.h"
#import "NotiModel.h"

#import "PersonViewController.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, assign)int offset;

@property(nonatomic, strong)DataTipsView * dataTipsView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
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
    _tableView.backgroundColor = RGBColor(246, 246, 246);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomInsets, 0);
    [_tableView registerClass:[NotiCell class] forCellReuseIdentifier:@"NotiCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    
    _dataTipsView = [[DataTipsView alloc]initWithFrame:_tableView.bounds];
    _dataTipsView.hidden = YES;
    weakObj(self);
    _dataTipsView.callBack = ^(NSDictionary *param) {
        [selfWeak.tableView.mj_header beginRefreshing];
    };
    [_tableView addSubview:_dataTipsView];
    
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


- (void)isHaveData {
    if (self.dataSource.count != 0) {
        _dataTipsView.hidden = YES;
    }else {
        if ([Reachability shared].reachable) {
            [_dataTipsView loadDataWithModel:@{@"label":@"暂无通知"}];
        }else {
            [_dataTipsView loadDataWithModel:@{@"img":@"icon_nonetwork",
                                               @"label":@"啊哦,网络不太顺畅呦~",
                                               @"btn":@"重新加载",
                                               }];
        }
        _dataTipsView.hidden = NO;
    }
}


- (void)loadData {
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"p":@(self.offset),
                             @"n":@20,
                             };
    
    [HttpRequest get_RequestWithURL:NOTI_LIST_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
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
                        NotiModel * model = [[NotiModel alloc]init];
                        [model setValuesForKeysWithDictionary:obj];
                        if (model.type.intValue == 2) continue;
                        [self.dataSource insertObject:[self handleModel:model] atIndex:0];
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


- (NotiModel *)handleModel:(NotiModel *)model {
    
    if (model.type.intValue == 1) {
        model.nick = [NSString stringWithFormat:@"%@ 关注了你",model.nick];
    }else {
        model.nick = [NSString stringWithFormat:@"%@ 取消关注",model.nick];
    }
    
    CGFloat height = [model.nick boundingRectWithSize:CGSizeMake(kWidth-180,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    model.contentHeight = ceil(height);
    
    
    float h = model.contentHeight+20>50?20+model.contentHeight+20+35:(50-model.contentHeight-20)/2.+ 20 +model.contentHeight+20+35;

    model.totalHeight = h;
    
    return model;
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
    NotiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotiCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NotiModel * model = self.dataSource[indexPath.row];
    
    PersonViewController * vc = [PersonViewController new];
    vc.uid = [NSString stringWithFormat:@"%@",model.uid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotiModel * model = self.dataSource[indexPath.row];
    return model.totalHeight;
}




@end
