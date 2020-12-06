//
//  MainTabBarController.m
//
//
//  Created by fantexix on 16/4/11.
//  Copyright © 2016年 fantexix. All rights reserved.
//

#import "MainTabBarController.h"
#import "BNavigationController.h"


@interface BaseTabBar : UITabBar
@property(nonatomic, assign)UIEdgeInsets oldSafeAreaInsets;
@end
@implementation BaseTabBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _oldSafeAreaInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _oldSafeAreaInsets = UIEdgeInsetsZero;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (!UIEdgeInsetsEqualToEdgeInsets(_oldSafeAreaInsets, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];
        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    if (@available(iOS 11.0, *)) {
        float bottomInset = self.safeAreaInsets.bottom;
        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
            size.height += bottomInset;
        }
    }
    
    return size;
}


- (void)setFrame:(CGRect)frame {
    if (self.superview) {
        if (frame.origin.y + frame.size.height < self.superview.frame.size.height) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
    }
    [super setFrame:frame];
}

@end

///


@interface HWJTabBarButton ()

@property(nonatomic, strong)UILabel * textLabel;
@property(nonatomic, strong)UILabel * edgeNumLabel;
@property(nonatomic, strong)UIView * dotView;

@end

@implementation HWJTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
        
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)addSubviews {
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.textAlignment = 1;
    [self addSubview:_textLabel];
    
    _edgeNumLabel = [[UILabel alloc]init];
    _edgeNumLabel.backgroundColor = RGBColor(255, 59, 48);
    _edgeNumLabel.textAlignment = 1;
    _edgeNumLabel.textColor = [UIColor whiteColor];
    _edgeNumLabel.font = [UIFont systemFontOfSize:9];
    _edgeNumLabel.layer.borderWidth = 1;
    _edgeNumLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _edgeNumLabel.layer.cornerRadius = 7.5f;
    _edgeNumLabel.layer.masksToBounds = YES;
    [self addSubview:_edgeNumLabel];
    
    _dotView = [[UIView alloc]init];
    _dotView.backgroundColor = RGBColor(242, 107, 105);
    _dotView.hidden = YES;
    [self addSubview:_dotView];
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _textLabel.textColor = [self titleColorForState:self.state];
}

- (void)setEdgeNumber:(NSString *)edgeNumber {
    _edgeNumber = edgeNumber;
    [self setNeedsLayout];
}

- (void)setDot:(BOOL)dot {
    _dot = dot;
    _dotView.hidden = !dot;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textLabel.textColor = [self titleColorForState:self.state];
    _textLabel.frame = [self titleRectForContentRect:self.bounds];

    if (_edgeNumber == nil || [_edgeNumber isEqualToString:@"0"]) {
        _edgeNumLabel.frame = CGRectMake(0.54*self.bounds.size.width, 0.05*self.bounds.size.height, 0, 0);
    }else {
        _edgeNumLabel.text = _edgeNumber;
        _edgeNumLabel.frame = CGRectMake(0.54*self.bounds.size.width, 0.05*self.bounds.size.height, 15, 15);
    }
    _dotView.frame = CGRectMake(0.57*self.bounds.size.width, 0.1*self.bounds.size.height, 8, 8);
    _dotView.layer.cornerRadius = 4;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake((width-0.5*height)/2.0, 0.1*height, 0.5*height, 0.5*height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    float width = contentRect.size.width;
    float height = contentRect.size.height;
    return CGRectMake(0, 0.7*height, width, 0.25*height);
}

@end



#define tBegin 5000
@interface MainTabBar ()<MainTabBarDelegate,CAAnimationDelegate>

@end

@implementation MainTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
        [self initial];
        
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.userInteractionEnabled = YES;
}

- (void)addSubviews {
    
}


