//
//  FindViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindViewController.h"
#import "LTScrollView-Swift.h"
#import "PagedView.h"
#import "FindSecondViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "FindTextFiled.h"
#import "ThemeSearchView.h"
#import "FindCategoryModel.h"
#import "FindManager.h"
#import "FimeMessageSourceViewController.h"
#import "ThemeVC.h"
#import "PersonViewController.h"
#import "TopicViewController.h"
#import "CommentViewController.h"
#import "BannerView.h"

//xxx
#import "HotHistoryWordsView.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface FindViewController ()<PagedViewDelegate,PagedViewDataSource,LTSimpleScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong)BannerView * bannerView;

//顶部推荐
@property (nonatomic,strong)NSMutableArray *topArr;
@property (nonatomic,strong)PagedView *pageView;

//
@property (nonatomic,strong)NSMutableArray *viewControllers;
@property (nonatomic,strong)NSMutableArray *titles;
@property (nonatomic,strong)NSMutableArray *findCategoryArr;//分类arr
@property (strong, nonatomic) LTLayout *layout;
@property (strong, nonatomic) LTSimpleManager *managerView;
//@property (strong, nonatomic) NSMutableArray *imageArray;
//
@property (strong, nonatomic) UIView *topView;
@property (nonatomic,strong) UIButton *backBT;

//searchview
@property (nonatomic,strong)ThemeSearchView *searchView;
@property (nonatomic,strong)HotHistoryWordsView *hotView;


//无网
@property(nonatomic, strong)DataTipsView * dataTipsView;


@end

@implementation FindViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//#pragma mark 顶部获取推荐
//    [self getTopData];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _searchView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataTheme" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataUser" object:nil];

}
- (void)cahngeTextFieldText:(NSNotification *)noti
{
    _searchTextFiled.text = noti.object;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.findCategoryArr = [[NSMutableArray alloc]init];
    self.titles = [[NSMutableArray alloc]init];
    self.topArr = [[NSMutableArray alloc]init];
    
    
    
    //1 topview
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusHeight, kScreenWidth, 44)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-30, 30)];
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.cornerRadius = 3.;
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.placeholder = @"搜你想搜的";
    searchTextField.backgroundColor = RGBColor(245, 245, 249);
    UIButton * tfView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    tfView.enabled = NO;
    [tfView setImage:UIImageResize(@"icon_search", 15, 15) forState:UIControlStateNormal];
    searchTextField.leftView = tfView;
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.topView addSubview:searchTextField];
    self.searchTextFiled = searchTextField;
    self.kTextField = self.searchTextFiled;
    
    self.backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBT.frame = CGRectMake(kScreenWidth-45, 3.5, 35, 35);
    [self.backBT setTitle:@"返回" forState:UIControlStateNormal];
    self.backBT.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.backBT addTarget:self action:@selector(backSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.backBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_topView addSubview:self.backBT];
    self.backBT.hidden = YES;


    
#pragma mark 分类获取
    [self getTopCatory];

