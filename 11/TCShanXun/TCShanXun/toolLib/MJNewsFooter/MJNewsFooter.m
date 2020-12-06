//
//  MJNewsFooter.m
//  News
//
//  Created by FANTEXIX on 2018/7/17.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "MJNewsFooter.h"

@implementation MJNewsFooter

- (void)prepare {
    [super prepare];
    self.automaticallyHidden = YES;
}


- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    if (self.isHidden) return;
    // 设置位置
    if (self.scrollView.mj_contentH < self.scrollView.mj_h - self.mj_h) {
        if (self.isAutomaticallyHidden) {
            self.hidden = YES;
        }
    }
    
}

@end
