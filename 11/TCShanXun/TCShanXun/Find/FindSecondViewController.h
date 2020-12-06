//
//  FindSecondViewController.h
//  News
//
//  Created by dzc on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlcok)(void);

@interface FindSecondViewController : UIViewController

- (void)updataDataWithType:(NSString *)type;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,copy)RefreshBlcok refreshBlock;

- (void)viewScrollToAppear;


@end
