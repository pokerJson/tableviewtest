//
//  CodeViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CodeViewController.h"
#import "ModiPhoneViewController.h"
#import "PasswordViewController.h"

@interface CodeViewController ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;

@property(nonatomic, strong)UITextField * codeTf;
@property(nonatomic, strong)UIButton * veriButton;
@property(nonatomic, strong)UIButton * reSendButton;

@property(nonatomic, strong)NSTimer * countTimer;
@property(nonatomic, assign)int timeCount;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor clearColor];
    self.navTitleLabel.hidden = YES;
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    self.navRightButton.hidden = YES;
    self.navShadowLine.hidden = YES;
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, 30)];
    _titleLabel.text = @"输入验证码";
    _titleLabel.textColor = RGBColor(34, 34, 34);
    _titleLabel.textAlignment = 1;
    _titleLabel.font = UIFontBSys(20);
    [self.view addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom, kWidth, 30)];
    _detailLabel.textColor = RGBColor(200, 200, 200);
    _detailLabel.textAlignment = 1;
    _detailLabel.font = UIFontBSys(14);
    [self.view addSubview:_detailLabel];

    
    _codeTf = [[UITextField alloc]initWithFrame:CGRectMake(15, _detailLabel.bottom+10, kWidth-30, 50)];
    _codeTf.cornerRadius = 10.;
    _codeTf.borderColor = RGBColor(175, 175, 175);
    _codeTf.borderWidth = 0.4;
    _codeTf.placeholder = @"输入验证码";
    _codeTf.font = UIFontSys(16);
    _codeTf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 50)];
    _codeTf.leftViewMode = UITextFieldViewModeAlways;
    _codeTf.keyboardType = UIKeyboardTypePhonePad;
    _codeTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeTf.autocorrectionType = UITextAutocorrectionTypeNo;
    _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeTf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_codeTf addTarget:self action:@selector(textFieldMethod:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeTf];
    
    _veriButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _codeTf.bottom+15, kWidth-30, 50)];
    _veriButton.adjustsImageWhenHighlighted = NO;
    _veriButton.titleLabel.font = UIFontSys(18);
    _veriButton.enabled = NO;
    _veriButton.cornerRadius = 10.;
    [_veriButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [_veriButton setTitle:@"验证" forState:UIControlStateNormal];
    [_veriButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_veriButton addTarget:self action:@selector(veriButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_veriButton];
    

    _reSendButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _veriButton.bottom+20, kWidth-30, 25)];
    _reSendButton.adjustsImageWhenHighlighted = NO;
    _reSendButton.titleLabel.font = UIFontSys(14);
    _reSendButton.enabled = YES;
    [_reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [_reSendButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
    [_reSendButton addTarget:self action:@selector(reSendButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reSendButton];
    
    
    _countTimer = [MSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    _countTimer.fireDate = [NSDate distantFuture];
    _timeCount = 60;
    
    if ([_veriType isEqualToString:@"0"]) {
        [self sendVeriPhoneCode];
    }else if ([_veriType isEqualToString:@"1"]) {
        [self sendVeriMimaCode];
    }else if ([_veriType isEqualToString:@"2"]) {
        [self sendPhoneCode];
    }
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)textFieldMethod:(UITextField *)tf {

    if (_codeTf.text.length > 0) {
        _veriButton.enabled = YES;
    }else {
        _veriButton.enabled = NO;
    }
}

- (void)veriButtonMethod:(UIButton *)button {
    [self resignResponder];

    if ([_veriType isEqualToString:@"0"]) {
        //修改手机的
        NSDictionary * dic = @{
                               @"userid":[UserManager shared].userInfo.uid,
                               @"token":[UserManager shared].userInfo.accessToken,
                               @"code":_codeTf.text,
                               };
        
        [HttpRequest get_RequestWithURL:CHARGE_PHONE_2 URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                    
                    ModiPhoneViewController * vc = [[ModiPhoneViewController alloc]init];
                    vc.sign = dic[@"data"][@"sign"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    self.codeTf.text = nil;
                    [self resignResponder];
                }else {
                    
                    [KKHUD showMiddleWithStatus:dic[@"msg"]];
                    
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }else if ([_veriType isEqualToString:@"1"]) {
        
        //修改密码的
        NSDictionary * dic = @{
                               @"userid":[UserManager shared].userInfo.uid,
                               @"token":[UserManager shared].userInfo.accessToken,
                               @"code":_codeTf.text,
                               };
        
        [HttpRequest get_RequestWithURL:MODIMIMA_VERI_URL URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                    
                    PasswordViewController * vc = [[PasswordViewController alloc]init];
                    vc.type = @"0";
                    vc.sign = dic[@"data"][@"sign"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    self.codeTf.text = nil;
                    [self resignResponder];
                }else {
                    [KKHUD showMiddleWithStatus:dic[@"msg"]];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
        
    }else if ([_veriType isEqualToString:@"2"])  {
        NSLog(@"登录");
        NSDictionary * dic = @{
                               @"phone":_phone,
                               @"code":_codeTf.text,
                               };
        
        [HttpRequest get_RequestWithURL:LOGIN_CODE_URL URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                    
                    
                    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setValue:dic[@"data"] forKey:@"UserLoginInfo"];
                    [userDefaults setBool:YES forKey:@"LOGIN"];
                    [userDefaults synchronize];
                    
                    NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
                    [shared setBool:YES forKey:@"LOGIN"];
                    [shared setObject:dic[@"data"][@"uid"] forKey:@"uid"];
                    [shared setObject:dic[@"data"][@"accessToken"] forKey:@"accessToken"];
                    [shared synchronize];
                    
                    
                    self.codeTf.text = nil;
                    [self resignResponder];
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                }else {
                    [KKHUD showMiddleWithStatus:dic[@"msg"]];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
    }
    
}

- (void)reSendButtonMethod:(UIButton *)button {
    button.enabled = NO;
    
    if ([_veriType isEqualToString:@"0"]) {
        [self sendVeriPhoneCode];
    }else if ([_veriType isEqualToString:@"1"]) {
        [self sendVeriMimaCode];
    }else if ([_veriType isEqualToString:@"2"]) {
        [self sendPhoneCode];
    }
}

- (void)sendVeriMimaCode {
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             };
    [HttpRequest get_RequestWithURL:MODIMIMA_SENDCODE_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                
                self.detailLabel.text = [NSString stringWithFormat:@"验证码已发送"];
                self.countTimer.fireDate = [NSDate distantPast];
                
                return ;
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }else {
            [KKHUD showMiddleWithStatus:@"发送失败"];
        }
        self.detailLabel.text = [NSString stringWithFormat:@"验证码发送失败"];
        self.timeCount = 60;
        self.reSendButton.enabled = YES;
        [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.reSendButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
        
    }];
    
    
}


- (void)sendVeriPhoneCode {

    if (![Reachability shared].reachable) {
        [KKHUD showMiddleWithErrorStatus:@"没有网络"];
    }
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             };
    [HttpRequest get_RequestWithURL:CHARGE_PHONE_1 URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                
                self.detailLabel.text = [NSString stringWithFormat:@"验证码已发送"];
                self.countTimer.fireDate = [NSDate distantPast];
                
                return ;

            }
        }else {

            MLog(@"%@",error.localizedDescription);
        }
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }else {
            [KKHUD showMiddleWithStatus:@"发送失败"];
        }

        self.detailLabel.text = [NSString stringWithFormat:@"验证码发送失败"];
        self.timeCount = 60;
        self.reSendButton.enabled = YES;
        [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.reSendButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
        
    }];
    
}


- (void)sendPhoneCode {
    
    if ([_phone isEqualToString:@"13812345678"]) return;
    
    NSString * timeStamp = [NSString stringWithFormat:@"%lu",time(0)];
    NSString * tmpCode = @"4c06f52227dbb6a19b4dc4d08ceb3c24";
    NSString * md5Str =  [NSString MD5ForStr:[NSString stringWithFormat:@"%@%@%@",_phone,timeStamp,tmpCode]];
    NSDictionary *dict = @{
                           @"phone":_phone,
                           @"time":timeStamp,
                           @"code":md5Str,
                           };
    
    [HttpRequest get_RequestWithURL:SMSCODE_URL URLParam:dict returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"发送验证码: %@",dic);
            if ([dic[@"code"] intValue] == 200) {
                
                self.detailLabel.text = [NSString stringWithFormat:@"验证码已发送至+86 %@",self.phone];
                self.countTimer.fireDate = [NSDate distantPast];
                return ;
            }
        }else {

            MLog(@"%@",error.localizedDescription);
        }
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }else {
            [KKHUD showMiddleWithStatus:@"发送失败"];
        }
        self.detailLabel.text = [NSString stringWithFormat:@"验证码发送失败"];
        self.timeCount = 60;
        self.reSendButton.enabled = YES;
        [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.reSendButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
        
    }];
}

- (void)timerMethod:(NSTimer *)timer {
    _timeCount--;
    if (_timeCount) {
        NSString * str = [NSString stringWithFormat:@"没有收到验证码?%ds之后可重新发送",_timeCount];
        _reSendButton.enabled = NO;
        [_reSendButton setTitle:str forState:UIControlStateNormal];
        [_reSendButton setTitleColor:RGBColor(205, 205, 205) forState:UIControlStateNormal];
    }else {
        timer.fireDate = [NSDate distantFuture];
        _timeCount = 60;
        _reSendButton.enabled = YES;
        [_reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_reSendButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
        
    }
}



- (void)resignResponder {
    [_codeTf resignFirstResponder];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignResponder];
}

- (void)dealloc {
    if ([_countTimer isValid]) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



@end
