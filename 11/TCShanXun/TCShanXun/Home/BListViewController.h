//
//  BListViewController.h
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"



@class BListViewController,ScrollSwitch;
@protocol BListViewControllerDelegate <NSObject>
@optional
- (void)viewController:(BListViewController *)vc offset:(float)offset interval:(float)interval;

@end

@interface BListViewController : BViewController

@property(nonatomic, weak)id<BListViewControllerDelegate> delegate;

@property(nonatomic, strong)UITableView * tableView;

@property(nonatomic, weak)ScrollSwitch * scrollSwitch;

- (void)viewWillScrollToAppear;

@end
