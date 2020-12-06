//
//  HttpRequest.h
//  HttpRequest
//
//  Created by LokTar on 2016/11/1.
//  Copyright © 2016年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpRequest : NSObject


//GET

/**
 URL
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;
/**
 URL,HeaderField
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam headerFieldParam:(NSDictionary *)headerParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;
/**
 URL,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;
/**
 URL,HeaderField,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam headerFieldParam:(NSDictionary *)headerParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;


//POST


/**
 URL
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;
/**
 URL,HeaderField
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam headerFieldParam:(NSDictionary *)headerParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;
/**
 URL,HeaderField,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam headerFieldParam:(NSDictionary *)headerParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;




+ (void)upload_RequestWithURL:(NSString *)URL URLParam:(id)URLParam image:(UIImage *)image name:(NSString *)name filename:(NSString *)filename returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock;


@end
