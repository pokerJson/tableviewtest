//
//  SectorProgressView.h
//  FANTEXIX
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectorProgressView : UIView

/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

/**
 *  扇形颜色
 */
@property(nonatomic,strong)UIColor *progressColor;

@end
