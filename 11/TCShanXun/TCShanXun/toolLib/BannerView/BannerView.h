//
//  BannerView.h
//  FANTEXIX
//
//  Created by FANTEXIX on 2018/7/24.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property(nonatomic,copy)void(^callBack)(NSDictionary * param);

@property(nonatomic,assign)BOOL scrollable;

- (void)loadDataWithModel:(id)model;

@end
