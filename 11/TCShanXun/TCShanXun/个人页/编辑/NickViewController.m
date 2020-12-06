//
//  NickViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "NickViewController.h"
#import "PersonModel.h"

@interface NickViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)UITableView * tableView;

@property(nonatomic, strong)UIView * headerView;
@property(nonatomic, strong)UIView * bgView;
@property(nonatomic, strong)UITextField * nameTf;
@property(nonatomic, strong)UILabel * tipsLabel;

@end

@implementation NickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"修改昵称";
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    [self.navRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:RGBColor(34, 34, 34) forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:RGBColor(150, 150, 150) forState:UIControlStateDisabled];
    self.navRightButton.titleLabel.font = UIFontSys(16);
    self.navRightButton.enabled = NO;
    
    
    [self createTableView];
    [self createHeaderView];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)navRightMethod:(UIButton *)button {
    [_nameTf resignFirstResponder];
    
//    userid 用户id
//    token accessToken
//    nick 昵称
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"nick":_nameTf.text,
                             };
    
    
    [HttpRequest get_RequestWithURL:UPDATE_NICK_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                self.model.nick = self.nameTf.text;
                [UserManager shared].userInfo.nick = self.nameTf.text;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
    
}



- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(243, 243, 243);
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

}

- (void)createHeaderView {
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 44)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_bgView];
    
    _nameTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kWidth-30, 44)];
    _nameTf.delegate = self;
    _nameTf.text = _model.nick;
    _nameTf.font = UIFontSys(14);
    _nameTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameTf.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameTf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_nameTf addTarget:self action:@selector(tfMethod:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_nameTf];
    
    _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _bgView.bottom, kWidth-30, 30)];
    _tipsLabel.text = @"4-24个字,一个月只能修改一次";
    _tipsLabel.textColor = RGBColor(100, 100, 100);
    _tipsLabel.textAlignment = 0;
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    [_headerView addSubview:_tipsLabel];
    
    _tableView.tableHeaderView = _headerView;
    
    [_nameTf becomeFirstResponder];
}

- (void)tfMethod:(UITextField *)tf {
    if ([tf.text isEqualToString:_model.nick]) {
        self.navRightButton.enabled = NO;
    }else {
        self.navRightButton.enabled = YES;
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    [_nameTf resignFirstResponder];
}



@end
