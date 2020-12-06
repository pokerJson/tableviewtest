//
//  FollowViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowViewController.h"
#import "BListModel.h"
#import "BListCell.h"
#import "UninterestedView.h"

#import "ThemeSearchView.h"

#import "ShareView.h"

#import "CommentViewController.h"
#import "ScourceViewController.h"

#import "MainTabBarController.h"
#import "FavoriteView.h"


#import "FimeMessageSourceViewController.h"
#import "ThemeVC.h"
#import "FindManager.h"
#import "PersonViewController.h"

#import "FollowDefaultView.h"
#import "FollowUnfoldCell.h"

#import "HotHistoryWordsView.h"

@interface FollowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BListCellDelegate,FavoriteViewDelegate,ShareViewDelegate,MorePopViewDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)BOOL uninitialized;

@property(nonatomic, assign)int offset;

@property(nonatomic, strong)UIView * statusView;
@property(nonatomic, strong)UIView * navView;
@property(nonatomic, strong)UITextField * navTf;
@property(nonatomic, strong)UIButton * backButton;
@property(nonatomic, strong)ThemeSearchView * searchView;

@property(nonatomic, strong)BListCell * moreViewCell;
@property(nonatomic, strong)BListModel * shareModel;

@property(nonatomic, strong)FollowDefaultView * defaultView;

@property (nonatomic,strong)HotHistoryWordsView *hotView;


@end

@implementation FollowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![Reachability shared].reachable && self.dataSource.count != 0) return;
    
    if ([UserManager shared].isLogin) {
        [self loadFollowed];
    }else {
        self.defaultView.hidden = NO;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
    
    if (self.uninitialized) {
        if (self.dataSource.count == 0) {
            self.offset = 1;
            [self loadData];
        }else {
            [_tableView reloadData];
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)loadFollowed {
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"p":@1,
                             @"n":@20,
                             };
    [HttpRequest get_RequestWithURL:FOLLOW_TOPIC_LIST_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray * arr = dic[@"data"];
                if (arr.count != 0) {
                    self.defaultView.hidden = YES;
                }else {
                    self.defaultView.hidden = NO;
                }
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        self.defaultView.hidden = NO;
    }];
    
}


- (void)reachabilityMethod:(NSNotification*)notification {
    if ([Reachability shared].reachable) {
       
        if ([UserManager shared].isLogin) {
            [self loadFollowed];
        }else {
            self.defaultView.hidden = NO;
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
        }
        
        if (self.uninitialized) {
            if (self.dataSource.count == 0) {
                self.offset = 1;
                [self loadData];
            }else {
                [_tableView reloadData];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityMethod:) name:kReachabilityChangedNotification object:nil];
    
    [self createTableView];
    [self createDefaultView];
    [self createSearchView];
    [self loadData];
}

- (void)createDefaultView {
    
    _defaultView = [[FollowDefaultView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)-kTabBarHeight)];
    _defaultView.hidden = YES;
    weakObj(self);
    _defaultView.callBack = ^{
        [selfWeak.tableView setContentOffset:CGPointZero animated:YES];
        selfWeak.offset = 1;
        [selfWeak loadData];
        selfWeak.defaultView.hidden = YES;
    };
    [self.view addSubview:_defaultView];
    
}


- (void)createSearchView {
    
    //navBar
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kStatusHeight+44)];
    _navView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:_navView];
    
    _navTf = [[UITextField alloc]initWithFrame:CGRectMake(15, kStatusHeight+7, kWidth-30, 30)];
    _navTf.delegate = self;
    _navTf.cornerRadius = 3;
    _navTf.backgroundColor = RGBColor(245, 245, 249);
    _navTf.placeholder = @"搜你想搜的";
    _navTf.font = UIFontSys(14);
    _navTf.returnKeyType = UIReturnKeyDone;
    [_navTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIButton * tfView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    tfView.enabled = NO;
    [tfView setImage:UIImageResize(@"icon_search", 15, 15) forState:UIControlStateNormal];
    _navTf.leftView = tfView;
    _navTf.leftViewMode = UITextFieldViewModeAlways;
    _navTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _navTf.autocorrectionType = UITextAutocorrectionTypeNo;
    _navTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _navTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _navTf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_navView addSubview:_navTf];
    self.kTextField = _navTf;

    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, kStatusHeight+4.5, 35, 35)];
    _backButton.titleLabel.font = UIFontSys(15);
    _backButton.clipsToBounds = YES;
    _backButton.hidden = YES;
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backButton];
    
    
    _statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kStatusHeight)];
    _statusView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:_statusView];
    
}

