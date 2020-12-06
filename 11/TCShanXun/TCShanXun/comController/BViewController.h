//
//  BViewController.h
//  KanKan
//
//  Created by FANTEXIX on 2016/12/13.
//  Copyright © 2016年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BViewController : UIViewController


//navBar
@property(nonatomic, strong)UIView      * navBarView;
@property(nonatomic, strong)UIButton    * navLeftButton;
@property(nonatomic, strong)UIButton    * navRightButton;
@property(nonatomic, strong)UILabel     * navTitleLabel;
@property(nonatomic, strong)UIView      * navShadowLine;

- (void)navLeftMethod:(UIButton *)button;
- (void)navRightMethod:(UIButton *)button;

//---------




/**
 强制转屏
 
 @param toInterfaceOrientation 旋转方向
 */
- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
