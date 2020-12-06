//
//  PhoneView.h
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneView : UIView

@property(nonatomic, copy)NSString * type;

@property(nonatomic, copy)void(^sendCodeMethod)(void);

- (void)loadDataWithModel:(id)model;

- (void)resignResponder;

@end
