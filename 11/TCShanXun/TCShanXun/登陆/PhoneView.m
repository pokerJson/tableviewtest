//
//  PhoneView.m
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PhoneView.h"
#import "AreaCodeViewController.h"
#import "CodeViewController.h"
#import "LoginViewController.h"
#import "PhoneBindViewController.h"


@interface PhoneView ()<UITextFieldDelegate,UMengShareDelegate>

@property(nonatomic, strong)UIView * writeBgView;
@property(nonatomic, strong)UIButton * areaCodeButton;
@property(nonatomic, strong)UITextField * phoneTf;
@property(nonatomic, strong)UIButton * codeButton;

@property(nonatomic, strong)UIButton * mimaButton;

@property(nonatomic, strong)UIView * spView0;
@property(nonatomic, strong)UIView * spView1;
@property(nonatomic, strong)UILabel * otherLabel;

@end

@implementation PhoneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addSubviews {
    
    _writeBgView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, sWidth-30, 50)];
    _writeBgView.cornerRadius = 10.;
    _writeBgView.borderColor = RGBColor(175, 175, 175);
    _writeBgView.borderWidth = 0.4;
    [self addSubview:_writeBgView];
    
    _areaCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 60, 50)];
    _areaCodeButton.titleLabel.font = UIFontBSys(15);
    [_areaCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    [_areaCodeButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
    [_areaCodeButton addTarget:self action:@selector(areaCodeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_writeBgView addSubview:_areaCodeButton];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(70, 10, 0.4, 30)];
    line.backgroundColor = RGBColor(175, 175, 175);
    [_writeBgView addSubview:line];
    
    _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, _writeBgView.width-85, 50)];
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
    [_writeBgView addSubview:_phoneTf];
    
    //UIImage * lan = [UIImage imageWithColor:RGBColor(60, 180, 245) imageSize:CGRectMake(0, 0, 5, 5)];
    _codeButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _writeBgView.bottom+15, sWidth-30, 50)];
    _codeButton.adjustsImageWhenHighlighted = NO;
    _codeButton.titleLabel.font = UIFontSys(18);
    _codeButton.enabled = NO;
    _codeButton.cornerRadius = 10.;
    [_codeButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(codeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeButton];
    
    
    _mimaButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(sWidth-150), _codeButton.bottom+20, 150, 20)];
    _mimaButton.hidden = YES;
    _mimaButton.adjustsImageWhenHighlighted = NO;
    _mimaButton.titleLabel.font = UIFontBSys(15);
    [_mimaButton setTitle:@"使用密码登录" forState:UIControlStateNormal];
    [_mimaButton setTitleColor:RGBColor(252, 84, 46) forState:UIControlStateNormal];
    [_mimaButton addTarget:self action:@selector(mimaButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mimaButton];
    
    _spView0 = [[UIView alloc]init];
    _spView0.backgroundColor = RGBColor(175, 175, 175);
    [self addSubview:_spView0];
    
    _spView1 = [[UIView alloc]init];
    _spView1.backgroundColor = RGBColor(175, 175, 175);
    [self addSubview:_spView1];
    
    _otherLabel = [[UILabel alloc]init];
    _otherLabel.text = @"其他账号登录";
    _otherLabel.textColor = RGBColor(175, 175, 175);
    _otherLabel.textAlignment = 1;
    _otherLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_otherLabel];
    
    
    self.type = @"0";
    
//    _otherLabel.hidden= YES;
//    _spView0.hidden= YES;
//    _spView1.hidden= YES;
    
}

- (void)setType:(NSString *)type {
    _type = type;
//    if ([_type isEqualToString:@"0"]) {
//        _mimaButton.hidden = YES;
//    }else {
//        _mimaButton.hidden = NO;
//    }
    
}


- (void)resignResponder {
    [_phoneTf resignFirstResponder];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignResponder];
}

