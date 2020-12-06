//
//  SignatureViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SignatureViewController.h"
#import "PersonModel.h"

@interface SignatureViewController ()<UITextViewDelegate>

@property(nonatomic, strong)UITableView * tableView;

@property(nonatomic, strong)UIView * headerView;
@property(nonatomic, strong)UIView * bgView;

@property(nonatomic, strong)UITextView * textView;

@property(nonatomic, strong)UILabel * numLabel;

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"修改签名";
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
    [_textView resignFirstResponder];
    
    if (_textView.text.length > 50) {
        NSLog(@"大于50");
        return;
    }

    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"signature":_textView.text,
                             };
    
    
    [HttpRequest get_RequestWithURL:UPDATE_INFO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                self.model.signature = self.textView.text;
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
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120)];
    
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_bgView];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, kWidth - 40, 70)];
    _textView.textColor = RGBColor(100, 100, 100);
    _textView.text = _model.signature;
    _textView.delegate = self;
    _textView.scrollEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_textView];
    
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, _bgView.height-25, 40, 20)];
    _numLabel.text = [NSString stringWithFormat:@"%zd",50-_textView.text.length];
    _numLabel.textColor = RGBColor(175, 175, 175);
    _numLabel.textAlignment = 2;
    _numLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_numLabel];
    
    
    _tableView.tableHeaderView = _headerView;

    [_textView becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView {
    

    if ([_textView.text isEqualToString:_model.signature]) {
        self.navRightButton.enabled = NO;
    }else {
        self.navRightButton.enabled = YES;
    }

    if (_textView.text.length >= 50) {
        _numLabel.text = @"0";
    }else {
        _numLabel.text = [NSString stringWithFormat:@"%zd",50-_textView.text.length];
    }
    
}





@end
