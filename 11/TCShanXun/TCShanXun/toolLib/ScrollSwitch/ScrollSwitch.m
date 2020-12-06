//
//  ScrollSwitch.m
//  ScrollSwitch
//
//  Created by fantexix on 2018/6/15.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ScrollSwitch.h"

#define     cWidth               (_controllerView.bounds.size.width)
#define     cHeight              (_controllerView.bounds.size.height)

#define     statusBarHeight      (self.hasStatusBar ? kStatusHeight:0)


#define     FONT            17
#define     TAGBEGIN        25255



@interface ScrollSwitch ()<UIScrollViewDelegate>

/** 页面视图*/
@property(nonatomic, strong)UIScrollView * controllerView;
/** 标签*/
@property(nonatomic, strong)UIScrollView * tabBarView;
/** 状态栏背景*/
@property(nonatomic, strong)UIView * statusBarView;
/** 黑线*/
@property(nonatomic, strong)UIView * shadowLine;
/** 滑块*/
@property(nonatomic, strong)UIView * sliderView;

/** 填充视图方法*/
@property(nonatomic, copy)void(^ loadViewBlock)(UIScrollView *, NSInteger);
/** 当前页数*/
@property(nonatomic, copy)void(^ currentIndexBlock)(UIScrollView *, NSInteger);

/** 标题数组*/
@property(nonatomic, strong)NSArray * titleArr;
/** 标题宽度*/
@property(nonatomic, strong)NSMutableArray * titleWidth;
/** 当前按钮*/
@property(nonatomic, weak)UILabel * currentLabel;
/** 当前页数*/
@property(nonatomic, assign)NSInteger currentIndex;
/** 未来页数*/
@property(nonatomic, assign)NSInteger loadIndex;





@end

@implementation ScrollSwitch


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubViews];
    }
    return self;
}
//初始化
- (void)initial {
    _hasStatusBar = YES;
    _tabBarHeight = 44;
}

- (void)setHasStatusBar:(BOOL)hasStatusBar {
    _hasStatusBar = hasStatusBar;
    [self layoutSubviews];
}

- (void)setTabBarHeight:(float)tabBarHeight {
    _tabBarHeight = tabBarHeight;
    [self layoutSubviews];
}


- (void)setAddonsView:(UIView *)addonsView {
    _addonsView = addonsView;
    [_tabBarView addSubview:_addonsView];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _statusBarView.frame = CGRectMake(0, 0, sWidth, statusBarHeight+_tabBarHeight);
    
    if (_addonsView) {
        _tabBarView.frame = CGRectMake(0, statusBarHeight, sWidth,_addonsView.height+_tabBarHeight);
    }else {
        _tabBarView.frame = CGRectMake(0, statusBarHeight, sWidth,_tabBarHeight);
    }
    
    _shadowLine.frame = CGRectMake(0, _tabBarView.height-0.4, sWidth, 0.4);
    
    
    _offset = self.addonsView.height;
}

//添加子视图
- (void)addSubViews {
    
    //0.滚动视图
    _controllerView = [[UIScrollView alloc]initWithFrame:CGRectMake(-1, 0, sWidth+2, sHeight)];
    _controllerView.delegate = self;
    _controllerView.pagingEnabled = YES;
    _controllerView.scrollEnabled = YES;
    _controllerView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_controllerView];
    
    //1.状态栏背景
    _statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sWidth, statusBarHeight+_tabBarHeight)];
    _statusBarView.backgroundColor = RGBColor(255, 255, 255);
    [self addSubview:_statusBarView];
    
    //1.标题视图
    _tabBarView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight, sWidth,_tabBarHeight)];
    _tabBarView.backgroundColor = RGBColor(255, 255, 255);
    _tabBarView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tabBarView];
    
    
    //2.黑线
    _shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, _tabBarView.height-0.4, sWidth, 0.4)];
    _shadowLine.backgroundColor = RGBColor(170, 170, 170);
    [_tabBarView addSubview:_shadowLine];
    
    //3.滑条
    _sliderView = [[UIView alloc]init];
    _sliderView.backgroundColor = RGBColor(255,77,32);
    [_tabBarView addSubview:_sliderView];
}


