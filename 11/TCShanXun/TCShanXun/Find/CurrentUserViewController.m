//
//  CurrentUserViewController.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CurrentUserViewController.h"
#import "FindManager.h"
#import "FIndUserTableViewCell.h"
#import "PersonModel.h"
#import "PersonViewController.h"
#import "FindViewController.h"

@interface CurrentUserViewController ()<FIndUserTableViewCellDelegate>{
    int tem;
}
@property (nonatomic,strong)NSMutableArray *userArr;
@end

@implementation CurrentUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.userArr = [[NSMutableArray alloc]init];
    tem = 1;
    [self.tableView registerClass:[FIndUserTableViewCell class] forCellReuseIdentifier:@"userCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user) name:@"user" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUser) name:@"updataUser" object:nil];

    self.hotLabel.hidden = YES;
    self.bagtagView.hidden = YES;
    self.historyLable.frame = CGRectMake(15, 10, 100, 15);
    self.deleteBT.frame = CGRectMake(kScreenWidth-30, 10, 15, 15);
    [self.histiryView removeFromSuperview];
    self.histiryView = [[FindHistoryView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 0)];
    [self.defaultScrollview addSubview:self.histiryView];
    
    /*
     //搜索历史
     NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
     NSArray *allArr = [userdde objectForKey:@"userArr"];
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
     NSLog(@"点击用户-==%@",str);
     (selfWeak.view.viewController).kTextField.text = str;
     FindManager *mana = [FindManager defaulManager];
     mana.currentString = str;
     [selfWeak user];
     }];

     */

}
- (void)updataUser
{
   [ self.tableView reloadData];
}
- (void)user{
    NSLog(@"user");
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
        [HttpRequest get_RequestWithURL:SEARCH_USER URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"用户dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    [self.userArr removeAllObjects];//移除
                    if(data.count > 0){
                        for (int i = 0; i<data.count; i++) {
                            PersonModel *info = [[PersonModel alloc]init];
                            [info setValuesForKeysWithDictionary:data[i]];
                            [self.userArr addObject:info];
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
        [HttpRequest get_RequestWithURL:SEARCH_USER URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"主题dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    if (data.count > 0) {
                        for (int i = 0; i<data.count; i++) {
                            PersonModel *info = [[PersonModel alloc]init];
                            [info setValuesForKeysWithDictionary:data[i]];
                            [self.userArr addObject:info];
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
    return _userArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIndUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    cell.info = _userArr[indexPath.row];
    cell.index = indexPath;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [(self.view.viewController).kTextField resignFirstResponder];
    
    PersonViewController *rr = [[PersonViewController alloc]init];
    rr.hidesBottomBarWhenPushed = YES;
    rr.uid = ((PersonModel *)self.userArr[indexPath.row]).userid;
    rr.personModel = self.userArr[indexPath.row];
    [self.view.viewController.navigationController pushViewController:rr animated:YES];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [(self.view.viewController).kTextField resignFirstResponder];
}
- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow
{
    FIndUserInfo *info = _userArr[index.row];
    info.if_guanzhu = isfollow;
}
- (void)deleteBTClick
{
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"userArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    [temArr removeAllObjects];
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"userArr"];
    [userdde synchronize];
    
    [self.histiryView removeFromSuperview];
    self.historyLable.hidden = YES;
    self.deleteBT.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
