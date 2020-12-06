//
//  FindHistoryView.h
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindHistoryView : UIView

@property (nonatomic,strong) NSMutableArray *histyARR;
@property(nonatomic,copy)void (^didselectItemBlock)(NSString *str);


@property (nonatomic,assign) float h_height;

@end
