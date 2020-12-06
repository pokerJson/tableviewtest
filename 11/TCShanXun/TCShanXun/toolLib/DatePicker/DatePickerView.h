//
//  DatePickerView.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/2/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerView;
@protocol DatePickerViewDelegate <NSObject>

@optional
- (void)datePickerView:(DatePickerView *)datePickerView date:(NSDate *)date;
- (void)dismissDatePickerView:(DatePickerView *)datePickerView;

@end

@interface DatePickerView : UIView

@property(nonatomic, weak)id<DatePickerViewDelegate>  delegate;
- (void)showWithDate:(NSDate *)date;
- (void)dismiss;

@end
