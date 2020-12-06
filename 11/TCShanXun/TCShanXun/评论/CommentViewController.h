//
//  CommentViewController.h
//  News
//
//  Created by FANTEXIX on 2018/7/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@class BListModel;
@class FindMessageInfo;
@interface CommentViewController : BViewController

@property(nonatomic, copy)NSString * ID;

@property(nonatomic, strong)BListModel * bModel;
@property(nonatomic, strong)FindMessageInfo * info;

@end
