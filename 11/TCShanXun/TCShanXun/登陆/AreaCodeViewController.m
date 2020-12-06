//
//  AreaCodeViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "AreaCodeViewController.h"

@interface AreaCodeViewController ()

@end

@implementation AreaCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"选择国家/地区";
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
}


- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
