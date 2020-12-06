//
//  FollowDefaultCell.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowDefaultCell : UICollectionViewCell

@property(nonatomic, copy)void(^callBack)(int m);

- (void)loadDataWithModel:(id)model;

@end
