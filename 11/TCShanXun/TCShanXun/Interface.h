//
//  Interface.h
//  News
//
//  Created by FANTEXIX on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#ifndef Interface_h
#define Interface_h


//登录系统
//1、请求验证码
#define SMSCODE_URL @"http://www.yzpai.cn/news/passport/postSMSCode"
//接口url：http://www.yzpai.cn/news/passport/postSMSCode
//参数：
//phone 手机号
//time: 时间戳
//code 验证码 验证串 md5(phone+time+4c06f52227dbb6a19b4dc4d08ceb3c24)

//2、验证码登录
#define LOGIN_CODE_URL @"http://www.yzpai.cn/news/passport/login"
//URL
//http://www.yzpai.cn/news/passport/login
//HTTP请求方式
//POST
//请求参数
//phone    手机号
//code    验证码

//3、注册
#define REGISTER_URL @"http://www.yzpai.cn/news/passport/reg"
//URL
//http://www.yzpai.cn/news/passport/reg
//HTTP请求方式
//POST
//
//请求参数
//参数    含义
//phone    手机号
//code    验证码
//password    用户密码的md5串
//nick    昵称

//4、刷新token
//接口url：http://www.yzpai.cn/news/passport/updateToken
//参数：
//uid 用户id
//refreshToken 刷新token

//5、第三方登录
#define LOGIN_PARTNER_URL @"http://www.yzpai.cn/news/passport/partnerLogin"
//接口url：http://www.yzpai.cn/news/passport/partnerLogin
//参数：
//partner 第三方名称： QQ WEIXIN WEIBO
//uid 第三方唯一id
//name 昵称
//gender 性别( 0女 1男)
//iconurl 头像文件

//6、密码登录
#define LOGIN_MIMA_URL @"http://www.yzpai.cn/news/passport/loginByPassword"
//接口url：http://www.yzpai.cn/news/passport/loginByPassword
//参数：
//phone 手机号
//password 用户密码的md5值

//7、找回密码第1步
//接口url：http://www.yzpai.cn/news/passport/getPassword
//参数：
//phone 手机号
//time: 时间戳
//code 验证码 验证串 md5(phone+time+4c06f52227dbb6a19b4dc4d08ceb3c24)
//返回成功，回给用户手机下发短信,进入第二步
//8、修改密码第1步
//接口url：http://www.yzpai.cn/news/passport/updatePassword
//参数：
//userid 用户id
//token accessToken
//返回成功，回给用户手机下发短信,进入第二步
//9、找回密码或者修改密码第2步
//接口url：http://www.yzpai.cn/news/passport/setPassword
//参数：
//phone 手机号
//code 短信验证码
//password 用户新密码的md5值

//10、绑定手机号
#define USER_BINDPHONE_URL @"http://www.yzpai.cn/news/passport/bindPhone"
//接口url：http://www.yzpai.cn/news/passport/bindPhone
//参数：
//userid 用户id
//token 验证token
//phone 手机号
//code 手机短信验证码

//11、修改昵称
#define UPDATE_NICK_URL @"http://www.yzpai.cn/news/passport/updateNick"
//接口url：http://www.yzpai.cn/news/passport/updateNick
//参数：
//userid 用户id
//token accessToken
//nick 昵称

//12、修改头像
#define UPDATE_ICON_URL @"http://www.yzpai.cn/news/passport/updateIcon"
//接口url：http://www.yzpai.cn/news/passport/updateIcon
//参数：
//userid 用户id
//token accessToken
//file 头像文件


//13、修改头背景图
#define UPDATE_BG_URL @"http://www.yzpai.cn/news/passport/updateBgpic"
//接口url：http://www.yzpai.cn/news/passport/updateBgpic
//参数：
//userid 用户id
//token accessToken
//file 头像文件

//12、修改信息
#define UPDATE_INFO_URL @"http://www.yzpai.cn/news/passport/updateInfo"
//接口url：http://www.yzpai.cn/news/passport/updateInfo

