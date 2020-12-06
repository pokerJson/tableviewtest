//
//  CommentViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "WriteBoardView.h"
#import "FindMessageInfo.h"

#import "PersonViewController.h"

@interface CommentViewController ()<TTableViewDelegate,UITableViewDelegate,UITableViewDataSource,WriteBoardViewDeletgate,CommentCellDelegate,UIAlertViewDelegate>

@property(nonatomic, strong)TTableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)int offset;

@property(nonatomic, strong)WriteBoardView * wBoardView;

@property(nonatomic, strong)DataTipsView * dataTipsView;

//评论
@property(nonatomic, strong)NSString * commentStr;

@property(nonatomic, strong)CommentCell * deleteCell;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    self.navTitleLabel.text = @"评论详情";
    
    [self createTableView];
    [self createWriteBoard];
    [self loadData];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createWriteBoard {
    _wBoardView = [[WriteBoardView alloc]initWithFrame:CGRectMake(0, kHeight-kBottomInsets-54, kWidth, kHeight)];
    _wBoardView.delegate = self;
    _wBoardView.submitName = @"发布";
    [self.view addSubview:_wBoardView];
}


- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_wBoardView resignResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_wBoardView resignResponder];
}


- (void)createTableView {
    
    _tableView = [[TTableView alloc]initWithFrame:CGRectMake(0, kStatusHeight + 44, kWidth, kHeight-(kStatusHeight + 44)-kBottomInsets-54) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(247, 247, 247);
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    _tableView.touchDelegate = self;
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
    MJRefreshBackStateFooter * header = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        selfWeak.offset++;
        [selfWeak loadData];
    }];
    _tableView.mj_footer = header;
}

- (CommentModel *)handleModel:(CommentModel *)model {
    //64
    //内容
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5];
    float contentHeight = [model.content boundingRectWithSize:CGSizeMake(kWidth-89, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style} context:nil].size.height;
    model.contentHeight = ceil(contentHeight);
    //总
    if ([UserManager shared].isLogin && [model.uid isEqualToString:[UserManager shared].userInfo.uid]) {
        model.totalHeight = ceil(64+model.contentHeight+15+20);
    }else {
        model.totalHeight = ceil(64+model.contentHeight+15);
    }
    return model;
}

- (void)isHaveData {
    if (self.dataSource.count != 0) {
        _dataTipsView.hidden = YES;
    }else {
        if ([Reachability shared].reachable) {
            [_dataTipsView loadDataWithModel:@{
                                               @"label":@"暂无评论",
                                               }];
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
    
    NSDictionary *param = nil;
    
    if ([UserManager shared].isLogin) {
        
        param = @{
                  @"did":_ID,
                  @"imei":[SysInfo deviceID],
                  @"pn":@(self.offset),
                  @"ps":@20,
                  };
        
    }else {
        
        param = @{
                  @"did":_ID,
                  @"imei":[SysInfo deviceID],
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  @"pn":@(self.offset),
                  @"ps":@20,
                  };
        
    }
    
    [HttpRequest get_RequestWithURL:COMMENT_LIST_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                
                NSArray * arr = dic[@"data"];
                
                if (arr.count != 0) {
                    
                    if (!self.tableView.mj_footer.isRefreshing) {
                        [self.dataSource removeAllObjects];
                    }
                    for (NSDictionary * obj in arr) {
                        CommentModel * model = [[CommentModel alloc]init];
                        [model setValuesForKeysWithDictionary:obj];
                        [self.dataSource addObject:[self handleModel:model]];
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
        
        [self isHaveData];
        self.offset--;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }];
    
}

- (void)writeBoardView:(WriteBoardView *)wBoardView submitWithStr:(NSString *)str {
    NSLog(@"%@",str);
    
    _commentStr = str;
    
    if ([UserManager shared].isLogin) {
        
        [self commentWithStr:str];
        
    }else {
        //未登陆
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

- (void)commentWithStr:(NSString *)str {
    
    if (str == nil) return;
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"did":_ID,
                             @"content":str,
                             };
    
    [HttpRequest get_RequestWithURL:COMMENT_ADD_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if (self.bModel) {
                    self.bModel.num_comment =  @(self.bModel.num_comment.integerValue+1).stringValue;
                }
                if (self.info) {
                    self.info.num_comment =  @(self.info.num_comment.integerValue+1).stringValue;
                }

                self.offset = 1;
                [self loadData];
                self.tableView.contentOffset = CGPointZero;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        self.commentStr = nil;
    }];
    
}



/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    weakObj(self);
    cell.personBlock = ^(NSString * uid) {
        
        PersonViewController * vc = [[PersonViewController alloc]init];
        vc.uid = uid;
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel * model = [self.dataSource objectAtIndex:indexPath.row];
    return model.totalHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)deleteComment:(CommentCell *)cell {
    
    _deleteCell = cell;
    
    
    UIAlertView * alet = [[UIAlertView alloc]initWithTitle:@"是否删除此条评论" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alet show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {

        
        NSIndexPath * indexPath = [_tableView indexPathForCell:_deleteCell];
        //cid 评论id
        //userid 用户id
        //token accessToken
        
        CommentModel * model = self.dataSource[indexPath.row];
        
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"cid":model.ID,
                                 };
        
        [HttpRequest get_RequestWithURL:DELETE_COMMENT_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [KKHUD showMiddleWithStatus:@"删除成功"];
                    return ;
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            [KKHUD showMiddleWithStatus:@"删除失败"];
        }];
        
        
        
    }
    
}



//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView * header = [[UIView alloc] init];
//    header.backgroundColor = RGBColor(247, 247, 247);
//
//    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 44)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [header addSubview:bgView];
//
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kWidth-30, 44)];
//    label.backgroundColor = [UIColor whiteColor];
//    label.textColor = RGBColor(34, 34, 34);
//    label.font = UIFontSys(14);
//    [header addSubview:label];
//
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 53.6, kWidth, 0.4)];
//    line.backgroundColor = RGBColor(175, 175, 175);
//    [header addSubview:line];
//
//    // 设置文字
//    if (section == 0) {
//        label.text = [self.dataSource.firstObject count] ? @"热门评论" : @"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return header;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return [self.dataSource.firstObject count]?54:0;
//    }else {
//        return [self.dataSource.lastObject count]?54:0;
//    }
//}



@end
