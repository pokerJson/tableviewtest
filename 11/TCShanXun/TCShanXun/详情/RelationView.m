//
//  RelationView.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/31.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "RelationView.h"
#import "ScourceViewController.h"

@interface RelationView ()

@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)BListModel * model;

@end

@implementation RelationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews {
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
    _iconImageView.cornerRadius = 5;
    [self addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, self.width-65, 40)];
    _titleLabel.textColor = RGBColor(0,0,0);
    _titleLabel.textAlignment = 0;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)loadDataWithModel:(BListModel *)model {
    
    _model = model;
    
    if (![model.pic_urls isEqualToString:@""]) {
        model.picsArr = [NSJSONSerialization JSONObjectWithData:[model.pic_urls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }else {
        model.picsArr = @[];
    }
    
    NSString *urlStr = [model.picsArr.firstObject[@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    model.des = [[model.des componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    
    if (![model.title isEqualToString:@""]) {
        if (![model.des isEqualToString:@""]) {
            if ([model.title isEqualToString:model.des]) {
                model.content = model.title;
            }else {
                model.content = [@[model.title,model.des] componentsJoinedByString:@"\n"];
            }
        }else {
            model.content  = model.title;
        }
    }else {
        model.content = model.des;
    }
    
    _titleLabel.text = model.content;
}


- (void)tapMethod:(UITapGestureRecognizer *)tap {
    ScourceViewController * vc = [[ScourceViewController alloc]init];
    vc.ID = _model.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}



@end
