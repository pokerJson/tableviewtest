//
//  FindSecondViewController.m
//  News
//
//  Created by dzc on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindSecondViewController.h"
#import "LTScrollView-Swift.h"
#import <MJRefresh/MJRefresh.h>
#import "ThemeViewController.h"

#import "ThemeTableViewCell.h"
#import "ThemeModel.h"
#import "ThemeVC.h"

#import "TopicViewController.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface FindSecondViewController ()<UITableViewDelegate,UITableViewDataSource,ThemeTableViewCellDelegate>{
    int tmp;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *themeArr;

@end

@implementation FindSecondViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    
}
- (void)viewScrollToAppear {
    if (self.themeArr.count == 0) {
        [self updataDataWithType:_type];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.view.backgroundColor = [UIColor whiteColor];
    self.themeArr = [[NSMutableArray alloc]init];
    tmp = 1;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    
    //数据
}

- (void)updataDataWithType:(NSString *)type {
    
    NSDictionary *parm = nil;
    
    if ([UserManager shared].isLogin) {
        parm = @{@"c":self.type,
                 @"p":@"1",
                 @"n":@"10",
                 @"userid":[UserManager shared].userInfo.uid,
                 @"token":[UserManager shared].userInfo.accessToken,
                 };
    }else {
        parm = @{@"c":self.type,
                 @"p":@"1",
                 @"n":@"10",
                 };
    }
   
    [HttpRequest get_RequestWithURL:TOPIC_C_LIST_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                [self.themeArr removeAllObjects];
                for (int i= 0; i<data.count; i++) {
                    ThemeModel *model = [[ThemeModel alloc]init];//主题类
                    model.isLoad = NO;//装到数组中，先不下载
                    [model setValuesForKeysWithDictionary:data[i]];
                    [self.themeArr addObject:model];
                }
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //让tableView准备好后，再显示
//                    [self loadShowCells];
//                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadShowCells];

                });

                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                self.refreshBlock();
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }

    }];


}
- (void)loadMoreData {
    tmp ++;
    NSDictionary *parm = nil;
    
    if ([UserManager shared].isLogin) {
        parm = @{@"c":self.type,
                 @"p":@(tmp),
                 @"n":@"10",
                 @"userid":[UserManager shared].userInfo.uid,
                 @"token":[UserManager shared].userInfo.accessToken,
                 };
    }else {
        parm = @{@"c":self.type,
                 @"p":@(tmp),
                 @"n":@"10",
                 };
    }
 
    [HttpRequest get_RequestWithURL:TOPIC_C_LIST_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                if (data.count > 0) {
                    for (int i= 0; i<data.count; i++) {
                        ThemeModel *model = [[ThemeModel alloc]init];//主题类
                        model.isLoad = NO;//装到数组中，先不下载

                        [model setValuesForKeysWithDictionary:data[i]];
                        [self.themeArr addObject:model];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //让tableView准备好后，再显示
                        [self loadShowCells];
                    });

                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }
        
    }];

}
- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow
{
    ThemeModel *model = _themeArr[index.row];
    model.if_guanzhu = isfollow;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findCELL"];
    cell.model = _themeArr[indexPath.row];
    ThemeModel * model = _themeArr[indexPath.row];
         if (model.isLoad) {
              [cell setImageWithModel:model];
         }else{
              [cell setImageWithModel:nil];
         }
    cell.delegate = self;
    cell.index = indexPath;
    return cell;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

  if (!decelerate) {
       //滑动时,加载占位图
       [self loadShowCells];
   }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

             [self loadShowCells];
}
-(void)loadShowCells{
      NSArray * array = [self.tableView indexPathsForVisibleRows];
  for (NSIndexPath *indexPath in array) {

   ThemeTableViewCell * cell = (ThemeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        ThemeModel * model = _themeArr[indexPath.row];
        [cell setImageWithModel:model];
    
  }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第 %ld 行", indexPath.row + 1);
    
//    ThemeVC *theme = [[ThemeVC alloc]init];
//    theme.iD = [_themeArr[indexPath.row] ID];
//    theme.model = _themeArr[indexPath.row];
//    theme.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:theme animated:YES];

    
    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = [_themeArr[indexPath.row] ID];
    vc.model = _themeArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - 44 - 64 - 24-83) : self.view.bounds.size.height - 44 - 64-49;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomInsets, 0);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ThemeTableViewCell class] forCellReuseIdentifier:@"findCELL"];
        
//        MJRefreshBackNormalFooter *fooo = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        _tableView.mj_footer = fooo;
//        _tableView.mj_footer.automaticallyHidden = YES;
//        MJNewsFooter * fooo = [MJNewsFooter footerWithRefreshingBlock:^{
//            [self loadMoreData];
//        }];
//        _tableView.mj_footer = fooo;
        
        MJRefreshAutoStateFooter *fooo = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [self loadMoreData];

        }];
        _tableView.mj_footer = fooo;


    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
