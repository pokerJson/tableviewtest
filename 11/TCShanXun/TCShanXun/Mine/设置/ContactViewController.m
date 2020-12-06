
//
//  ContactViewController.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/24.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.font = UIFontBSys(18);
    self.navTitleLabel.text = @"联系我们";
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_black") forState:UIControlStateNormal];
    
    self.view.backgroundColor = RGBColor(245, 245, 245);
    
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navBarView.bottom+10, kWidth, 130)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, bgView.width-30, 20)];
    titleLabel.text = @"联系我们";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, bgView.width-30, 80)];
    //content.backgroundColor = [UIColor greenColor];
    content.attributedText = [self attributed:@"您好,如果您有什么问题和建议,可以加闪讯官方QQ:2307298189,和我们官方的客服同学一起交流,您的宝贵意见是我们进步的动力!" lineSpace:5];
    content.textColor = [UIColor blackColor];
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:content];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSAttributedString *)attributed:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return attributedString;
}



@end
