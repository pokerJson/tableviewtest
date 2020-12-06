//
//  FIndUserInfo.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FIndUserInfo.h"

@implementation FIndUserInfo
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (instancetype)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
