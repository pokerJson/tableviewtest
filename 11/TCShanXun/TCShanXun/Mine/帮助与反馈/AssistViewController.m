//
//  AssistViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "AssistViewController.h"

@interface AssistViewController ()<UITextFieldDelegate,TTableViewDelegate>

@property(nonatomic, strong)TTableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, strong)UITextView * textView;
@property(nonatomic, strong)UITextField * textField;


@end

@implementation AssistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navTitleLabel.text = @"意见反馈";
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self createTableView];
}
- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardFrameDidChange:(NSNotification*)notice {
    NSDictionary * userInfo = notice.userInfo;
    NSValue * endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameValue.CGRectValue;
    
    _tableView.frame = CGRectMake(0, kStatusHeight + 44, kWidth, endFrame.origin.y - (kStatusHeight + 44));
    [self.view setNeedsLayout];
}


- (void)createTableView {
    
    _tableView = [[TTableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(245, 245, 245);
    _tableView.touchDelegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIView * topInset = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    topInset.backgroundColor = RGBColor(245, 245, 245);
    [headerView addSubview:topInset];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, topInset.bottom+10, kWidth-30, 20)];
    titleLabel.text = @"请详细填写你的建议和感想:";
    titleLabel.textColor = RGBColor(150, 150, 150);
    titleLabel.textAlignment = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, titleLabel.bottom+10, kWidth-30, 150)];
    _textView.backgroundColor = RGBColor(245, 245, 245);
    _textView.cornerRadius = 5;
    _textView.placeholder = @"";
    _textView.font = UIFontSys(15);
    [headerView addSubview:_textView];
    
    
    UILabel * contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _textView.bottom+20, kWidth-30, 20)];
    contactLabel.text = @"您的联系方式:";
    contactLabel.textColor = RGBColor(150, 150, 150);
    contactLabel.textAlignment = 0;
    contactLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:contactLabel];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, contactLabel.bottom+10, kWidth-30, 50)];
    _textField.backgroundColor = RGBColor(245, 245, 245);
    _textField.cornerRadius = 5;
    _textField.delegate = self;
    _textField.placeholder = @"QQ/邮箱/手机";
    _textField.font = UIFontSys(15);
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 50)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [headerView addSubview:_textField];
    
    UIButton * submitButton = [[UIButton alloc]initWithFrame:CGRectMake(50, _textField.bottom+30, kWidth-100, 44)];
    submitButton.cornerRadius = 22;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitButton setBackgroundImage:UIImageNamed(@"btn_login_normal") forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:submitButton];

    headerView.frame = CGRectMake(0, 0, kWidth, submitButton.bottom+40);
    _tableView.tableHeaderView = headerView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resignResponder];
}

- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignResponder];
}

- (void)resignResponder {
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

- (void)submitButtonMethod:(UIButton *)button {
    
    [self resignResponder];
    
    //contact 联系方式 手机邮箱qq等
    //content 详细反馈信息
    
    if (_textView.text == nil || _textView.text.length == 0) {
        [KKHUD showMiddleWithStatus:@"信息不完整"];
        return;
    }
    
    if (_textField.text == nil || _textField.text.length == 0) {
        [KKHUD showMiddleWithStatus:@"信息不完整"];
        return;
    }
    
    NSDictionary * param = @{
                             @"content":_textView.text,
                             @"contact":_textField.text,
                             };
    
    [HttpRequest get_RequestWithURL:USER_FEEDBACK_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
            
                
                self.textView.text = nil;
                self.textField.text = nil;
                
                [KKHUD showMiddleWithStatus:@"提交成功"];
                
                return ;
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
        [KKHUD showMiddleWithStatus:@"提交失败"];
    }];
    
    

    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



@end