- (void)areaCodeButtonMethod:(UIButton *)button {
    //AreaCodeViewController * vc = [AreaCodeViewController new];
    //[self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)codeButtonMethod:(UIButton *)button {
    [self resignResponder];
    
    if (![Reachability shared].reachable) {
        [KKHUD showMiddleWithErrorStatus:@"没有网络"];
        return;
    }
    
    if (_sendCodeMethod) _sendCodeMethod();
    
    CodeViewController * vc = [[CodeViewController alloc]init];
    vc.veriType = @"2";
    vc.phone = _phoneTf.text;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)mimaButtonMethod:(UIButton *)button {
    
    LoginViewController * vc = [[LoginViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


- (void)textFieldMethod:(UITextField *)tf {
    NSLog(@"textFieldMethod");
    if (_phoneTf.text.length > 0) {
        _codeButton.enabled = YES;
    }else {
        _codeButton.enabled = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _otherLabel.frame = CGRectMake((self.width-100)/2., sHeight-44-60-30, 100, 20);
    _spView0.frame = CGRectMake(40, _otherLabel.y+10, _otherLabel.x - 50, 0.4);
    _spView1.frame = CGRectMake(_otherLabel.right+10, _spView0.y, _spView0.width, 0.4);
    
}

- (void)loadDataWithModel:(NSArray *)model {
    //return;
    for (int i = 0; i < model.count; i++) {
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((sWidth - model.count*75 + 15)/2.+i*75, sHeight-44-60, 60, 60)];
        [button setImage:[UIImage imageNamed:model[i][@"img"]] forState:UIControlStateNormal];
        button.tag = 8888+i;
        [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    
}

- (void)buttonMethod:(UIButton *)button {
    
    UMengShare * um =  [UMengShare share];
    um.delegate = self;

    switch (button.tag-8888) {
        case 0:{
            [um authWithPlatform:UMSocialPlatformType_WechatSession];
        }
            break;
        case 1:{
            [um authWithPlatform:UMSocialPlatformType_Sina];
        }
            break;
        case 2:{
            [um authWithPlatform:UMSocialPlatformType_QQ];
        }
            break;
        case 3:{
            LoginViewController * vc = [LoginViewController new];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)umengShare:(UMengShare *)umShare authWithPlatform:(UMSocialPlatformType)platformType result:(id)result error:(NSError *)error {
    
    if (!error) {
        
        UMSocialUserInfoResponse * resp = result;
        NSLog(@"%@",resp);
        NSLog(@"uid:%@",resp.uid);
        NSLog(@"name:%@",resp.name);
        NSLog(@"gender:%@",resp.gender);
        NSLog(@"iconurl:%@",resp.iconurl);
        
        NSString * partner = @"other";
        
        if (platformType == UMSocialPlatformType_Sina) {
            partner = @"WEIBO";
        }else if (platformType == UMSocialPlatformType_WechatSession) {
            partner = @"WEIXIN";
        }else if (platformType == UMSocialPlatformType_QQ) {
            partner = @"QQ";
        }
        
        NSDictionary * gender = @{
                                  @"女":@0,
                                  @"男":@1,
                                  @"m":@0,
                                  @"f":@1,
                                  };
        
        NSDictionary * param = @{
                                 @"partner":partner,
                                 @"uid":resp.uid,
                                 @"name":resp.name,
                                 @"gender":gender[resp.gender],
                                 @"iconurl":resp.iconurl,
                                 };
        
        [HttpRequest get_RequestWithURL:LOGIN_PARTNER_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:dic[@"data"] forKey:@"UserLoginInfo"];
                    [userDefaults setBool:YES forKey:@"LOGIN"];
                    [userDefaults synchronize];
                    
                    
                    NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
                    [shared setBool:YES forKey:@"LOGIN"];
                    [shared setObject:dic[@"data"][@"uid"] forKey:@"uid"];
                    [shared setObject:dic[@"data"][@"accessToken"] forKey:@"accessToken"];
                    [shared synchronize];
                    
                    
                    if ([dic[@"data"][@"ifBindPhone"] intValue] == 1) {
                        [self.viewController.navigationController dismissViewControllerAnimated:YES completion:nil];

                    }else {
                        PhoneBindViewController * vc = [[PhoneBindViewController alloc]init];
                        vc.type = @"1";
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.viewController.navigationController pushViewController:vc animated:YES];
                    }
                    

                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }
    
}


@end
