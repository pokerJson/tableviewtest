//
//  CurrentFIndViewController.h
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindBagTagView.h"
#import "FindHistoryView.h"
#import "BViewController.h"

@interface CurrentFIndViewController : BViewController<UITableViewDelegate,UITableViewDataSource>

//1
@property(nonatomic,strong)UIScrollView *defaultScrollview;
@property(nonatomic,strong)FindBagTagView *bagtagView;
@property(nonatomic,strong)UILabel *historyLable;//搜索历史
@property(nonatomic,strong)UIButton *deleteBT;//删除
@property(nonatomic,strong)FindHistoryView *histiryView;//
@property(nonatomic,strong)UILabel *hotLabel;//

//2
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *hotSearchARR;//热门搜索数组
@property(nonatomic,strong)NSMutableArray *historySearchARR;//搜索历史数组
@property(nonatomic,strong)UITextField *texf;


@end
