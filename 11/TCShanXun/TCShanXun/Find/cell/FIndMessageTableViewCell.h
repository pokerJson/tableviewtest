//
//  FIndMessageTableViewCell.h
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindMessageInfo.h"
@class FIndMessageTableViewCell;

@protocol FIndMessageTableViewCellDlegate<NSObject>

- (void)addColletion:(FIndMessageTableViewCell *)cell;
- (void)gotoCommentVC:(FIndMessageTableViewCell *)cell;
- (void)gotoFimeMessageSourceVC:(NSIndexPath *)index;
- (void)shareBTClick:(NSIndexPath *)idnex;
- (void)noLogin;
@end

@interface FIndMessageTableViewCell : UITableViewCell

@property (nonatomic,strong)FindMessageInfo *info;
@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic,assign)id<FIndMessageTableViewCellDlegate> delegate;

@end
