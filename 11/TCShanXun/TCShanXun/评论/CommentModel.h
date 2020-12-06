//
//  CommentModel.h
//  News
//
//  Created by FANTEXIX on 2018/7/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic, copy)NSString * ID;
@property(nonatomic, copy)NSString * uhead;
@property(nonatomic, copy)NSString * uid;
@property(nonatomic, copy)NSString * lastmodified;
@property(nonatomic, copy)NSString * rid;
@property(nonatomic, copy)NSString * has_like;
@property(nonatomic, copy)NSString * uname;
@property(nonatomic, copy)NSString * rrid;
@property(nonatomic, copy)NSString * ctime;
@property(nonatomic, copy)NSString * did;
@property(nonatomic, copy)NSString * like_count;
@property(nonatomic, copy)NSString * reply_count;
@property(nonatomic, copy)NSString * status;
@property(nonatomic, copy)NSString * content;

@property(nonatomic, assign)float contentHeight;
@property(nonatomic, assign)float totalHeight;

@end


//id = 11,
//uhead = "http://yzpaipic.ks3-cn-beijing.ksyun.com/icon/default/17.jpg",
//uid = 10131,
//lastmodified = 1531814748000,
//rid = 0,
//has_like = 0,
//uname = "199****0255",
//rrid = 0,
//ctime = 1531814748000,
//did = 1939,
//like_count = 0,
//reply_count = 0,
//status = 1,
//content = "酷干净利落",
