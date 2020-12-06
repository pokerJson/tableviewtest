//
//  TopicNewsCell.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TopicNewsCell,BListModel;
@protocol TopicNewsCellDelegate <NSObject>
@optional
- (void)shareMethod:(TopicNewsCell *)cell;
- (void)moreMethod:(TopicNewsCell *)cell;
- (void)commentMethod:(TopicNewsCell *)cell;
- (void)picMethod:(TopicNewsCell *)cell atIndex:(int)index;

@end

@interface TopicNewsCell : UITableViewCell

@property(nonatomic, weak)id<TopicNewsCellDelegate> delegate;

@property(nonatomic, strong)NSIndexPath * indexPath;

@property(nonatomic, strong)BListModel * model;

@property(nonatomic, strong)NSMutableArray * imageViewArr;

- (void)loadDataWithModel:(id)model;

@end
