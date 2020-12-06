//
//  TopicHeaderView.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicHeaderView : UIView

@property(nonatomic, strong)void(^updateFrame)(void);
@property(nonatomic, strong)void(^updateFollow)(void);

- (void)loadDataWithModel:(id)model;

@end
