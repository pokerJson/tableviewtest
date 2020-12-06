//
//  FollowView.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowView.h"

@interface FollowView ()

@property(nonatomic, strong)UILabel * numLabel;
@property(nonatomic, strong)UILabel * tabLabel;

@property(nonatomic, strong)UITapGestureRecognizer * tap;

@end

@implementation FollowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [self addGestureRecognizer:_tap];
}

- (void)addSubviews {
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = RGBColor(150, 150, 150);
    _numLabel.textAlignment = 1;
    _numLabel.font = UIFontBSys(20);
    [self addSubview:_numLabel];
    
    _tabLabel = [[UILabel alloc]init];
    _tabLabel.textColor = RGBColor(150, 150, 150);
    _tabLabel.textAlignment = 1;
    _tabLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_tabLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _numLabel.frame = CGRectMake(0, 5, sWidth, 25);
    _tabLabel.frame = CGRectMake(0, 30, sWidth, 25);
}

- (void)setNum:(NSString *)num {
    _num = num;
    _numLabel.text = num;
}
- (void)setTab:(NSString *)tab {
    _tab = tab;
    _tabLabel.text = tab;
}

- (void)tapMethod:(UITapGestureRecognizer *)tap {
    if (_tapMethod) {
        _tapMethod();
    }
}

@end
