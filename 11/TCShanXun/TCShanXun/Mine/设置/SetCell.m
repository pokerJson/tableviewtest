//
//  SetCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/5.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "SetCell.h"

@interface SetCell ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIImageView * detailImageView;

@property(nonatomic, strong)UILabel * detailLabel;

@end

@implementation SetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, self.height);
    self.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)addSubviews {
  
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, sWidth - 100, sHeight)];
    _titleLabel.font = UIFontSys(15);
    _titleLabel.textColor = RGBColor(50, 50, 50);
    [self addSubview:_titleLabel];
    
    
    _detailImageView = [[UIImageView alloc]init];
    _detailImageView.image = UIImageNamed(@"ic_common_arrow_right");
    [self addSubview:_detailImageView];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth - 118, 0, 100, sHeight)];
    _detailLabel.font = UIFontSys(13);
    _detailLabel.textAlignment = 2;
    _detailLabel.textColor = RGBColor(150, 150, 150);
    [self addSubview:_detailLabel];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    _detailImageView.frame = CGRectMake(sWidth-25, (sHeight-12)/2., 7, 12);
    
}

- (void)loadDataWithModel:(id)model {
    _titleLabel.text = model[@"title"];
    
    if ([model[@"type"] intValue]) {
        _detailImageView.hidden = NO;
    }else {
        _detailImageView.hidden = YES;
    }
    
    if ([_titleLabel.text isEqualToString:@"清除缓存"]) {
        double size =  [[SDImageCache sharedImageCache] getSize]/(double)1024.0/(double)1024.0;
        size += [[YYImageCache sharedCache].diskCache totalCost]/(double)1024.0/(double)1024.0;
        _detailLabel.text = [NSString stringWithFormat:@"%.1fM",fabs(size)];
    }else {
        _detailLabel.text = nil;
    }

}

@end
