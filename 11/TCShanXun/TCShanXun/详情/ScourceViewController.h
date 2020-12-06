//
//  ScourceViewController.h
//  News
//
//  Created by FANTEXIX on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@class BListModel;
@interface ScourceViewController : BViewController

@property(nonatomic, copy)NSString * ID;
@property(nonatomic, strong)BListModel * model;

//@property(nonatomic, copy)NSString * rec_url;
//@property(nonatomic, copy)NSString * source_site;

@end
