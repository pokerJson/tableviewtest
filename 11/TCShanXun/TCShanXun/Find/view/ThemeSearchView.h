//
//  ThemeSearchView.h
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThemeSearchBlock)(NSInteger tag);

@interface ThemeSearchView : UIView

//当前
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,copy)ThemeSearchBlock searchBlcok;
@property (nonatomic,strong)NSMutableArray *childControllers;

- (void)show;
- (void)hid;

@end
