//
//  GenderPickerView.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/2/28.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenderPickerView;
@protocol GenderPickerViewDelegate <NSObject>

@optional
- (void)genderPickerView:(GenderPickerView *)genderPickerView gender:(NSInteger)gender;
- (void)dismissGenderPickerView:(GenderPickerView *)genderPickerView;

@end

@interface GenderPickerView : UIView

@property(nonatomic, weak)id<GenderPickerViewDelegate>  delegate;
- (void)showWithDate:(NSDate *)date;
- (void)dismiss;

@end
