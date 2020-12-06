//
//  HttpRequest.m
//  HttpRequest
//
//  Created by LokTar on 2016/11/1.
//  Copyright © 2016年 fantexix Inc. All rights reserved.
//

#import "HttpRequest.h"

#define STR_DATA(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation HttpRequest

/**
 URL
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    [self get_RequestWithURL:URL URLParam:URLParam headerFieldParam:nil cachePolicy:NSURLRequestUseProtocolCachePolicy returnData:returnBlock];
}
/**
 URL,HeaderField
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam headerFieldParam:(NSDictionary *)headerParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    [self get_RequestWithURL:URL URLParam:URLParam headerFieldParam:headerParam cachePolicy:NSURLRequestUseProtocolCachePolicy returnData:returnBlock];
}
/**
 URL,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    [self get_RequestWithURL:URL URLParam:URLParam headerFieldParam:nil cachePolicy:cachePolicy returnData:returnBlock];
}
/**
 URL,HeaderField,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)get_RequestWithURL:(NSString *)URL URLParam:(NSDictionary *)URLParam headerFieldParam:(NSDictionary *)headerParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    
    NSString * urlStr = nil;
    //接口参数拼接
    if (URLParam != nil) {
        NSArray * keyArr = [URLParam allKeys];
        NSArray * paramArr = [URLParam allValues];
        NSMutableArray * param = [NSMutableArray array];
        for (int i = 0; i < keyArr.count; i++) {
            NSString * str = [NSString stringWithFormat:@"%@=%@",keyArr[i],paramArr[i]];
            [param addObject:str];
        }
        NSString * paramStr = [param componentsJoinedByString:@"&"];
        
        if ([URL rangeOfString:@"?"].location == NSNotFound) {
            urlStr = [NSString stringWithFormat:@"%@?%@",URL,paramStr];
        }else {
            urlStr = [NSString stringWithFormat:@"%@&%@",URL,paramStr];
        }
    }else {
        urlStr = URL;
    }
    //接口编码
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

#if DEBUG
    printf("\n   >>>>  : %s\n\n",[urlStr UTF8String]);
#endif

    
    //可变请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:cachePolicy timeoutInterval:10.0f];
    //请求方法
    request.HTTPMethod = @"GET";
    //请求头参数
    if (headerParam != nil) {
        NSArray * keyArr = [headerParam allKeys];
        NSArray * paramArr = [headerParam allValues];
        for (int i = 0; i < keyArr.count; i++) {
            [request setValue:paramArr[i] forHTTPHeaderField:keyArr[i]];
        }
    }
    //数据任务
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                __weak typeof(error) errorWeak = error;
                returnBlock(nil,nil,errorWeak);
            }else {
                @try {
                    __weak typeof(response) responseWeak = response;
                    __weak typeof(data) dataWeak = data;
                    returnBlock(responseWeak,dataWeak,nil);
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }];
    }] resume];

}



/**
 URL
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    [self post_RequestWithURL:URL URLParam:URLParam headerFieldParam:nil cachePolicy:NSURLRequestUseProtocolCachePolicy returnData:returnBlock];
}
/**
 URL,HeaderField
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam headerFieldParam:(NSDictionary *)headerParam returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    [self post_RequestWithURL:URL URLParam:URLParam headerFieldParam:headerParam cachePolicy:NSURLRequestUseProtocolCachePolicy returnData:returnBlock];
}
/**
 URL,HeaderField,CachePolicy
 
 @param URL 数据接口
 @param URLParam 接口参数
 @param headerParam 请求参数
 @param cachePolicy 缓存策略
 @param returnBlock 网络数据(接口响应,接口数据,错误)
 */