//参数（信息可以选填，不更新不用提交）：
//userid 用户id
//token accessToken
//nick 昵称
//sex 性别 （男 女 保密)
//age 年龄(数字)
//astro 星座(白羊座、金牛座、双子座、巨蟹座、狮子座、处女座、天秤座、天蝎座、射手座、摩羯座、水瓶座、双鱼座)
//signature 签名

//13、imei登录
//接口url：http://www.yzpai.cn/news/passport/loginByImei
//参数：
//imei 唯一设备号
//14、imei注册
//接口url：http://www.yzpai.cn/news/passport/regByImei
//参数：
//imei 唯一设备号
//nick 昵称


//17、绑定列表
#define USER_BIND_LIST @"http://www.yzpai.cn/news/passport/bindList"
//接口url：http://www.yzpai.cn/news/passport/bindList
//参数：
//userid
//token
//18、绑定第三方
#define USER_BIND_URL @"http://www.yzpai.cn/news/passport/bindPartner"
//接口url：http://www.yzpai.cn/news/passport/bindPartner
//参数：
//userid
//token
//partner 第三方名称： QQ WEIXIN WEIBO
//uid 第三方唯一id
//19、解绑第三方
#define USER_UNBIND_URL @"http://www.yzpai.cn/news/passport/unBindPartner"
//接口url：http://www.yzpai.cn/news/passport/unBindPartner
//参数：
//userid
//token
//partner 第三方名称： QQ WEIXIN WEIBO

//20、更换手机号1 发送旧版手机短信
#define CHARGE_PHONE_1 @"http://www.yzpai.cn/news/passport/changePhone1"
//接口url：http://www.yzpai.cn/news/passport/changePhone1
//参数：
//userid
//token
//21、更换手机号2 验证旧手机号
#define CHARGE_PHONE_2 @"http://www.yzpai.cn/news/passport/changePhone2"
//接口url：http://www.yzpai.cn/news/passport/changePhone2
//参数：
//userid
//token
//code 短信验证
//返回参数： sign 给下面的接口使用

//22、更换手机号3 更新新手机号
#define CHARGE_PHONE_3 @"http://www.yzpai.cn/news/passport/changePhone3"
//接口url：http://www.yzpai.cn/news/passport/changePhone3
//参数：
//userid
//token
//phone 新手机号
//code 短信验证码.发送使用接口1
//sign 旧手机验证成功返回的sign参数


//23、找回密码第1步
#define FORGOT_SENDCODE_URL @"http://www.yzpai.cn/news/passport/getPassword"
//接口url：http://www.yzpai.cn/news/passport/getPassword
//参数：
//phone 手机号
//time: 时间戳
//code 验证码 验证串 md5(phone+time+4c06f52227dbb6a19b4dc4d08ceb3c24)
//返回成功，回给用户手机下发短信,进入第2步

//24、找回密码第2步
#define FORGOT_VERI_URL @"http://www.yzpai.cn/news/passport/getPassword2"
//接口url：http://www.yzpai.cn/news/passport/getPassword2
//参数：
//phone 手机号
//code 短信验证码
//成功返回sign参数，进入第3步

//25、修改密码第1步
#define MODIMIMA_SENDCODE_URL @"http://www.yzpai.cn/news/passport/updatePassword"
//接口url：http://www.yzpai.cn/news/passport/updatePassword
//参数：
//userid 用户id
//token accessToken
//返回成功，回给用户手机下发短信,进入第2步

//26、修改密码第2步
#define MODIMIMA_VERI_URL @"http://www.yzpai.cn/news/passport/updatePassword2"
//接口url：http://www.yzpai.cn/news/passport/updatePassword2
//参数：
//userid 用户id
//token accessToken
//code 短信验证码
//返回成功，sign参数，进入第3步

//27、找回密码或者修改密码第3步
#define SET_PASSWORD_URL @"http://www.yzpai.cn/news/passport/setPassword"
//接口url：http://www.yzpai.cn/news/passport/setPassword
//参数：
//userid 用户uid (修改密码提交)
//phone 手机号(找回密码密码提交)
//sign 第2步返回的参数
//password 用户新密码的md5值



