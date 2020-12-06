//
//  UMengShare.m
//  News
//
//  Created by FANTEXIX on 2018/7/10.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UMengShare.h"


@interface UMengShare ()

@property(nonatomic, weak)UIViewController * vc;

@property(nonatomic, strong)BListModel * shareModel;
@property(nonatomic, strong)TopicModel * topicModel;

@end

@implementation UMengShare

static id _instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)shareWithModel:(BListModel *)model atIndex:(int)index viewController:(UIViewController *)viewController {
    
    _vc = viewController;
    _shareModel = model;
    
    switch (index) {
        case 0: {
            //NSLog(@"制作卡片");
        }
            break;
        case 1: {
            //NSLog(@"分享朋友圈");
            [self sharePlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case 2: {
            //NSLog(@"分享微信");
            [self sharePlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case 3: {
            //NSLog(@"分享QQ空间");
            [self sharePlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case 4: {
            //NSLog(@"分享QQ");
            [self sharePlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case 5: {
            //NSLog(@"分享微博");
            [self sharePlatformType:UMSocialPlatformType_Sina];
        }
            break;
        case 6: {
            NSLog(@"复制链接");
            UIPasteboard* pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:_shareModel.rec_url];
            [KKHUD showMiddleWithStatus:@"复制成功"];
        }
            break;
        case 7: {
            //NSLog(@"浏览器");
            [self openSomethingWithCommand:_shareModel.rec_url];
        }
            break;
        case 8: {
            NSLog(@"更多");
            
            NSString * text = nil;
            
            if (![_shareModel.title isEqualToString:@""]) {
                text = _shareModel.title;
            }else {
                text = _shareModel.des;
            }
            
            UIImage * image = UIImageNamed(@"all_topics_bg");
            NSURL * url = [NSURL URLWithString:_shareModel.rec_url];
            NSArray * activityItems = nil;
            if (image) {
                activityItems = @[text,image,url];
            }else {
                activityItems = @[text,url];
            }
            UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [viewController presentViewController:activityViewController animated:YES completion:nil];
            
        }
            break;
            
            
        default:
            break;
    }
    
}


- (void)openSomethingWithCommand:(NSString *)command {
    //当前程序
    UIApplication * app = [UIApplication sharedApplication];
    //命令
    NSURL * url = [NSURL URLWithString:command];
    
    if ([app canOpenURL:url]) {
        //执行命令
        [app openURL:url];
    }else {
        //不能执行
    }
}


- (void)sharePlatformType:(UMSocialPlatformType)platformType {
    
    UMSocialMessageObject * messageObject = [UMSocialMessageObject messageObject];
    NSString * des = [NSString stringWithFormat:@"来自「%@」",_shareModel.topicname];
    UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareModel.content descr:des thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareModel.topicicon]]];
    shareObject.webpageUrl = [NSString stringWithFormat:SHARE_NEWS_URL,_shareModel.ID];
    
    messageObject.shareObject = shareObject;
    
    
    weakObj(self);
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_vc completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"分享成功");
            //[FantexHUD showMiddleWithStatus:@"分享成功"];
        
        }else{
            NSLog(@"分享失败");
            //[FantexHUD showMiddleWithStatus:@"分享失败"];
            NSLog(@"error: %@",error);
        }
    }];
    
    
    [[UserActionReport shared] sharePost:selfWeak.shareModel.ID ext:_shareModel.ext];

}


- (void)authWithPlatform:(UMSocialPlatformType)platformType {
    __weak typeof(self) selfWeak = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        @try {
            __weak typeof(result) resultWeak = result;
            __weak typeof(result) errorWeak = error;
            if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(umengShare:authWithPlatform:result:error:)]) {
                [selfWeak.delegate umengShare:selfWeak authWithPlatform:platformType result:resultWeak error:errorWeak];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }];
}
- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType {
    __weak typeof(self) selfWeak = self;
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        @try {
            __weak typeof(result) resultWeak = result;
            __weak typeof(result) errorWeak = error;
            if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(umengShare:cancelAuthWithPlatform:result:error:)]) {
                [selfWeak.delegate umengShare:selfWeak cancelAuthWithPlatform:platformType result:resultWeak error:errorWeak];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }];
}

- (void)shareTopicWithModel:(TopicModel *)model atIndex:(int)index viewController:(UIViewController *)viewController {
    
    _vc = viewController;
    _topicModel = model;
    
    switch (index) {
        case 0: {
            //NSLog(@"制作卡片");
        }
            break;
        case 1: {
            //NSLog(@"分享朋友圈");
            [self shareTopicPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case 2: {
            //NSLog(@"分享微信");
            [self shareTopicPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case 3: {
            //NSLog(@"分享QQ空间");
            [self shareTopicPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case 4: {
            //NSLog(@"分享QQ");
            [self shareTopicPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case 5: {
            //NSLog(@"分享微博");
            [self shareTopicPlatformType:UMSocialPlatformType_Sina];
        }
            break;
        case 6: {
            NSLog(@"复制链接");
            UIPasteboard* pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:[NSString stringWithFormat:SHARE_TOPIC_URL,_topicModel.ID]];
            [KKHUD showMiddleWithStatus:@"复制成功"];
        }
            break;
        case 7: {
            //NSLog(@"浏览器");
            [self openSomethingWithCommand:[NSString stringWithFormat:SHARE_TOPIC_URL,_topicModel.ID]];
        }
            break;
        case 8: {
            NSLog(@"更多");
            
            NSString * text = nil;
            
            text = _topicModel.name;
            
            UIImage * image = UIImageNamed(@"all_topics_bg");
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:SHARE_TOPIC_URL,_topicModel.ID]];
            NSArray * activityItems = nil;
            if (image) {
                activityItems = @[text,image,url];
            }else {
                activityItems = @[text,url];
            }
            UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [viewController presentViewController:activityViewController animated:YES completion:nil];
            
        }
            break;
            
            
        default:
            break;
    }
    
}


- (void)shareTopicPlatformType:(UMSocialPlatformType)platformType {
    
    UMSocialMessageObject * messageObject = [UMSocialMessageObject messageObject];
    NSString * des = [NSString stringWithFormat:@"来自「%@」",_topicModel.name];
    UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:_topicModel.des descr:des thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:_topicModel.icon]]];
    shareObject.webpageUrl = [NSString stringWithFormat:SHARE_TOPIC_URL,_topicModel.ID];
    
    messageObject.shareObject = shareObject;
    
    
    //weakObj(self);
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_vc completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"分享成功");
            //[FantexHUD showMiddleWithStatus:@"分享成功"];
            
        }else{
            NSLog(@"分享失败");
            //[FantexHUD showMiddleWithStatus:@"分享失败"];
            NSLog(@"error: %@",error);
        }
    }];
    
    
    //[[UserActionReport shared] sharePost:selfWeak.shareModel.ID ext:_shareModel.ext];
    
}



@end
