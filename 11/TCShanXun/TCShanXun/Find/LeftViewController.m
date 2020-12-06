//
//  LeftViewController.m
//  News
//
//  Created by dzc on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "LeftViewController.h"
#import "LTScrollView-Swift.h"
#import "ThemeInfo.h"

//#import "FirstTableViewCell.h"
#import "FIndMessageTableViewCell.h"

#import <SDAutoLayout/SDAutoLayout.h>
//#import "TijianjianTableViewCell.h"
//#import "TuijianInfo.h"
#import "FindMessageInfo.h"
#import "FimeMessageSourceViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataARR;
//@property(nonatomic,strong)TuijianInfo *infof;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    self.dataARR = [[NSMutableArray alloc]init];
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    
//    接口url：http://www.yzpai.cn/news/topic/news
//    * 参数：
//    topicid topicid
//    p 第几页 默认1
//    n 每页条数 默认10
    NSDictionary *parm = @{@"topicid":self.iD,
                           @"p":@1,
                           @"n":@10
                           };
    [HttpRequest get_RequestWithURL:TOPIC_NEWS_URL URLParam:parm returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                [self.dataARR removeAllObjects];
                for (int i = 0; i<data.count; i++) {
                    FindMessageInfo *info = [[FindMessageInfo alloc]init];
                    [info setValuesForKeysWithDictionary:data[i]];
                    [self.dataARR addObject:info];
                }
                [self.tableView reloadData];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }

    }];
    
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataARR.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIndMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.info = self.dataARR[indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id info = self.dataARR[indexPath.row];
    float hei = [self.tableView cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[FIndMessageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    return hei;
    
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1) {
//        TijianjianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondcell"];
//        cell.info = self.dataARR[indexPath.row];
//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//        return cell;
//    }else{
//        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell"];
//        cell.indexpath = indexPath;
//        weakObj(self);
//        cell.moreButtonClickedBlock = ^(NSIndexPath *indexPath) {
//            ThemeInfo *model = selfWeak.dataARR[indexPath.row];
//            model.isOpening = !model.isOpening;
//            [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//        cell.info = self.dataARR[indexPath.row];
//
//        return cell;
//
//    }
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 1) {
//        return 240;
//    }
//    else{
//        // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//        id info = self.dataARR[indexPath.row];
//        float hei = [self.tableView cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[FirstTableViewCell class] contentViewWidth:[self cellContentViewWith]];
//        NSLog(@"rr==%f",hei);
//        return hei;
//
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FimeMessageSourceViewController * vc = [[FimeMessageSourceViewController alloc]init];
    vc.rec_url = [self.dataARR[indexPath.row] rec_url];
    [self.navigationController pushViewController:vc animated:YES];

    
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat H = IS_IPHONE_X ? (kScreenHeight - 44 - 64 - 24 - 34) : kScreenHeight - 44 - 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 解决在iOS11上朋友圈demo文字收折或者展开时出现cell跳动问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[FIndMessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];

//        [_tableView registerClass:[FirstTableViewCell class] forCellReuseIdentifier:@"firstcell"];
//        [_tableView registerClass:[TijianjianTableViewCell class] forCellReuseIdentifier:@"secondcell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
