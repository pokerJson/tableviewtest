//
//  TTableView.h
//  NvYou
//
//  Created by FANTEXIX on 2018/6/7.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface TTableView : UITableView
@property (nonatomic,weak) id<TTableViewDelegate> touchDelegate;
@end
