//
//  CommentCell.h
//  News
//
//  Created by FANTEXIX on 2018/7/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentCell;
@protocol CommentCellDelegate <NSObject>

@optional
- (void)deleteComment:(CommentCell *)cell;

@end

@interface CommentCell : UITableViewCell

@property(nonatomic, weak)id<CommentCellDelegate> delegate;

@property(nonatomic, copy)void(^personBlock)(NSString * uid);
@property(nonatomic, copy)void(^deleteBlock)(void);

- (void)loadDataWithModel:(id)model;

@end
