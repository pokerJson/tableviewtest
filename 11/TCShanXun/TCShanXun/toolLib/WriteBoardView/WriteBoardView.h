//
//  WriteBoardView.h
//  ControlExtensionLib
//
//  Created by FANTEXIX on 2017/2/19.
//  Copyright © 2017年 FANTEXIX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WriteBoardView;
@protocol WriteBoardViewDeletgate<NSObject>

@optional
- (void)writeBoardViewDismiss:(WriteBoardView *)wBoardView;
- (void)writeBoardView:(WriteBoardView *)wBoardView submitWithStr:(NSString *)str;

@end


@interface WriteBoardView : UIView

@property(nonatomic, weak)id<WriteBoardViewDeletgate> delegate;

@property(nonatomic, assign)BOOL responsive;

@property(nonatomic, copy)NSString * placeholder;
@property(nonatomic, copy)NSString * submitName;

- (void)becomeResponder;
- (void)resignResponder;

- (void)reset;



@end
