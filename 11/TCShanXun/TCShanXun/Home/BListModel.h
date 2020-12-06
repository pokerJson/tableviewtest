//
//  BListModel.h
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BListModel : NSObject

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

//id: 2186,
//topicid: 61,
//title: "",
//description: "范丞丞心形头发nine percent 济南#范丞丞[超话]# 回到山东的丞丞 三看 一看过去山东人全是海拔一看过去一个个都这么美再看过去 爱你们 比心@范丞丞Adam0616 范三岁小姐姐的秒拍视频 ​",
//small_pic: "",
//rec_url: "https://m.weibo.cn/status/GoZRxBejA?mblogid=GoZRxBejA&luicode=10000011&lfid=100103type%3D60%26q%3D%E8%8C%83%E4%B8%9E%E4%B8%9E%E5%BF%83%E5%BD%A2%E5%A4%B4%E5%8F%91%26t%3D0",
//pic_urls: "",
//video_url: "",
//source_site: "微博",
//source_id: "4259576758873166",
//posttime: 1531103794,
//type: 0,
//status: 0,
//topicname: "范丞丞心形头发",
//topicicon: "http://yzpaipic.ks3-cn-beijing.ksyun.com/icon/default/16.jpg",
//num_comment: 7,
//num_love: 10,
//showtype: "热门"
//if_love: 0,
//if_fav: 0

