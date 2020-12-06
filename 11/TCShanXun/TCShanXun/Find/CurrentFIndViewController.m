//
//  CurrentFIndViewController.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CurrentFIndViewController.h"
#import "FindManager.h"

@interface CurrentFIndViewController ()



@end

@implementation CurrentFIndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zonghe) name:@"zonghe" object:nil];

    //开始
    _defaultScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _defaultScrollview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*1.2);
    _defaultScrollview.userInteractionEnabled = YES;
    _defaultScrollview.showsVerticalScrollIndicator = NO;
    _defaultScrollview.showsHorizontalScrollIndicator = NO;
    _defaultScrollview.userInteractionEnabled = YES;
    [self.view addSubview:_defaultScrollview];
    
    _hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 15)];
    _hotLabel.text = @"热点";
    _hotLabel.textColor = RGBColor(222, 222, 222);
    _hotLabel.textAlignment = NSTextAlignmentLeft;
    [_defaultScrollview addSubview:_hotLabel];
    
    NSArray *strArray=@[@"大好人",@"自定义流式标签",@"github",@"code4app",@"已婚",@"阳光开朗",@"慷慨大方帅气身材好",@"仗义",@"值得一交的朋友",@"值得一交的朋友",@"值得的交",@"值得一交的朋友",@"值得一交的朋友",@"大好人",@"自定义流式标签",@"github",@"code4app",@"已婚",@"更多热门搜索"];
    _bagtagView = [[FindBagTagView alloc]initWithFrame:CGRectMake(5, 30, kScreenWidth-10, 0)];
    _bagtagView.canTouch = YES;
    _bagtagView.isSingleSelect = YES;
    [_bagtagView setTagWithTagArray:strArray];
    [_defaultScrollview addSubview:_bagtagView];

    [_bagtagView setDidselectItemBlock:^(NSString *str) {
        NSLog(@"选中的标签==%@",str);
        
    }];
    
    //
    _historyLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 15)];
    _historyLable.text = @"搜索历史";
    _historyLable.textAlignment = NSTextAlignmentLeft;
    _historyLable.textColor = RGBColor(222, 222, 222);
    _historyLable.font = [UIFont systemFontOfSize:14.0];
    [_defaultScrollview addSubview:_historyLable];
    
    //
    _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBT.frame = CGRectMake(kScreenWidth-30, _historyLable.frame.origin.y, 12, 12);
    [_deleteBT setBackgroundImage:UIImageNamed(@"ic_navbar_close") forState:UIControlStateNormal];
    [_deleteBT addTarget:self action:@selector(deleteBTClick) forControlEvents:UIControlEventTouchUpInside];
    [_defaultScrollview addSubview:_deleteBT];
    
    //
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"allArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    
    _histiryView = [[FindHistoryView alloc]initWithFrame:CGRectMake(0, _historyLable.frame.origin.y+40, kScreenWidth, 0)];
    _histiryView.userInteractionEnabled = YES;
    _histiryView.histyARR = temArr;
    [_defaultScrollview addSubview:_histiryView];
    [_histiryView setDidselectItemBlock:^(NSString *str) {
        NSLog(@"选中历史===%@",str);
    }];
    if (temArr.count == 0) {
        _historyLable.hidden = YES;
        _deleteBT.hidden = YES;
    }

}
- (void)zonghe
{
    NSLog(@"综合");
    FindManager *mana = [FindManager defaulManager];
    if (mana.currentString.length > 0) {
        //有s搜索词
        _defaultScrollview.hidden = YES;
        self.tableView.hidden = NO;
//        接口url:http://www.yzpai.cn/news/so/all
//        请求方式：get post
//        请求参数：
//        keyword 搜索关键词
//        userid 用户id
//        token accessToken
        NSLog(@"na.curren==%@",mana.currentString);
        NSDictionary *param = @{@"keyword":mana.currentString,
                                @"userid":[UserManager shared].userInfo.uid,
                                @"token":[UserManager shared].userInfo.accessToken
                                };
        [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/so/all" URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"综合dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    for (int i = 0; i<data.count; i++) {
                        
                    }
                    
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }

        }];

    }else{
        _defaultScrollview.hidden = NO;
        self.tableView.hidden = YES;
    }

}
- (void)loadMoreData
{
    
}
- (void)deleteBTClick
{
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"allArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    [temArr removeAllObjects];
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"allArr"];
    [userdde synchronize];
    
    [_histiryView removeFromSuperview];
    _historyLable.hidden = YES;
    _deleteBT.hidden = YES;

}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cel"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cel"];
    }
    cell.textLabel.text = @"xxxx";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第 %ld 行", indexPath.row + 1);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kScreenHeight-kStatusHeight-44-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cel"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//隐藏多余的cell
//        MJRefreshAutoStateFooter * header = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
//            [self loadMoreData];
//        }];
        MJRefreshBackNormalFooter *fooo = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = fooo;
        _tableView.mj_footer.automaticallyHidden = YES;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
