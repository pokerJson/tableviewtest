//
//  BListCell.h
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BListCell,BListModel;
@protocol BListCellDelegate <NSObject>
@optional
- (void)shareMethod:(BListCell *)cell;
- (void)moreMethod:(BListCell *)cell;
- (void)commentMethod:(BListCell *)cell;
- (void)picMethod:(BListCell *)cell atIndex:(int)index;

@end

@interface BListCell : UITableViewCell

@property(nonatomic, weak)id<BListCellDelegate> delegate;

@property(nonatomic, strong)NSIndexPath * indexPath;

@property(nonatomic, strong)BListModel * model;

@property(nonatomic, strong)NSMutableArray * imageViewArr;

@property(nonatomic, copy)void(^reloadBlock)(void);

@property(nonatomic, assign)BOOL spe;

- (void)loadDataWithModel:(id)model;

@end