+ (void)post_RequestWithURL:(NSString *)URL URLParam:(id)URLParam headerFieldParam:(NSDictionary *)headerParam cachePolicy:(NSURLRequestCachePolicy)cachePolicy returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString * paramStr = nil;
    //接口参数拼接
    if (URLParam != nil ) {
        
        if ([URLParam isKindOfClass:[NSDictionary class]]) {
            NSArray * keyArr = [URLParam allKeys];
            NSArray * paramArr = [URLParam allValues];
            NSMutableArray * param = [NSMutableArray array];
            for (int i = 0; i < keyArr.count; i++) {
                NSString * str = [NSString stringWithFormat:@"%@=%@",keyArr[i],paramArr[i]];
                [param addObject:str];
            }
            paramStr = [param componentsJoinedByString:@"&"];
            //接口参数编码
            paramStr = [paramStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        if ([URLParam isKindOfClass:[NSString class]]) {
            paramStr = URLParam;
        }
    }
    
#if DEBUG
    NSString * urlStr = nil;
    
    if (paramStr) {
        
        if ([URL rangeOfString:@"?"].location == NSNotFound) {
            urlStr = [NSString stringWithFormat:@"%@?%@",URL,paramStr];
        }else {
            urlStr = [NSString stringWithFormat:@"%@&%@",URL,paramStr];
        }
        printf("\n   >>>>  : %s\n\n",[URL UTF8String]);
        printf("\n   >>>>  : %s\n\n",[paramStr UTF8String]);
        printf("\n   >>>>  : %s\n\n",[urlStr UTF8String]);
    }else {
        
        urlStr = URL;
        printf("\n   >>>>  : %s\n\n",[URL UTF8String]);
    }

#endif
    

    //可变请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URL] cachePolicy:cachePolicy timeoutInterval:20.0f];
    //请求方法
    request.HTTPMethod = @"POST";
    //参数编码
    if (paramStr) {
         request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    //请求头参数
    if (headerParam != nil) {
        NSArray * keyArr = [headerParam allKeys];
        NSArray * paramArr = [headerParam allValues];
        for (int i = 0; i < keyArr.count; i++) {
            [request setValue:paramArr[i] forHTTPHeaderField:keyArr[i]];
        }
    }
    //数据任务
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                __weak typeof(error) errorWeak = error;
                returnBlock(nil,nil,errorWeak);
            }else {
                @try {
                    __weak typeof(response) responseWeak = response;
                    __weak typeof(data) dataWeak = data;
                    returnBlock(responseWeak,dataWeak,nil);
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }];
    }] resume];

}





+ (void)upload_RequestWithURL:(NSString *)URL URLParam:(id)URLParam image:(UIImage *)image name:(NSString *)name filename:(NSString *)filename returnData:(void(^)(NSURLResponse * urlResponse, NSData * resultData, NSError * error))returnBlock {
    
    NSString * urlStr = nil;
    //接口参数拼接
    if (URLParam != nil) {
        NSArray * keyArr = [URLParam allKeys];
        NSArray * paramArr = [URLParam allValues];
        NSMutableArray * param = [NSMutableArray array];
        for (int i = 0; i < keyArr.count; i++) {
            NSString * str = [NSString stringWithFormat:@"%@=%@",keyArr[i],paramArr[i]];
            [param addObject:str];
        }
        NSString * paramStr = [param componentsJoinedByString:@"&"];
        
        if ([URL rangeOfString:@"?"].location == NSNotFound) {
            urlStr = [NSString stringWithFormat:@"%@?%@",URL,paramStr];
        }else {
            urlStr = [NSString stringWithFormat:@"%@&%@",URL,paramStr];
        }
    }else {
        urlStr = URL;
    }
    //接口编码
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
#if DEBUG
    printf("\n   >>>>  : %s\n\n",[urlStr UTF8String]);
#endif
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.];
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data;boundary=FANTEXIX" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData * body = [[NSMutableData alloc]init];
    
    [body appendData:STR_DATA(@"--FANTEXIX\r\n")];

    NSString * fileInfo = [NSString stringWithFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"\r\n",name,filename];
    [body appendData:STR_DATA(fileInfo)];
    
    NSString *fileType = [NSString stringWithFormat:@"Content-Type:image/png\r\n\r\n"];
    [body appendData:STR_DATA(fileType)];
    
    NSData * fileData = UIImagePNGRepresentation(image);
    [body appendData:fileData];
    [body appendData:STR_DATA(@"\r\n")];
    
    [body appendData:STR_DATA(@"--FANTEXIX--\r\n")];

    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                __weak typeof(error) errorWeak = error;
                returnBlock(nil,nil,errorWeak);
            }else {
                @try {
                    __weak typeof(response) responseWeak = response;
                    __weak typeof(data) dataWeak = data;
                    returnBlock(responseWeak,dataWeak,nil);
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }];
    }] resume];
    
}




@end
