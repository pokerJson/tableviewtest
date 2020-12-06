//
//  FirstTableViewCell.m
//  News
//
//  Created by dzc on 2018/7/11.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FirstTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "ThemePicContainerView.h"

CGFloat maxContentLabelHeight = 0; // 根据具体font而定
const CGFloat contentLabelFontSize = 15;

@interface FirstTableViewCell ()


@property (nonatomic,strong)UIView *backGroundView;//背景白色
@property (nonatomic,strong)UILabel *sendTimeLabel;//发布日期
@property (nonatomic,strong)UIButton *oprerationBT;//右上角 下拉箭头
@property (nonatomic,strong)UILabel *contentLabel;//内容
@property (nonatomic,strong)UIButton *moreBt;//全文
//配图
@property (nonatomic,strong)ThemePicContainerView *picContainerView;

@property (nonatomic,strong)UIImageView *authorIcon;//发布者头像
@property (nonatomic,strong)UILabel *authorName;//发布者
@property (nonatomic,strong)UILabel *sendLabel;//发布  字样
@property (nonatomic,strong)UILabel *bottomLine;//线
@property (nonatomic,strong)UIButton *dianzanBT;//点赞button
@property (nonatomic,strong)UILabel *dianzanLabel;//点赞数量
@property (nonatomic,strong)UIImageView *comenImageV;//
@property (nonatomic,strong)UILabel *comenLabel;//
@property (nonatomic,strong)UIButton *nothingBT;//不知道干啥的button
@property (nonatomic,strong)UILabel *nothingLabel;//不知道干啥的label
@property (nonatomic,strong)UIButton *shareBt;//
@property (nonatomic,strong)UILabel *bottom__Line;//最下面的line









@end

