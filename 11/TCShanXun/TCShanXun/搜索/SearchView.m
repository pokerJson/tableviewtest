//
//  SearchView.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SearchView.h"
#import "ScrollSwitch.h"

@interface SearchView ()

@property(nonatomic, strong)UIView * view;
@property(nonatomic, strong)ScrollSwitch * scrollSwitch;
@property(nonatomic, strong)NSMutableArray * childVC;
@property(nonatomic, weak)UIViewController * currentVC;

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBColor(240, 240, 240);
        self.hidden = YES;
        
        _view = [[UIView alloc]initWithFrame:self.bounds];
        _view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
        
        
        _scrollSwitch = [[ScrollSwitch alloc]initWithFrame:CGRectMake(0, 0, sWidth, sHeight)];
        _scrollSwitch.hasStatusBar = NO;
        [_view addSubview:_scrollSwitch];
        
        NSArray * arr = @[
                          @"综合",
                          @"主题",
                          @"消息",
                          ];
        
        _childVC = [NSMutableArray array];
        
        for (NSString * obj in arr) {
            UIViewController * vc = [[UIViewController alloc]init];
            vc.title = obj;
            [_childVC addObject:vc];
        }
        
        weakObj(self);
        [_scrollSwitch titleArr:arr loadViewBlock:^(UIScrollView *scrollView, NSInteger index) {
            NSLog(@"loadView: %zd",index);
            [selfWeak.childVC[index] view].frame = CGRectMake(scrollView.bounds.size.width*index+(scrollView.width-sWidth)/2., 0, sWidth, sHeight);
            [scrollView addSubview:[selfWeak.childVC[index] view]];
        } currentIndexBlock:^(UIScrollView *scrollView, NSInteger index) {
            NSLog(@"currentIndex: %zd",index);
            self.currentVC = selfWeak.childVC[index];
        }];
    
        
    }
    return self;
}


- (void)show {
    self.hidden = NO;
    self.view.transform = CGAffineTransformMakeScale(0.98, 0.98);
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)hid {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
    }];
}



@end
