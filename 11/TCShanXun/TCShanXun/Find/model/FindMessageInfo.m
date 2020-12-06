//
//  FindMessageInfo.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindMessageInfo.h"

@implementation FindMessageInfo
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString: @"id"]) {
        _ID = value;
    }
    if ([key isEqualToString: @"description"]) {
        _des = value;
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
