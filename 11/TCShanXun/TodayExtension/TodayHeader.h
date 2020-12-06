//
//  TodayHeader.h
//  TodayExtension
//
//  Created by FANTEXIX on 2018/9/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#ifndef TodayHeader_h
#define TodayHeader_h

#import "UIImageView+WebCache.h"
#import "HttpRequest.h"

#ifdef  DEBUG
#define MLog(fmt, ...)  {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define NSLog(...)      {NSLog(__VA_ARGS__);}
#else
#define MLog(...)       {}
#define NSLog(...)      {}
#endif

#define IS_IPHONE_X (([UIScreen mainScreen].bounds.size.height == 812.) ? YES : NO)
#define kStatusHeight  (([UIApplication sharedApplication].isStatusBarHidden) ? 0 : (([UIScreen mainScreen].bounds.size.height == 812.) ? 44. : 20.))
#define kTabBarHeight (([UIScreen mainScreen].bounds.size.height == 812.) ? 83. : 49.)


#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kWidth          self.view.bounds.size.width
#define kHeight         self.view.bounds.size.height

#define sWidth          self.bounds.size.width
#define sHeight         self.bounds.size.height

#define kHalf(a)        ((a)/2.0)

#define weakObj(o)      __weak    typeof(o) o##Weak = o;
#define strongObj(o)    __strong  typeof(o) o = o##Weak;


#define Font_Sys(s)         [UIFont systemFontOfSize:s]
#define UIImageNamed(s)     [UIImage imageNamed:s]


#define RGBColor(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RandomColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define UIColorRGB(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]






#endif /* TodayHeader_h */
