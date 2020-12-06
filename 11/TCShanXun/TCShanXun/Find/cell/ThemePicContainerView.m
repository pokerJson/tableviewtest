//
//  ThemePicContainerView.m
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemePicContainerView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "PicInfo.h"

@interface ThemePicContainerView ()


@end

@implementation ThemePicContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.tag = i+250;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
        
        
    }
    
    self.imageViewsArray = [temp copy];
}
- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
#pragma mark 没有图片的话就是设置高度0
    if (_picPathStringsArray.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
#pragma mark 单张图片的话设置宽度高度  这个根据type==3是视频其他不是视频
        NSString *image = [_picPathStringsArray.firstObject small]; //数组中保存的是照片所有信息 取出来small
        if (image) {
            //            itemH = image.size.height / image.size.width * itemW;
            if ([self.type intValue] == 3) {
                //视频
                itemW = kScreenWidth-20;
                itemH = (kScreenWidth-20)*9/16;
            }else{
                //单图的
                itemH = 200;
                PicInfo *Info = (PicInfo *)_picPathStringsArray[0];
                NSString *width = Info.width;
                NSString *height = Info.height;
                float ratio = [height floatValue]/[width floatValue];
                itemW = itemH/ratio;
            }
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    weakObj(self);
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [selfWeak.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
#pragma mark sdwebimage设置网络图片 
        PicInfo *Info = (PicInfo *)obj;
        NSString *urlStr = [Info.small stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:UIImageNamed(@"pic_theme_s")];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        if ([self.type intValue] == 3) {
            //视频的话
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            bt.frame = CGRectMake(kHalf(imageView.width-50), kHalf(imageView.height-50), 50, 50);
            [bt setBackgroundImage:UIImageNamed(@"video_icon_play") forState:UIControlStateNormal];
            [bt addTarget:selfWeak action:@selector(gotoFimdVC) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:bt];
        }
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width_sd = w;
    self.height_sd = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        //单独一张图片的时候 设置它的宽度
        return 120;
    } else {
        //好几张的时候就是平分
        float www = ([UIScreen mainScreen].bounds.size.width - 20 -10)/3;
        CGFloat w = www;
        return w;
    }
}
//每行返回的图片个数 以这个为基数
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    return 3;
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    if ([self.type intValue] == 3) {
        //视频
        self.picBlock(self.index);
    }else{
        //图片
        [self.delegate picXXXXX:tap.view.tag-250];
    }
}
- (void)gotoFimdVC
{
    self.picBlock(self.index);
}
@end
