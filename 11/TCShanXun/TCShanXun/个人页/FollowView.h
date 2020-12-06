//
//  FollowView.h
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowView : UIView

@property(nonatomic, copy)NSString * num;
@property(nonatomic, copy)NSString * tab;

@property(nonatomic, copy)void(^ tapMethod)(void);

@end

