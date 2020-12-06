//
//  PicPreView.m
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PicPreView.h"
#import "PicView.h"

@interface PicPreView ()<UIScrollViewDelegate,PicViewDeletgate>

@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)UILabel * tabLabel;

@property(nonatomic, strong)NSArray * picArr;
@property(nonatomic, assign)int currentIndex;

@property(nonatomic, strong)PicView * fromView;
@property(nonatomic, assign)int fromeIndex;
@property(nonatomic, assign)CGRect fromeRect;

@end

@implementation PicPreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}

- (void)addSubviews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-10, 0, sWidth+20, sHeight)];
    if (@available(iOS 11.0, *)) _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _tabLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, sHeight-40, sWidth, 20)];
    _tabLabel.textColor = [UIColor whiteColor];
    _tabLabel.textAlignment = 1;
    _tabLabel.font = UIFontBSys(18);
    [self addSubview:_tabLabel];
    
}

- (void)picArr:(NSArray *)picArr atIndex:(int)index fromRect:(CGRect)rect {
    
    _scrollView.contentSize = CGSizeMake(picArr.count * _scrollView.width, sHeight);
    
    _picArr = picArr;
    _fromeIndex = index;
    _fromeRect = rect;
    
    
    _scrollView.contentOffset = CGPointMake(index*_scrollView.width, 0);
    
    if (picArr.count == 1) {
        _tabLabel.hidden = YES;
    }else {
        _tabLabel.hidden = NO;
    }
    _tabLabel.text = [NSString stringWithFormat:@"%d/%d",index+1,(int)picArr.count];

    
    for (int i = 0; i < picArr.count; i++) {
        
        PicView * picView = [[PicView alloc]initWithFrame:CGRectMake(10+i*_scrollView.width, 0, sWidth, sHeight)];
        picView.picDelegate = self;
        [picView loadDataWithModel:picArr[i]];
        [_scrollView addSubview:picView];
        
        if (i == index) {
            _fromView = picView;
        }
    
    }

    __block CGRect orginFrame = _fromView.imageView.frame;

    _fromView.imageView.frame = CGRectMake(rect.origin.x, rect.origin.y-_fromView.scrollView.contentInset.top, rect.size.width, rect.size.height);

    NSLog(@"%@",NSStringFromCGRect(_fromView.imageView.frame));
    
    [UIView animateWithDuration:0.25 animations:^{
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
        rootVC.hideBar = YES;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        self.fromView.imageView.frame = orginFrame;
       
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentIndex = (scrollView.contentOffset.x + _scrollView.width/2.0)/_scrollView.width;
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        _tabLabel.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,(int)_picArr.count];
    }
}

- (void)picViewViewTap:(PicView *)picView {

    self.tabLabel.hidden = YES;
    
    CGRect toFrame = CGRectMake((self.currentIndex%3-self.fromeIndex%3)*(self.fromeRect.size.width+5)+self.fromeRect.origin.x, (self.currentIndex/3-self.fromeIndex/3)*(self.fromeRect.size.width+5)+self.fromeRect.origin.y, _fromeRect.size.width, _fromeRect.size.height);
    
    UIImageView * imageView = picView.imageView;

    [UIView animateWithDuration:0.25 animations:^{
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
        rootVC.hideBar = NO;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        picView.scrollView.zoomScale = 1;
        
        float cY = 0.0;
        
        if (picView.scrollView.contentOffset.y < picView.scrollView.contentInset.top) {
            cY = -picView.scrollView.contentInset.top;
        }
        
        if (picView.scrollView.contentOffset.y > picView.scrollView.contentSize.height+ picView.scrollView.contentInset.bottom-picView.scrollView.height) {
            cY = picView.scrollView.contentSize.height+ picView.scrollView.contentInset.bottom-picView.scrollView.height;
        }
        
        imageView.frame = CGRectMake(toFrame.origin.x, imageView.y+toFrame.origin.y+cY, toFrame.size.width, toFrame.size.height);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}





@end
