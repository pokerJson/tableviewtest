//
//  FindThemeInfo.m
//  News
//
//  Created by dzc on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindThemeInfo.h"

@implementation FindThemeInfo
- (void)setValue:(id)value forKey:(NSString *)key {
//    [super setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    if ([key isEqualToString: @"id"]) {
        _ID = value;
    }else{
        //调用父类方法，保证其他属性正常加载
        [super setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (instancetype)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
