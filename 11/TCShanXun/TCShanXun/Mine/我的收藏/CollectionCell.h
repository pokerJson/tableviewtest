//
//  CollectionCell.h
//  News
//
//  Created by FANTEXIX on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CollectionCell,BListModel;
@protocol CollectionCellDelegate <NSObject>
@optional
- (void)moreMethod:(CollectionCell *)cell;
- (void)shareMethod:(CollectionCell *)cell;
- (void)collectionMethod:(CollectionCell *)cell;
- (void)commentMethod:(CollectionCell *)cell;
- (void)picMethod:(CollectionCell *)cell atIndex:(int)index;

@end

@interface CollectionCell : UITableViewCell

@property(nonatomic, weak)id<CollectionCellDelegate> delegate;

@property(nonatomic, strong)NSIndexPath * indexPath;

@property(nonatomic, strong)BListModel * model;

@property(nonatomic, strong)NSMutableArray * imageViewArr;

- (void)loadDataWithModel:(id)model;
@property(nonatomic, copy)void(^reloadBlock)(void);

@end
