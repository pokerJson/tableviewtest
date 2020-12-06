//
//  ThemeModel.h
//  News
//
//  Created by dzc on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeModel : NSObject

@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *category_id;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *description_content;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *num_follow;
@property (nonatomic,strong)NSString *if_guanzhu;

@property(nonatomic,assign)BOOL isLoad;

@end
