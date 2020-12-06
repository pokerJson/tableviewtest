//
//  ReAndLoViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ReAndLoViewController.h"
#import "PhoneView.h"

@interface ReAndLoViewController ()

@property(nonatomic, strong)UIImageView * bgImageView;
@property(nonatomic, strong)UIButton * closeButton;

@property(nonatomic, strong)UIButton * registerButton;
@property(nonatomic, strong)UIButton * loginButton;
@property(nonatomic, strong)UIView * arrowView;


@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)PhoneView * rPView;
@property(nonatomic, strong)PhoneView * lPView;

@end

@implementation ReAndLoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kStatusHeight+44+100)];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    //_bgImageView.image = UIImageNamed(@"illustration_login_background");
    [self.view addSubview:_bgImageView];
    
    _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, kStatusHeight, 44, 44)];
    [_closeButton setImage:[UIImage imageNamed:@"ic_navbar_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    
    _registerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth/2., 44)];
    _registerButton.selected = YES;
    _registerButton.titleLabel.font = UIFontBSys(20);
    _registerButton.titleEdgeInsets = UIEdgeInsetsMake(0, kWidth/4., 0, 0);
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    [_registerButton setTitleColor:RGBColor(0, 0, 0) forState:UIControlStateSelected];
    [_registerButton addTarget:self action:@selector(registerButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    
    _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2., kStatusHeight+44, kWidth/2., 44)];
    _loginButton.selected = NO;
    _loginButton.titleLabel.font = UIFontBSys(20);
    _loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kWidth/4.);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    [_loginButton setTitleColor:RGBColor(0, 0, 0) forState:UIControlStateSelected];
    [_loginButton addTarget:self action:@selector(loginButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    _arrowView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44+44, 10, 10)];
    _arrowView.backgroundColor = [UIColor whiteColor];
    _arrowView.transform = CGAffineTransformMakeRotation(M_PI/4);
    _arrowView.center = CGPointMake(kWidth/4., self.bgImageView.height);
    [self.view addSubview:_arrowView];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44+44, kWidth, kHeight-(kStatusHeight+44+44))];
    if (@available(iOS 11.0, *)) _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.width*2, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    _rPView = [[PhoneView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    _rPView.type = @"0";
    [_rPView loadDataWithModel:@[
                                 @{
                                     @"img":@"ic_login_wechat",
                                     @"name":@"微信",
                                     },/*
                                 @{
                                     @"img":@"ic_login_weibo",
                                     @"name":@"微博",
                                     },
                                 @{
                                     @"img":@"ic_login_qq",
                                     @"name":@"QQ",
                                     },*/
                                 ]];
    [_scrollView addSubview:_rPView];
    
    
    _lPView = [[PhoneView alloc]initWithFrame:CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height)];
    _lPView.type = @"1";
    [_lPView loadDataWithModel:@[
                                 @{
                                     @"img":@"ic_login_wechat",
                                     @"name":@"微信",
                                     },/*
                                 @{
                                     @"img":@"ic_login_weibo",
                                     @"name":@"微博",
                                     },
                                 @{
                                     @"img":@"ic_login_qq",
                                     @"name":@"QQ",
                                     },*/
                                 ]];
    [_scrollView addSubview:_lPView];
    
}

- (void)closeButtonMethod:(UIButton *)button {
    [_rPView resignResponder];
    [_lPView resignResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerButtonMethod:(UIButton *)button {
    [_rPView resignResponder];
    [_lPView resignResponder];
    
    _registerButton.selected = YES;
    _loginButton.selected = NO;
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowView.center = CGPointMake(kWidth/4., self.bgImageView.height);
    }];
    
}
- (void)loginButtonMethod:(UIButton *)button {
    [_rPView resignResponder];
    [_lPView resignResponder];
    
    _registerButton.selected = NO;
    _loginButton.selected = YES;
    [_scrollView setContentOffset:CGPointMake(_scrollView.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowView.center = CGPointMake(3*kWidth/4., self.bgImageView.height);
    }];
    
}



@end
