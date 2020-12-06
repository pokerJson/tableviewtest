//
//  TopicModel.m
//  News
//
//  Created by FANTEXIX on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        _des = value;
    }
    
}
- (instancetype)valueForUndefinedKey:(NSString *)key {
    return nil;
}

#if DEBUG
- (NSDictionary *)mapProperties {
    // 报错的话，加上这句：
    // #import <objc/runtime.h>
    
    // 用以存储属性（key）及其值（value）
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    // 获取当前类对象类型
    Class cls = [self class];
    
    // 获取类对象的成员变量列表，count为成员个数
    uint count = 0;
    Ivar * ivars = class_copyIvarList(cls, &count);
    
    // 遍历成员变量列表，其中每个变量为Ivar类型的结构体
    
    for (int i = 0; i < count; i++) {
        Ivar  ivar = *(ivars+i);
        //　获取变量名
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 若此变量声明为属性，则变量名带下划线前缀'_'
        if ([key hasPrefix:@"_"]) key = [key substringFromIndex:1];
        
        //　获取变量值
        id value = [self valueForKey:key];
        
        // 处理属性未赋值属性，将其转换为null，若为nil，插入将导致程序异常
        [dic setObject:value ? value : [NSNull null]
                forKey:key];
    }
    
    return dic;
}

- (NSString *)description {
    
    NSMutableString * str = [NSMutableString string];
    NSString * className = NSStringFromClass([self class]);
    
    NSDictionary * dic = [self mapProperties];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [str appendFormat:@"\t@\"%@\" : @\"%@\",\n", key, obj];
        }else {
            [str appendFormat:@"\t@\"%@\" : %@,\n", key, obj];
        }
    }];
    
    return [NSString stringWithFormat:@"%@: {\n%@}", className, str];
}
#endif

@end
