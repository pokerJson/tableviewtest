//
//  CYAX_SelectView.h
//  选项卡
//
//  Created by CYAX_BOY on 17/5/12.
//  Copyright © 2017年 CYAX_BOY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempScrollview.h"

@class CYAX_SelectView;

/**
 *  设置代理，点击btn去改变scroll的偏移量显示对应内容
 */
@protocol CYAX_SelectViewDelegate <NSObject>

/**
 *  控制器去完成点击选项卡去移动相应tableView或者collectView
 */
@optional
-(void)CYAX_SelectView:(CYAX_SelectView *)selectView moveTableView_or_CollectionVWithTag:(NSInteger)tag;
/**
 *  拖动下面scrollV时候触发的传值代理
 */
-(void)CYAX_SelectViewWhenbottomScrollVDidEndDecelerating;

@end

@interface CYAX_SelectView : UIView<UIScrollViewDelegate>


/**
    存放uiviewcontroller的滑动scrollview
 */
@property (nonatomic,strong)TempScrollview *bgScrollView;

/**
 代理
 */
@property (nonatomic,assign)id<CYAX_SelectViewDelegate>delegate;
/**
 顶部的选项卡
 */
- (void)setTopStatusButtonWithTitles:(NSArray *)titleArray NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor LineColor:(UIColor *)lineColor;



@end
