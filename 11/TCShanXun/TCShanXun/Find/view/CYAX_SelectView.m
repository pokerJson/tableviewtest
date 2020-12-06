//
//  CYAX_SelectView.m
//  选项卡
//
//  Created by CYAX_BOY on 17/5/12.
//  Copyright © 2017年 CYAX_BOY. All rights reserved.
//

#import "CYAX_SelectView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define height_per ([UIScreen mainScreen].bounds.size.width)/375

/**
    选项卡的高度
*/
#define SelectViewHeight 44

@interface CYAX_SelectView()


/**
 存放button的
 */
@property (nonatomic,strong)NSMutableArray *buttonArray;

/**
    下面的横线
 */
@property (nonatomic,strong) UIView *lineView;

/**
 当前点击下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  顶部放置选项卡的scrollView
 */
@property (nonatomic, strong) TempScrollview *TopScrollView;//为了uiscrollview左滑返回生效，重写自定义scrollview的方法

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) int tabCount;


@end

@implementation CYAX_SelectView

- (void)setTopStatusButtonWithTitles:(NSArray *)titleArray NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor LineColor:(UIColor *)lineColor
{
    _tabCount = titleArray.count;
    //选项按钮的创建 可以设置默认屏幕可见最多创建 几个个选项卡，这里直接略掉了 直接平分
    _width =  ScreenWidth / _tabCount;
    self.TopScrollView .frame = CGRectMake(-1, 0, ScreenWidth + 2, SelectViewHeight-0.5);
    self.TopScrollView.contentSize = CGSizeMake(_tabCount * _width, SelectViewHeight-0.5);
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, SelectViewHeight-1, ScreenWidth + 2, 0.5)];
    la.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [self.TopScrollView addSubview:la];

    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenWidth)/_tabCount*i, 0,kScreenWidth/_tabCount, SelectViewHeight-3);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:13*height_per];
        [button addTarget:self action:@selector(buttonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.TopScrollView addSubview:button];
        [self.buttonArray addObject:button];
        if (i == 0) {
            button.selected = YES;
        }

    }
    self.currentIndex = 0;
    //线条
    if (lineColor) {
        self.lineView.frame = CGRectMake(0, SelectViewHeight-1.5,kScreenWidth/_tabCount, 1);
        self.lineView.backgroundColor = lineColor;
    }
    [self addSubview:self.bgScrollView];
    self.bgScrollView.contentSize = CGSizeMake(_tabCount * ScreenWidth, self.frame.size.height - SelectViewHeight);

    

}

#pragma mark 点击选项Btn，
- (void)buttonTouchEvent:(UIButton *)button{
    
    if (button.tag == self.currentIndex) {
        return;
    }
    [self changeStateWithTag:button.tag];
    //    代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(CYAX_SelectView:moveTableView_or_CollectionVWithTag:)]) {
        
        [self.delegate CYAX_SelectView:self moveTableView_or_CollectionVWithTag:button.tag];
    }
    
}

- (void)changeStateWithTag:(NSInteger)tag
{
    //改变当前选中的下标,并且使其处于被选中状态
    self.currentIndex = tag;
    UIButton *selectBtn = self.buttonArray[tag];
    selectBtn.selected = YES;
    //同时关闭上一个选中Btn的选中状态
    for (NSInteger i = 0; i < self.buttonArray.count; i++) {
        if (i != self.currentIndex) {
            UIButton *btn = self.buttonArray[i];
            btn.selected = NO;
        }
    }
    //移动下划线到对应btn下面
    if (self.lineView) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect lineRect = self.lineView.frame;
            lineRect.origin.x = kScreenWidth/_tabCount*tag;
            self.lineView.frame = lineRect;
        }];
    }
}
#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bgScrollView) {
        NSInteger touchIndex = scrollView.contentOffset.x / ScreenWidth;
        [self changeStateWithTag:touchIndex];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CYAX_SelectViewWhenbottomScrollVDidEndDecelerating)]) {
            [self.delegate CYAX_SelectViewWhenbottomScrollVDidEndDecelerating];
        }
    }
}



#pragma mark -- 懒加载
- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
        
    }
    return _buttonArray;
}
-(TempScrollview *)TopScrollView
{
    if (!_TopScrollView) {
        _TopScrollView = [[TempScrollview alloc] init];
//        _TopScrollView.delegate = self;
        _TopScrollView.showsVerticalScrollIndicator = NO;
        _TopScrollView.showsHorizontalScrollIndicator = NO;
        _TopScrollView.backgroundColor = [UIColor whiteColor];
        _TopScrollView.bounces = NO;
        [self addSubview:_TopScrollView];
    }
    return _TopScrollView;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self.TopScrollView addSubview:_lineView];
    }
    return _lineView;
}
-(TempScrollview *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[TempScrollview alloc] initWithFrame:CGRectMake(0, SelectViewHeight, ScreenWidth, self.frame.size.height-SelectViewHeight)];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _bgScrollView;
}

@end