#pragma mark 顶部获取推荐
    [self getTopData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityMethod:) name:kReachabilityChangedNotification object:nil];
    
    //无网
    _dataTipsView = [[DataTipsView alloc]initWithFrame:self.view.bounds];
    _dataTipsView.hidden = YES;
    weakObj(self);
    _dataTipsView.callBack = ^(NSDictionary *param) {
    };
    [self.view addSubview:_dataTipsView];
    if ([Reachability shared].reachable) {
        [self loadData];
    }else {
        [_dataTipsView loadDataWithModel:@{@"img":@"icon_nonetwork",
                                           @"label":@"啊哦,网络不太顺畅呦~",
                                           @"btn":@"重新加载",
                                           }];
        _dataTipsView.hidden = NO;
    }

}
- (void)reachabilityMethod:(NSNotification*)notification {
    if (self.topArr.count == 0 && [Reachability shared].reachable) {
        [self loadData];
    }
}
- (void)loadData
{
    [self getTopCatory];
    [self getTopData];

}
- (void)getTopData
{
    //顶部推荐
    weakObj(self);
    [HttpRequest get_RequestWithURL:TOP_TUIJIAN URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"分类==%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                [self.topArr removeAllObjects];
                for (int i = 0; i<data.count; i++) {
                    [self.topArr addObject:data[i]];
                }
//                [selfWeak.pageView reloadData];
                //填充数据
                [selfWeak.bannerView loadDataWithModel:self.topArr];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];

}
- (void)getTopCatory {
    //请求分类
    [HttpRequest get_RequestWithURL:CATEGORY_LIST_URL URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"分类==%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                NSArray *data = dic[@"data"];
                for (int i = 0; i<data.count; i++) {
                    FindCategoryModel *model = [[FindCategoryModel alloc]init];
                    [model setValuesForKeysWithDictionary:data[i]];
                    
                    [self.findCategoryArr addObject:model];
                    NSString *name = data[i][@"name"];
                    [self.titles addObject:name];
                }
                [self setupSubViews];
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
    }];
}
#pragma mark textfiled值变化
- (void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"textFieldDidChange.text==%@",textField.text);
    if (textField.text.length == 0) {
        [_searchView hid];
        [_searchView removeFromSuperview];
        _searchView = nil;
    }
    if (textField.markedTextRange == nil) {
        [self setuserdefault:textField.text];
        FindManager *mana = [FindManager defaulManager];
        mana.currentString = textField.text;
        if (_searchView.currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theme" object:nil];
        }else if(_searchView.currentPage == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
        }else if(_searchView.currentPage == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil];
            
        }
    }
}
- (void)creatDefault
{
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    if ([[userDe objectForKey:@"allArr"] count] == 0) {
        NSArray *allArr = [[NSArray alloc]init];
        [userDe setObject:allArr forKey:@"allArr"];
        [userDe synchronize];
        
    }
    if (![userDe objectForKey:@"themeArr"]) {
        NSArray *themeArr = [[NSArray alloc]init];
        [userDe setObject:themeArr forKey:@"themeArr"];
        [userDe synchronize];
    }
    if (![userDe objectForKey:@"messageArr"]) {
        NSArray *messageArr = [[NSArray alloc]init];
        [userDe setObject:messageArr forKey:@"messageArr"];
        [userDe synchronize];
    }

    if (![userDe objectForKey:@"userArr"]) {
        NSArray *userArr = [[NSArray alloc]init];
        [userDe setObject:userArr forKey:@"userArr"];
        [userDe synchronize];
    }

    
}
#pragma mark 返回点击
- (void)backSearch
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
    rootVC.hideBar = NO;

    self.searchTextFiled.text = @"";
    FindManager *mana = [FindManager defaulManager];
    mana.currentString = @"";

    [self.searchTextFiled resignFirstResponder];;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchTextFiled.frame = CGRectMake(15, 7, kScreenWidth-30, 30);
        self.backBT.frame = CGRectMake(kScreenWidth-45, 3.5, 35, 35);
        self.backBT.hidden = YES;
    }];
    [_searchView removeFromSuperview];
    _searchView = nil;
    [_hotView removeFromSuperview];
    _hotView = nil;
}
#pragma  mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //输入文字时 一直监听
    return YES;
}
#pragma mark 点击搜索框相应开始
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 准备开始输入  文本字段将成为第一响应者
    NSLog(@"2");
    weakObj(self);
    if (!_hotView) {
        _hotView = [[HotHistoryWordsView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kScreenWidth, kScreenHeight-kStatusHeight-44)];
        _hotView.keybordBlock = ^{
            [selfWeak.searchTextFiled resignFirstResponder];
        };
        _hotView.h_hBlock = ^(NSString * _Nonnull str) {
            NSLog(@"点击热词或者搜索历史的x词==%@",str);
            selfWeak.kTextField.text = str;
            [selfWeak.searchTextFiled resignFirstResponder];
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
//    if (!_searchView) {
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
        
//    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    NSLog(@"4");
    [UIView animateWithDuration:0.3 animations:^{
        self.searchTextFiled.frame = CGRectMake(15, 7, kScreenWidth-75, 30);
        self.backBT.frame = CGRectMake(kScreenWidth-55, 3.5, 35, 35);
        self.backBT.hidden = NO;
    }];
    
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    // 点击‘x’清除按钮时 调用
    NSLog(@"5");
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    NSLog(@"6");
    return YES;
}
#pragma mark 保存搜索历史呢
- (void)setuserdefault:(NSString *)text
{
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

////    if (_searchView.currentPage == 0) {
////        NSLog(@"综合搜索");
////        NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
////        NSArray *allArr = [userdde objectForKey:@"allArr"];
////        NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
////        if ([temArr containsObject:text]) {
////            [temArr removeObject:text];
////            [temArr addObject:text];
////        }else{
////            [temArr addObject:text];
////        }
////        NSArray *A = [NSArray arrayWithArray:temArr];
////        [userdde setObject:A forKey:@"allArr"];
////        [userdde synchronize];
////    }else
//        if (_searchView.currentPage == 1){
//        NSLog(@"主题搜索");
//        NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
//        NSArray *allArr = [userdde objectForKey:@"themeArr"];
//        NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
//        if ([temArr containsObject:text]) {
//            [temArr removeObject:text];
//            [temArr addObject:text];
//        }else{
//            [temArr addObject:text];
//        }
//        NSArray *A = [NSArray arrayWithArray:temArr];
//        [userdde setObject:A forKey:@"themeArr"];
//        [userdde synchronize];
//
//    }
//        else if (_searchView.currentPage == 0){
//            NSLog(@"消息搜索");
//            NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
//            NSArray *allArr = [userdde objectForKey:@"messageArr"];
//            NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
//            if ([temArr containsObject:text]) {
//                [temArr removeObject:text];
//                [temArr addObject:text];
//            }else{
//                [temArr addObject:text];
//            }
//            NSArray *A = [NSArray arrayWithArray:temArr];
//            [userdde setObject:A forKey:@"messageArr"];
//            [userdde synchronize];
//
//        }
//    else if (_searchView.currentPage == 2){
//        NSLog(@"用户搜索");
//        NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
//        NSArray *allArr = [userdde objectForKey:@"userArr"];
//        NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
//        if ([temArr containsObject:text]) {
//            [temArr removeObject:text];
//            [temArr addObject:text];
//        }else{
//            [temArr addObject:text];
//        }
//        NSArray *A = [NSArray arrayWithArray:temArr];
//        [userdde setObject:A forKey:@"userArr"];
//        [userdde synchronize];
//    }
}
#pragma mark 点击键盘上完成去搜搜
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 点击键盘的‘换行’会调用
    if (textField.text.length != 0) {
        [self.searchTextFiled resignFirstResponder];
        if (_searchView.hidden == YES || _searchView == nil) {
            [self showMangeViews];
        }
    }else{
        [self.searchTextFiled resignFirstResponder];
    }

    return YES;
}
-(void)setupSubViews {
    
    [self.view addSubview:self.managerView];
    NSLog(@"ss=%@",NSStringFromCGRect(_managerView.frame));

    __weak typeof(self) weakSelf = self;
    
    //配置headerView
    [self.managerView configHeaderView:^UIView * _Nullable{
        return [weakSelf setupHeaderView];
    }];
    
    //pageView点击事件
    [self.managerView didSelectIndexHandle:^(NSInteger index) {
        NSLog(@"点击了 -> %ld", index);
        FindSecondViewController * one = (FindSecondViewController *)[self.viewControllers objectAtIndex:index];
        FindCategoryModel *model = self.findCategoryArr[index];
        one.type = model.ID;
        [one viewScrollToAppear];
        //[one updataDataWithType:model.ID];
        one.refreshBlock = ^{
        };
    }];
    
    //控制器刷新事件
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getTopData];
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            FindSecondViewController *one = (FindSecondViewController *)[self.viewControllers objectAtIndex:index];
            FindCategoryModel * model = self.findCategoryArr[index];
            one.type = model.ID;
            [one updataDataWithType:model.ID];
            one.refreshBlock = ^{
                [strongScrollView.mj_header endRefreshing];
            };
            //无网
            if (![Reachability shared].reachable) {
                [KKHUD showMiddleWithErrorStatus:@"没有网络"];
                [strongScrollView.mj_header endRefreshing];
            }
  
        }];
    }];
    
}
#pragma mark headview
-(UIView *)setupHeaderView {
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (kWidth-30)*9/16.+20)];
    view2.backgroundColor = [UIColor whiteColor];
    
