//
//  KKHUD.m
//  KanKan
//
//  Created by FANTEXIX on 2017/2/24.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "KKHUD.h"
#import "AppDelegate.h"

#define SDELAY 0
#define DURING 0.85

#define FontSize_top        15
#define FontSize_middle     17
#define FontSize_bottom     15

@interface KKHUD ()

@property(nonatomic, strong)UIImageView * statusImageView;
@property(nonatomic, strong)UILabel * statusLabel;

@end


@implementation KKHUD


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = NO;

    }
    return self;
}

+ (void)showTopWithStatus:(NSString *)status {
    
    float width = [status boundingRectWithSize:CGSizeMake(kScreenWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontSys(15)} context:nil].size.width;
    
    if (width > 180) {
        width = 180;
    }
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    KKHUD * HUD = [[KKHUD alloc]initWithFrame:CGRectMake((kScreenWidth - width - 20)*0.5, 20, width + 20, 35)];
    HUD.alpha = 0;
    [app.window addSubview:HUD];
    
    HUD.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, width, HUD.bounds.size.height)];
    HUD.statusLabel.text = status;
    HUD.statusLabel.font = UIFontSys(15);
    HUD.statusLabel.textColor = [UIColor whiteColor];
    HUD.statusLabel.textAlignment = 1;
    [HUD addSubview:HUD.statusLabel];
    
    
    [UIView animateWithDuration:0.25 delay:SDELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        HUD.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:DURING options:UIViewAnimationOptionCurveEaseInOut animations:^{
            HUD.alpha = 0;
        } completion:^(BOOL finished) {
            [HUD removeFromSuperview];
        }];
    }];
}
+ (void)showMiddleWithStatus:(NSString *)status {
    
    float width = [status boundingRectWithSize:CGSizeMake(kScreenWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontSys(16)} context:nil].size.width;
    
    if (width > kScreenWidth-100) {
        width = kScreenWidth-100;
    }
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    KKHUD * HUD = [[KKHUD alloc]initWithFrame:CGRectMake((kScreenWidth - width - 40)*0.5, (kScreenHeight - 44)*0.5, width + 40, 44)];
    HUD.alpha = 0;
    [app.window addSubview:HUD];
    
    HUD.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, width, HUD.bounds.size.height)];
    HUD.statusLabel.text = status;
    HUD.statusLabel.font = UIFontSys(16);
    HUD.statusLabel.textColor = [UIColor whiteColor];
    HUD.statusLabel.textAlignment = 1;
    [HUD addSubview:HUD.statusLabel];
    
    
    [UIView animateWithDuration:0.25 delay:SDELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        HUD.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:DURING options:UIViewAnimationOptionCurveEaseInOut animations:^{
            HUD.alpha = 0;
        } completion:^(BOOL finished) {
            [HUD removeFromSuperview];
        }];
    }];
}

+ (void)showMiddleWithSuccessStatus:(NSString *)status {
    
    float width = [status boundingRectWithSize:CGSizeMake(kScreenWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontSys(17)} context:nil].size.width;
    
    if (width > 180) {
        width = 180;
    }
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    KKHUD * HUD = [[KKHUD alloc]initWithFrame:CGRectMake((kScreenWidth-width-30)*0.5, (kScreenHeight - 85)*0.5, width + 30, 85)];
    HUD.alpha = 0;
    [app.window addSubview:HUD];
    
    HUD.statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake((HUD.bounds.size.width - 24)*0.5, 15, 24, 24)];
    HUD.statusImageView.image = UIImageNamed(@"sheet_icon_success");
    [HUD addSubview:HUD.statusImageView];
    
    HUD.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, HUD.bounds.size.width, 40)];
    HUD.statusLabel.text = status;
    HUD.statusLabel.font = UIFontSys(17);
    HUD.statusLabel.textColor = [UIColor whiteColor];
    HUD.statusLabel.textAlignment = 1;
    [HUD addSubview:HUD.statusLabel];
    
    HUD.statusImageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [UIView animateWithDuration:0.25 delay:SDELAY usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        HUD.statusImageView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:SDELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        HUD.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:DURING options:UIViewAnimationOptionCurveEaseInOut animations:^{
            HUD.alpha = 0;
        } completion:^(BOOL finished) {
            [HUD removeFromSuperview];
        }];
    }];
}

+ (void)showMiddleWithErrorStatus:(NSString *)status {
    
    float width = [status boundingRectWithSize:CGSizeMake(kScreenWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontSys(17)} context:nil].size.width;
    
    if (width > 180) {
        width = 180;
    }
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    KKHUD * HUD = [[KKHUD alloc]initWithFrame:CGRectMake((kScreenWidth-width-30)*0.5, (kScreenHeight - 85)*0.5, width + 30, 85)];
    HUD.alpha = 0;
    [app.window addSubview:HUD];
    
    HUD.statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake((HUD.bounds.size.width - 24)*0.5, 15, 24, 24)];
    HUD.statusImageView.image = UIImageNamed(@"sheet_icon_error");
    [HUD addSubview:HUD.statusImageView];
    
    HUD.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, HUD.bounds.size.width, 40)];
    HUD.statusLabel.text = status;
    HUD.statusLabel.font = UIFontSys(17);
    HUD.statusLabel.textColor = [UIColor whiteColor];
    HUD.statusLabel.textAlignment = 1;
    [HUD addSubview:HUD.statusLabel];
    
    HUD.statusImageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [UIView animateWithDuration:0.25 delay:SDELAY usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        HUD.statusImageView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:SDELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        HUD.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:DURING options:UIViewAnimationOptionCurveEaseInOut animations:^{
            HUD.alpha = 0;
        } completion:^(BOOL finished) {
            [HUD removeFromSuperview];
        }];
    }];
}

+ (void)showBottomWithStatus:(NSString *)status {
    
    float width = [status boundingRectWithSize:CGSizeMake(kScreenWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontSys(15)} context:nil].size.width;
    
    if (width > 180) {
        width = 180;
    }
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    KKHUD * HUD = [[KKHUD alloc]initWithFrame:CGRectMake((kScreenWidth - width - 40)*0.5, kScreenHeight - 100-kBottomInsets, width + 40, 40)];
    HUD.alpha = 0;
    [app.window addSubview:HUD];
    
    HUD.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, width, HUD.bounds.size.height)];
    HUD.statusLabel.text = status;
    HUD.statusLabel.font = UIFontSys(15);
    HUD.statusLabel.textColor = [UIColor whiteColor];
    HUD.statusLabel.textAlignment = 1;
    [HUD addSubview:HUD.statusLabel];

    [UIView animateWithDuration:0.25 delay:SDELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        HUD.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:DURING options:UIViewAnimationOptionCurveEaseInOut animations:^{
            HUD.alpha = 0;
        } completion:^(BOOL finished) {
            [HUD removeFromSuperview];
        }];
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
