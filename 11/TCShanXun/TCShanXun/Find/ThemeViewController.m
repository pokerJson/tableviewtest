//
//  ThemeViewController.m
//  News
//
//  Created by dzc on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ThemeViewController.h"
#import "LTScrollView-Swift.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#define HeaderImageViewHeight (kStatusHeight + 140)
#define HeaderHeight (kStatusHeight + 140 + 160 + 5)
#define NavHeight (kStatusHeight + 44)

@interface ThemeViewController ()<LTSimpleScrollViewDelegate>{
    float _historyY;
}
//
@property (nonatomic,strong)NSMutableArray *viewControllers;
@property (nonatomic,strong)NSMutableArray *titles;
@property (strong, nonatomic) LTLayout *layout;
@property (strong, nonatomic) LTSimpleManager *managerView;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property(strong, nonatomic) UIView *headerView;// headerview
@property(strong, nonatomic) UIImageView *headerImageView;//背景图片
@property(strong, nonatomic)UIVisualEffectView *imageEffectView;

//top 导航栏
@property (strong, nonatomic) UIImageView *topView;
@property(nonatomic, strong)UIVisualEffectView *topEffectView;
@property(nonatomic, strong)UILabel *topTitle;

//头像 遮罩层 关注数
@property (strong, nonatomic) UIImageView *iconImagView;
@property (strong, nonatomic) UILabel *attentionNumber;
@property (strong, nonatomic) UIView *eeeeev;

//标题 创建者等
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *authorIcon;
@property (strong, nonatomic) UILabel *chuangjianzhe;
@property (strong, nonatomic) UILabel *author;
@property (strong, nonatomic) UILabel *contentLabel;//有的没有创建者只有一个说明
@property (strong, nonatomic) UIButton *attentionBT;

//推送的view
//@property (strong, nonatomic) UIView *noticeView;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *line_left;
@property (strong, nonatomic) UISwitch *line_swich;

//

@end

