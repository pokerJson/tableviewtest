//
//  DataTipsView.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTipsView : UIView

@property(nonatomic, copy)void(^callBack)(NSDictionary * param);

- (void)loadDataWithModel:(NSDictionary *)model;

@end
