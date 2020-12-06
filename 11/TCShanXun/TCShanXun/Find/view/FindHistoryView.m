//
//  FindHistoryView.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindHistoryView.h"

#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface FindHistoryView(){
    CGRect previousFrame;
    int totalHeight;
    int tmp;
}
@end

@implementation FindHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        tmp = 0;
    }
    return self;
}
 - (void)setHistyARR:(NSMutableArray *)histyARR
{
    _histyARR = histyARR;
    for (long i = _histyARR.count-1; i<_histyARR.count; i--) {
        NSString *string = _histyARR[i];
        if (string.length==0) {
            continue;
        }
        CGSize Size_str = [self calculateStringWith:string];
        Size_str.width += 7*5;// 宽度
        Size_str.height += 3*3+5;
        
        float btWifth;
        if (Size_str.width > 100) {
            btWifth = 100+20;
        }else{
            btWifth = Size_str.width;
        }
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [tagBtn setTitleColor:R_G_B_16(0x818181) forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:string forState:UIControlStateNormal];
        [tagBtn setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]];
        tagBtn.layer.cornerRadius=5;
        tagBtn.clipsToBounds=YES;
        tagBtn.tag = 400+i;
        tagBtn.userInteractionEnabled=YES;
        
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + btWifth +  10+10> self.bounds.size.width) {
            tmp++;
            newRect.origin = CGPointMake(10,previousFrame.origin.y + Size_str.height + 10);
            totalHeight +=Size_str.height*2-3*3;
            if (tmp == 2) {
                return;
            }
            
        }
        else {
            if (tmp == 0) {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + 10, 5);
            }else{
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + 10, previousFrame.origin.y);
            }
        }
        
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height];
        [self addSubview:tagBtn];
    }
}
-(void)tagBtnClick:(UIButton*)button{
    NSLog(@"_histyARR[button.tag-20000]==%@",_histyARR[button.tag-400]);
    self.didselectItemBlock(_histyARR[button.tag-400]);
    
}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
    self.h_height = tempFrame.size.height;
}

//
- (CGSize)calculateStringWith:(NSString *)str
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0],NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(self.bounds.size.width-30, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil].size;;
    
    return textSize;
    
}

@end