@implementation ThemeViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"ss";

    //
    [self setupSubViews];

    //+++++++++++++++++++++++++++++++++
    //topview
    self.topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+kStatusHeight)];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    self.topView.userInteractionEnabled = YES;
    [self.view addSubview:self.topView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃视图
    _topEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    _topEffectView.frame = self.topView.bounds;
    _topEffectView.alpha = 0;
    [self.topView addSubview:_topEffectView];
    
    self.topTitle = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-200)/2, kStatusHeight+(44-20)/2, 200, 20)];
    self.topTitle.textAlignment = NSTextAlignmentCenter;
    self.topTitle.textColor = [UIColor whiteColor];
    self.topTitle.font = [UIFont systemFontOfSize:16.0];
    [self.topView addSubview:self.topTitle];

    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(5, kStatusHeight, 44, 44);
    [but addTarget:self action:@selector(gobackTp) forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    [self.topView addSubview:but];
    

    /////_____++++++++++++++++++++++++
    
}
- (void)gobackTp
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupSubViews {
    
    [self.view addSubview:self.managerView];
    
    __weak typeof(self) weakSelf = self;
    
    //配置headerView
    [self.managerView configHeaderView:^UIView * _Nullable{
        [weakSelf.headerView addSubview:weakSelf.headerImageView];
        //1 头像
        weakSelf.iconImagView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, HeaderHeight-160-5-80, 100, 100)];
        NSLog(@"icooo==%@",NSStringFromCGRect(weakSelf.iconImagView.frame));
        weakSelf.iconImagView.image = UIImageNamed(@"placeholder_share_no_pic");
        [weakSelf.headerView addSubview:weakSelf.iconImagView];
        
        //title
        weakSelf.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HeaderImageViewHeight+30, kScreenWidth, 20)];
        weakSelf.titleLabel.font = [UIFont systemFontOfSize:16.0];
        weakSelf.titleLabel.textAlignment = NSTextAlignmentCenter;
        weakSelf.titleLabel.text = @"罪行热门的热哈哈哈是";
        [weakSelf.headerView addSubview:weakSelf.titleLabel];
        //author
        weakSelf.chuangjianzhe = [[UILabel alloc]initWithFrame:CGRectMake(weakSelf.authorIcon.frame.origin.x+30, weakSelf.titleLabel.frame.origin.y+40, 50, 20)];
        weakSelf.chuangjianzhe.text = @"创建者:";
        [weakSelf.headerView addSubview:weakSelf.chuangjianzhe];
        weakSelf.chuangjianzhe.font = [UIFont systemFontOfSize:12.0];
        weakSelf.chuangjianzhe.center = CGPointMake(kScreenWidth/2-25, weakSelf.titleLabel.center.y+30);

        weakSelf.authorIcon = [[UIImageView alloc]initWithFrame:CGRectMake(weakSelf.chuangjianzhe.frame.origin.x-30, self.titleLabel.frame.origin.y+30, 20, 20)];
        weakSelf.authorIcon.image = UIImageNamed(@"ic_personal_tab_custom_topic");
        [weakSelf.headerView addSubview:weakSelf.authorIcon];
        
        weakSelf.author = [[UILabel alloc]initWithFrame:CGRectMake(weakSelf.chuangjianzhe.frame.origin.x+50, weakSelf.titleLabel.frame.origin.y+30, 100, 20)];
        weakSelf.author.textAlignment = NSTextAlignmentLeft;
        weakSelf.author.text = @"打电话都好得很";
        weakSelf.author.font = [UIFont systemFontOfSize:12.0];
        weakSelf.author.textColor = [UIColor blueColor];
        [weakSelf.headerView addSubview:weakSelf.author];
        
        //关注button
        weakSelf.attentionBT = [UIButton buttonWithType:UIButtonTypeCustom];
        weakSelf.attentionBT.frame = CGRectMake((kScreenWidth-60)/2, HeaderHeight-5-20-30, 60, 30);
        [weakSelf.attentionBT setBackgroundImage:UIImageNamed(@"ic_messages_like_selected") forState:UIControlStateNormal];
        [weakSelf.attentionBT setBackgroundImage:UIImageNamed(@"ic_messages_like") forState:UIControlStateSelected];
        [weakSelf.attentionBT addTarget:self action:@selector(attentionBTClick:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.headerView addSubview:weakSelf.attentionBT];
        weakSelf.attentionBT.selected = NO;
        //推送的view 可以放大缩小的
        weakSelf.line = [[UIView alloc]initWithFrame:CGRectMake(0, HeaderHeight-5, kScreenWidth, 5)];
        weakSelf.line.backgroundColor = RGBColor(234, 235, 237);
        [weakSelf.headerView addSubview:weakSelf.line];
        
        weakSelf.line_left = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        weakSelf.line_left.text = @"推送通知";
        weakSelf.line_left.textColor = RGBColor(33, 33, 33);
        weakSelf.line_left.font = [UIFont systemFontOfSize:14.0];
        weakSelf.line_left.textAlignment = NSTextAlignmentCenter;
        [weakSelf.line addSubview:weakSelf.line_left];
        weakSelf.line_left.hidden = YES;

        weakSelf.line_swich = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 5, 60, 30)];
        weakSelf.line_swich.tintColor = RGBColor(178, 178, 178);
        weakSelf.line_swich.onTintColor = RGBColor(247, 207, 95);
        [weakSelf.line_swich setOn:YES animated:true];
        [weakSelf.line_swich addTarget:self action:@selector(line_swichClick:) forControlEvents:UIControlEventValueChanged];
        [weakSelf.line addSubview:weakSelf.line_swich];
        weakSelf.line_swich.hidden = YES;
        
        return weakSelf.headerView;
    }];
    
    //pageView点击事件
    [self.managerView didSelectIndexHandle:^(NSInteger index) {
        NSLog(@"点击了 -> %ld", index);
    }];
    
    
}
- (void)line_swichClick:(UISwitch *)wich
{
    
}
#pragma mark 关注点击
- (void)attentionBTClick:(UIButton *)button{
    weakObj(self);
    if (button.selected) {
        //收回
        button.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            selfWeak.line.frame = CGRectMake(0,HeaderHeight-5, kScreenWidth, 5);
            selfWeak.headerView.frame = CGRectMake(0, 0, kScreenWidth, HeaderHeight);
            [selfWeak.managerView configHeaderView:^UIView * _Nullable{
                return selfWeak.headerView;
            }];
            selfWeak.line_left.hidden = YES;
            selfWeak.line_swich.hidden = YES;

        }];
    }else{
        //放开
        button.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            selfWeak.line.frame = CGRectMake(0,HeaderHeight-5, kScreenWidth, 40);
            selfWeak.headerView.frame = CGRectMake(0, 0, kScreenWidth, (kStatusHeight + 140 + 160 + 5)+35);
            //从新更新下
            [selfWeak.managerView configHeaderView:^UIView * _Nullable{
                return selfWeak.headerView;
            }];
        } completion:^(BOOL finished) {
            selfWeak.line_left.hidden = NO;
            selfWeak.line_swich.hidden = NO;
        }];
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture");
}

