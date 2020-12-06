//
//  PersonInfoViewController.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PersonInfoViewController.h"

#import "PersonInfoCell.h"

#import "PersonModel.h"

#import "ModifyIconController.h"
#import "NickViewController.h"
#import "GenderViewController.h"
#import "SignatureViewController.h"

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@end

@implementation PersonInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self loadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"编辑个人信息";
    self.navTitleLabel.font = UIFontBSys(18);
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];

    
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(247, 247, 247);
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomInsets, 0);
    
    [_tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:@"PersonInfoCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 9.6, kWidth, 0.4)];
    line.backgroundColor = RGBColor(170, 170, 170);
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
    
}

- (void)loadData {

    NSLog(@"%@",_model);
    
    NSString * sex = [_model.sex isEqualToString:@""] ? @"点击设置性别" :([_model.sex isEqualToString:@"1"]?@"男":@"女");

    NSArray * arr = @[
                      @[
                          @{
                              @"title":@"修改头像",
                              @"type":@"0",
                              @"icon":_model.icon,
                              @"content":@"",
                              @"height":@(80),
                              },
                          ],
                      @[
                          @{
                              @"title":@"昵称",
                              @"type":@"1",
                              @"icon":@"",
                              @"content":_model.nick,
                              @"height":@(50),
                              },
                          @{
                              @"title":@"性别",
                              @"type":@"1",
                              @"icon":@"",
                              @"content":sex,
                              @"height":@(50),
                              },
                          @{
                              @"title":@"签名",
                              @"type":@"1",
                              @"icon":@"",
                              @"content":_model.signature,
                              @"height":@(50),
                              },
                          ],
                      
        
                      ];
    
    [self.dataSource setArray:arr];
    
    [_tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        ModifyIconController * vc = [[ModifyIconController alloc]init];
        vc.type = @"1";
        vc.icon = _model.icon;
        vc.model = _model;
        [self.navigationController  pushViewController:vc animated:YES];
        
    }
    
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0: {
                NickViewController * vc = [NickViewController new];
                vc.model = _model;
                [self.navigationController  pushViewController:vc animated:YES];
            }
                break;
            case 1: {
                GenderViewController * vc = [GenderViewController new];
                vc.model = _model;
                [self.navigationController  pushViewController:vc animated:YES];
            }
                break;
            case 2: {
                SignatureViewController * vc = [SignatureViewController new];
                vc.model = _model;
                [self.navigationController  pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.section][indexPath.row][@"height"] floatValue];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footer = [[UIView alloc] init];
    
    UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    line0.backgroundColor = RGBColor(170, 170, 170);
    [footer addSubview:line0];
    
    if (section != self.dataSource.count-1) {
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9.6, kWidth, 0.4)];
        line1.backgroundColor = RGBColor(170, 170, 170);
        [footer addSubview:line1];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end
