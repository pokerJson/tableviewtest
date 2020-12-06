//
//  KKHUD.h
//  KanKan
//
//  Created by FANTEXIX on 2017/2/24.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHUD : UIView

+ (void)showTopWithStatus:(NSString *)status;
+ (void)showMiddleWithStatus:(NSString *)status;
+ (void)showMiddleWithSuccessStatus:(NSString *)status;
+ (void)showMiddleWithErrorStatus:(NSString *)status;
+ (void)showBottomWithStatus:(NSString *)status;

@end
