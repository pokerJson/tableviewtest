//
//  TijianjianTableViewCell.m
//  News
//
//  Created by dzc on 2018/7/12.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TijianjianTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "TuijianCollectionViewCell.h"

@interface TijianjianTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLable;//相关推荐
@property (nonatomic,strong) UICollectionView *collectionView;//相关推荐
@property (nonatomic,strong) NSArray *collectiondataARR;//


@end

@implementation TijianjianTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.collectiondataARR = [[NSArray alloc]init];
        self.backgroundColor = RGBColor(222, 222, 222);
    }
    return self;
}
- (void)setup
{
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:13.0];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    _titleLable.text = @"相关推荐";
    
    [self.contentView addSubview:_titleLable];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = RGBColor(222, 222, 222);
//    _collectionView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_collectionView];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[TuijianCollectionViewCell class] forCellWithReuseIdentifier:@"tuijian"];
    
    NSArray *views = @[_titleLable,_collectionView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    _titleLable.sd_layout.leftSpaceToView(contentView, 10).topSpaceToView(contentView, 5).widthIs(100).heightIs(15);
    _collectionView.sd_layout.leftSpaceToView(contentView, 0).topSpaceToView(_titleLable, 5).widthIs(kScreenWidth).heightIs(200);

}
-(void)setInfo:(TuijianInfo *)info
{
    _info = info;
    if (info.attentionArr.count>0) {
        self.collectiondataARR = info.attentionArr;
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectiondataARR.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TuijianCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tuijian" forIndexPath:indexPath];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:self.collectiondataARR[indexPath.row]] placeholderImage:nil];
    cell.attentionBT_Block = ^(TuijianCollectionViewCell *cell) {
        
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(160, 200);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