- (void)setTitle:(NSArray *)titleArr normalImage:(NSArray *)normalImage selectedImage:(NSArray *)selectedImage {
    
    NSMutableArray * subMarr = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i =0; i < titleArr.count; i++) {
        
        HWJTabBarButton * tabBarButton = [[HWJTabBarButton alloc]init];
        tabBarButton.adjustsImageWhenHighlighted = NO;
        tabBarButton.textLabel.text = titleArr[i];
        tabBarButton.textLabel.font = [UIFont systemFontOfSize:10];
        [tabBarButton setTitleColor:RGBColor(160, 160, 160) forState:UIControlStateNormal];
        [tabBarButton setTitleColor:RGBColor(255, 77, 32) forState:UIControlStateSelected];
        [tabBarButton setImage:[UIImage imageNamed:normalImage[i]] forState:UIControlStateNormal];
        [tabBarButton setImage:[UIImage imageNamed:selectedImage[i]] forState:UIControlStateSelected];
        [tabBarButton addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchDown];
        tabBarButton.tag = tBegin+i;
        
        if (i == 0) {
            tabBarButton.selected = YES;
            _currentButton = tabBarButton;
            _refreshButton = tabBarButton;
        }
        
        [self addSubview:tabBarButton];
        
        [subMarr addObject:tabBarButton];
    }

    self.subViews = subMarr;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int count = (int)self.subviews.count;
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            HWJTabBarButton * tabBarButton = self.subviews[i];
            tabBarButton.frame = CGRectMake(i * self.bounds.size.width/count, 3, self.bounds.size.width/count, 44);
        }
    }
}


- (void)tabBarButtonClicked:(HWJTabBarButton *)tabBarButton {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)]) {
        
        BOOL selectedable = [self.delegate tabBar:self shouldSelectIndex:(tabBarButton.tag -tBegin)];
        
        if (selectedable) {
           
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabBar:didSelectedFromButton:toButton:)]) {
                [self.delegate tabBar:self didSelectedFromButton:(_currentButton.tag -tBegin) toButton:(tabBarButton.tag -tBegin)];
            }
            
            _currentButton.selected = NO;
            _currentButton = tabBarButton;
            _currentButton.selected = YES;
            
        }else {
            
            return;
        }
    }

}

@end



@interface MainTabBarController ()<MainTabBarDelegate,MainTabBarControllerDelegate,CAAnimationDelegate>


@property(nonatomic, weak)UIViewController * currentVC;
@property(nonatomic, weak)UIView * tabBarButton;
@property(nonatomic, weak)UIView * aniView;