- (void)titleArr:(NSArray *)titleArr loadViewBlock:(void(^)(UIScrollView * scrollView,NSInteger index))loadViewBlock currentIndexBlock:(void(^)(UIScrollView * scrollView,NSInteger index))currentIndexBlock {
    
    
    _titleArr = titleArr;
    _loadViewBlock = loadViewBlock;
    _currentIndexBlock = currentIndexBlock;
    
    for (UIView * view in _tabBarView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView * view in _controllerView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_titleArr.count <=5 ) {
        _tabBarScroll = NO;
        _tabBarView.scrollEnabled = NO;
    }else {
        _tabBarScroll = YES;
        _tabBarView.scrollEnabled = YES;
    }
    
    //1
    if (!_titleWidth) _titleWidth = [NSMutableArray array];
    [_titleWidth removeAllObjects];
    [_titleWidth addObject:@0];
    
    for (int i = 0; i < _titleArr.count; i++) {
        
        UILabel * tabLabel = [[UILabel alloc]init];
        
        if (_tabBarScroll) {
            
            CGFloat width = [_titleArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT,_tabBarHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT]} context:nil].size.width;
            [_titleWidth addObject:@([_titleWidth[i] floatValue]+ width + 25)];
            tabLabel.frame = CGRectMake([_titleWidth[i] floatValue], _tabBarView.height-_tabBarHeight, width+25, _tabBarHeight);
            
        }else {
    
            [_titleWidth addObject:@([_titleWidth[i] floatValue]+sWidth/_titleArr.count)];
            tabLabel.frame = CGRectMake([_titleWidth[i] floatValue], _tabBarView.height-_tabBarHeight, sWidth/_titleArr.count, _tabBarHeight);
        }
    
        tabLabel.userInteractionEnabled = YES;
        tabLabel.text = _titleArr[i];
        tabLabel.textColor = RGBColor(99, 99, 99);
        tabLabel.font = UIFontSys(FONT);
        tabLabel.textAlignment = NSTextAlignmentCenter;
        tabLabel.tag = TAGBEGIN + i;
        
        if (i == 0) {
            _currentIndex = 0;
            _currentLabel = tabLabel;
            _currentLabel.font = UIFontBSys(FONT);
            _currentLabel.textColor = RGBColor(51, 51, 51);
        }
        
        [tabLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabLabelMethod:)]];
        [_tabBarView addSubview:tabLabel];
    }
    
    //2.
    _controllerView.contentSize = CGSizeMake(_titleArr.count * _controllerView.width, _controllerView.height);
    _controllerView.contentOffset = CGPointMake(_currentIndex*cWidth, 0);
    
    _tabBarView.contentSize = CGSizeMake([_titleWidth.lastObject floatValue], _tabBarView.height);
    
    _sliderView.frame = CGRectMake(_currentLabel.x + (_currentLabel.width-30)/2., _tabBarView.height-5,30, 2);
    
    //3.视图填充
    _loadIndex = _currentIndex;
    _loadViewBlock(_controllerView,_loadIndex);
    _currentIndexBlock(_controllerView,_currentIndex);
    
}


- (void)tabLabelMethod:(UITapGestureRecognizer *)tap {
    
    if (!self.delegate && [self.delegate respondsToSelector:@selector(scrollSwitch:selectedFromIndex:toIndex:)]) {
        [self.delegate scrollSwitch:self selectedFromIndex:_currentLabel.tag - TAGBEGIN toIndex:tap.view.tag - TAGBEGIN];
    }
    
    if (_currentIndex ==  tap.view.tag - TAGBEGIN) return;
    
    UILabel * label = (UILabel *)tap.view;
    
    _currentLabel.textColor = RGBColor(0, 0, 0);
    _currentLabel.font = UIFontSys(FONT);
    _currentLabel = label;
    _currentLabel.textColor = RGBColor(51, 51, 51);
    _currentLabel.font = UIFontBSys(FONT);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.frame = CGRectMake(label.frame.origin.x + (label.width-30)/2., self.tabBarView.height-5, 30, 2);
    }];
    
    [self linkedMethod:label];
    
    //4.填充视图
    _loadIndex = _currentIndex = label.tag - TAGBEGIN;
    _loadViewBlock(_controllerView,_loadIndex);
    _currentIndexBlock(_controllerView,_currentIndex);
    
    //5.视图移动
    _controllerView.delegate = nil;
    [_controllerView setContentOffset:CGPointMake(_currentIndex * sWidth, 0) animated:NO];
    _controllerView.delegate = self;
}

