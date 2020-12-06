//
//  FIndMessageTableViewCell.m
//  News
//
//  Created by dzc on 2018/7/18.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FIndMessageTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "ThemePicContainerView.h"
#import "PicInfo.h"

//CGFloat maxContentLabelHeight = 0; // 根据具体font而定
//const CGFloat contentLabelFontSize = 12;

@interface FIndMessageTableViewCell()<ThemePicContainerViewDlegate>

@property (nonatomic,strong)UIImageView *topicIcon;//主题头像
@property (nonatomic,strong)UILabel *topicName;//主题名字
@property (nonatomic,strong)UILabel *sendTimeLabel;//发布日期
@property (nonatomic,strong)UIButton *oprerationBT;//右上角 下拉箭头
@property (nonatomic,strong)UILabel *title;//内容
@property (nonatomic,strong)UILabel *contentLabel;//内容
//配图
@property (nonatomic,strong)ThemePicContainerView *picContainerView;

@property (nonatomic,strong)UILabel *bottomLine;//线
@property (nonatomic,strong)UIButton *dianzanBT;//点赞button
@property (nonatomic,strong)UILabel *dianzanLabel;//点赞数量
@property (nonatomic,strong)UIButton *comenBT;//
@property (nonatomic,strong)UILabel *comenLabel;//
@property (nonatomic,strong)UIButton *nothingBT;//不知道干啥的button
@property (nonatomic,strong)UILabel *nothingLabel;//不知道干啥的label
@property (nonatomic,strong)UIButton *shareBt;//
@property (nonatomic,strong)UILabel *bottom__Line;//最下面的line

@end

