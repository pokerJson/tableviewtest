//
//  HotHistoryWordsView.m
//  TCShanXun
//
//  Created by dzc on 2019/1/21.
//  Copyright © 2019 fantexix Inc. All rights reserved.
//

#import "HotHistoryWordsView.h"

@implementation HotHistoryWordsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBColor(240, 240, 240);
        self.hotArr = [[NSArray alloc]init];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xxxxx)];
        [self addGestureRecognizer:tap];
        [self ui];
        [self requesturl];
    }
    return self;
}
- (void)xxxxx
{
    self.keybordBlock();
}
- (void)ui{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,50, 20)];
    label.font= [UIFont systemFontOfSize:14.0];
    label.text = @"热点";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGBColor(133, 133, 133);
    [self addSubview:label];
    
    weakObj(self);
    _hotWordsView = [[FindBagTagView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 0)];
    _hotWordsView.userInteractionEnabled = YES;
    _hotWordsView.canTouch = YES;
    _hotWordsView.isSingleSelect = YES;
    [self addSubview:_hotWordsView];
    [_hotWordsView setDidselectItemBlock:^(NSString *str) {
//        NSLog(@"选中热点===%@",str);
        selfWeak.h_hBlock(str);
    }];
    
    _historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _hotWordsView.origin.y+_hotWordsView.size.height, 100, 20)];
    _historyLabel.textColor = RGBColor(133, 133, 133);
    _historyLabel.text = @"搜索历史";
    _historyLabel.font = [UIFont systemFontOfSize:14.0];
    _historyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_historyLabel];
    
    _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBT.frame = CGRectMake(kScreenWidth-30, _historyLabel.frame.origin.y, 12, 12);
    [_deleteBT setBackgroundImage:UIImageNamed(@"ic_navbar_close") forState:UIControlStateNormal];
    [_deleteBT addTarget:self action:@selector(deleteBTClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBT];

    
    //lishi
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"allArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];

    _historyWordsView = [[FindHistoryView alloc]initWithFrame:CGRectMake(0, _historyLabel.origin.y+20, kScreenWidth, 0)];
    _historyWordsView.userInteractionEnabled = YES;
    [self addSubview:_historyWordsView];
    _historyWordsView.histyARR = temArr;
    [_historyWordsView setDidselectItemBlock:^(NSString *str) {
//        NSLog(@"选中历史===%@",str);
        selfWeak.h_hBlock(str);
    }];
    if (temArr.count == 0) {
        _historyLabel.hidden = YES;
        _deleteBT.hidden = YES;
    }

}
- (void)deleteBTClick
{
    NSLog(@"删除本地l搜索历史");
    NSUserDefaults *userdde = [NSUserDefaults standardUserDefaults];
    NSArray *allArr = [userdde objectForKey:@"allArr"];
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:allArr];
    [temArr removeAllObjects];
    NSArray *A = [NSArray arrayWithArray:temArr];
    [userdde setObject:A forKey:@"allArr"];
    [userdde synchronize];
    
    [_historyWordsView removeFromSuperview];
    _historyLabel.hidden = YES;
    _deleteBT.hidden = YES;

}
- (void)requesturl
{
    weakObj(self);
    [HttpRequest get_RequestWithURL:@"https://www.yzpai.cn/news/so/hotword" URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            selfWeak.hotArr = dic[@"data"];
            [selfWeak.hotWordsView setTagWithTagArray:dic[@"data"]];
        }else{
            
        }
        
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _historyLabel.frame = CGRectMake(15, _hotWordsView.origin.y+_hotWordsView.size.height+5, 100, 20);
    _deleteBT.frame = CGRectMake(kScreenWidth-30, _historyLabel.frame.origin.y, 12, 12);
    _historyWordsView.frame = CGRectMake(0,  _historyLabel.origin.y+20+5, kScreenWidth, _historyWordsView.h_height);

    
}
- (void)show {
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)hid {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        [self removeFromSuperview];
        
    }];
    
}

@end
