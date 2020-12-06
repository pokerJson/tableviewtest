//
//  FindManager.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindManager.h"

@implementation FindManager

+ (FindManager *)defaulManager
{
    static FindManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
    
}
@end
