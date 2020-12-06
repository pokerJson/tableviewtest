//
//  BannerView.m
//  FANTEXIX
//
//  Created by FANTEXIX on 2018/7/24.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BannerView.h"

#define     TimeInterval        5
#define     TAGBEGIN            80808
#define     cWidth              (_scrollView.bounds.size.width)
#define     cHeight             (_scrollView.bounds.size.height)



@interface BannerView ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)NSTimer * scrollTimer;

@property(nonatomic, strong)NSMutableArray * dataArr;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = RGBColor(255, 255, 255);
    
    _dataArr = [NSMutableArray new];

    _scrollTimer = [MSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    [_scrollTimer setFireDate:[NSDate distantFuture]];
    

}

- (void)addSubviews {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, sWidth, sHeight)];
    _scrollView.backgroundColor = RGBColor(245, 245, 245);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
}

- (void)loadDataWithModel:(NSArray *)model {
    
    if (model.count == 0) return;
    
    [_scrollTimer setFireDate:[NSDate distantFuture]];
    
    [_dataArr removeAllObjects];
    //构建数据源  使视图能够左右轮播
    [_dataArr addObject:[model lastObject]];
    [_dataArr addObjectsFromArray:model];
    [_dataArr addObject:[model firstObject]];
    
    //滚动视图
    //滚动视图的大小
    _scrollView.contentSize = CGSizeMake(cWidth * _dataArr.count, cHeight);
    _scrollView.contentOffset = CGPointMake(cWidth, 0);
    
    //创建图片视图
    for (int i = 0; i < _dataArr.count; i++) {
        //创建图片
        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*cWidth+15, 10, cWidth-30, cHeight-20)];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.layer.cornerRadius = 5;
        bgImageView.layer.masksToBounds = YES;
        bgImageView.tag = TAGBEGIN +i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        [bgImageView addGestureRecognizer:tap];
        [_scrollView addSubview:bgImageView];
        
        
        
        UIImageView * rollImageView = [[UIImageView alloc]initWithFrame:bgImageView.bounds];
        rollImageView.layer.cornerRadius = 5;
        rollImageView.layer.masksToBounds = YES;
        [bgImageView addSubview:rollImageView];
        
        
//        bgImageView.image = [UIImage imageNamed:_dataArr[i][@"bg"]];
//        rollImageView.image = [UIImage imageNamed:_dataArr[i][@"slogan"]];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[i][@"pic"]] placeholderImage:nil];
        [rollImageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[i][@"pic"]] placeholderImage:nil];
    }
    
    
    if (_dataArr.count <= 3) {
        _scrollView.scrollEnabled = NO;
    }else {
        //开启定时器
        [_scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:TimeInterval]];
        _scrollView.scrollEnabled = YES;
    }
    
}


- (void)timerMethod:(NSTimer *)timer {
    NSInteger currentPage = _scrollView.contentOffset.x /cWidth;
    if (currentPage == 0) {
        //当前页为0时,滚动到下一页 不带动画不触发协议方法
        [_scrollView setContentOffset:CGPointMake(cWidth*(currentPage + 1), 0) animated:NO];
    }else {
        //带动画触发协议方法
        [_scrollView setContentOffset:CGPointMake(cWidth*(currentPage + 1), 0) animated:YES];
    }
}

// 定时器暂停问题
// 开始拖拽 暂定定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_scrollTimer setFireDate:[NSDate distantFuture]];
}
// 拖拽完毕 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_dataArr.count > 3) {
        [_scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:TimeInterval]];
    }
}

//减速完毕
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //刷新填充数据
    [self refreshData:scrollView];
}

//动画移动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //刷新填充数据
    [self refreshData:scrollView];
}

//刷新填充数据
- (void)refreshData:(UIScrollView *)scrollView {
    
    NSInteger currentPage = scrollView.contentOffset.x /cWidth;
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((_dataArr.count - 2)*cWidth, 0) animated:NO];
        currentPage = _dataArr.count - 2;
    }
    if (currentPage == _dataArr.count - 1) {
        [scrollView setContentOffset:CGPointMake(cWidth, 0) animated:NO];
        currentPage = 1;
    }
}


- (void)tapMethod:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - TAGBEGIN;
    //回调函数
    if (_callBack != nil) {
        _callBack(@{@"tag":@(index).stringValue});
    }
}


- (void)setScrollable:(BOOL)scrollable {
    _scrollable = scrollable;
    if (scrollable && _dataArr.count > 3) {
        [_scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:TimeInterval]];
    }else {
        [_scrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //差动
    int index = scrollView.contentOffset.x/cWidth;
    
    float lastRate = scrollView.contentOffset.x/cWidth - (int)(scrollView.contentOffset.x/cWidth);
    float nextRate = 1-lastRate;
    
    UIView * lastView = [self viewWithTag:TAGBEGIN + index];
    UIView * nextView = [self viewWithTag:TAGBEGIN + index+1];
    
    UIImageView * lastImageView = lastView.subviews.firstObject;
    UIImageView * nextImageView = nextView.subviews.firstObject;
    
    lastImageView.x = -150 * lastRate;
    nextImageView.x = 150 * nextRate;

}




- (void)dealloc {
    if ([_scrollTimer isValid]) {
        [_scrollTimer invalidate];
    }
    _scrollTimer = nil;
    
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


@end
