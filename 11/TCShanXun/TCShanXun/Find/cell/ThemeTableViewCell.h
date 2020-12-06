//
//  ThemeTableViewCell.h
//  News
//
//  Created by dzc on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"

@protocol ThemeTableViewCellDelegate<NSObject>

- (void)updataInfoWith:(NSIndexPath *)index withBool:(NSString *)isfollow;

@end

@interface ThemeTableViewCell : UITableViewCell

@property (nonatomic,strong)ThemeModel *model;
@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic,assign)id<ThemeTableViewCellDelegate> delegate;

-(void)setImageWithModel:(ThemeModel *)model;


@end