@implementation FIndMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup{
    
    _topicIcon = [[UIImageView alloc]init];
    _topicName = [[UILabel alloc]init];
    
    _sendTimeLabel = [[UILabel alloc]init];
    _sendTimeLabel.font = [UIFont systemFontOfSize:12];
    _sendTimeLabel.textColor = RGBColor(203, 203, 203);
    
    _oprerationBT = [UIButton new];
    [_oprerationBT setBackgroundImage:UIImageNamed(@"info_more") forState:UIControlStateNormal];
    [_oprerationBT addTarget:self action:@selector(oprerationBTClick) forControlEvents:UIControlEventTouchUpInside];

    _title = [UILabel new];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = [UIFont systemFontOfSize:16];
    _title.numberOfLines = 0;

    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.numberOfLines = 0;
    

    
    //图片容器
    _picContainerView = [[ThemePicContainerView alloc]init];
    _picContainerView.delegate = self;
    
    _bottomLine = [[UILabel alloc]init];
    _bottomLine.backgroundColor = RGBColor(235, 235, 235);
    
    _dianzanBT = [UIButton new];
    [_dianzanBT setBackgroundImage:UIImageNamed(@"info_love_pre") forState:UIControlStateNormal];
    [_dianzanBT addTarget:self action:@selector(dianzanBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dianzanBT setImage:[UIImage imageNamed:@"info_love"] forState:UIControlStateSelected];


    _dianzanLabel = [UILabel new];
    _dianzanLabel.textColor = RGBColor(203, 203, 203);
    _dianzanLabel.textAlignment = NSTextAlignmentLeft;
    _dianzanLabel.font = [UIFont systemFontOfSize:13.0];

    _comenBT = [UIButton new];
    [_comenBT setBackgroundImage:UIImageNamed(@"info_comment") forState:UIControlStateNormal];
    [_comenBT addTarget:self action:@selector(comenBTClcik) forControlEvents:UIControlEventTouchUpInside];


    _comenLabel = [UILabel new];
    _comenLabel.textColor = RGBColor(203, 203, 203);
    _comenLabel.textAlignment = NSTextAlignmentLeft;
    _comenLabel.font = [UIFont systemFontOfSize:13.0];

    
    _shareBt = [UIButton new];
    [_shareBt setImage:UIImageNamed(@"info_share") forState:UIControlStateNormal];
    [_shareBt setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBt setTitleColor:RGBColor(203, 203, 203) forState:UIControlStateNormal];
    _shareBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _shareBt.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _shareBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_shareBt addTarget:self action:@selector(shareBtClcik) forControlEvents:UIControlEventTouchUpInside];
    
    _nothingBT = [UIButton new];
    [_nothingBT setBackgroundImage:UIImageNamed(@"info_link") forState:UIControlStateNormal];
    [_nothingBT addTarget:self action:@selector(nothingBTClick) forControlEvents:UIControlEventTouchUpInside];

    _nothingLabel = [UILabel new];
    _nothingLabel.textColor = RGBColor(203, 203, 203);
    _nothingLabel.textAlignment = NSTextAlignmentLeft;
    _nothingLabel.font = [UIFont systemFontOfSize:12.0];

    _bottom__Line = [[UILabel alloc]init];
    _bottom__Line.backgroundColor = RGBColor(245, 245, 245);

    NSArray *views = @[_topicIcon,_topicName,_sendTimeLabel,_oprerationBT,_title,_contentLabel,_picContainerView,_bottomLine,_dianzanBT,_dianzanLabel,_comenBT,_comenLabel,_shareBt,_nothingBT,_nothingLabel,_bottom__Line];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    _topicIcon.sd_layout.leftSpaceToView(contentView, margin).topSpaceToView(contentView, margin).widthIs(40).heightIs(40);
    _topicName.sd_layout.leftSpaceToView(_topicIcon, margin).topSpaceToView(contentView, margin+5).widthIs(160).heightIs(15);
    _sendTimeLabel.sd_layout.leftEqualToView(_topicName).topSpaceToView(_topicName, margin-5).widthIs(150).heightIs(15);
    _oprerationBT.sd_layout.rightSpaceToView(contentView, margin).topEqualToView(_topicIcon).widthIs(15).heightIs(15);
    _title.sd_layout.leftEqualToView(_topicIcon).topSpaceToView(_topicIcon, margin-5).widthIs(kScreenWidth-margin*2).autoHeightRatio(0);
    _contentLabel.sd_layout.leftEqualToView(_topicIcon).topSpaceToView(_title, margin-5).widthIs(kScreenWidth-margin*2).autoHeightRatio(0);
    //图片容器  里面已经设置高度了 你懂的
    _picContainerView.sd_layout.leftSpaceToView(contentView, margin).topSpaceToView(_contentLabel, 10);
    
    _bottomLine.sd_layout.leftEqualToView(_picContainerView).topSpaceToView(_picContainerView, margin).widthIs(kScreenWidth-margin*2).heightIs(1);
    float www = (kScreenWidth-margin*4)/4;
    _dianzanBT.sd_layout.leftSpaceToView(contentView,margin*2).topSpaceToView(_bottomLine, margin).widthIs(20).heightIs(20);
    _dianzanLabel.sd_layout.leftSpaceToView(_dianzanBT, margin).topEqualToView(_dianzanBT).widthIs(50).heightIs(15);
    _comenBT.sd_layout.leftSpaceToView(contentView, margin*2+www).topEqualToView(_dianzanBT).widthIs(20).heightIs(20);
    _comenLabel.sd_layout.leftSpaceToView(_comenBT, margin).topEqualToView(_dianzanLabel).widthIs(50).heightIs(15);
    _shareBt.sd_layout.leftSpaceToView(contentView, www*2+margin*2).topEqualToView(_dianzanBT).widthIs(www).heightIs(20);
    _nothingBT.sd_layout.leftSpaceToView(contentView, www*3+margin*3).topEqualToView(_dianzanBT).widthIs(20).heightIs(20);
    _nothingLabel.sd_layout.leftSpaceToView(_nothingBT, margin).topEqualToView(_dianzanLabel).widthIs(100).heightIs(15);
    _bottom__Line.sd_layout.leftSpaceToView(contentView, 0).topSpaceToView(_dianzanBT, margin).widthIs(kScreenWidth).heightIs(7);


}



