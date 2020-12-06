//
//  ThemeInfo.h
//  News
//
//  Created by dzc on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeInfo : NSObject

@property (nonatomic,strong)NSString *sendTime;
@property (nonatomic,strong)NSString *contentstr;
@property (nonatomic,strong)NSMutableArray *imageuRLArr;
@property (nonatomic,strong)NSString *authorIcon;
@property (nonatomic,strong)NSString *authorName;
@property (nonatomic,strong)NSString *comentNum;
@property (nonatomic,strong)NSString *dianzanNum;
@property (nonatomic,strong)NSString *nothingNum;

@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign) BOOL shouldShowMoreButton;

@end
