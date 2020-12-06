//
//  AboutViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "AboutViewController.h"
#import "SetCell.h"
#import "LicenseViewController.h"
#import "ContactViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navTitleLabel.text = @"关于闪讯";
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];

    self.view.backgroundColor = RGBColor(245, 245, 245);
    
    [self createTableView];
    [self loadData];
    
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+44, kWidth, kHeight-(kStatusHeight+44)-kTabBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(245, 245, 245);
    
    [_tableView registerClass:[SetCell class] forCellReuseIdentifier:@"SetCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.tableFooterView = [UIView new];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 245)];
    
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHalf(kWidth-80), 50, 80, 80)];
    iconImageView.cornerRadius = 10;
    NSString * icon = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    iconImageView.image = [UIImage imageNamed:icon];
    [headerView addSubview:iconImageView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+30, kWidth, 20)];
    nameLabel.text = @"闪讯";
    nameLabel.textColor = RGBColor(131, 131, 131);
    nameLabel.textAlignment = 1;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:nameLabel];
    
    UILabel * verLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.bottom+20, kWidth, 20)];
    verLabel.text = [NSString stringWithFormat:@"版本号:%@",[SysInfo appBuildVersion]];
    verLabel.textColor = RGBColor(131, 131, 131);
    verLabel.textAlignment = 1;
    verLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:verLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.bottom-0.4, kWidth, 0.4)];
    line.backgroundColor = RGBColor(170, 170, 170);
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
}

- (void)loadData {
    
    [self.dataSource setArray:@[
                                @{
                                    @"img":@"",
                                    @"title":@"用户协议",
                                    @"controllor":@"0",
                                    @"type":@"1",
                                    },
                                @{
                                    @"img":@"",
                                    @"title":@"去评分",
                                    @"controllor":@"1",
                                    @"type":@"1",
                                    },
                                @{
                                    @"img":@"",
                                    @"title":@"联系我们",
                                    @"controllor":@"2",
                                    @"type":@"1",
                                    },
                                ]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * str = self.dataSource[indexPath.row][@"controllor"];
    
    switch (str.intValue) {
        case 0: {

            LicenseViewController * vc = [[LicenseViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1: {
            
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", KAPPID];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
            
        }
            break;
        case 2: {
            
            ContactViewController * vc = [[ContactViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



@end
