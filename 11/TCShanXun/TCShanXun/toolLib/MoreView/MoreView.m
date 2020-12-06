//
//  MoreView.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/20.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "MoreView.h"
#import "MoreViewCell.h"
#import "AppDelegate.h"

@interface MoreView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIButton * maskButton;
@property(nonatomic, strong)UIView * bgView;
@property(nonatomic, strong)UIButton * cancelButton;

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataSource;
@property(nonatomic, assign)CGFloat tableHeight;

@property(nonatomic, assign)float aniHeight;

@end

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
        [self initial];
        [self addSubviews];

    }
    return self;
}

- (void)maskButtonClicked:(UIButton *)button {
    [self dismiss];
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

- (void)addSubviews {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, sHeight, sWidth, sHeight)];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, _bgView.height-kBottomInsets-65, sWidth-20, 55)];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.cornerRadius = 10.;
    _cancelButton.titleLabel.font = UIFontBSys(20);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:RGBColor(60, 180, 245) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelButton];
}
- (void)cancelButtonMethod:(UIButton *)button {
    [self dismiss];
}


/** */
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)showWithData:(NSArray *)oArr object:(id)model {
    
    NSArray * listArr = nil;
    if (oArr) {
        listArr = oArr;
    }else {
        listArr = @[
                    @"举报"
                    ];
    }
    
    [self.dataSource setArray:listArr];
    [self addTableView];
    [self show];
}

- (void)show {
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 1;
        self.bgView.frame = CGRectMake(0, sHeight - self.aniHeight, sWidth, sHeight);
    }];
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.bgView.frame = CGRectMake(0, sHeight, sWidth, sHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissMoreView:)]) {
            [self.delegate dismissMoreView:self];
        }
    }];
}


- (void)addTableView {

    _tableHeight = self.dataSource.count * 55;
    _aniHeight = _tableHeight+10+_cancelButton.height+10+kBottomInsets;
    _cancelButton.frame = CGRectMake(10, _tableHeight+10, sWidth-20, 55);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, sWidth-20, _tableHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBColor(247, 247, 247);
    _tableView.cornerRadius = 10.;
    [_tableView registerClass:[MoreViewCell class] forCellReuseIdentifier:@"MoreViewCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 55;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
    [_bgView addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MoreViewCell" forIndexPath:indexPath];
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskButton.alpha = 0;
        self.bgView.frame = CGRectMake(0, sHeight, sWidth, sHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (indexPath.section == 0 && self.delegate && [self.delegate respondsToSelector:@selector(moreView:selectedAtIndex:)]) {
            [self.delegate moreView:self selectedAtIndex:(int)(indexPath.row)];
        }
    }];
    
}


- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
