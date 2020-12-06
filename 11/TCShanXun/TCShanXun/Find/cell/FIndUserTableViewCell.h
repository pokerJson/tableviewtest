//
//  FIndUserTableViewCell.h
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIndUserInfo.h"
#import "PersonModel.h"

@protocol FIndUserTableViewCellDelegate<NSObject>

- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow;

@end

@interface FIndUserTableViewCell : UITableViewCell

@property (nonatomic,strong)PersonModel *info;
@property (nonatomic,assign)id<FIndUserTableViewCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath *index;

@end
