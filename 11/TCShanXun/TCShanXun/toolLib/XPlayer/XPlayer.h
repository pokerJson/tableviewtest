//
//  XPlayer.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/15.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol XPlayerDelegate <NSObject>
@optional
- (void)xPlayerEnded;

@end

@interface XPlayer : UIView

@property(nonatomic, assign)id <XPlayerDelegate> delegate;
@property(nonatomic, assign)BOOL backType;
@property(nonatomic, assign)BOOL pauseType;

+ (instancetype)shared;
- (void)playURL:(id)model videoGravity:(BOOL)isFill repeat:(BOOL)yesOrNo;
- (void)startPlay;
- (void)stopPlay;
- (void)removePlayer;

@end
