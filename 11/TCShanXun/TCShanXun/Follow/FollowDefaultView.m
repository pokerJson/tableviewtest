//
//  FollowDefaultView.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FollowDefaultView.h"
#import "FollowDefaultCell.h"
#import "TopicViewController.h"

@interface FollowDefaultView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UILabel * titleLabel;

@property(nonatomic, strong)UICollectionView * collectionView;
@property(nonatomic, strong)NSMutableArray * dataSource;

@property(nonatomic, strong)UIButton * refreshButton;
@property(nonatomic, strong)UIButton * submitButton;

@property(nonatomic, assign)__block int num_follow;

@end

@implementation FollowDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
        //[self loadData];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden == NO) {
        if (self.dataSource.count == 0) {
            [self.collectionView setContentOffset:CGPointZero animated:YES];
            [self loadData];
        }else {
            [_collectionView reloadData];
        }
        _submitButton.enabled = NO;
    }
}

/** dataSource*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)initial {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addSubviews {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, sWidth, 25)];
    _titleLabel.text = @"为您推荐的主题";
    _titleLabel.textColor = RGBColor(64, 64, 64);
    _titleLabel.textAlignment = 0;
    _titleLabel.font = [UIFont systemFontOfSize:24];
    [self addSubview:_titleLabel];
    
    
    float h = sHeight-85-200>350?350:(sHeight-85-150);
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 85, sWidth, h) collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *)) _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectionView.backgroundColor = RGBColor(255, 255, 255);
    [_collectionView registerClass:[FollowDefaultCell class] forCellWithReuseIdentifier:@"FollowDefaultCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    
    float inset = (sHeight-_collectionView.bottom-25-40)/3.;
    
    
    _refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(kHalf(sWidth-100), _collectionView.bottom+0.8*inset, 100, 25)];
    _refreshButton.adjustsImageWhenHighlighted = NO;
    _refreshButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_refreshButton setTitle:@"换一组" forState:UIControlStateNormal];
    [_refreshButton setTitleColor:RGBColor(165, 165, 165) forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(refreshButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refreshButton];
    
    UIImage * hong = [UIImage imageWithColor:RGBColor(255,77,32) imageSize:CGRectMake(0, 0, 5, 5)];
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(80, _refreshButton.bottom+0.8*inset, sWidth-160, 40)];
    _submitButton.enabled = NO;
    _submitButton.adjustsImageWhenHighlighted = NO;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _submitButton.cornerRadius = 5;
    [_submitButton setBackgroundImage:hong forState:UIControlStateNormal];
    [_submitButton setTitle:@"进入关注频道" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];

}

- (void)submitButtonMethod:(UIButton *)button {
    
    if (_callBack) {
        _callBack();
    }
    
}

- (void)refreshButtonMethod:(UIButton *)button {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [self loadData];
}

- (void)loadData {
    
    [HttpRequest get_RequestWithURL:TOPIC_RECOMMEND_URL URLParam:nil returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                NSArray * arr = dic[@"data"];
                
                if (arr.count != 0) {
                    
                    int m = arr.count > 6 ? 6: (int)arr.count;
                    
                    [self.dataSource removeAllObjects];
                    
                    for (int i = 0; i < m; i++) {
                        BListModel * model = [BListModel new];
                        [model setValuesForKeysWithDictionary:arr[i]];
                        [self.dataSource addObject:model];
                    }
                    [self.collectionView reloadData];
                    
                }
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}

- (void)submit {
    
    if (_num_follow >0) {
        _submitButton.enabled = YES;
    }else {
        _submitButton.enabled = NO;
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowDefaultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowDefaultCell" forIndexPath:indexPath];
    
    BListModel * model = self.dataSource[indexPath.row];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * if_guanzhu = app.overallParam[model.topicid];
    if (if_guanzhu != nil) model.if_guanzhu = if_guanzhu;
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    weakObj(self);
    cell.callBack = ^(int m) {
        selfWeak.num_follow = selfWeak.num_follow+m;
        [selfWeak submit];
    };
    return cell;
}


//大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 150);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //secton 之间的边距
    return UIEdgeInsetsMake(20, floorf((sWidth-300)/4.0), 20, floorf((sWidth-300)/4.0));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return floorf((sWidth-300)/4.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BListModel * model = self.dataSource[indexPath.row];
    TopicViewController * vc = [[TopicViewController alloc]init];
    vc.topicID = model.topicid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
