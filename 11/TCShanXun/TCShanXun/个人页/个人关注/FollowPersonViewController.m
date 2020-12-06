//
//  FollowPersonViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowPersonViewController.h"
#import "FollowPersonCell.h"

#import "PersonModel.h"

#import "PersonViewController.h"

@interface FollowPersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)int offset;

@property(nonatomic, strong)NSString * url;

@end

@implementation FollowPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    if (_isSelf) {
    
        if (_follow) {
            self.navTitleLabel.text = @"我关注的人";
        }else {
            self.navTitleLabel.text = @"关注我的人";
        }
        
    }else {
        
        if (_follow) {
            self.navTitleLabel.text = @"TA关注的人";
            
        }else {
            self.navTitleLabel.text = @"关注TA的人";
            
        }
        
    }
    
    
    if (_follow) {
        _url = BOKE_FOLLOWING_URL;
    }else {
        _url = BOKE_FOLLOWER_URL;
    }
    
    
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
    [_tableView registerClass:[FollowPersonCell class] forCellReuseIdentifier:@"FollowPersonCell"];
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
    MJRefreshBackStateFooter * header = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        selfWeak.offset++;
        [selfWeak loadData];
    }];
    _tableView.mj_footer = header;
}

- (void)loadData {

    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"uid":_uid,
                             @"p":@(self.offset),
                             @"n":@20,
                             };
    
    
    [HttpRequest get_RequestWithURL:_url URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
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
                        PersonModel * model = [[PersonModel alloc]init];
                        [model setValuesForKeysWithDictionary:obj];
                        [self.dataSource addObject:model];
                    }
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                    
                    return;
                }
                
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        self.offset--;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }];
    
    
    [self.tableView reloadData];
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
    FollowPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FollowPersonCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonModel * model = self.dataSource[indexPath.row];
    PersonViewController * vc = [PersonViewController new];
    vc.uid = model.userid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

@end