- (void)backButtonMethod:(UIButton *)button {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
    rootVC.hideBar = NO;
    
    _navTf.text = @"";
    FindManager *mana = [FindManager defaulManager];
    mana.currentString = @"";
    
    [self.navTf resignFirstResponder];;
    [UIView animateWithDuration:0.3 animations:^{
        self.navTf.frame = CGRectMake(10, kStatusHeight+7, kScreenWidth-20, 30);
        self.backButton.frame = CGRectMake(kScreenWidth-45, kStatusHeight+4.5, 35, 35);
        self.backButton.hidden = YES;
    }];
    [_searchView removeFromSuperview];
    _searchView = nil;
    [_hotView removeFromSuperview];
    _hotView = nil;

}
#pragma mark textfiled值变化
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        [_searchView hid];
        [_searchView removeFromSuperview];
        _searchView = nil;
    }

    if (textField.markedTextRange == nil) {
        [self setuserdefault:textField.text];
        FindManager *mana = [FindManager defaulManager];
        mana.currentString = textField.text;
        if (_searchView.currentPage == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theme" object:nil];
        }else if(_searchView.currentPage == 1){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
        }else if(_searchView.currentPage == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil];
            
        }
    }
}
#pragma mark 保存搜索历史呢
- (void)setuserdefault:(NSString *)text {

    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"allArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    if ([temArr containsObject:text]) {
        [temArr removeObject:text];
        [temArr addObject:text];
    }else{
        [temArr addObject:text];
    }
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"allArr"];
    [userdde synchronize];
}

#pragma  mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //输入文字时 一直监听
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // 准备开始输入  文本字段将成为第一响应者
    NSLog(@"2");
    weakObj(self);
    if (!_hotView) {
        _hotView = [[HotHistoryWordsView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kScreenWidth, kScreenHeight-kStatusHeight-44)];
        _hotView.keybordBlock = ^{
            [selfWeak.navTf resignFirstResponder];
        };
        _hotView.h_hBlock = ^(NSString * _Nonnull str) {
            NSLog(@"点击热词或者搜索历史的x词==%@",str);
            selfWeak.kTextField.text = str;
            [selfWeak.navTf resignFirstResponder];
            FindManager *mana = [FindManager defaulManager];
            mana.currentString = str;
            //保存历史
            [selfWeak setuserdefault:str];
            //显示内容
            [selfWeak showMangeViews];
        };
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
        rootVC.hideBar = YES;
        
        [self.view addSubview:_hotView];
        _hotView.hidden = YES;
        [_hotView show];
    }
    
}
- (void)showMangeViews
{
    weakObj(self);
    _searchView = [[ThemeSearchView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kScreenWidth, kScreenHeight-kStatusHeight-44)];
    _searchView.searchBlcok = ^(NSInteger tag) {
        NSLog(@"searchview.tag == %ld",tag);
        if (selfWeak.searchView.currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theme" object:nil];
        }else if(selfWeak.searchView.currentPage == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
        }else if(selfWeak.searchView.currentPage == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil];
        }
    };
    if (_searchView.currentPage == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"theme" object:nil];
    }else if(_searchView.currentPage == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
    }else if(_searchView.currentPage == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil];
    }
    
    [self.view addSubview:_searchView];
    _searchView.hidden = YES;
    [_searchView show];
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    NSLog(@"4");
    [UIView animateWithDuration:0.3 animations:^{
        self.navTf.frame = CGRectMake(10, kStatusHeight+7, kScreenWidth-70, 30);
        self.backButton.frame = CGRectMake(kScreenWidth-55, kStatusHeight+4.5, 35, 35);
        self.backButton.hidden = NO;
    }];
    
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    // 点击‘x’清除按钮时 调用
    NSLog(@"5");
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    NSLog(@"6");
    return YES;
}
#pragma mark 点击键盘上完成去搜搜
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 点击键盘的‘换行’会调用
    if (textField.text.length != 0) {
        [self.navTf resignFirstResponder];
        if (_searchView.hidden == YES || _searchView == nil) {
            [self showMangeViews];
        }
    }else{
        [self.navTf resignFirstResponder];
    }

    return YES;
}


- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)-kTabBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.backgroundColor = RGBColor(245,245,245);
    [_tableView registerClass:[BListCell class] forCellReuseIdentifier:@"BListCell"];
    [_tableView registerClass:[FollowUnfoldCell class] forCellReuseIdentifier:@"FollowUnfoldCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    MJRefreshStateHeader * header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.offset = 1;
        [self loadData];
    }];
    _tableView.mj_header = header;
}
- (void)addFooterRefresh {
    MJNewsFooter * header = [MJNewsFooter footerWithRefreshingBlock:^{
        self.offset++;
        [self loadData];
    }];
    _tableView.mj_footer = header;
}

