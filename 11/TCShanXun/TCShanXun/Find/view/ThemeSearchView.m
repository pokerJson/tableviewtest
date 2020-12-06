//
//  ThemeSearchView.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemeSearchView.h"
#import "CurrentFIndViewController.h"
#import "CurrentUserViewController.h"
#import "CurrentThemeViewController.h"
#import "CurrentMessageViewController.h"
#import "CYAX_SelectView.h"


@interface ThemeSearchView ()<CYAX_SelectViewDelegate,UIGestureRecognizerDelegate>

//存数据 放uiviewcontroller
//@property (nonatomic,strong)NSMutableArray *childControllers;

@property (nonatomic, strong) CYAX_SelectView *CYAX_SelectView;

@end

@implementation ThemeSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBColor(240, 240, 240);
        self.childControllers = [[NSMutableArray alloc]init];

        self.userInteractionEnabled = YES;
        [self creatUI];

        [self creatDefault];
        
    }
    return self;
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
#pragma mark 创建部分UI
- (void)creatUI
{
    [self addSubview:self.CYAX_SelectView];
    self.CYAX_SelectView.bgScrollView.bounces = NO;
    
    NSArray *vcARR = @[@"CurrentMessageViewController",@"CurrentThemeViewController",@"CurrentUserViewController"];
    [self creatChildViewControllersWithvcArr:vcARR];
    
}
- (void)creatChildViewControllersWithvcArr:(NSArray *)vcARR
{
    for (NSInteger i = 0; i < vcARR.count; i++) {
        NSString * className = [NSString stringWithFormat:@"%@",vcARR[i]];
        
        Class myClass = NSClassFromString(className);
        UIViewController * VC = [[myClass alloc]init];
        [self.childControllers addObject:VC];
        //  默认,加载第一个视图
        [self addSubViewWithCurrentPage:0];
        self.currentPage = 0;
    }
//    CurrentThemeViewController *theme = [[CurrentThemeViewController alloc]init];
//    theme.texf = self.textf;
//    [self.childControllers addObject:theme];
//    [self addSubViewWithCurrentPage:0];
//    self.currentPage = 0;
//    CurrentMessageViewController *theme2 = [[CurrentMessageViewController alloc]init];
//    theme2.texf = self.textf;
//    [self.childControllers addObject:theme2];
//    [self addSubViewWithCurrentPage:1];
//    CurrentUserViewController *theme22 = [[CurrentUserViewController alloc]init];
//    theme22.texf = self.textf;
//    [self.childControllers addObject:theme22];
//    [self addSubViewWithCurrentPage:2];

    
}
//  切换各个标签内容
-(void)addSubViewWithCurrentPage:(NSInteger)currentPage
{
    
    if (self.childControllers.count > currentPage) {
        UIView *currentView = [self.childControllers[currentPage] view];
        if (currentView.superview == nil) {
            CGFloat width = self.CYAX_SelectView.bgScrollView.bounds.size.width;
            CGFloat height = self.CYAX_SelectView.bgScrollView.bounds.size.height;
            
            currentView.frame = CGRectMake(width * currentPage, 0, width, height);
            [self.CYAX_SelectView.bgScrollView addSubview:currentView];
            
        }
    }
}
#pragma mark --CYAX_SelectViewdelegate
-(void)CYAX_SelectView:(CYAX_SelectView *)selectView moveTableView_or_CollectionVWithTag:(NSInteger)tag
{
    NSLog(@"按钮选择==%ld",self.currentPage);
    //  点击处于当前页面的按钮,直接跳出
    if (self.currentPage == tag) {
        return;
    }
    [self.CYAX_SelectView.bgScrollView setContentOffset:CGPointMake(tag * kScreenWidth, 0) animated:YES];
    
    [self addSubViewWithCurrentPage:tag];
    self.currentPage = tag;
    
    self.searchBlcok(tag);

}
//拖动CYAX_SelectView的代理
-(void)CYAX_SelectViewWhenbottomScrollVDidEndDecelerating
{
    self.currentPage = self.CYAX_SelectView.bgScrollView.contentOffset.x / self.CYAX_SelectView.bgScrollView.frame.size.width;
    //加载subView
    [self addSubViewWithCurrentPage:self.currentPage];
    //huidoa
    self.searchBlcok(self.currentPage);

    
}

-(CYAX_SelectView *)CYAX_SelectView
{
    if (!_CYAX_SelectView) {
        _CYAX_SelectView = [[CYAX_SelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        _CYAX_SelectView.delegate = self;
        NSArray *tabNameArrM = [NSArray array];
        tabNameArrM = @[@"消息",@"主题",@"用户"];
        [_CYAX_SelectView setTopStatusButtonWithTitles:tabNameArrM NormalColor:[UIColor colorWithRed:128/255.0 green:131/255.0 blue:135/255.0 alpha:1] SelectedColor:[UIColor colorWithRed:100/255.0 green:181/255.0 blue:245/255.0 alpha:1] LineColor:[UIColor colorWithRed:100/255.0 green:181/255.0 blue:245/255.0 alpha:1]];
    }
    return _CYAX_SelectView;
}
- (void)show {
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)hid {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
//        [self removeFromSuperview];

    }];
    
}




@end
