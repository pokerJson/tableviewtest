//
//  FindBagTagView.h
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindBagTagView : UIView{
//    CGRect previousFrame ;
//    int totalHeight ;
//    NSMutableArray*_tagArr;

}
@property (nonatomic,assign)CGRect previousFrame;
@property (nonatomic,assign)int totalHeight;
@property (nonatomic,strong)NSMutableArray *tagArr;

@property(nonatomic,retain)UIColor *BbackgroundColor;
/**
 *  设置单一颜色
 */
@property(nonatomic)UIColor*signalTagColor;
/**
 *  回调统计选中tag
 */
@property(nonatomic,copy)void (^didselectItemBlock)(NSString *str);

/**
 *  是否可点击
 */
@property(nonatomic) BOOL canTouch;
/**
 
 *  限制点击个数
 *  0->不限制
 *  不设置此属性默认不限制
 */
@property(nonatomic) NSInteger canTouchNum;

/** 单选模式,该属性的优先级要高于canTouchNum */

@property(nonatomic) BOOL isSingleSelect;
/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;
/**
 *  设置tag之间的距离
 *
 *  @param Margin
 */
-(void)setMarginBetweenTagLabel:(CGFloat)Margin AndBottomMargin:(CGFloat)BottomMargin;

@end
