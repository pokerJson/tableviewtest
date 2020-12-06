//
//  CurrentThemeViewController.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CurrentThemeViewController.h"
#import "FindManager.h"
#import "FindThemeTableViewCell.h"
#import "ThemeVC.h"
#import "TopicViewController.h"
#import "FindViewController.h"

@interface CurrentThemeViewController ()<FindThemeTableViewCellDelegate>{
    int tem;
}

@property (nonatomic,strong)NSMutableArray *themeArr;

@end

@implementation CurrentThemeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"xxxxxx");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.themeArr = [[NSMutableArray alloc]init];
    tem = 1;
    [self.tableView registerClass:[FindThemeTableViewCell class] forCellReuseIdentifier:@"themeCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theme) name:@"theme" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataTheme) name:@"updataTheme" object:nil];

    self.hotLabel.hidden = YES;
    self.bagtagView.hidden = YES;
    self.historyLable.frame = CGRectMake(15, 10, 100, 15);
    self.deleteBT.frame = CGRectMake(kScreenWidth-30, 10, 12, 12);
    [self.histiryView removeFromSuperview];
    self.histiryView = [[FindHistoryView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 0)];
    [self.defaultScrollview addSubview:self.histiryView];

    /*
     //搜索历史
     NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
     NSArray *allArr = [userdde objectForKey:@"themeArr"];
     NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
     if (temArr.count == 0) {
     self.historyLable.hidden = YES;
     self.deleteBT.hidden = YES;
     }else{
     self.historyLable.hidden = NO;
     self.deleteBT.hidden = NO;
     
     }
     self.histiryView.histyARR = temArr;
     weakObj(self);
     [self.histiryView setDidselectItemBlock:^(NSString *str) {
     NSLog(@"点击主题-==%@",str);
     (selfWeak.view.viewController).kTextField.text = str;
     FindManager *mana = [FindManager defaulManager];
     mana.currentString = str;
     [selfWeak theme];
     }];
     */
    

}
- (void)deleteBTClick
{
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"themeArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    [temArr removeAllObjects];
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"themeArr"];
    [userdde synchronize];
    
    [self.histiryView removeFromSuperview];
    self.historyLable.hidden = YES;
    self.deleteBT.hidden = YES;
    
}

- (void)updataTheme
{
    [self.tableView reloadData];
}
- (void)theme{
    NSLog(@"主题");
    FindManager *mana = [FindManager defaulManager];
    if (mana.currentString.length > 0) {
        //有s搜索词
        self.defaultScrollview.hidden = YES;
        self.tableView.hidden = NO;
       
        NSDictionary *param = @{@"keyword":mana.currentString,
                                @"userid":[UserManager shared].userInfo.uid,
                                @"token":[UserManager shared].userInfo.accessToken,
                                @"p":@"1",
                                @"n":@"10"
                                };
        [HttpRequest get_RequestWithURL:SEARCH_THEME URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"主题dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    [self.themeArr removeAllObjects];//移除
                    if(data.count > 0){
                        for (int i = 0; i<data.count; i++) {
                            TopicModel *info = [[TopicModel alloc]init];
                            [info setValuesForKeysWithDictionary:data[i]];
                            [self.themeArr addObject:info];
                        }
                    }else{
                        //无数据
                        [KKHUD showMiddleWithStatus:@"没搜到内容,请换一个词试试"];
                    }
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
        }];
        
    }else{
        self.defaultScrollview.hidden = NO;
        self.tableView.hidden = YES;
    }

}
- (void)loadMoreData
{
    FindManager *mana = [FindManager defaulManager];
    if (mana.currentString.length > 0) {
        //有s搜索词
        tem ++ ;
        self.defaultScrollview.hidden = YES;
        self.tableView.hidden = NO;
        NSDictionary *param = @{@"keyword":mana.currentString,
                                @"userid":[UserManager shared].userInfo.uid,
                                @"token":[UserManager shared].userInfo.accessToken,
                                @"p":@(tem),
                                @"n":@"10"
                                };
        [HttpRequest get_RequestWithURL:SEARCH_THEME URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"主题dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    if (data.count > 0) {
                        for (int i = 0; i<data.count; i++) {
                            TopicModel *info = [[TopicModel alloc]init];
                            [info setValuesForKeysWithDictionary:data[i]];
                            [self.themeArr addObject:info];
                        }
                        [self.tableView reloadData];
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        //到底了
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
        }];
        
    }else{
        self.defaultScrollview.hidden = NO;
        self.tableView.hidden = YES;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themeArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
    cell.info = _themeArr[indexPath.row];
    cell.index = indexPath;
    cell.delegate = self;
    return cell;
}
- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow
{
    FindThemeInfo *info = _themeArr[index.row];
    info.if_guanzhu = isfollow;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(self.view.viewController).kTextField resignFirstResponder];

    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = [_themeArr[indexPath.row] ID];
    vc.hidesBottomBarWhenPushed = YES;
    [self.view.viewController.navigationController pushViewController:vc animated:YES];


}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [(self.view.viewController).kTextField resignFirstResponder];
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
