//
//  ThemeVC.h
//  News
//
//  Created by dzc on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"

@interface ThemeVC : UIViewController

@property (nonatomic,strong)NSString *iD;
@property (nonatomic,strong)ThemeModel *model;

//首页取消关注关联
@property(nonatomic, strong)BListModel * bModel;

@end