- (void)loadData {
    NSDictionary * param = nil;
    if ([UserManager shared].isLogin) {
        param = @{
                  @"userid":[UserManager shared].userInfo.uid,
                  @"token":[UserManager shared].userInfo.accessToken,
                  @"p":@(_offset),
                  @"n":@10,
                  };
    }
    
    [HttpRequest get_RequestWithURL:@"http://www.yzpai.cn/news/index/followV2" URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        self.uninitialized = YES;
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                NSArray * arr = dic[@"data"];
                
                if (!self.tableView.mj_footer.isRefreshing) {
                    [self.dataSource removeAllObjects];
                }
                
                for (int i = 0; i < arr.count; i++) {
                    NSMutableDictionary * mDic = @{}.mutableCopy;
                    NSMutableArray *  mArr = @[].mutableCopy;
                    
                    //NSArray * arrr = arr[i][@"articleList"];
                    
                    for (int j = 0; j < [arr[i][@"articleList"] count]; j++) {
                        BListModel * model = [BListModel new];
                        [model setValuesForKeysWithDictionary:arr[i][@"articleList"][j]];
                        model.dataType = @"1";
                        [mArr addObject:[self handleModel:model]];
                        if (mArr.count > 1) {
                            [mDic setObject:@"0" forKey:@"unfold"];
                        }else {
                            [mDic setObject:@"1" forKey:@"unfold"];
                        }
                        [mDic setObject:mArr forKey:@"data"];
                    }
                    [self.dataSource addObject:mDic];
                }
                
                NSLog(@"%@",self.dataSource);
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
                
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }
        
        if (self.tableView.mj_footer.isRefreshing) {
            self.offset--;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        
    }];
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
    id arr = [NSJSONSerialization JSONObjectWithData:[model.pic_urls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if ([arr isKindOfClass:[NSArray class]]) {
        model.picsArr = arr;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource[section][@"unfold"] isEqualToString:@"0"]) {
        return 2;
    }else {
        return [self.dataSource[section][@"data"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource[indexPath.section][@"unfold"] isEqualToString:@"0"]) {
        
        if (indexPath.row != 0) {
            
            FollowUnfoldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUnfoldCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell loadDataWithModel:(int)[self.dataSource[indexPath.section][@"data"] count]-1];
            
            return cell;

        }else {
          
            BListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BListCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.spe = YES;
            BListModel * model = self.dataSource[indexPath.section][@"data"][indexPath.row];
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString * if_guanzhu = app.overallParam[model.topicid];
            if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
            
            [cell loadDataWithModel:model];
            cell.delegate  = self;
            
            weakObj(self);
            cell.reloadBlock = ^{
                [selfWeak.tableView reloadData];
            };
            
            return cell;
            
        }
        
        
        
    }else {
      
        BListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.spe = NO;
        BListModel * model = self.dataSource[indexPath.section][@"data"][indexPath.row];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString * if_guanzhu = app.overallParam[model.topicid];
        if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
        
        [cell loadDataWithModel:model];
        cell.delegate  = self;
        
        weakObj(self);
        cell.reloadBlock = ^{
            [selfWeak.tableView reloadData];
        };
        
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.dataSource[indexPath.section][@"unfold"] isEqualToString:@"0"] && indexPath.row != 0) {
        [self.dataSource[indexPath.section] setObject:@"1" forKey:@"unfold"];
        [self.tableView reloadData];
    }else {
        ScourceViewController * vc = [[ScourceViewController alloc]init];
        vc.ID = [self.dataSource[indexPath.section][@"data"][indexPath.row] ID];
        vc.model = self.dataSource[indexPath.section][@"data"][indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource[indexPath.section][@"unfold"] isEqualToString:@"0"] && indexPath.row !=0) {
        return 50;
    }else {
        BListModel * model = [self.dataSource objectAtIndex:indexPath.section][@"data"][indexPath.row];
        return model.totalHeight;
    }
    
}


- (void)moreMethod:(BListCell *)cell {
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


- (void)commentMethod:(BListCell *)cell {
    CommentViewController * vc = [[CommentViewController alloc]init];
    vc.ID = cell.model.ID;
    vc.bModel = cell.model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)shareMethod:(BListCell *)cell {
    _shareModel = cell.model;
    ShareView * moreView = [[ShareView alloc]init];
    moreView.delegate = self;
    [moreView showWithShortcutOptions:nil object:nil];
    
}

- (void)shareViewSelectedAtIndex:(int)index {
    UMengShare * share = [UMengShare share];
    [share shareWithModel:_shareModel atIndex:index viewController:self.navigationController];
}

- (void)picMethod:(BListCell *)cell atIndex:(int)index {
    
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
