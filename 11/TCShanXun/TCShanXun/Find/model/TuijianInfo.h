//
//  TuijianInfo.h
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuijianInfo : NSObject

@property (nonatomic,strong) NSString *iconStr;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *attenionNum;
@property (nonatomic,strong) NSMutableArray *attentionArr;//包扩图片 title 关注

@end
