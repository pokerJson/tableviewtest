//
//  HotHistoryWordsView.h
//  TCShanXun
//
//  Created by dzc on 2019/1/21.
//  Copyright © 2019 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindBagTagView.h"
#import "FindHistoryView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HotHistoryWordsViewBlcok)(NSString *str);
typedef void(^HHHblOCK)(void);

@interface HotHistoryWordsView : UIView

@property(nonatomic,strong)FindBagTagView *hotWordsView;
@property (nonatomic,strong)NSArray  *hotArr;

@property (nonatomic,strong)UILabel *historyLabel;
@property (nonatomic,strong)UIButton *deleteBT;
@property(nonatomic,strong)FindHistoryView *historyWordsView;


@property (nonatomic,copy)HotHistoryWordsViewBlcok h_hBlock;
@property (nonatomic,copy)HHHblOCK keybordBlock;

- (void)show;
- (void)hid;

@end

NS_ASSUME_NONNULL_END
