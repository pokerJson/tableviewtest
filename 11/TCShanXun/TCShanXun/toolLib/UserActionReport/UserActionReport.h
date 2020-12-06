//
//  UserActionReport.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/3.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActionReport : NSObject

+ (instancetype)shared;

- (void)newsPost:(NSString *)newsID ext:(NSString *)ext;
- (void)sharePost:(NSString *)newsID ext:(NSString *)ext;
- (void)uninterestedPost:(NSString *)newsID ext:(NSString *)ext;

@end