- (void)setInfo:(FindMessageInfo *)info
{
    _info = info;
    [_topicIcon sd_setImageWithURL:[NSURL URLWithString:info.topicicon] placeholderImage:nil];
    _topicName.text = info.topicname;
    _sendTimeLabel.text = [self anilaseTIme:info.posttime];
    _title.text = info.title;
    
//    _contentLabel.text = info.des;
    //行间距
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    UIColor *color = [UIColor blackColor];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:info.des attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    _contentLabel.attributedText = string;
    
    //配图
//    if ([info.type intValue] == 0) {
//        //没有配图
//        _picContainerView.picPathStringsArray = nil;
//    }else if ([info.type intValue] == 1){
//        //一个配图
//        _picContainerView.picPathStringsArray = [self analysis:info.pic_urls];
//    }else if([info.type intValue] == 2){
//        //多个配图
//    }
    _picContainerView.type = info.type;
    _picContainerView.index = self.index;
    _picContainerView.picPathStringsArray = [self analysis:info.pic_urls];
    weakObj(self);
    _picContainerView.picBlock = ^(NSIndexPath *index) {
        [selfWeak.delegate gotoFimeMessageSourceVC:index];
    };

    if ([info.if_love intValue] ==1) {
        _dianzanBT.selected = YES;
    }else{
        _dianzanBT.selected = NO;
    }
    _dianzanLabel.text = info.num_love;
    _comenLabel.text = info.num_comment;
    _nothingLabel.text = info.source_site;
    
    
    
    [self setupAutoHeightWithBottomView:_bottom__Line bottomMargin:10];

}
- (void)dianzanBTClick:(UIButton *)button
{
    if ([UserManager shared].isLogin) {
        
        if (button.selected == NO) {
            //点赞
            //userid 用户id
            //token accessToken
            //newsid 消息id
            NSDictionary * param = @{
                                     @"userid":[UserManager shared].userInfo.uid,
                                     @"token":[UserManager shared].userInfo.accessToken,
                                     @"newsid":_info.ID,
                                     };
            [HttpRequest get_RequestWithURL:LIKE_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.dianzanBT.selected = YES;
                        self.info.if_love = @"1";
                        self.info.num_love = @(self.info.num_love.intValue+1).stringValue;
                        self.dianzanLabel.text = [NSString stringWithFormat:@"%@",self.info.num_love];
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
                                     @"newsid":_info.ID,
                                     };
            [HttpRequest get_RequestWithURL:UNLIKE_TOPIC_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
                if (!error) {
                    id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                        self.dianzanBT.selected = NO;
                        self.info.if_love = @"0";
                        if (self.info.num_love.intValue > 0) {
                            self.info.num_love = @(self.info.num_love.intValue-1).stringValue;
                        }
                        self.dianzanLabel.text = [NSString stringWithFormat:@"%@",self.info.num_love];
                    }
                }else {
                    MLog(@"%@",error.localizedDescription);
                }
            }];
            
        }
        
        
    }else {
        //未登陆
        [self.delegate noLogin];
        
    }
}
- (void)comenBTClcik
{
    [self.delegate gotoCommentVC:self];
}
- (void)nothingBTClick
{
    
}
- (void)shareBtClcik
{
    [self.delegate shareBTClick:self.index];
}
- (void)oprerationBTClick
{
    [self.delegate addColletion:self];
}
- (NSMutableArray *)analysis:(NSString *)includes
{
    if (includes.length > 0) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
        NSRange range1 = [includes rangeOfString:@"["];
        NSRange range2 = [includes rangeOfString:@"]"];
        NSString *include = [includes substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        NSArray *includeARR = [include componentsSeparatedByString:@"},"];
        for (int i =0; i<includeARR.count; i++) {
            NSString *srr = includeARR[i];
            if (![srr hasSuffix:@"}"]) {
                srr =  [srr stringByAppendingString:@"}"];
            }
            NSData *JSONData = [srr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            PicInfo *info = [[PicInfo alloc]init];
            [info setValuesForKeysWithDictionary:responseJSON];
            [tmpArr addObject:info];
//            NSString *small = responseJSON[@"small"];
//            NSString *big = responseJSON[@"big"];
//            NSString *width = responseJSON[@"width"];
//            NSString *height = responseJSON[@"height"];
            
        }
        return tmpArr;
    }else{
        return nil;
    }
    
    
}

- (NSMutableArray *)analysis222:(NSString *)includes
{
    if (includes.length > 0) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
        NSRange range1 = [includes rangeOfString:@"["];
        NSRange range2 = [includes rangeOfString:@"]"];
        NSString *include = [includes substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        NSArray *includeARR = [include componentsSeparatedByString:@"},"];
        for (int i =0; i<includeARR.count; i++) {
            NSString *srr = includeARR[i];
            if (![srr hasSuffix:@"}"]) {
                srr =  [srr stringByAppendingString:@"}"];
            }
            NSData *JSONData = [srr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            //            NSString *small = responseJSON[@"small"];
            //             NSString *big = responseJSON[@"big"];
            //            NSString *width = responseJSON[@"width"];
            //            NSString *height = responseJSON[@"height"];
            
            [tmpArr addObject:responseJSON];

        }
        return tmpArr;
    }else{
        return nil;
    }
    
    
}

- (void)picXXXXX:(long)index
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIImageView * imageView = (UIImageView *)self.picContainerView.imageViewsArray[index];
    
    CGRect frame = [imageView convertRect:imageView.bounds toView:app.window];
    
    PicPreView * picView = [[PicPreView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    
    [picView picArr:[self analysis222:_info.pic_urls] atIndex:index fromRect:frame];
    
    [app.window addSubview:picView];

}


#pragma mark 时间戳
- (NSString *)anilaseTIme:(NSString *)time
{
    NSTimeInterval interval    = [time doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
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
