//
//  CommentCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/9.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@interface CommentCell ()

@property(nonatomic, strong)UIButton * iconButton;
@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UILabel * timeLabel;
@property(nonatomic, strong)UILabel * contentLabel;

@property(nonatomic, strong)TIButton * likeButton;

@property(nonatomic, strong)CommentModel * model;

@property(nonatomic, strong)UIButton * deleteButton;

@end


@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.frame = CGRectMake(0, 0, kScreenWidth, self.height);
    
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
    }
}

- (void)addSubviews {
 
    _iconButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 44, 44)];
    _iconButton.contentMode = UIViewContentModeScaleAspectFill;
    _iconButton.backgroundColor = [UIColor lightGrayColor];
    _iconButton.layer.cornerRadius = 22.;
    _iconButton.layer.masksToBounds = YES;
    _iconButton.borderWidth = 1;
    _iconButton.borderColor = RGBColor(220, 220, 220);
    [_iconButton addTarget:self action:@selector(iconButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(74, _iconButton.y, sWidth-174, 25)];
    _nameLabel.textColor = RGBColor(120, 120, 120);
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(74, _iconButton.y+25, sWidth-174, 15)];
    _timeLabel.textColor = RGBColor(200, 200, 200);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timeLabel];
    
    _likeButton = [[TIButton alloc]initWithFrame:CGRectMake(sWidth-95, 20, 80, 16)];
    _likeButton.hidden = YES;
    _likeButton.titleLabel.font = UIFontSys(12);
    [_likeButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    [_likeButton setImage:UIImageNamed(@"info_love_pre") forState:UIControlStateNormal];
    [_likeButton setImage:UIImageNamed(@"info_love") forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = RGBColor(50, 50, 50);
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(74, sHeight-25, 44, 15)];
    _deleteButton.hidden = YES;
    _deleteButton.titleLabel.font = UIFontSys(12);
    _deleteButton.contentHorizontalAlignment = 1;
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:RGBColor(80, 105, 144) forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)deleteButtonMethod:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteComment:)]) {
        [self.delegate deleteComment:self];
    }
}

- (void)iconButtonMethod:(UIButton *)button {
    if (_personBlock) {
        _personBlock(_model.uid);
    }
}

- (void)likeButtonMethod:(TIButton *)button {
    
    if ([UserManager shared].isLogin) {
        
        //userid 用户id
        //token accessToken
        //cid 评论id
        
        NSDictionary * param = @{
                                 @"userid":[UserManager shared].userInfo.uid,
                                 @"token":[UserManager shared].userInfo.accessToken,
                                 @"cid":_model.ID,
                                 };
        
        [HttpRequest get_RequestWithURL:LIKE_COMMENT_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
            if (!error) {
                id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                    
                    //code = 200,
                    //data = 1,
                    //msg = "success",
                    self.likeButton.selected = YES;
                    self.model.has_like = @"1";
                    self.model.like_count = [dic[@"data"] stringValue];
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",self.model.like_count] forState:UIControlStateNormal];
                }
            }else {
                MLog(@"%@",error.localizedDescription);
            }
        }];
        
        
        
    }else {
    
        BNavigationController * nav = [[BNavigationController alloc]initWithRootViewController:[ReAndLoViewController new]];
        nav.navigationBar.hidden = YES;
        [self.viewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)loadDataWithModel:(CommentModel *)model {
    _model = model;
    
    [_iconButton sd_setImageWithURL:[NSURL URLWithString:model.uhead] forState:UIControlStateNormal];
    _nameLabel.text = model.uname;
    _timeLabel.text = [self dateFormat:[model.ctime integerValue]];
    _contentLabel.frame = CGRectMake(74, 64, sWidth-89, model.contentHeight);
    _contentLabel.attributedText = [self attributed:model.content lineSpace:5];

    if (model.like_count.intValue == 0) {
        [_likeButton setTitle:nil forState:UIControlStateNormal];
    }else {
        [_likeButton setTitle:[NSString stringWithFormat:@"%@",model.like_count] forState:UIControlStateNormal];
    }
    
    if (model.has_like.intValue == 0) {
        _likeButton.selected = NO;
    }else {
        _likeButton.selected = YES;
    }
    
    if ([UserManager shared].isLogin && [model.uid isEqualToString:[UserManager shared].userInfo.uid]) {
        _deleteButton.hidden = NO;
    }else {
        _deleteButton.hidden = YES;
    }
    
    _deleteButton.frame = CGRectMake(74, sHeight-25, 44, 15);
}

- (NSString *)dateFormat:(NSInteger)timeStamp {
    timeStamp= timeStamp/1000;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate: detailDate];
}


- (NSAttributedString *)attributed:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [UIView animateWithDuration:0.25 animations:^{
        if(highlighted)
            self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        else
            self.contentView.backgroundColor = [UIColor whiteColor];
    }];
}

@end
