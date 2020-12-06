//
//  FavoriteView.m
//  News
//
//  Created by FANTEXIX on 2018/7/20.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FavoriteView.h"
#import "AppDelegate.h"

#import "BListModel.h"

@interface FavoriteView ()

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * bgView;
@property(nonatomic, strong)UIButton * collectionButton;

@property(nonatomic, strong)BListModel * model;

@end

@implementation FavoriteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    _maskButton = [[UIButton alloc]initWithFrame:self.bounds];
    _maskButton.alpha = 0;
    _maskButton.backgroundColor = RGBAColor(0, 0, 0, 0.45);
    [_maskButton addTarget:self action:@selector(maskButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_maskButton];
}

- (void)maskButtonClicked:(UIButton *)button {
    [self dismiss];
}

- (void)addSubviews {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.cornerRadius = 10;
    [self addSubview:_bgView];
    
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bgView.width, 50)];
    _collectionButton.contentHorizontalAlignment = 1;
    _collectionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    _collectionButton.adjustsImageWhenHighlighted = NO;
    [_collectionButton setBackgroundImage:[UIImage imageWithColor:RGBColor(240, 240, 240) imageSize:CGRectMake(0, 0, 5, 5)] forState:UIControlStateHighlighted];
    _collectionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_collectionButton setImage:[UIImage imageNamed:@"ic_messages_collect_unselected"] forState:UIControlStateNormal];
    [_collectionButton setTitle:@"加入收藏" forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"ic_messages_collect_selected"] forState:UIControlStateSelected];
    [_collectionButton setTitle:@"取消收藏" forState:UIControlStateSelected];
    [_collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_collectionButton addTarget:self action:@selector(collectionButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_collectionButton];
    
}

- (void)collectionButtonMethod:(UIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //收藏
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"newsid":_model.ID,
                                     };
            
            [HttpRequest get_RequestWithURL:FAVO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        
                        self.model.if_fav = @"1";
                        self.collectionButton.selected = YES;
                        [self dismiss];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
            }];
            
        }else {
            //取消
            
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"newsid":_model.ID,
                                     };
            
            [HttpRequest get_RequestWithURL:UNFAVO_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.model.if_fav = @"0";
                        self.collectionButton.selected = NO;
                        [self dismiss];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
            }];
            
        }
        
        
    }else {
        //未登陆
        if (_loginMethod) {
            _loginMethod();
            [self dismiss];
        }
    }
}



- (void)showWithY:(float)y object:(BListModel *)model {
    
    _model = model;
    
    _bgView.frame = CGRectMake(10, y, kScreenWidth-20, 50);
    
    if (_model.if_fav.intValue == 0) {
        _collectionButton.selected = NO;
    }else {
        _collectionButton.selected = YES;
    }
    
    [self show];
}

- (void)show {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskButton.alpha = 1;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
