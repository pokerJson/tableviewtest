//
//  PhoneBindViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/22.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PhoneBindViewController.h"

@interface PhoneBindViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * detailLabel;


@property(nonatomic, strong)UIView * writeBgView0;
@property(nonatomic, strong)UIButton * areaCodeButton;
@property(nonatomic, strong)UITextField * phoneTf;
@property(nonatomic, strong)UIButton * codeButton;

@property(nonatomic, strong)UIView * writeBgView1;
@property(nonatomic, strong)UITextField * codeTf;

@property(nonatomic, strong)UIButton * submitButton;

@property(nonatomic, strong)NSTimer * countTimer;
@property(nonatomic, assign)int timeCount;

@end

@implementation PhoneBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.hidden = YES;
    self.navTitleLabel.font = UIFontBSys(18);
    self.navShadowLine.hidden = YES;
    [self.navRightButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = UIFontSys(15);
    
    
    if ([_type isEqualToString:@"0"]) {
        [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
        [self.navRightButton setTitle:nil forState:UIControlStateNormal];
        self.navLeftButton.hidden = NO;
        self.navRightButton.hidden = YES;
    }else {
        [self.navLeftButton setImage:nil forState:UIControlStateNormal];
        [self.navRightButton setTitle:@"跳过" forState:UIControlStateNormal];
        self.navLeftButton.hidden = YES;
        self.navRightButton.hidden = NO;
    }
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, 30)];
    _titleLabel.text = @"绑定手机";
    _titleLabel.textColor = RGBColor(34, 34, 34);
    _titleLabel.textAlignment = 1;
    _titleLabel.font = UIFontBSys(20);
    [self.view addSubview:_titleLabel];
    
    _writeBgView0 = [[UIView alloc]initWithFrame:CGRectMake(15, _titleLabel.bottom+30, kWidth-30, 50)];
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
    
    _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, _writeBgView0.width-175, 50)];
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
    
    _codeButton = [[UIButton alloc]initWithFrame:CGRectMake(_writeBgView0.width-90, 2, 80, 46)];
    _codeButton.contentHorizontalAlignment = 2;
    _codeButton.adjustsImageWhenHighlighted = NO;
    _codeButton.titleLabel.font = UIFontSys(14);
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:RGBColor(180, 180, 180) forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(codeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_writeBgView0 addSubview:_codeButton];
    
    
    _writeBgView1 = [[UIView alloc]initWithFrame:CGRectMake(15, _writeBgView0.bottom+15, kWidth-30, 50)];
    _writeBgView1.cornerRadius = 10.;
    _writeBgView1.borderColor = RGBColor(175, 175, 175);
    _writeBgView1.borderWidth = 0.4;
    [self.view addSubview:_writeBgView1];
    
    
    _codeTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, _writeBgView1.width-30, 50)];
    _codeTf.delegate = self;
    _codeTf.placeholder = @"输入验证码";
    _codeTf.font = UIFontSys(16);
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
    
    
    _countTimer = [MSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    _countTimer.fireDate = [NSDate distantFuture];
    _timeCount = 60;
    
}


- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navRightMethod:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (void)codeButtonMethod:(UIButton *)button {
    
    if (_phoneTf.text == nil || _phoneTf.text.length ==0) {
        [KKHUD showMiddleWithStatus:@"请输入手机号"];
        return;
    }
    
    NSString * timeStamp = [NSString stringWithFormat:@"%lu",time(0)];
    NSString * tmpCode = @"4c06f52227dbb6a19b4dc4d08ceb3c24";
    NSString * md5Str =  [NSString MD5ForStr:[NSString stringWithFormat:@"%@%@%@",_phoneTf.text,timeStamp,tmpCode]];
    NSDictionary *dict = @{
                           @"phone":_phoneTf.text,
                           @"time":timeStamp,
                           @"code":md5Str,
                           };
    
    [HttpRequest get_RequestWithURL:SMSCODE_URL URLParam:dict returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            MLog(@"发送验证码: %@",dic);
            if ([dic[@"code"] intValue] == 200) {
                
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

    }];
    
    
}

- (void)timerMethod:(NSTimer *)timer {
    _timeCount--;
    if (_timeCount) {
        NSString * str = [NSString stringWithFormat:@"%dS",_timeCount];
        _codeButton.enabled = NO;
        [_codeButton setTitle:str forState:UIControlStateNormal];
    }else {
        timer.fireDate = [NSDate distantFuture];
        _timeCount = 60;
        _codeButton.enabled = YES;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)submitButtonMethod:(UIButton *)button {

    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"phone":_phoneTf.text,
                             @"code":_codeTf.text,
                             };
    
    [HttpRequest get_RequestWithURL:USER_BINDPHONE_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200 ) {
                
                self.phoneTf.text = nil;
                self.codeTf.text = nil;
                [self resignResponder];
                [UserManager shared].userInfo.ifBindPhone = @"1";
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }else {
                [KKHUD showMiddleWithStatus:dic[@"msg"]];
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        
        if (![Reachability shared].reachable) {
            [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        }else {
            [KKHUD showMiddleWithStatus:@"绑定失败"];
        }
        
    }];
    
}







@end
