//
//  HistoryCell.h
//  TCShanXun
//
//  Created by dzc on 2018/9/3.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryCell,BListModel;
@protocol HistoryCellDelegate <NSObject>
@optional
- (void)moreMethod:(HistoryCell *)cell;
- (void)shareMethod:(HistoryCell *)cell;
- (void)collectionMethod:(HistoryCell *)cell;
- (void)commentMethod:(HistoryCell *)cell;
- (void)picMethod:(HistoryCell *)cell atIndex:(int)index;

@end

@interface HistoryCell : UITableViewCell


@property(nonatomic, weak)id<HistoryCellDelegate> delegate;

@property(nonatomic, strong)NSIndexPath * indexPath;

@property(nonatomic, strong)BListModel * model;

@property(nonatomic, strong)NSMutableArray * imageViewArr;

- (void)loadDataWithModel:(id)model;

@property(nonatomic, copy)void(^reloadBlock)(void);

@end
