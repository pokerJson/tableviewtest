//
//  CurrentMessageViewController.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CurrentMessageViewController.h"
#import "FindManager.h"
//#import "FIndMessageTableViewCell.h"
#import "FindMessageCell.h"

#import <SDAutoLayout/SDAutoLayout.h>
#import "FimeMessageSourceViewController.h"
#import "AddCollectionView.h"
#import "ScourceViewController.h"
#import "UninterestedView.h"
#import "CommentViewController.h"
#import "FindViewController.h"

@interface CurrentMessageViewController ()<AddCollectionViewDelegate,FindMessageCellDelegate,UninterestedViewDelegate,ShareViewDelegate,MorePopViewDelegate>{
    int tem;
}
@property (nonatomic,strong)NSMutableArray *messageArr;
@property(nonatomic, strong)FindMessageCell * moreViewCell;
@property(nonatomic, strong)BListModel * shareModel;

@end

@implementation CurrentMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"xxxxxxxxxxxx");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.messageArr = [[NSMutableArray alloc]init];
    tem = 1;
    [self.tableView registerClass:[FindMessageCell class] forCellReuseIdentifier:@"messageCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message) name:@"message" object:nil];
    
    /*
    //lishi
    self.hotLabel.hidden = YES;
    self.bagtagView.hidden = YES;
    self.historyLable.frame = CGRectMake(15, 10, 100, 15);
    self.deleteBT.frame = CGRectMake(kScreenWidth-30, 10, 15, 15);
    [self.histiryView removeFromSuperview];
    self.histiryView = [[FindHistoryView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 0)];
    [self.defaultScrollview addSubview:self.histiryView];
    
    //搜索历史
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"messageArr"];
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
        NSLog(@"点击消息-==%@",str);
        (selfWeak.view.viewController).kTextField.text = str;
        FindManager *mana = [FindManager defaulManager];
        mana.currentString = str;
        [selfWeak message];
    }];
    */
}
//#pragma mark代理
//- (void)addColletion:(FIndMessageTableViewCell *)cell
//{
//    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//    CGRect frame =[cell convertRect:cell.bounds toView:window];
//    
//    float y = frame.origin.y;
//    
//    AddCollectionView * uninterestedView = [[AddCollectionView alloc]init];
//    uninterestedView.delegate = self;
//    
//    weakObj(self);
//    uninterestedView.loginMethod = ^{
//        
//        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
//        nav.navigationBar.hidden = YES;
//        [selfWeak presentViewController:nav animated:YES completion:nil];
//        
//    };
//    
//    _moreViewCell = cell;
//    
//    if (y + 10 - 100 - 10 > kStatusHeight + 44) {
//        [uninterestedView showWithY:y + 10 - 100 object:cell.info];
//    }else {
//        [uninterestedView showWithY:y + 45 object:cell.info];
//    }
//    
//}
- (void)gotoFimeMessageSourceVC:(NSIndexPath *)index
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoFimeMessageSourceViewController" object:self.messageArr[index.row]];

}
- (void)deleteBTClick
{
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"messageArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    [temArr removeAllObjects];
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"messageArr"];
    [userdde synchronize];
    
    [self.histiryView removeFromSuperview];
    self.historyLable.hidden = YES;
    self.deleteBT.hidden = YES;
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)message{
    NSLog(@"消息");
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
        [HttpRequest get_RequestWithURL:SEARCH_MESSAGE URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"主题dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    [self.messageArr removeAllObjects];//移除
                    if(data.count>0){
                        for (int i = 0; i<data.count; i++) {
                            //                        FindMessageInfo *info = [[FindMessageInfo alloc]init];
                            //                        [info setValuesForKeysWithDictionary:data[i]];
                            //                        [self.messageArr addObject:info];
                            BListModel * model = [BListModel new];
                            [model setValuesForKeysWithDictionary:data[i]];
                            [self.messageArr addObject:[self handleModel:model]];
                            
                        }
                    }else{
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
- (BListModel *)handleModel:(BListModel *)model {
    
    CGFloat width = [model.topicname boundingRectWithSize:CGSizeMake(kWidth-100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    
    model.titleWidth = width;
    
    float ch = 0;
    float ph = 0;
    float vh = 0;
    
    model.des = [[model.des componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    
    if (![model.title isEqualToString:@""]) {
        if (![model.des isEqualToString:@""]) {
            model.content  = [@[model.title,model.des] componentsJoinedByString:@"\n"];
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
    
    if (model.contentHeight != 0) ch = model.contentHeight+10;
    
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
    
    
    if (model.imageHeight != 0) ph = model.imageHeight+10;
    
    //视频
    if ([model.video_url isEqualToString:@""]) {
        model.videoHeight = 0;
    }else {
        model.videoHeight = ceil((kWidth - 30)*9/16.);
    }
    
    if (model.videoHeight != 0) vh = model.videoHeight+10;
    
    //总
    model.totalHeight = ceil(60+ch+ph+vh+44+8);
    
    return model;
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
        [HttpRequest get_RequestWithURL:SEARCH_MESSAGE URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                MLog(@"主题dic==%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    NSArray *data = dic[@"data"];
                    if (data.count > 0) {
                        for (int i = 0; i<data.count; i++) {
//                            FindMessageInfo *info = [[FindMessageInfo alloc]init];
//                            [info setValuesForKeysWithDictionary:data[i]];
//                            [self.messageArr addObject:info];
                            BListModel * model = [BListModel new];
                            [model setValuesForKeysWithDictionary:data[i]];
                            [self.messageArr addObject:[self handleModel:model]];

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
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FIndMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//    cell.delegate = self;
//    cell.index = indexPath;
//    cell.info = self.messageArr[indexPath.row];
//
//    return cell;
    
    FindMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.delegate  = self;
    
    BListModel * model = self.messageArr[indexPath.row];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = app.overallParam[model.topicid];
    if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
    
    [cell loadDataWithModel:self.messageArr[indexPath.row]];
    
    weakObj(self);
    cell.reloadBlock = ^{
        [selfWeak.tableView reloadData];
    };
    
    return cell;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    id info = self.messageArr[indexPath.row];
//    float hei = [self.tableView cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[FIndMessageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
//    return hei;
    
    BListModel * model = [self.messageArr objectAtIndex:indexPath.row];
    return model.totalHeight;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(self.view.viewController).kTextField resignFirstResponder];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    FimeMessageSourceViewController *fin = [[FimeMessageSourceViewController alloc]init];
//    fin.model = self.messageArr[indexPath.row];
//    fin.rec_url = [self.messageArr[indexPath.row] rec_url];
//    fin.hidesBottomBarWhenPushed = YES;
//    [self.view.viewController.navigationController pushViewController:fin animated:YES];
    
    ScourceViewController * vc = [[ScourceViewController alloc]init];
    vc.ID = [self.messageArr[indexPath.row] ID];
    vc.model = self.messageArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.view.viewController.navigationController pushViewController:vc animated:YES];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [(self.view.viewController).kTextField resignFirstResponder];
}
- (void)moreMethod:(FindMessageCell *)cell {
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

- (void)commentMethod:(FindMessageCell *)cell {
    
    CommentViewController * vc = [[CommentViewController alloc]init];
    vc.ID = ((BListModel *)cell.model).ID;
    vc.bModel = (BListModel *)cell.model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.view.viewController.navigationController pushViewController:vc animated:YES];

}

- (void)shareMethod:(FindMessageCell *)cell {
    _shareModel = cell.model;
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
}
- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:_shareModel atIndex:index viewController:self.navigationController];
}

- (void)picMethod:(FindMessageCell *)cell atIndex:(int)index {
    
    if (cell.model.type.intValue == 3) {
        
        ScourceViewController * vc = [[ScourceViewController alloc]init];
        vc.model = cell.model;
        vc.ID = cell.model.ID;
//        vc.rec_url = [cell.model rec_url];
//        vc.source_site = [cell.model source_site];
        vc.hidesBottomBarWhenPushed = YES;
        [self.view.viewController.navigationController pushViewController:vc animated:YES];

    }else {
        
        [[UserActionReport shared]newsPost:cell.model.ID ext:cell.model.ext];
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIImageView * imageView = (UIImageView *)cell.imageViewArr[index];
        CGRect frame = [imageView convertRect:imageView.bounds toView:app.window];
        
        PicPreView * picView = [[PicPreView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [picView picArr:cell.model.picsArr atIndex:index fromRect:frame];
        [app.window addSubview:picView];
        
    }
    
}
//- (CGFloat)cellContentViewWith
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    // 适配ios7横屏
//    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
//        width = [UIScreen mainScreen].bounds.size.height;
//    }
//    return width;
//}

@end
