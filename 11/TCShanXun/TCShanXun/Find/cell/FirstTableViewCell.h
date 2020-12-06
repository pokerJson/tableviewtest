//
//  FirstTableViewCell.h
//  News
//
//  Created by dzc on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@interface FirstTableViewCell : UITableViewCell

@property (nonatomic, strong) ThemeInfo *info;
@property (nonatomic, strong) NSIndexPath *indexpath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
