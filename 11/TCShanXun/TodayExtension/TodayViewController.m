//
//  TodayViewController.m
//  TodayExtension
//
//  Created by FANTEXIX on 2018/9/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "TodayHeader.h"
#import "TodayNewCell.h"
#import "TodayOldCell.h"
#import "TodayModel.h"
#import "SAMKeychain.h"

@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, assign)BOOL sysAbove10;
@property(nonatomic, assign)BOOL screenLandscape;
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, strong)UIButton * moreButton;

@end

@implementation TodayViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    _sysAbove10 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 10 ? YES:NO;
    _screenLandscape = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? YES:NO;
    
    [self reparedData];
    [self dataRequest];
}


- (void)reparedData {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * dataArr = [userDefaults valueForKey:@"widget"];
    if (!dataArr) return;
    
    NSUInteger count = dataArr.count < 4 ? dataArr.count : 4;
    for (int i = 0; i < count; i++) {
        TodayModel * model = [[TodayModel alloc]init];
        [model setValuesForKeysWithDictionary:dataArr[i]];
        [self.dataSource addObject:[self handleModel:model]];
    }
    
    //UI
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    } else {
        // Fallback on earlier versions
    }
    
    NSLog(@"bounds:%@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"preferred:%@",NSStringFromCGSize(self.preferredContentSize));
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[TodayNewCell class] forCellReuseIdentifier:@"TodayNewCell"];
    [_tableView registerClass:[TodayOldCell class] forCellReuseIdentifier:@"TodayOldCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    NSLog(@"_tableView: %@",NSStringFromCGRect(_tableView.bounds));
    
    _moreButton = [[UIButton alloc] init];
    if (_sysAbove10) {
        _moreButton.backgroundColor = RGBAColor(200, 200, 200, 1);
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_moreButton setTitleColor:RGBColor(0, 0, 0) forState:UIControlStateNormal];
    }else {
        _moreButton.backgroundColor = RGBAColor(200, 200, 200, 0.95);
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_moreButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
    }
    _moreButton.layer.cornerRadius = 5;
    [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];

}



- (BOOL)isLogin {
    BOOL login = NO;
    NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
    if ([[shared valueForKey:@"LOGIN"] boolValue]) {
        login = YES;
    }
    return login;
}