@implementation FirstTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup{
    
    _sendTimeLabel = [[UILabel alloc]init];
    _sendTimeLabel.textColor = RGBColor(33, 33, 33);
    _sendTimeLabel.textAlignment = NSTextAlignmentLeft;
    _sendTimeLabel.font = [UIFont systemFontOfSize:12.0];
    
    _oprerationBT = [UIButton new];
    [_oprerationBT setBackgroundImage:UIImageNamed(@"ic_common_arrow_down") forState:UIControlStateNormal];
    [_oprerationBT addTarget:self action:@selector(oprerationBTClick) forControlEvents:UIControlEventTouchUpInside];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }

    
    _moreBt = [UIButton new];
    [_moreBt setTitle:@"全文" forState:UIControlStateNormal];
    [_moreBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_moreBt addTarget:self action:@selector(moreBtClick) forControlEvents:UIControlEventTouchUpInside];
    _moreBt.titleLabel.font = [UIFont systemFontOfSize:14];

    //图片容器
    _picContainerView = [[ThemePicContainerView alloc]init];
    

    _authorIcon = [[UIImageView alloc]init];
    
    _authorName = [[UILabel alloc]init];
    _authorName.font = [UIFont systemFontOfSize:12.0];
    _authorName.textColor = RGBColor(137, 137, 137);
    
    _sendLabel = [[UILabel alloc]init];
    _sendLabel.text = @"发布";
    _sendLabel.textAlignment = NSTextAlignmentLeft;
    _sendLabel.font = [UIFont systemFontOfSize:12.0];
    _sendLabel.textColor = RGBColor(137, 137, 137);
    
    _bottomLine = [[UILabel alloc]init];
    _bottomLine.backgroundColor = RGBColor(235, 235, 235);
    
    _dianzanBT = [UIButton new];
    [_dianzanBT setBackgroundImage:UIImageNamed(@"ic_messages_like") forState:UIControlStateNormal];
    [_dianzanBT addTarget:self action:@selector(dianzanBTClick) forControlEvents:UIControlEventTouchUpInside];
    
    _dianzanLabel = [[UILabel alloc]init];
    _dianzanLabel.textColor = RGBColor(33, 33, 33);
    _dianzanLabel.textAlignment = NSTextAlignmentLeft;
    _dianzanLabel.font = [UIFont systemFontOfSize:12.0];
    
    _comenImageV = [[UIImageView alloc]init];
    _comenImageV.image = UIImageNamed(@"ic_messages_comment");
    
    _comenLabel = [[UILabel alloc]init];
    _comenLabel.textColor = RGBColor(33, 33, 33);
    _comenLabel.textAlignment = NSTextAlignmentLeft;
    _comenLabel.font = [UIFont systemFontOfSize:12.0];

    _nothingBT = [UIButton new];
    [_nothingBT setBackgroundImage:UIImageNamed(@"ic_messages_repost") forState:UIControlStateNormal];
    [_nothingBT addTarget:self action:@selector(nothingBTClick) forControlEvents:UIControlEventTouchUpInside];
    
    _nothingLabel = [[UILabel alloc]init];
    _nothingLabel.textColor = RGBColor(33, 33, 33);
    _nothingLabel.textAlignment = NSTextAlignmentLeft;
    _nothingLabel.font = [UIFont systemFontOfSize:12.0];

    _shareBt = [UIButton new];
    [_shareBt setBackgroundImage:UIImageNamed(@"ic_messages_share") forState:UIControlStateNormal];
    [_shareBt addTarget:self action:@selector(shareBtClcik) forControlEvents:UIControlEventTouchUpInside];
    
    _bottom__Line = [[UILabel alloc]init];
    _bottom__Line.backgroundColor = RGBColor(222, 222, 222);

    NSArray *views = @[_sendTimeLabel,_oprerationBT,_contentLabel,_moreBt,_picContainerView,_authorIcon,_authorName,_sendLabel,_bottomLine,_dianzanBT,_dianzanLabel,_comenImageV,_comenLabel,_nothingBT,_nothingLabel,_shareBt,_bottom__Line];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _sendTimeLabel.sd_layout
    .leftSpaceToView(contentView, margin+5)
    .topSpaceToView(contentView, 15)
    .heightIs(15)
    .widthIs(50);
    
    _oprerationBT.sd_layout
    .rightSpaceToView(contentView, margin)
    .topEqualToView(_sendTimeLabel)
    .widthIs(15)
    .heightIs(15);
    
    _contentLabel.sd_layout.leftSpaceToView(contentView, margin+5).topSpaceToView(_sendTimeLabel, margin).rightSpaceToView(contentView, margin+10).autoHeightRatio(0);
    _moreBt.sd_layout.leftSpaceToView(contentView, margin+5).topSpaceToView(_contentLabel, 0).widthIs(30);
    
    //图片容器  里面已经设置高度了 你懂的
    _picContainerView.sd_layout.leftSpaceToView(contentView, margin);
    
    //发布者
    _authorIcon.sd_layout.leftSpaceToView(contentView, margin+5).topSpaceToView(_picContainerView, margin+4).widthIs(20).heightIs(20);
    _authorName.sd_layout.topEqualToView(_authorIcon).leftSpaceToView(_authorIcon, margin).widthIs(70).heightIs(15);
    _sendLabel.sd_layout.topEqualToView(_authorIcon).leftSpaceToView(_authorName, 10).widthIs(50).heightIs(15);
    _bottomLine.sd_layout.leftSpaceToView(contentView, margin+5).topSpaceToView(_authorName, 10).widthIs(kScreenWidth-(margin +5)*2).heightIs(1);
    //
    _dianzanBT.sd_layout.leftSpaceToView(contentView, margin+5).topSpaceToView(_bottomLine, margin).widthIs(20).heightIs(20);
    _dianzanLabel.sd_layout.leftSpaceToView(_dianzanBT, 10).topEqualToView(_dianzanBT).widthIs(50).heightIs(15);
    _comenImageV.sd_layout.leftSpaceToView(_dianzanLabel, 10).topEqualToView(_dianzanBT).widthIs(20).heightIs(20);
    _comenLabel.sd_layout.leftSpaceToView(_comenImageV, 10).topEqualToView(_dianzanLabel).widthIs(50).heightIs(15);
    _nothingBT.sd_layout.leftSpaceToView(_comenLabel, 10).topEqualToView(_dianzanBT).widthIs(20).heightIs(20);
    _nothingLabel.sd_layout.leftSpaceToView(_nothingBT, 10).topEqualToView(_comenLabel).widthIs(50).heightIs(15);
    _shareBt.sd_layout.rightSpaceToView(contentView, margin+5).topEqualToView(_dianzanBT).widthIs(20).heightIs(20);
    _bottom__Line.sd_layout.leftSpaceToView(contentView, 0).topSpaceToView(_dianzanBT, margin).widthIs(kScreenWidth).heightIs(7);
    
}

- (void)setInfo:(ThemeInfo *)info
{
    _info = info;
    _sendTimeLabel.text = info.sendTime;
    _contentLabel.text = info.contentstr;
    //配图
    _picContainerView.picPathStringsArray = info.imageuRLArr;
    
    _authorIcon.image = UIImageNamed(info.authorIcon);
    _authorName.text = info.authorName;
    _dianzanLabel.text = info.dianzanNum;
    _comenLabel.text = info.comentNum;
    _nothingLabel.text = info.nothingNum;
    
    if (info.shouldShowMoreButton) { // 如果文字高度超过60
        _moreBt.sd_layout.heightIs(20);
        _moreBt.hidden = NO;
        if (info.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreBt setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreBt setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreBt.sd_layout.heightIs(0);
        _moreBt.hidden = YES;
    }
    //设置下图片
    CGFloat picContainerTopMargin = 0;
    if (info.imageuRLArr.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreBt, picContainerTopMargin);

    [self setupAutoHeightWithBottomView:_bottom__Line bottomMargin:10];

}

- (void)oprerationBTClick
{
    
}
- (void)moreBtClick
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexpath);
    }
}
- (void)dianzanBTClick
{
    
}
- (void)nothingBTClick
{
    
}
- (void)shareBtClcik
{
    
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
