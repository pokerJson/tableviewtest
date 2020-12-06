//
//  BindViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/22.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BindViewController.h"
#import "BindCell.h"
#import "PhoneBindViewController.h"
#import "SafeVeriViewController.h"

@interface BindViewController ()<UITableViewDelegate,UITableViewDataSource,UMengShareDelegate,UIAlertViewDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@end

@implementation BindViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navTitleLabel.text = @"账号与绑定";
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBColor(245, 245, 245);
    
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom, kWidth, kHeight-self.navBarView.height) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.backgroundColor = RGBColor(245, 245, 245);
    
    [_tableView registerClass:[BindCell class] forCellReuseIdentifier:@"BindCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableView];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 9.6, kWidth, 0.4)];
    line.backgroundColor = RGBColor(190, 190, 190);
    [headerView addSubview:line];
    _tableView.tableHeaderView = headerView;
    
    
}



- (void)loadData {
    
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             };
    
    [HttpRequest get_RequestWithURL:USER_BIND_LIST URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                [self.dataSource removeAllObjects];
                
                NSDictionary * data = dic[@"data"];
                
                NSArray * title = @[@"手机号",@"微信",@"微博",@"QQ"];
                NSArray * arr = @[@"PHONE",@"WEIXIN",@"WEIBO",@"QQ"];
                
                NSMutableArray * mArr = @[].mutableCopy;
                
                for (int i = 0; i < arr.count; i++) {
                    
                    [mArr addObject:@{
                                      @"title":title[i],
                                      @"type":arr[i],
                                      @"ifBind":data[arr[i]],
                                      }];
                }
                
                [self.dataSource addObject:mArr];
                
                [self.dataSource addObject:@[
                                             @{
                                                 @"title":@"修改密码",
                                                 @"type":@"0",
                                                 @"ifBind":@"0",
                                                 },
                                             ]];
                [self.tableView reloadData];
                
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BindCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BindCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UMengShare * um =  [UMengShare share];
    um.delegate = self;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0: {
                
                if ([self.dataSource[indexPath.section][indexPath.row][@"ifBind"] isEqualToString:@"0"]) {
                    PhoneBindViewController * vc = [PhoneBindViewController new];
                    vc.type = @"0";
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    SafeVeriViewController * vc = [[SafeVeriViewController alloc]init];
                    vc.veriType = @"0";
                    vc.phone = self.dataSource[indexPath.section][indexPath.row][@"ifBind"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
                break;
            case 1: {
                
                if ([self.dataSource[indexPath.section][indexPath.row][@"ifBind"] isEqualToString:@"0"]) {
                    [um authWithPlatform:UMSocialPlatformType_WechatSession];
                }else {
                    
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"是否解除微信绑定?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除绑定", nil];
                    alertView.tag = 8888+1;
                    [alertView show];
                }
    
            }
                break;
            case 2: {
                if ([self.dataSource[indexPath.section][indexPath.row][@"ifBind"] isEqualToString:@"0"]) {
                    [um authWithPlatform:UMSocialPlatformType_Sina];
                }else {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"是否解除微博绑定?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除绑定", nil];
                    alertView.tag = 8888+2;
                    [alertView show];
                }
            }
                break;
            case 3: {
                if ([self.dataSource[indexPath.section][indexPath.row][@"ifBind"] isEqualToString:@"0"]) {
                    [um authWithPlatform:UMSocialPlatformType_QQ];
                }else {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"是否解除QQ绑定?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除绑定", nil];
                    alertView.tag = 8888+3;
                    [alertView show];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section == 1) {
        
        if ([self.dataSource[0][0][@"ifBind"] isEqualToString:@"0"]) {
            PhoneBindViewController * vc = [PhoneBindViewController new];
            vc.type = @"0";
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            SafeVeriViewController * vc = [[SafeVeriViewController alloc]init];
            vc.veriType = @"1";
            vc.phone = self.dataSource[0][0][@"ifBind"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }else {
        return 44;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footer = [[UIView alloc] init];
    
    UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.4)];
    line0.backgroundColor = RGBColor(190, 190, 190);
    [footer addSubview:line0];
    
    if (section != self.dataSource.count-1) {
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29.6, kWidth, 0.4)];
        line1.backgroundColor = RGBColor(190, 190, 190);
        [footer addSubview:line1];
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        
        UMengShare * um =  [UMengShare share];
        um.delegate = self;
        
        switch (alertView.tag-8888) {
            case 1:{
                [um cancelAuthWithPlatform:UMSocialPlatformType_WechatSession];
            }
                break;
            case 2:{
                [um cancelAuthWithPlatform:UMSocialPlatformType_Sina];
            }
                break;
            case 3:{
                [um cancelAuthWithPlatform:UMSocialPlatformType_QQ];
            }
                break;
                
            default:
                break;
        }
        
        
    }
}

- (void)umengShare:(UMengShare *)umShare authWithPlatform:(UMSocialPlatformType)platformType result:(id)result error:(NSError *)error {
    
    if (!error) {
        
        UMSocialUserInfoResponse * resp = result;

        NSString * partner = @"other";
        __block int index = 0;
        if (platformType == UMSocialPlatformType_WechatSession) {
            partner = @"WEIXIN";
            index = 1;
        }else if (platformType == UMSocialPlatformType_Sina) {
            partner = @"WEIBO";
            index = 2;
        }else if (platformType == UMSocialPlatformType_QQ) {
            partner = @"QQ";
            index = 3;
        }
        
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"partner":partner,
                                 @"uid":resp.uid,
                                 };
        
        [HttpRequest get_RequestWithURL:USER_BIND_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    NSDictionary * pa = self.dataSource[0][index];
                    NSDictionary * re = @{
                                          @"title":pa[@"title"],
                                          @"type":pa[@"type"],
                                          @"ifBind":@"1",
                                          };
                    [self.dataSource[0] replaceObjectAtIndex:index withObject:re];
                    
                    [self.tableView reloadData];
                    
                }else if ([dic[@"msg"] isEqualToString:@"已经绑定"]) {
                    [KKHUD showMiddleWithStatus:@"该账号已被绑定"];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }
    
}

- (void)umengShare:(UMengShare *)umShare cancelAuthWithPlatform:(UMSocialPlatformType)platformType result:(id)result error:(NSError *)error {
    
    if (!error) {
        
        NSString * partner = @"other";
        __block int index = 0;
        if (platformType == UMSocialPlatformType_WechatSession) {
            partner = @"WEIXIN";
            index = 1;
        }else if (platformType == UMSocialPlatformType_Sina) {
            partner = @"WEIBO";
            index = 2;
        }else if (platformType == UMSocialPlatformType_QQ) {
            partner = @"QQ";
            index = 3;
        }
        
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"partner":partner,
                                 };
        
        [HttpRequest get_RequestWithURL:USER_UNBIND_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    NSDictionary * pa = self.dataSource[0][index];
                    NSDictionary * re = @{
                                          @"title":pa[@"title"],
                                          @"type":pa[@"type"],
                                          @"ifBind":@"0",
                                          };
                    [self.dataSource[0] replaceObjectAtIndex:index withObject:re];
                    
                    [self.tableView reloadData];
                    
                }else if ([dic[@"msg"] isEqualToString:@"至少要保留一个绑定"]) {
                    [KKHUD showMiddleWithStatus:@"至少要保留一个绑定"];
                }
                
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
    }
    
}




@end
