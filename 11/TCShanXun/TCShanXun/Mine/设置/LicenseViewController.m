//
//  LicenseViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "LicenseViewController.h"
#import <WebKit/WebKit.h>

@interface LicenseViewController ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic, strong)WKWebView * webView;

@end

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navTitleLabel.text = @"闪讯产品和服务许可协议";
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LICENSE_URL]]];
    [self.view addSubview:_webView];
    
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
