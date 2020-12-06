//
//  CollectionViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"

#import "CollectionCell.h"

#import "UninterestedView.h"

#import "ShareView.h"

#import "CommentViewController.h"
#import "ScourceViewController.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource,CollectionCellDelegate,UninterestedViewDelegate,ShareViewDelegate,MorePopViewDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, assign)int offset;

@property(nonatomic, strong)BListModel * shareModel;
@property(nonatomic, strong)CollectionCell * moreViewCell;

@property(nonatomic, strong)DataTipsView * dataTipsView;

@end

@implementation CollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

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
    _tableView.backgroundColor = RGBColor(245, 245, 245);
    [_tableView registerClass:[CollectionCell class] forCellReuseIdentifier:@"CollectionCell"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomInsets, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            [_dataTipsView loadDataWithModel:@{@"label":@"暂无收藏"}];
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
    
    [HttpRequest get_RequestWithURL:FAVO_LIST_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
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
                        BListModel * model = [BListModel new];
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
    
    
    [self.tableView reloadData];
}

- (BListModel *)handleModel:(BListModel *)model {
    
    CGFloat width = [model.topicname boundingRectWithSize:CGSizeMake(kWidth-100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    
    model.titleWidth = width;
    
    //内容
    float ch = 0;
    float ph = 0;
    float vh = 0;
    
    model.des = [[model.des componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    
    if (![model.title isEqualToString:@""]) {
        if (![model.des isEqualToString:@""]) {
            if ([model.title isEqualToString:model.des]) {
                model.content = model.title;
            }else {
                model.content = [@[model.title,model.des] componentsJoinedByString:@"\n"];
            }
        }else {
            model.content  = model.title;
        }
    }else {
        model.content = model.des;
    }
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5];
    float contentHeight = [model.content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:style} context:nil].size.height;
    model.contentHeight = ceil(contentHeight);
    
    if (model.contentHeight != 0) {
        ch = model.contentHeight+10;
    }
    
    //图片
    if (![model.pic_urls isEqualToString:@""]) {
        model.picsArr = [NSJSONSerialization JSONObjectWithData:[model.pic_urls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }else {
        model.picsArr = @[];
    }
    
    if (model.picsArr.count == 0) {
        model.imageHeight = 0;
    }else if (model.picsArr.count==1) {
        
        if (model.type.intValue == 3) {
            model.imageHeight = ceil((kWidth-30)*9/16.);
        }else {
            model.imageHeight = 180;
        }
        
    }else {
        int num = model.picsArr.count%3 ?(int)model.picsArr.count/3+1 : (int)model.picsArr.count/3;
        model.imageHeight = (kWidth-40)/3.*num + 5*(num-1);
    }
    
    if (model.imageHeight != 0) {
        ph = model.imageHeight+10;
    }
    
    //视频
    if ([model.video_url isEqualToString:@""]) {
        model.videoHeight = 0;
    }else {
        model.videoHeight = ceil((kWidth - 30)*9/16.);
    }
    
    if (model.videoHeight != 0) {
        vh = model.videoHeight+10;
    }
    
    //总
    model.totalHeight = ceil(60+ch+ph+vh+44+8);
    
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
    CollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.delegate  = self;
    BListModel * model = self.dataSource[indexPath.row];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = app.overallParam[model.topicid];
    if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    
    weakObj(self);
    cell.reloadBlock = ^{
        [selfWeak.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScourceViewController * vc = [[ScourceViewController alloc]init];
    vc.ID = [self.dataSource[indexPath.row] ID];
    vc.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BListModel * model = [self.dataSource objectAtIndex:indexPath.row];
    return model.totalHeight;
}



- (void)commentMethod:(CollectionCell *)cell {
    CommentViewController * vc = [[CommentViewController alloc]init];
    vc.ID = cell.model.ID;
    vc.bModel = cell.model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareMethod:(CollectionCell *)cell {
    _shareModel = cell.model;
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
    
}
- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:_shareModel atIndex:index viewController:self.navigationController];
}



- (void)moreMethod:(CollectionCell *)cell {
    _moreViewCell = cell;
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect frame =[cell convertRect:cell.bounds toView:window];
    
    float y = frame.origin.y+cell.height-52;
    
    MorePopView * morePopView = [[MorePopView alloc]init];
    morePopView.delegate = self;
    
    NSArray * arr = @[
                      @"举报",
                      ];
    
    NSLog(@"%f",y);
    if (y - arr.count*50 - 10 > kStatusHeight + 44) {
        [morePopView showWithY:y-arr.count*50 option:arr];
    }else {
        [morePopView showWithY:y + 44 option:arr];
    }
    
}
- (void)morePopViewSelectedAtIndex:(int)index {
    
    if (![Reachability shared].reachable) {
        [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        return;
    }
    
    switch (index) {
        case 0:{
            [HttpRequest get_RequestWithURL:[NSString stringWithFormat:REPORT_URL,_moreViewCell.model.ID] URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        [KKHUD showBottomWithStatus:@"举报成功"];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)picMethod:(CollectionCell *)cell atIndex:(int)index {
    
    if (cell.model.type.intValue == 3) {
        
        ScourceViewController * vc = [[ScourceViewController alloc]init];
        vc.ID = cell.model.ID;
        vc.model = cell.model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
       
        [[UserActionReport shared]newsPost:cell.model.ID ext:cell.model.ext];
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIImageView * imageView = (UIImageView *)cell.imageViewArr[index];
        CGRect frame = [imageView convertRect:imageView.bounds toView:app.window];
        PicPreView * picView = [[PicPreView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [picView picArr:cell.model.picsArr atIndex:index fromRect:frame];
        [self.view addSubview:picView];
        
    }
    
    
    
    
}

@end
