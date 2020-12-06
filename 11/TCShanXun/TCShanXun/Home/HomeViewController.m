//
//  HomeViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "BListViewController.h"
#import "ScrollSwitch.h"
#import "ThemeSearchView.h"
#import "FindManager.h"
#import "HotHistoryWordsView.h"

@interface HomeViewController ()<UITextFieldDelegate,BListViewControllerDelegate>

@property(nonatomic, strong)ScrollSwitch * scrollSwitch;
@property(nonatomic, weak)UIViewController * currentVC;
@property(nonatomic, strong)UIView * searchBar;
@property(nonatomic, strong)UITextField * textF;
@property(nonatomic, strong)UIButton * backButton;
@property(nonatomic, strong)ThemeSearchView * searchView;

@property (nonatomic,strong)HotHistoryWordsView *hotView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _searchBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    
    _textF = [[UITextField alloc]initWithFrame:CGRectMake(15, 7, kWidth-30, 30)];
    _textF.backgroundColor = RGBColor(245, 245, 249);
    _textF.delegate = self;
    _textF.cornerRadius = 5;
    _textF.placeholder = @"搜你想搜的";
    _textF.font = UIFontSys(14);
    _textF.returnKeyType = UIReturnKeyDone;
    UIButton * tfView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    tfView.enabled = NO;
    [tfView setImage:UIImageResize(@"icon_search", 15, 15) forState:UIControlStateNormal];
    _textF.leftView = tfView;
    _textF.leftViewMode = UITextFieldViewModeAlways;
    _textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textF.autocorrectionType = UITextAutocorrectionTypeNo;
    _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textF.autocorrectionType = UITextAutocorrectionTypeNo;
    [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchBar addSubview:_textF];
    self.kTextField = _textF;
    
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth, 0, 55, 44)];
    _backButton.titleLabel.font = UIFontSys(18);
    _backButton.clipsToBounds = YES;
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBar addSubview:_backButton];
    
    

    _scrollSwitch = [[ScrollSwitch alloc]initWithFrame:self.view.bounds];
    _scrollSwitch.backgroundColor = RGBColor(247, 245, 247);
    _scrollSwitch.addonsView = _searchBar;
    [self.view addSubview:_scrollSwitch];
    
    NSArray * arr = @[
                      @"推荐",
                      @"资讯",
                      ];
    
    for (UIViewController * obj in self.childViewControllers) {
        [obj removeFromParentViewController];
    }
    
    for (NSString * obj in arr) {
        BListViewController * vc = [[BListViewController alloc]init];
        vc.title = obj;
        vc.delegate = self;
        vc.scrollSwitch = _scrollSwitch;
        [self addChildViewController:vc];
    }
    
    weakObj(self);
    [_scrollSwitch titleArr:arr loadViewBlock:^(UIScrollView *scrollView, NSInteger index) {
        NSLog(@"loadView: %zd",index);
        selfWeak.childViewControllers[index].view.frame = CGRectMake(scrollView.bounds.size.width*index+(scrollView.width-kWidth)/2., 0, kWidth, kHeight);
        [scrollView addSubview:selfWeak.childViewControllers[index].view];
        [(BListViewController *)selfWeak.childViewControllers[index] viewWillScrollToAppear];

    } currentIndexBlock:^(UIScrollView *scrollView, NSInteger index) {
        NSLog(@"currentIndex: %zd",index);
        
        MainTabBarController * tabBarVC = (MainTabBarController *)self.tabBarController;
        tabBarVC.delegateRefresh = selfWeak.childViewControllers[index];
        selfWeak.currentVC = selfWeak.childViewControllers[index];
        
    }];

    
}

- (void)viewController:(BListViewController *)vc offset:(float)offset interval:(float)interval{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (vc == self.currentVC ) {
            if (vc.tableView.contentOffset.y >-44 && vc.tableView.contentOffset.y < vc.tableView.contentSize.height-vc.tableView.height) {
                [self.scrollSwitch scrollOffset:offset interval:interval];
            }
        }
        
        for (BListViewController * obj in self.childViewControllers) {
            if (obj != self.currentVC) {
                if (obj.tableView) {
                    if (obj.tableView.contentOffset.y<=0 ) {
                        [obj.tableView setContentOffset:CGPointMake(0, -self.scrollSwitch.offset)];
                    }
                }
            }
        }
        
    }];
    
}



- (void)backButtonMethod:(UIButton *)button {
    
    _textF.text = @"";
    FindManager *mana = [FindManager defaulManager];
    mana.currentString = @"";
    
    [self.textF resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.textF.frame = CGRectMake(15, 7, kScreenWidth-30, 30);
        self.backButton.hidden = YES;
    }completion:^(BOOL finished) {
        self.backButton.frame = CGRectMake(kWidth, 0, 55, 44);
    }];
    [_searchView removeFromSuperview];
    _searchView = nil;
    [_hotView removeFromSuperview];
    _hotView = nil;

    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
    rootVC.hideBar = NO;
    
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
        if (_searchView.currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theme" object:nil];
        }else if(_searchView.currentPage == 0){
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
            [selfWeak.textF resignFirstResponder];
        };
        _hotView.h_hBlock = ^(NSString * _Nonnull str) {
            NSLog(@"点击热词或者搜索历史的x词==%@",str);
            selfWeak.kTextField.text = str;
            [selfWeak.textF resignFirstResponder];
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

    [UIView animateWithDuration:0.25 animations:^{
        self.textF.frame = CGRectMake(15, 7, kScreenWidth-85, 30);
        self.backButton.frame = CGRectMake(kScreenWidth-65, 0, 55, 44);
        self.backButton.hidden = NO;
    }];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 点击键盘的‘换行’会调用
    if (textField.text.length != 0) {
        [self.textF resignFirstResponder];
        if (_searchView.hidden == YES || _searchView == nil) {
            [self showMangeViews];
        }
    }else{
        [self.textF resignFirstResponder];
    }

    return YES;
}


@end
