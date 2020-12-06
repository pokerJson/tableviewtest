//
//  TTableView.m
//  NvYou
//
//  Created by FANTEXIX on 2018/6/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TTableView.h"

@implementation TTableView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

@end