//主要
//1、资讯
#define INDEX_NEWS_URL @"http://www.yzpai.cn/news/index/news"
//接口url：http://www.yzpai.cn/news/index/news

//1、推荐
#define INDEX_RECOMMEND_URL @"http://www.yzpai.cn/news/index/recommend"
//接口url：http://www.yzpai.cn/news/index/recommend

//2、关注
#define INDEX_FOLLOW_URL @"http://www.yzpai.cn/news/index/follow"
//接口url：http://www.yzpai.cn/news/index/follow

//3、分类
#define CATEGORY_LIST_URL @"http://www.yzpai.cn/news/category/list"
//接口url：http://www.yzpai.cn/news/category/list



//主题
#define TOPIC_INFO_URL @"http://www.yzpai.cn/news/topic/index"
//1、主题信息
//接口url：http://www.yzpai.cn/news/topic/index
//* 参数：
//topicid topicid

//2、顶部滑动推荐主题
#define TOP_TUIJIAN @"http://www.yzpai.cn/news/topic/retop"
//接口url：http://www.yzpai.cn/news/topic/retop

//3、主题下的消息列表
#define TOPIC_NEWS_URL @"http://www.yzpai.cn/news/topic/news"
//接口url：http://www.yzpai.cn/news/topic/news
//* 参数：
//topicid topicid
//p 第几页 默认1
//n 每页条数 默认10

//4、主题列表
#define TOPIC_C_LIST_URL @"http://www.yzpai.cn/news/topic/list"
//接口url：http://www.yzpai.cn/news/topic/list
//* 参数：
//c 分类id

//5、关注主题
#define FOLLOW_TOPIC_URL @"http://www.yzpai.cn/news/topic/follow"
//接口url：http://www.yzpai.cn/news/topic/follow
//* 参数：
//userid 用户id
//token accessToken
//topicid 主题id

//6、关注多条主题
//接口url：http://www.yzpai.cn/news/topic/followMulti
//* 参数：
//userid 用户id
//token accessToken
//topicids 多个主题id，中间用“,”逗号隔开

//7、取消关注主题
#define UNFOLLOW_TOPIC_URL @"http://www.yzpai.cn/news/topic/unfollow"
//接口url：http://www.yzpai.cn/news/topic/unfollow
//* 参数：
//userid 用户id
//token accessToken
//topicid 主题id

//8、收藏消息
#define FAVO_URL @"http://www.yzpai.cn/news/article/fav"
//接口url：http://www.yzpai.cn/news/article/fav
//* 参数：
//userid 用户id
//token accessToken
//newsid 消息id

//9、取消收藏消息
#define UNFAVO_URL @"http://www.yzpai.cn/news/article/unfav"
//接口url：http://www.yzpai.cn/news/article/unfav
//* 参数：
//userid 用户id
//token accessToken
//newsid 消息id

//10、首次启动推荐主题
#define TOPIC_RECOMMEND_URL @"http://www.yzpai.cn/news/index/newRecommend"
//接口url：http://www.yzpai.cn/news/index/newRecommend


//5、单个消息
#define NEWS_INFO_URL @"http://www.yzpai.cn/news/article/show"
//接口url：http://www.yzpai.cn/news/article/show
//参数：
//id 消息id
//userid 用户id，判断是否收藏使用



//3、点赞消息
#define LIKE_TOPIC_URL @"http://www.yzpai.cn/news/article/love"
//接口url：http://www.yzpai.cn/news/article/love
//* 参数：
//userid 用户id
//token accessToken
//newsid 消息id

//4、取消点赞消息
#define UNLIKE_TOPIC_URL @"http://www.yzpai.cn/news/article/unlove"
//接口url：http://www.yzpai.cn/news/article/unlove
//* 参数：
//userid 用户id
//token accessToken
//newsid 消息id



