//
//  FindMessageCell.h
//  TCShanXun
//
//  Created by dzc on 2018/8/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindMessageCell,BListModel;
@protocol FindMessageCellDelegate <NSObject>
@optional
- (void)shareMethod:(FindMessageCell *)cell;
- (void)moreMethod:(FindMessageCell *)cell;
- (void)commentMethod:(FindMessageCell *)cell;
- (void)picMethod:(FindMessageCell *)cell atIndex:(int)index;

@end

@interface FindMessageCell : UITableViewCell

@property(nonatomic, weak)id<FindMessageCellDelegate> delegate;

@property(nonatomic, strong)NSIndexPath * indexPath;

@property(nonatomic, strong)BListModel * model;

@property(nonatomic, strong)NSMutableArray * imageViewArr;

@property(nonatomic, copy)void(^reloadBlock)(void);

- (void)loadDataWithModel:(id)model;


@end
