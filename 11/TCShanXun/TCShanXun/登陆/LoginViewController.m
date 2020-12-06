//
//  LoginViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)UILabel * titleLabel;

@property(nonatomic, strong)UIView * writeBgView0;
@property(nonatomic, strong)UIButton * areaCodeButton;
@property(nonatomic, strong)UITextField * phoneTf;

@property(nonatomic, strong)UIView * writeBgView1;
@property(nonatomic, strong)UITextField * codeTf;

@property(nonatomic, strong)UIButton * submitButton;


@property(nonatomic, strong)UIButton * forgetButton;

@end

@implementation LoginViewController

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
    _titleLabel.text = @"手机号密码登录";
    _titleLabel.textColor = RGBColor(34, 34, 34);
    _titleLabel.textAlignment = 1;
    _titleLabel.font = UIFontBSys(20);
    [self.view addSubview:_titleLabel];
    
    _writeBgView0 = [[UIView alloc]initWithFrame:CGRectMake(15, _titleLabel.bottom+20, kWidth-30, 50)];
    _writeBgView0.cornerRadius = 10.;
    _writeBgView0.borderColor = RGBColor(175, 175, 175);
    _writeBgView0.borderWidth = 0.4;
    [self.view addSubview:_writeBgView0];
    
    _areaCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 60, 50)];
    _areaCodeButton.titleLabel.font = UIFontBSys(15);
    [_areaCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    [_areaCodeButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
    [_areaCodeButton addTarget:self action:@selector(areaCodeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_writeBgView0 addSubview:_areaCodeButton];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(70, 10, 0.4, 30)];
    line.backgroundColor = RGBColor(175, 175, 175);
    [_writeBgView0 addSubview:line];
    
    
    _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, _writeBgView0.width-85, 50)];
    _phoneTf.delegate = self;
    _phoneTf.placeholder = @"输入手机号码";
    _phoneTf.font = UIFontSys(16);
    _phoneTf.keyboardType = UIKeyboardTypePhonePad;
    _phoneTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _phoneTf.autocorrectionType = UITextAutocorrectionTypeNo;
    _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _phoneTf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_phoneTf addTarget:self action:@selector(textFieldMethod:) forControlEvents:UIControlEventEditingChanged];
    [_writeBgView0 addSubview:_phoneTf];

    
    _writeBgView1 = [[UIView alloc]initWithFrame:CGRectMake(15, _writeBgView0.bottom+15, kWidth-30, 50)];
    _writeBgView1.cornerRadius = 10.;
    _writeBgView1.borderColor = RGBColor(175, 175, 175);
    _writeBgView1.borderWidth = 0.4;
    [self.view addSubview:_writeBgView1];
    
    
    _codeTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, _writeBgView1.width-30, 50)];
    _codeTf.delegate = self;
    _codeTf.placeholder = @"输入密码";
    _codeTf.font = UIFontSys(16);
    _codeTf.secureTextEntry = YES;
    _codeTf.keyboardType = UIKeyboardTypePhonePad;
    _codeTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeTf.autocorrectionType = UITextAutocorrectionTypeNo;
    _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeTf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_codeTf addTarget:self action:@selector(textFieldMethod:) forControlEvents:UIControlEventEditingChanged];
    [_writeBgView1 addSubview:_codeTf];
    
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _writeBgView1.bottom+20, kWidth-30, 50)];
    _submitButton.adjustsImageWhenHighlighted = NO;
    _submitButton.titleLabel.font = UIFontSys(18);
    _submitButton.enabled = NO;
    _submitButton.cornerRadius = 10.;
    [_submitButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    
    _forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(kWidth-150), _submitButton.bottom+20, 150, 20)];
    _forgetButton.adjustsImageWhenHighlighted = NO;
    _forgetButton.titleLabel.font = UIFontBSys(15);
    [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
    [_forgetButton addTarget:self action:@selector(forgetButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetButton];

}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldMethod:(UITextField *)tf {
    
    if (_phoneTf.text.length > 0 && _codeTf.text.length > 0) {
        _submitButton.enabled = YES;
    }else {
        _submitButton.enabled = NO;
    }
    
}

- (void)resignResponder {
    [_phoneTf resignFirstResponder];
    [_codeTf resignFirstResponder];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignResponder];
}

- (void)areaCodeButtonMethod:(UIButton *)button {
    
}

- (void)submitButtonMethod:(UIButton *)button {
    //phone 手机号
    //password 用户密码的md5值
    
    NSDictionary * param = @{
                             @"phone":_phoneTf.text,
                             @"password":[NSString MD5ForStr:_codeTf.text],
                             };
    
    [HttpRequest get_RequestWithURL:LOGIN_MIMA_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                [self resignResponder];
                
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic[@"data"] forKey:@"UserLoginInfo"];
                [userDefaults setBool:YES forKey:@"LOGIN"];
                [userDefaults synchronize];
                
                NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
                [shared setBool:YES forKey:@"LOGIN"];
                [shared setObject:dic[@"data"][@"uid"] forKey:@"uid"];
                [shared setObject:dic[@"data"][@"accessToken"] forKey:@"accessToken"];
                [shared synchronize];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];

                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }else {
            [KKHUD showMiddleWithStatus:@"登录失败"];
        }
        
    }];
    
    
    
}

- (void)forgetButtonMethod:(UIButton *)button {
    ForgetViewController * vc = [[ForgetViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
