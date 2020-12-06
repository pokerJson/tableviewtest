//
//  FimeMessageSourceViewController.h
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"
@class FindMessageInfo;
//typedef void(^FimeMessageSourceViewControllerBlcok)(void);

@interface FimeMessageSourceViewController : BViewController


@property(nonatomic, strong)FindMessageInfo * model;

@property(nonatomic, copy)NSString * rec_url;
@property(nonatomic, copy)NSString * source_site;
//@property(nonatomic, copy)FimeMessageSourceViewControllerBlcok  block_blcok;

@end