//    _pageView = [[PagedView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, (kWidth-30)*9/16.)];
//    _pageView.delegate = self;
//    _pageView.dataSource = self;
//    _pageView.minimumPageAlpha = 0.1;
//    _pageView.isCarousel = YES;
//    _pageView.orientation = PagedViewOrientationHorizontal;
//    _pageView.isOpenAutoScroll = YES;
//    [_pageView reloadData];
//    [view2 addSubview:_pageView];
    
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 180-5, kScreenWidth, 5)];
//    line.backgroundColor = RGBColor(234, 235, 237);
//    [view2 addSubview:line];
    
    weakObj(self);
    _bannerView = [[BannerView alloc]initWithFrame:view2.bounds];
    [self.bannerView loadDataWithModel:self.topArr];

    _bannerView.callBack = ^(NSDictionary *param) {
        NSLog(@"papa==%@",param[@"tag"]);
        int tag = [param[@"tag"] intValue];
        TopicViewController * vc = [[TopicViewController alloc]init];
        vc.topicID = [selfWeak.topArr[tag-1] objectForKey:@"topicid"];
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    
    [view2 addSubview:_bannerView];
    
    
    
    return view2;
    
}
#pragma mark PagedView Delegate 轮播图
- (CGSize)sizeForPageInFlowView:(PagedView *)flowView {
    return CGSizeMake(self.view.bounds.size.width - 30, (self.view.bounds.size.width - 30) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    ThemeVC *vc = [[ThemeVC alloc]init];
    vc.model = self.topArr[subIndex];
    vc.hidesBottomBarWhenPushed = YES;
    vc.iD = [self.topArr[subIndex] objectForKey:@"topicid"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//ViewController 滚动到了第%ld页
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedView *)flowView {
    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
    
}

#pragma mark PagedView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedView *)flowView {
    
    return self.topArr.count;
    
}

- (IndexBannerSubiew *)flowView:(PagedView *)flowView cellForPageAtIndex:(NSInteger)index{
    IndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[IndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 10;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    NSString *pic = [self.topArr[index] objectForKey:@"pic"];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:nil];
    return bannerView;
}
///
-(void)tapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture");
}
#pragma mark 滚动代理 没用
-(void)glt_scrollViewDidScroll:(UIScrollView *)scrollView {
}

-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34-49) : self.view.bounds.size.height - Y-49;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, kStatusHeight+44, self.view.bounds.size.width, kScreenHeight-kStatusHeight-kTabBarHeight-44) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        
    }
    return _managerView;
}


-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.bottomLineHeight = 2.;
        _layout.bottomLineCornerRadius = 1.0;
        _layout.titleViewBgColor = [UIColor whiteColor];
        _layout.titleSelectColor = RGBColor(33,33,33);
        _layout.bottomLineColor = RGBColor(32,132,254);
        _layout.scale = 1;
        _layout.titleColor = RGBColor(117,117,117);
        _layout.titleFont = UIFontSys(16);
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
    }
    return _layout;
}



-(NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSMutableArray *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"idx===%ld",idx);
        FindSecondViewController *second = [[FindSecondViewController alloc] init];
        second.refreshBlock = ^{
            
        };
        
        if (idx == 0) {
            FindCategoryModel *model = self.findCategoryArr[idx];
            second.type = model.ID;
            [second viewScrollToAppear];
        }
        
        [testVCS addObject:second];
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
