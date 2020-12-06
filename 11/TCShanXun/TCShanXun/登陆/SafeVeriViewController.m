//
//  SafeVeriViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/23.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SafeVeriViewController.h"
#import "CodeViewController.h"

@interface SafeVeriViewController ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;
@property(nonatomic, strong)UILabel * phoneLabel;
@property(nonatomic, strong)UIButton * codeButton;

@end

@implementation SafeVeriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.hidden = YES;
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    //[self.navLeftButton setImage:UIImageNamed(@"ic_navbar_close") forState:UIControlStateNormal];
    self.navShadowLine.hidden = YES;
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, 30)];
    _titleLabel.text = @"安全验证";
    _titleLabel.textColor = RGBColor(34, 34, 34);
    _titleLabel.textAlignment = 1;
    _titleLabel.font = UIFontBSys(20);
    [self.view addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _titleLabel.bottom+10, kWidth-30, 50)];
    _detailLabel.attributedText = [self attributed:@"为了保证你的账号安全,需要验证你的身份,验证成功后可以进行下一步操作" lineSpace:5];
    _detailLabel.textColor = RGBColor(141, 141, 141);
    _detailLabel.textAlignment = 1;
    _detailLabel.numberOfLines= 0;
    _detailLabel.font = UIFontSys(14);
    [self.view addSubview:_detailLabel];
    
    

    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _detailLabel.bottom+10, kWidth, 40)];
    _phoneLabel.text = [NSString stringWithFormat:@"+86 %@",_phone];
    _phoneLabel.textColor = RGBColor(34, 34, 34);
    _phoneLabel.textAlignment = 1;
    _phoneLabel.font = UIFontBSys(18);
    [self.view addSubview:_phoneLabel];
    
    
    _codeButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _phoneLabel.bottom+15, kWidth-30, 50)];
    _codeButton.adjustsImageWhenHighlighted = NO;
    _codeButton.titleLabel.font = UIFontSys(18);
    _codeButton.cornerRadius = 10.;
    [_codeButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(codeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    
    
}
- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)codeButtonMethod:(UIButton *)button {
    
    if (![Reachability shared].reachable) {
        [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        return;
    }
    
    CodeViewController * vc = [[CodeViewController alloc]init];
    vc.veriType = _veriType;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSAttributedString *)attributed:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return attributedString;
}

@end
