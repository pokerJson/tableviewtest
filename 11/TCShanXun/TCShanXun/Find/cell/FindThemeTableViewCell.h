//
//  FindThemeTableViewCell.h
//  News
//
//  Created by dzc on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindThemeInfo.h"
#import "TopicModel.h"

@protocol FindThemeTableViewCellDelegate<NSObject>

- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow;

@end

@interface FindThemeTableViewCell : UITableViewCell

@property (nonatomic,strong)TopicModel *info;

@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic,assign)id<FindThemeTableViewCellDelegate> delegate;

@end