@property(nonatomic, assign)NSInteger hideCount;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置TabBar
    
    //    if (IS_IPHONE_X) {
    //        BaseTabBar * tabBar = [[BaseTabBar alloc] init];
    //        [self setValue:tabBar forKey:@"tabBar"];
    //    }

    _myTabBar = [[MainTabBar alloc]init];
    _myTabBar.delegate = self;
    [self.tabBar addSubview:_myTabBar];
    
    //创建添加视图控制器
    [self createControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    //设置TabBar
    [self setUpTabBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

/**
 *  创建添加视图控制器
 */
- (void)createControllers {
    NSLog(@"createControllers");
    
    NSArray * controllerNames =@[@"HomeViewController",
                                 @"FollowViewController",
                                 @"FindViewController",
                                 @"MineViewController",
                                 ];
    
    NSArray * titleArr = @[@"首页",
                           @"关注",
                           @"发现",
                           @"我的",
                           ];
    
    NSArray * normalImageNames = @[@"tab_home",
                                   @"tab_follow",
                                   @"tab_search",
                                   @"tab_mine",
                                   ];
    
    NSArray * selectedImageNames = @[@"tab_home_pre",
                                     @"tab_follow_pre",
                                     @"tab_search_pre",
                                     @"tab_mine_pre",
                                     ];
    
    NSMutableArray * controllerArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < controllerNames.count; i++) {
    
        //0.创建ViewController
        Class class = NSClassFromString(controllerNames[i]);
        UIViewController * controller = [[class alloc]init];
        controller.title = titleArr[i];
        
        BNavigationController * nav =[[BNavigationController alloc]initWithRootViewController:controller];
        nav.tabBarItem.image  = [[UIImage imageNamed:normalImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.title = titleArr[i];
        nav.navigationBar.hidden = YES;
        //2.添加到数组
        [controllerArr addObject:nav];
    
    }

    //为tabbarController添加子视图控制器
    self.viewControllers = controllerArr;
    _currentVC = controllerArr.firstObject;
    self.selectedIndex = 0;
    
    //创建TabBar
    [_myTabBar setTitle:titleArr normalImage:normalImageNames selectedImage:selectedImageNames];
    
}


/**
 *  设置TabBar
 */
- (void)setUpTabBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.tabBar.tintColor = RGBColor(255, 77, 32);
    
    self.myTabBar.frame = CGRectMake(0, 0, kWidth, self.tabBar.height);
    
    if (_hideBar) {
        self.tabBar.alpha = 0;
    }else {
        self.tabBar.alpha = 1;
    }
    
    //    if (IS_IPHONE_X) return;
    //    CGRect rect = self.tabBar.frame;
    //    rect.size.height = kTabBarHeight;
    //    rect.origin.y = kScreenHeight - kTabBarHeight;
    //    self.tabBar.frame = rect;
    
}

- (void)setHideBar:(BOOL)hideBar {
    
    if (hideBar) {
        _hideCount++;
        
    }else {
        if (_hideCount == 0) {
            _hideCount = 0;
        }else {
            _hideCount--;
        }
    }
    
    if (hideBar) {
        _hideBar = hideBar;
    }else {
        if (_hideCount == 0) {
            _hideBar = hideBar;
        }
    }
    
    if (_hideBar) {
        self.tabBar.alpha = 0;
    }else {
        self.tabBar.alpha = 1;
        
    }
}


- (BOOL)tabBar:(MainTabBar *)tabBar shouldSelectIndex:(NSInteger)index {
    return YES;
}

- (void)tabBar:(MainTabBar *)tabBar didSelectedFromButton:(NSInteger)fromButton toButton:(NSInteger)toButton {
    
    [_myTabBar.refreshButton.imageView.layer removeAllAnimations];

    self.selectedIndex = toButton;

    if (toButton == 1) {
        self.myTabBar.subViews[1].dot = NO;
    }
    
    if (toButton == 0 ) {
        _myTabBar.refreshButton.edgeNumber = @"0";
        
        if (fromButton == toButton) {
            NSLog(@"转圈 刷新");
            
            if (self.delegateRefresh != nil && [self.delegateRefresh respondsToSelector:@selector(tabBarController:refreshAtIndex:)]) {
                [self.delegateRefresh tabBarController:self refreshAtIndex:toButton];
            }
            
            _myTabBar.refreshButton.userInteractionEnabled = NO;
            [_myTabBar.refreshButton setImage:[UIImage imageNamed:@"tab_refresh_pre"] forState:UIControlStateSelected];
            
            CABasicAnimation *refreshAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            refreshAnim.delegate = self;
            refreshAnim.fromValue = @(2*M_PI);
            refreshAnim.toValue = @0;
            refreshAnim.repeatCount = 1;
            refreshAnim.duration = 0.75;
            [_myTabBar.refreshButton.imageView.layer addAnimation:refreshAnim forKey:@"tabBarRefresh"];

        }
    }else {
        [_myTabBar.refreshButton setImage:[UIImage imageNamed:@"tab_home_pre"] forState:UIControlStateSelected];
        
    }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_myTabBar.refreshButton.imageView.layer removeAllAnimations];
    [_myTabBar.refreshButton setImage:[UIImage imageNamed:@"tab_home_pre"] forState:UIControlStateSelected];
    _myTabBar.refreshButton.userInteractionEnabled = YES;
}






- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//自动旋转
- (BOOL)shouldAutorotate { return NO; }

@end
