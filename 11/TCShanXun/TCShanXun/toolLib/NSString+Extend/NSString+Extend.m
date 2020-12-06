//
//  NSString+Extend.m
//  NvYou
//
//  Created by FANTEXIX on 2018/4/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//
@implementation NSString (Extend)

+ (NSString *)timeFormat:(int)seconds {
    int s = seconds %60;
    int m = seconds/60 %60;
    int h   = seconds/60/60 %60;
    
    if (h) return [NSString stringWithFormat:@"%d:%.2d:%.2d",h,m,s];
    else return [NSString stringWithFormat:@"%.2d:%.2d",m,s];
}


+ (NSString *)dateFormat:(NSInteger)timeStamp formatter:(NSString *)formatter {
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate: detailDate];
}


/**
 MD5值
 @param string 加密字符串
 @return MD5值
 */
+ (NSString *)MD5ForStr:(NSString *)string {
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *MD5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return MD5String;
}



@end

