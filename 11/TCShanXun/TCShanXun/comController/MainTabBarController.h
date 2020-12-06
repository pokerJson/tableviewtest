//
//  MainTabBarController.h
//
//
//  Created by fantexix on 16/4/11.
//  Copyright © 2016年 fantexix. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HWJTabBarButton : UIButton
@property(nonatomic, copy)NSString * edgeNumber;
@property(nonatomic, assign)BOOL dot;
@end


//---------//

@class MainTabBar;
@protocol MainTabBarDelegate <NSObject>
@optional
- (BOOL)tabBar:(MainTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(MainTabBar *)tabBar didSelectedFromButton:(NSInteger)fromButton toButton:(NSInteger)toButton;
@end

@interface MainTabBar : UIView

@property(nonatomic, weak)id<MainTabBarDelegate> delegate;

@property(nonatomic, strong)NSArray <HWJTabBarButton *> * subViews;
@property(nonatomic, weak)HWJTabBarButton * currentButton;
@property(nonatomic, weak)HWJTabBarButton * refreshButton;

- (void)setTitle:(NSArray *)titleArr normalImage:(NSArray *)normalImage selectedImage:(NSArray *)selectedImage;

@end

//---------//

@class MainTabBarController;
@protocol MainTabBarControllerDelegate <NSObject>
@optional
- (void)tabBarController:(MainTabBarController *)tabBarController refreshAtIndex:(NSInteger)index;
@end

@interface MainTabBarController : UITabBarController

@property(nonatomic, weak)id<MainTabBarControllerDelegate> delegateRefresh;

@property(nonatomic, strong)MainTabBar * myTabBar;

@property(nonatomic, assign)BOOL hideBar;

@end
