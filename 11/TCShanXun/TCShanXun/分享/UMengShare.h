//
//  UMengShare.h
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UMengShare;
@protocol UMengShareDelegate <NSObject>
@optional
- (void)umengShare:(UMengShare *)umShare authWithPlatform:(UMSocialPlatformType)platformType result:(id)result error:(NSError *)error;
- (void)umengShare:(UMengShare *)umShare cancelAuthWithPlatform:(UMSocialPlatformType)platformType result:(id)result error:(NSError *)error;

@end

@interface UMengShare : NSObject

@property(nonatomic, weak)id<UMengShareDelegate> delegate;

+ (instancetype)share;

- (void)shareWithModel:(id)model atIndex:(int)index viewController:(UIViewController *)viewController;
- (void)shareTopicWithModel:(id)model atIndex:(int)index viewController:(UIViewController *)viewController;

- (void)authWithPlatform:(UMSocialPlatformType)platformType;
- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType;


@end
