//
//  TodayModel.h
//  TodayExtension
//
//  Created by FANTEXIX on 2018/9/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayModel : NSObject

@property(nonatomic, copy)NSString * ID;
@property(nonatomic, copy)NSString * topicid;
@property(nonatomic, copy)NSString * title;
@property(nonatomic, copy)NSString * des;
@property(nonatomic, copy)NSString * content;
@property(nonatomic, copy)NSString * small_pic;
@property(nonatomic, copy)NSString * rec_url;
@property(nonatomic, copy)NSString * pic_urls;
@property(nonatomic, strong)NSArray * picsArr;
@property(nonatomic, copy)NSString * video_url;
@property(nonatomic, copy)NSString * source_site;
@property(nonatomic, copy)NSString * source_id;
@property(nonatomic, copy)NSString * posttime;
@property(nonatomic, copy)NSString * type;
@property(nonatomic, copy)NSString * status;
@property(nonatomic, copy)NSString * topicname;
@property(nonatomic, copy)NSString * topicicon;
@property(nonatomic, copy)NSString * num_comment;
@property(nonatomic, copy)NSString * num_love;
@property(nonatomic, copy)NSString * showtype;
@property(nonatomic, copy)NSString * if_love;
@property(nonatomic, copy)NSString * if_fav;
@property(nonatomic, copy)NSString * if_guanzhu;

@property(nonatomic, copy)NSString * ext;

@property(nonatomic, copy)NSString * dataType; //@"0":首页 //@"1":关注页 //@"2":话题 //@"3":收藏



@property(nonatomic, assign)float titleWidth;
@property(nonatomic, assign)float contentHeight;
@property(nonatomic, assign)float imageHeight;
@property(nonatomic, assign)float videoHeight;
@property(nonatomic, assign)float totalHeight;


@end