- (void)linkedMethod:(UILabel *)label {

    if ((_currentLabel.frame.origin.x + _currentLabel.frame.size.width/2.0) < _tabBarView.bounds.size.width/2.0) {
        [_tabBarView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if ((_currentLabel.frame.origin.x + _currentLabel.frame.size.width/2.0) > _tabBarView.bounds.size.width/2.0 && (_currentLabel.frame.origin.x + _currentLabel.frame.size.width/2.0) < _tabBarView.contentSize.width - _tabBarView.bounds.size.width/2.0) {
        [_tabBarView setContentOffset:CGPointMake(_currentLabel.frame.origin.x + _currentLabel.frame.size.width/2.0-_tabBarView.bounds.size.width/2.0, 0) animated:YES];
    }else if ((_currentLabel.frame.origin.x + _currentLabel.frame.size.width/2.0) > _tabBarView.contentSize.width - _tabBarView.bounds.size.width/2.0) {
        [_tabBarView setContentOffset:CGPointMake(_tabBarView.contentSize.width - _tabBarView.bounds.size.width, 0) animated:YES];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int currentPage = (scrollView.contentOffset.x + cWidth/2.0)/cWidth;
    float off = scrollView.contentOffset.x - currentPage*cWidth;
    float d = scrollView.contentOffset.x/cWidth - currentPage;

    if (currentPage > _titleArr.count-1) return;
    
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= (_titleArr.count-1)*cWidth) {
        
        int index = scrollView.contentOffset.x/cWidth;
        float lastRate = scrollView.contentOffset.x/cWidth - (int)(scrollView.contentOffset.x/cWidth);
        float nextRate = 1-lastRate;
        
        UILabel * lastLabel = [self viewWithTag:TAGBEGIN + index];
        UILabel * nextLabel = [self viewWithTag:TAGBEGIN + index+1];
        lastLabel.textColor = RGBColor(51-51*lastRate, 51-51*lastRate, 51-51*lastRate);
        nextLabel.textColor = RGBColor(51-51*nextRate, 51-51*nextRate, 51-51*nextRate);
        
        if (off >= 0) {
            _sliderView.frame = CGRectMake(lastLabel.x+(lastLabel.width-30)/2.+ lastLabel.width*off/cWidth, _tabBarView.height-5, 30, 2);
        }else {
            _sliderView.frame = CGRectMake(nextLabel.x+(nextLabel.width-30)/2.+ nextLabel.width*off/cWidth, _tabBarView.height-5, 30, 2);
        }
    }

    if (_currentIndex != currentPage) {
        _currentIndex = currentPage;
        
        UILabel * label = [self viewWithTag:TAGBEGIN + currentPage];
        _currentLabel.font = UIFontSys(FONT);
        _currentLabel = label;
        _currentLabel.font = UIFontBSys(FONT);
        //1.按钮移动
        [self linkedMethod:label];
        //2.当前视图
        _currentIndexBlock(_controllerView,_currentIndex);
    }
    
    
    static BOOL sLeft;
    static BOOL sRight;
    static NSInteger recordPage;
    static float recordOff;
    static NSInteger willloadIndex;
    
    if (!sRight && !sLeft && off > 0) {
        recordPage = _currentIndex;
        recordOff = off;
        sRight = YES;
        sLeft = NO;
    }
    if (!sRight && !sLeft && off < 0) {
        recordPage = _currentIndex;
        recordOff = off;
        sRight = NO;
        sLeft = YES;
    }
    
    if (sRight && off > 0) {
        if (d>0) {
            willloadIndex = _currentIndex + 1;
        }
        if (d<0) {
            willloadIndex = _currentIndex - 1;
        }
        if (willloadIndex >=0 && willloadIndex < _titleArr.count) {
            if (_loadIndex != willloadIndex) {
                _loadIndex = willloadIndex;
                _loadViewBlock(_controllerView,_loadIndex);
            }
        }
    }
    
    if (sLeft && off < 0) {
        if (d>0) {
            willloadIndex = _currentIndex + 1;
        }
        if (d<0) {
            willloadIndex = _currentIndex - 1;
        }
        if (willloadIndex >=0 && willloadIndex < _titleArr.count) {
            if (_loadIndex != willloadIndex) {
                _loadIndex = willloadIndex;
                _loadViewBlock(_controllerView,_loadIndex);
            }
        }
    }
    
    if (scrollView.contentOffset.x/cWidth -  (int)(scrollView.contentOffset.x/cWidth) == 0) {
        sRight = NO;
        sLeft = NO;
    }
    
    if (fabs(off - recordOff) > fabs(off) && recordPage == _currentIndex) {
        sRight = NO;
        sLeft = NO;
    }
    
}


- (void)scrollOffset:(float)offset interval:(float)interval {
    
    if (interval >= 0) {
        
        if (self.tabBarView.y - interval <= kStatusHeight-self.addonsView.height ) {
            if (offset > -44) {
                self.tabBarView.frame = CGRectMake(0, kStatusHeight-self.addonsView.height, self.tabBarView.width, self.tabBarView.height);
            }
        }else {
            if (offset > -44) {
                self.tabBarView.y = self.tabBarView.y - interval;
            }
        }
        
    }else {
        
        if (self.tabBarView.y - interval >= kStatusHeight) {
            self.tabBarView.frame = CGRectMake(0, kStatusHeight, self.tabBarView.width, self.tabBarView.height);
        }else {
            self.tabBarView.y = self.tabBarView.y - interval;
        }
        
    }
    
    //透明度
    float alpha =  (self.tabBarView.y - (kStatusHeight-self.addonsView.height))/self.addonsView.height;
    
    alpha = alpha<0?0:(alpha>1?1:alpha);
    
    self.addonsView.alpha = alpha;
    
    self.offset = self.tabBarView.y - (kStatusHeight-self.addonsView.height);

}

- (void)showAddonsView {
    self.addonsAutoAnimation = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarView.frame = CGRectMake(0, kStatusHeight, self.tabBarView.width, self.tabBarView.height);
        self.addonsView.alpha = 1;
        self.offset = self.tabBarView.y - (kStatusHeight-self.addonsView.height);
    }];
}
- (void)hideAddonsView {
    self.addonsAutoAnimation = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarView.frame = CGRectMake(0, kStatusHeight-self.addonsView.height, self.tabBarView.width, self.tabBarView.height);
    }];
}




@end
