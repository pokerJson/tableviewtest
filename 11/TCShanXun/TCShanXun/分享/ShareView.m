//
//  ShareView.m
//  News
//
//  Created by FANTEXIX on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import "ShareCell.h"

#define bgheight (295+kBottomInsets)


@interface ShareView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * bgView;
@property(nonatomic, strong)UIView * kindsBgView;
@property(nonatomic, strong)UIButton * cancelButton;

@property(nonatomic, strong)UICollectionView * firstView;
@property(nonatomic, strong)NSArray * firstArr;
@property(nonatomic, strong)UICollectionView * secondView;
@property(nonatomic, strong)NSArray * secondArr;

@end

@implementation ShareView

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
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, bgheight)];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    
    _kindsBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, sWidth-20, 210)];
    _kindsBgView.backgroundColor = [UIColor whiteColor];
    _kindsBgView.cornerRadius = 10.;
    [_bgView addSubview:_kindsBgView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _kindsBgView.width, 30)];
    titleLabel.text = @"分享到";
    titleLabel.textColor = RGBColor(150, 150, 150);
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [_kindsBgView addSubview:titleLabel];
    
    
    UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
    flayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _firstView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, _kindsBgView.width, 75) collectionViewLayout:flayout];
    _firstView.backgroundColor = [UIColor whiteColor];
    [_firstView registerClass:[ShareCell class] forCellWithReuseIdentifier:@"ShareCell"];
    _firstView.dataSource  = self;
    _firstView.delegate = self;
    _firstView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _firstView.showsHorizontalScrollIndicator = NO;
    [_kindsBgView addSubview:_firstView];
    
    _firstArr = @[
                        @{
                            @"img":@"ic_share_wechat_timeline",
                            @"type":@"0",
                            @"name":@"朋友圈",
                            @"index":@"1",
                            },
                        @{
                            @"img":@"ic_share_wechat",
                            @"type":@"0",
                            @"name":@"微信",
                            @"index":@"2",
                            },
                        @{
                            @"img":@"ic_share_qzone",
                            @"type":@"0",
                            @"name":@"QQ空间",
                            @"index":@"3",
                            },
                        @{
                            @"img":@"ic_share_qq",
                            @"type":@"0",
                            @"name":@"QQ",
                            @"index":@"4",
                            },
                        @{
                            @"img":@"ic_share_weibo",
                            @"type":@"0",
                            @"name":@"微博",
                            @"index":@"5",
                            },
                        ];
    
    [_firstView reloadData];
    
    
    UICollectionViewFlowLayout * slayout = [[UICollectionViewFlowLayout alloc]init];
    slayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _secondView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 125, _kindsBgView.width, 75) collectionViewLayout:slayout];
    _secondView.backgroundColor = [UIColor whiteColor];
    [_secondView registerClass:[ShareCell class] forCellWithReuseIdentifier:@"ShareCell"];
    _secondView.dataSource  = self;
    _secondView.delegate = self;
    _secondView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _secondView.showsHorizontalScrollIndicator = NO;
    [_kindsBgView addSubview:_secondView];

    _secondArr = @[
                        @{
                            @"img":@"ic_share_copylink",
                            @"type":@"1",
                            @"name":@"复制链接",
                            @"index":@"6",
                            },
                        @{
                            @"img":@"ic_share_more",
                            @"type":@"1",
                            @"name":@"更多",
                            @"index":@"8",
                            },
                        ];

    [_secondView reloadData];
    
    
    UIView * speLine = [[UIView alloc]initWithFrame:CGRectMake(0, 125, _kindsBgView.width, 0.4)];
    speLine.backgroundColor = RGBColor(190, 190, 190);
    [_kindsBgView addSubview:speLine];
    
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, _bgView.height-kBottomInsets-65, sWidth-20, 55)];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.cornerRadius = 10.;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelButton];
}

- (void)cancelButtonMethod:(UIButton *)button {
    [self dismiss];
}


- (void)showWithShortcutOptions:(NSArray *)oArr object:(id)model {
    [self show];
}

- (void)show {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskButton.alpha = 1;
        self.bgView.frame = CGRectMake(0, kScreenHeight - bgheight, kScreenWidth, bgheight);
    } completion:^(BOOL finished) {
        
    }];

    
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, bgheight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _firstView) {
         return self.firstArr.count;
    }else {
         return self.secondArr.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];

    if (collectionView == _firstView) {
        [cell loadDataWithModel:self.firstArr[indexPath.row]];
    }else {
        [cell loadDataWithModel:self.secondArr[indexPath.row]];

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(65, 75);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    int index;
    if (collectionView == _firstView) {
        index = [_firstArr[indexPath.row][@"index"] intValue];
    }else {
        index = [_secondArr[indexPath.row][@"index"] intValue];
    }
    //NSLog(@"index : %d",index);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewSelectedAtIndex:)]) {
        [self.delegate shareViewSelectedAtIndex:index];
    }
    
    [self dismiss];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
