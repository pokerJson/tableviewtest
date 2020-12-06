//
//  FindManager.h
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindManager : NSObject

+ (FindManager *)defaulManager;

@property (nonatomic,strong)NSString *currentString;

@end
