//
//  SectorProgressView.m
//  FANTEXIX
//
//  Created by FANTEXIX on 2018/7/27.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SectorProgressView.h"

#define     w     24
#define     b     26.5

@interface SectorProgressView ()

@property(nonatomic, strong)CAShapeLayer * border;
@property(nonatomic, strong)CAShapeLayer * fillLayer;       //用来填充的图层
@property(nonatomic, strong)UIBezierPath * fillBezierPath;



@end

@implementation SectorProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.userInteractionEnabled = NO;
}

- (void)addSubviews {
    
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    _border.fillColor = nil;
    _border.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:b startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    _border.lineWidth = 1;
    [self.layer addSublayer:_border];
    
    _fillLayer = [CAShapeLayer layer];
    _fillLayer.fillColor = nil;
    _fillLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    _fillLayer.lineWidth = w;
    [self.layer addSublayer:_fillLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _border.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:b startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
}


- (void)setProgressColor:(UIColor *)progressColor {
    _fillLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressValue:(CGFloat)progressValue {
    _fillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:w/2 startAngle:-M_PI_2 endAngle:-M_PI_2 + progressValue * M_PI * 2 clockwise:YES];
    _fillLayer.path = _fillBezierPath.CGPath;
}

@end
