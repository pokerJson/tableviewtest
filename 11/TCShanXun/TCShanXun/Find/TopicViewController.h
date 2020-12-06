//
//  TopicViewController.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"
#import "ThemeModel.h"
#import "FindThemeInfo.h"

@interface TopicViewController : BViewController

@property(nonatomic,copy)NSString *topicID;

@property(nonatomic, strong)TopicModel * topicModel;

@property(nonatomic, strong)BListModel * bModel;

@property (nonatomic,strong)ThemeModel *model;
@property (nonatomic,strong)FindThemeInfo *info;

@end
