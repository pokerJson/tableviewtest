//
//  NSString+Extend.h
//  NvYou
//
//  Created by FANTEXIX on 2018/4/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)


+ (NSString *)timeFormat:(int)seconds;
+ (NSString *)dateFormat:(NSInteger)timeStamp formatter:(NSString *)formatter;
+ (NSString *)MD5ForStr:(NSString *)string;


@end

