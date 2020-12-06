//
//  PasswordViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/23.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIView * writeBgView1;
@property(nonatomic, strong)UITextField * codeTf;

@property(nonatomic, strong)UIButton * submitButton;


@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navShadowLine.hidden = YES;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, 30)];
    _titleLabel.text = @"输入新密码";
    _titleLabel.textColor = RGBColor(34, 34, 34);
    _titleLabel.textAlignment = 1;
    _titleLabel.font = UIFontBSys(20);
    [self.view addSubview:_titleLabel];
    
    _writeBgView1 = [[UIView alloc]initWithFrame:CGRectMake(15, _titleLabel.bottom+30, kWidth-30, 50)];
    _writeBgView1.cornerRadius = 10.;
    _writeBgView1.borderColor = RGBColor(175, 175, 175);
    _writeBgView1.borderWidth = 0.4;
    [self.view addSubview:_writeBgView1];
    
    
    _codeTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, _writeBgView1.width-30, 50)];
    _codeTf.delegate = self;
    _codeTf.placeholder = @"输入密码(6-20位)";
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
    _submitButton.cornerRadius = 10.;
    [_submitButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [_submitButton setTitle:@"完成" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
}

- (void)textFieldMethod:(UITextField *)tf {
    if (_codeTf.text.length > 0) {
        _submitButton.enabled = YES;
    }else {
        _submitButton.enabled = NO;
    }
}

- (void)resignResponder {
    [_codeTf resignFirstResponder];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignResponder];
}

- (void)submitButtonMethod:(UIButton *)button {

    if (_codeTf.text.length < 6) {
        [KKHUD showMiddleWithStatus:@"密码位数太短"];
        return;
    }
    if (_codeTf.text.length >20) {
        [KKHUD showMiddleWithStatus:@"密码位数太长"];
        return;
    }
    
    if ([_type isEqualToString:@"0"]) {
    
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"sign":_sign,
                                 @"password":[NSString MD5ForStr:_codeTf.text],
                                 };
        
        [HttpRequest get_RequestWithURL:SET_PASSWORD_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    [KKHUD showMiddleWithStatus:@"修改成功"];
                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                    return ;
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
            if (![Reachability shared].reachable) {
                [KKHUD showMiddleWithErrorStatus:@"没有网络"];
            }else {
                [KKHUD showMiddleWithStatus:@"修改失败"];
            }
            
        }];
        
    }else if ([_type isEqualToString:@"1"]) {
       //忘记密码
        
        NSDictionary * param = @{
                                 @"phone":_phone,
                                 @"sign":_sign,
                                 @"password":[NSString MD5ForStr:_codeTf.text],
                                 };
        
        [HttpRequest get_RequestWithURL:SET_PASSWORD_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    [KKHUD showMiddleWithStatus:@"修改成功"];
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                    return ;
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
            
            if (![Reachability shared].reachable) {
                [KKHUD showMiddleWithErrorStatus:@"没有网络"];
            }else {
                [KKHUD showMiddleWithStatus:@"修改失败"];
            }
        }];
        
    }
    
    
    
}

@end
