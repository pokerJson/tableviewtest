//
//  TuijianCollectionViewCell.h
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TuijianCollectionViewCell;

typedef void(^XiangguanTuijianAttentionBTBlock)(TuijianCollectionViewCell *cell);

@interface TuijianCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *attentionLabel;
@property (nonatomic,strong)UIButton *attentionBT;

@property (nonatomic,assign)XiangguanTuijianAttentionBTBlock attentionBT_Block;

@end