-(void)glt_scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"---> %lf", scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= HeaderImageViewHeight - (kStatusHeight + 44)) {
        if (!self.topView.image) {
            self.topView.image = _headerImageView.image;
        }
        _topEffectView.alpha = 0.7;
    }else {
        self.topView.image = nil;
        _topEffectView.alpha = 0;
        
    }
    
    CGFloat headerImageY = offsetY;
    CGFloat headerImageH = HeaderImageViewHeight - offsetY;
    
    
    CGRect headerImageFrame = self.headerImageView.frame;
    headerImageFrame.origin.y = headerImageY;
    headerImageFrame.size.height = headerImageH;
    self.headerImageView.frame = headerImageFrame;
    _imageEffectView.frame = _headerImageView.bounds;

    //切割
    float maskHeight;
    if (offsetY < HeaderImageViewHeight-(kStatusHeight+44)-80) {
        maskHeight = 0;
    }else if (offsetY >= HeaderImageViewHeight-(kStatusHeight+44)-80 && offsetY<= HeaderImageViewHeight+20) {
        maskHeight = offsetY - (HeaderImageViewHeight-(kStatusHeight+44)-80);
    }else {
        maskHeight = 100;
    }
    CAShapeLayer * mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRect:_iconImagView.bounds];
    UIBezierPath * holePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, maskHeight)];
    [maskPath appendPath:holePath];
    mask.path = maskPath.CGPath;
    [_iconImagView.layer setMask:mask];
    
    //2
    CAShapeLayer * mask2 = [CAShapeLayer layer];
    [mask2 setFillRule:kCAFillRuleEvenOdd];
    UIBezierPath * maskPath2 = [UIBezierPath bezierPathWithRect:self.eeeeev.bounds];
    UIBezierPath * holePath2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, maskHeight)];
    [maskPath2 appendPath:holePath2];
    mask2.path = maskPath2.CGPath;
    [self.eeeeev.layer setMask:mask2];


    //标题
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - _historyY;
    _historyY = contentOffset;
    
    if (offset > 0 && contentOffset > 0 ) {
        NSLog(@"上拉行为");
        if (offsetY >= 135) {
            self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 44);
                self.topTitle.text = @"的房间里的风力发电";
                self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 22);
                self.topTitle.hidden = NO;
        }
    }
    if (offset < 0 && distanceFromBottom > hight) {
        NSLog(@"下拉行为");
        if (offsetY <= 135) {
                self.topTitle.text = @"的房间里的风力发电";
                self.topTitle.center = CGPointMake(kScreenWidth/2, kStatusHeight + 44);
                self.topTitle.hidden = YES;
        }

    }

    
}


-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = 0.0;
        CGFloat H = IS_IPHONE_X ? (kScreenHeight - Y - 34) :kScreenHeight - Y;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, Y, kScreenWidth, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
        
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        /* 设置悬停位置 */
        _managerView.hoverY = NavHeight;
        
    }
    return _managerView;
}

-(UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, HeaderImageViewHeight)];
        _headerImageView.image = [UIImage imageNamed:@"Yosemite1"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        _imageEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        
        _imageEffectView.frame = _headerImageView.bounds;
        //设置模糊透明度
        _imageEffectView.alpha = 0.7f;
        [_headerImageView addSubview:_imageEffectView];
        
        //遮罩view
        self.eeeeev = [[UIView alloc]initWithFrame:CGRectMake(0, HeaderImageViewHeight - 80, kScreenWidth, 80)];
        self.eeeeev.backgroundColor = [UIColor clearColor];
        self.eeeeev.userInteractionEnabled = YES;
        self.eeeeev.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        [_headerImageView addSubview:self.eeeeev];
        //1
        self.attentionNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 80-30, 120, 20)];
        self.attentionNumber.text = @"55664人关注";
        self.attentionNumber.textColor = [UIColor whiteColor];
        self.attentionNumber.font = [UIFont systemFontOfSize:12.0];
        self.attentionNumber.textAlignment = NSTextAlignmentCenter;
        [self.eeeeev addSubview:self.attentionNumber];
        self.attentionNumber.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        //2
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(kScreenWidth-30, 80-30, 20, 20);
        [but setBackgroundImage:UIImageNamed(@"ic_personaltab_activity_message_error") forState:UIControlStateNormal];
        [but addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
        [self.eeeeev addSubview:but];
    }
    return _headerImageView;
}
#pragma mark 顶部右边那个按钮
- (void)gotoClick
{
    NSLog(@"gotoClick--gotoClick");
}
-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
    }
    return _headerView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.bottomLineHeight = 4.0;
        _layout.bottomLineCornerRadius = 2.0;
        _layout.titleViewBgColor = [UIColor whiteColor];
        _layout.titleSelectColor = RGBColor(95, 250, 255);
        _layout.bottomLineColor = RGBColor(95, 250, 255);
        _layout.titleFont = [UIFont systemFontOfSize:13.0];
        
        _layout.lrMargin = 40;
        _layout.isAverage = YES;
    }
    return _layout;
}


- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = @[@"精选", @"广场"];
    }
    return _titles;
}


-(NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSMutableArray  *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            LeftViewController *left = [[LeftViewController alloc]init];
            left.iD = self.iD;
            [testVCS addObject:left];
        }else if (idx == 1){
            RightViewController *right = [[RightViewController alloc]init];
            right.iD = self.iD;
            [testVCS addObject:right];
        }
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    //侧滑出现的透明细节调整
//    self.navigationController.navigationBar.alpha = self.currentProgress;
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
