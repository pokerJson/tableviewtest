//
//  GenderViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "GenderViewController.h"
#import "PersonModel.h"


@interface GenderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, strong)UIImageView * markImageView;

@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"选择性别";
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    self.navRightButton.hidden = YES;
    
    [self createTableView];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


- (void)createTableView {
    
    _markImageView = [[UIImageView alloc]init];
    _markImageView.image = UIImageNamed(@"ic_common_checkmark_blue");
    
    NSArray * arr = @[
                      @{
                          @"title":@"男",
                          @"type":@"1",
                          },
                      @{
                          @"title":@"女",
                          @"type":@"0",
                          },
                      
                      ];
    
    [self.dataSource setArray:arr];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(243, 243, 243);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = UIFontSys(15);
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    if ([_model.sex isEqualToString:self.dataSource[indexPath.row][@"type"]]) {
        _markImageView.frame = CGRectMake(kWidth-36, 14, 16, 16);
        [cell addSubview:_markImageView];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * sex = self.dataSource[indexPath.row][@"type"];
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             @"sex":sex,
                             };
    
    
    [HttpRequest get_RequestWithURL:UPDATE_INFO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                self.model.sex = sex;
                [cell addSubview:self.markImageView];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
    
}



@end