- (void)dataRequest {
    
    NSLog(@"dataRequest");
    
    NSDictionary * param = nil;
    
    if ([self isLogin]) {
        NSUserDefaults * shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.client.news"];
        param = @{
                  @"userid":[shared valueForKey:@"uid"],
                  @"token":[shared valueForKey:@"accessToken"],
                  };
    }else {
        param = @{
                  @"imei":[self getDeviceId],
                  };
    }
    
    NSArray * keyArr = [param allKeys];
    NSArray * paramArr = [param allValues];
    NSMutableArray * par = [NSMutableArray array];
    for (int i = 0; i < keyArr.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%@=%@",keyArr[i],paramArr[i]];
        [par addObject:str];
    }
    NSString * paramStr = [par componentsJoinedByString:@"&"];
    
    NSString * str = [NSString stringWithFormat:@"http://www.yzpai.cn/news/index/recommend?%@",paramStr];
    NSLog(@"%@",str);
    NSURL * url = [NSURL URLWithString:str];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:10.0f];
    request.HTTPMethod = @"GET";
    weakObj(self);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"code"] intValue] == 200) {
                NSArray * arr = dic[@"data"];
                
                NSUserDefaults * shared = [NSUserDefaults standardUserDefaults];
                [shared setObject:arr forKey:@"widget"];
                [shared synchronize];
                
                if (self.dataSource.count == 0) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [selfWeak reparedData];
                    }];
                }
            }
        }
        
    }] resume];
    
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    _sysAbove10 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 10 ? YES:NO;
    _screenLandscape = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? YES:NO;
    
    NSLog(@"bounds: %@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"Landscape: %d",_screenLandscape);
    
    if (!_sysAbove10) {
        //iOS 9
        if (!_screenLandscape) {
            self.preferredContentSize = CGSizeMake(kWidth, self.dataSource.count * 80 + 50);
            _tableView.frame = CGRectMake(0, 0, kWidth - 8, self.dataSource.count * 80 + 50);
            _moreButton.frame = CGRectMake((kWidth-220)/2.- 25, self.preferredContentSize.height - 35, 220, 30);
        }else {
            self.preferredContentSize = CGSizeMake(kWidth, self.dataSource.count/2 * 80 + 50);
            _tableView.frame = CGRectMake(0, 0, kWidth - 8, self.dataSource.count/2 * 88 + 50);
            _moreButton.frame = CGRectMake((kWidth-220)/2. - 40, self.preferredContentSize.height - 35, 220, 30);
        }
        
    }else {
        //iOS 10
        _tableView.frame = CGRectMake(0, 0, kWidth , self.dataSource.count * 110 + 55);
    }
    
    [self.view setNeedsLayout];
    [_tableView setNeedsLayout];
    [_tableView reloadData];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize  API_AVAILABLE(ios(10.0)){
    _sysAbove10 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 10 ? YES:NO;
    _screenLandscape = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? YES:NO;
    NSLog(@"maxSize:%@",NSStringFromCGSize(maxSize));
    
    if (activeDisplayMode == 0) {
        self.preferredContentSize = CGSizeMake(kWidth, 110);
    } else {
        if (!_screenLandscape) {
            self.preferredContentSize = CGSizeMake(kWidth, self.dataSource.count * 110 + 55);
            _tableView.frame = CGRectMake(0, 0, kWidth , self.dataSource.count * 110 + 55);
        }else {
            self.preferredContentSize = CGSizeMake(kWidth, self.dataSource.count/2 * 110 + 55);
            _tableView.frame = CGRectMake(0, 0, kWidth ,self.dataSource.count/2 * 110 + 55);
        }
        _moreButton.frame = CGRectMake((kWidth-220)/2., self.preferredContentSize.height - 45, 220, 30);
        
        [_tableView setNeedsLayout];
        [_tableView reloadData];
    }
}


- (NSString *)getDeviceId {
    NSString * deviceUUID = [SAMKeychain passwordForService:@"tcnews"account:@"uuid"];
    if (deviceUUID == nil || [deviceUUID isEqualToString:@""]) {
        NSUUID * UUID  = [UIDevice currentDevice].identifierForVendor;
        deviceUUID = UUID.UUIDString;
        deviceUUID = [deviceUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        deviceUUID = [deviceUUID lowercaseString];
        [SAMKeychain setPassword:deviceUUID forService:@"tcnews"account:@"uuid"];
    }
    return deviceUUID;
}

- (TodayModel *)handleModel:(TodayModel *)model {
    
    CGFloat width = [model.topicname boundingRectWithSize:CGSizeMake(kWidth-100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    
    model.titleWidth = width;
    
    float ch = 0;
    float ph = 0;
    float vh = 0;
    
    model.des = [[model.des componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    
    if (![model.title isEqualToString:@""]) {
        if (![model.des isEqualToString:@""]) {
            if ([model.title isEqualToString:model.des]) {
                model.content = model.title;
            }else {
                model.content = [@[model.title,model.des] componentsJoinedByString:@"\n"];
            }
        }else {
            model.content  = model.title;
        }
    }else {
        model.content = model.des;
    }
    
    NSLog(@"%@",model.content);
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5];
    float contentHeight = [model.content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:style} context:nil].size.height;
    
    model.contentHeight = ceil(contentHeight);
    
    if (model.contentHeight != 0) ch = model.contentHeight+10;
    
    //图片
    if (![model.pic_urls isEqualToString:@""]) {
        model.picsArr = [NSJSONSerialization JSONObjectWithData:[model.pic_urls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }else {
        model.picsArr = @[];
    }
    
    if (model.picsArr.count == 0) {
        model.imageHeight = 0;
    }else if (model.picsArr.count==1) {
        
        if (model.type.intValue == 3) {
            model.imageHeight = ceil((kWidth-30)*9/16.);
        }else {
            model.imageHeight = 180;
        }
        
    }else {
        int num = model.picsArr.count%3 ?(int)model.picsArr.count/3+1 : (int)model.picsArr.count/3;
        model.imageHeight = (kWidth-40)/3.*num + 5*(num-1);
    }
    
    
    if (model.imageHeight != 0) ph = model.imageHeight+10;
    
    //视频
    if ([model.video_url isEqualToString:@""]) {
        model.videoHeight = 0;
    }else {
        model.videoHeight = ceil((kWidth - 30)*9/16.);
    }
    
    if (model.videoHeight != 0) vh = model.videoHeight+10;
    
    //总
    model.totalHeight = ceil(60+ch+ph+vh+44+8);
    
    return model;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_screenLandscape) {
        return self.dataSource.count/2;
    }else {
        return self.dataSource.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_sysAbove10) {
        
        TodayNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayNewCell" forIndexPath:indexPath];
        if (indexPath.row > self.dataSource.count || self.dataSource.count == 0) return cell;
        [cell loadDataWithModel:self.dataSource[indexPath.row]];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0,8,0,8)];
        }
        return cell;
        
    }else {
        
        TodayOldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayOldCell" forIndexPath:indexPath];
        if (indexPath.row > self.dataSource.count || self.dataSource.count == 0) return cell;
        [cell loadDataWithModel:self.dataSource[indexPath.row]];
        
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_sysAbove10) {
        return 110;
    }else {
        return 80;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > self.dataSource.count || self.dataSource.count == 0) return;
    TodayModel * model = self.dataSource[indexPath.row];
    [self openURLContainingAPP:model.ID];
}
- (void)openURLContainingAPP:(NSString *)vid{
    if (vid) {
        [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"shanxunlauncher://news?id=%@",vid]] completionHandler:^(BOOL success) {
            NSLog(@"open url result:%d",success);
        }];
    }
}
- (void)moreButtonClicked:(UIButton *)button {
    [self.extensionContext openURL:[NSURL URLWithString:@"shanxunlauncher://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