//个人
//1、我的收藏
#define FAVO_LIST_URL @"http://www.yzpai.cn/news/my/myfav"
//接口url：http://www.yzpai.cn/news/my/myfav
//参数：
//userid 用户id
//token accessToken
//p 第几页 默认1
//n 每页条数 默认10

//2、我的主题
#define FOLLOW_TOPIC_LIST_URL @"http://www.yzpai.cn/news/my/myfollowTopic"
//接口url：http://www.yzpai.cn/news/my/myfollowTopic
//参数：
//userid 用户id
//token accessToken
//p 第几页 默认1
//n 每页条数 默认10

//3、关注用户
#define FOLLOW_PERSON_URL @"http://www.yzpai.cn/news/my/followUser"
//接口url：http://www.yzpai.cn/news/my/followUser
//* 参数：
//userid 用户id
//token accessToken
//uid 关注的uid

//4、取消关注用户
#define UNFOLLOW_PERSON_URL @"http://www.yzpai.cn/news/my/unfollowUser"
//接口url：http://www.yzpai.cn/news/my/unfollowUser
//* 参数：
//userid 用户id
//token accessToken
//uid 关注的uid

//搜索
//1、综合搜索
//接口url:http://www.yzpai.cn/news/so/all
//请求方式：get post
//请求参数：
//keyword 搜索关键词
//userid 用户id
//token accessToken
//2、主题搜素
#define SEARCH_THEME @"http://www.yzpai.cn/news/so/topic"
//接口url:http://www.yzpai.cn/news/so/topic
//请求方式：get post
//请求参数：
//keyword 搜索关键词
//p 第几页 默认1
//n 每页条数 默认10
//userid 用户id
//token accessToken
//3、消息搜索
#define SEARCH_MESSAGE @"http://www.yzpai.cn/news/so/news"
//接口url:http://www.yzpai.cn/news/so/news
//请求方式：get post
//请求参数：
//keyword 搜索关键词
//p 第几页 默认1
//n 每页条数 默认10
//userid 用户id
//token accessToken
//4、用户搜索
#define SEARCH_USER @"http://www.yzpai.cn/news/so/user"
//接口url:http://www.yzpai.cn/news/so/user
//请求方式：get post
//请求参数：
//keyword 搜索关键词
//p 第几页 默认1
//n 每页条数 默认10
//userid 用户id
//token accessToken



//用户播客系统
//1、主页
#define BOKE_URL @"http://www.yzpai.cn/news/boke/index"
//接口url:http://www.yzpai.cn/news/boke/index
//请求方式：post
//请求参数：
//uid 用户uid

//2、用户创建的主题
//接口url:http://www.yzpai.cn/news/boke/topic
//请求方式：post
//请求参数：
//uid 用户uid
//3、用户关注的主题
#define BOKE_TOPIC_URL @"http://www.yzpai.cn/news/boke/followTopic"
//接口url:http://www.yzpai.cn/news/boke/followTopic
//请求方式：post
//请求参数：
//uid 用户uid

//4、关注播主的人
#define BOKE_FOLLOWING_URL @"http://www.yzpai.cn/news/boke/followings"
//接口url:http://www.yzpai.cn/news/boke/followings
//请求方式：post
//请求参数：
//uid 用户uid
//5、播主的粉丝
#define BOKE_FOLLOWER_URL @"http://www.yzpai.cn/news/boke/followers"
//接口url:http://www.yzpai.cn/news/boke/followers
//请求方式：post
//请求参数：
//uid 用户uid



//评论系统
//1、添加评论
#define COMMENT_ADD_URL @"http://www.yzpai.cn/news/comment/create"
//接口url:http://www.yzpai.cn/news/comment/create
//请求方式：post
//请求参数：
//did 评论对象id
//content 评论内容
//userid 用户id
//token accessToken

//2、回复评论
//比添加评论多传入以下参数：
//rid 回复id

//3、获取视频评论数
#define COMMENT_NUM_URL @"http://www.yzpai.cn/news/comment/count"
//请求url:http://www.yzpai.cn/news/comment/count
//请求参数：
//did 评论对象的id，多个逗号分割

//4、获取视频评论列表
#define COMMENT_LIST_URL @"http://www.yzpai.cn/news/comment/list"
//请求url:http://www.yzpai.cn/news/comment/list
//请求参数：
//did 评论对象id
//imei 设备号
//userid 用户id (未登录不传入)
//pn 当前页 默认1
//ps 页尺寸 默认 20
//应答参数
//cid 评论id
//uid 用户id
//uname 用户昵称
//uhead 用户头像
//content 评论内容
//like_count 点赞次数
//reply_count 回复次数
//has_like 是否已经点赞
//ctime 评论时间


//4、评论点赞
#define LIKE_COMMENT_URL @"http://www.yzpai.cn/news/comment/like"
//接口url:http://www.yzpai.cn/news/comment/like
//请求参数
//userid 用户id
//token accessToken
//cid 评论id
//应答参数：
//count 点赞总量


//5、删除评论
#define DELETE_COMMENT_URL @"https://www.yzpai.cn/news/comment/delete"
//请求url:https://www.yzpai.cn/news/comment/delete
//请求方式：post
//请求参数：
//cid 评论id
//userid 用户id
//token accessToken


//动态
//1、动态列表
#define NOTI_LIST_URL @"http://www.yzpai.cn/news/message/index"
//接口url：http://www.yzpai.cn/news/message/index
//* 参数：
//userid 用户id
//token accessToken


//2、是否有动态
#define NOTI_MESSAGE_URL @"http://www.yzpai.cn/news/message/getNewCount"
//接口url：http://www.yzpai.cn/news/message/getNewCount
//参数：
//userid 用户id
//token accessToken
//3、关注的话题是否有更新
#define NOTI_FOLLOWNEWS_URL @"http://www.yzpai.cn/news/my/myfollowNewsCount"
//接口url：http://www.yzpai.cn/news/my/myfollowNewsCount
//参数：
//userid 用户id
//token accessToken



//web页面
//1、分享页
#define SHARE_NEWS_URL @"http://www.yzpai.cn/news/web/article?id=%@"
//接口url：http://www.yzpai.cn/news/web/article?id=%@
//参数：
//id 消息id
#define SHARE_TOPIC_URL @"http://www.yzpai.cn/news/web/topic?id=%@"
//接口url：http://www.yzpai.cn/news/web/topic?id=xxxx
//参数：
//id 主题id

//2、协议
#define LICENSE_URL @"http://www.yzpai.cn/news/web/license"
//接口url：http://www.yzpai.cn/news/web/license


//
#define REPORT_URL @"http://www.yzpai.cn/news/other/jubao?id=%@"
//接口url:
//http://www.yzpai.cn/news/other/jubao?id=xxx


#define USER_ACTION_URL @"http://www.yzpai.cn/news/actionlog/post"
//接口url：
//参数：
//play 行为 1 点击消息
//did 动作操作对象id。点击消息发送消息id
//ver 1
//uid 用户id.未登录用户发唯一设备号
//uploadtime：时间戳


//反馈信息
#define USER_FEEDBACK_URL @"http://www.yzpai.cn/news/other/feedback"
//接口url：http://www.yzpai.cn/news/other/feedback
//参数：
//contact 联系方式 手机邮箱qq等
//content 详细反馈信息

#define MY_HISTORY_URL @"http://www.yzpai.cn/news/my/myhistory"
//接口url：http://www.yzpai.cn/news/my/myhistory
//参数：
//userid 用户id
//token accessToken
//p 第几页 默认1
//n 每页条数 默认10


//5、友盟设备号上报接口
#define DEVICETOKEN @"http://www.yzpai.cn/news/other/updateDeviceToken"
//接口url：http://www.yzpai.cn/news/other/updateDeviceToken
//参数：
//DeviceToken 友盟消息推送服务对设备的唯一标识友盟唯一设备号
//userid 用户userid，未登录不发送



#endif /* Interface_h */
