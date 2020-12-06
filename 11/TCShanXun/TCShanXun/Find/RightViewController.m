//
//  RightViewController.m
//  News
//
//  Created by dzc on 2018/7/6.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "RightViewController.h"
#import "LTScrollView-Swift.h"
#import "ThemeInfo.h"
#import "FirstTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "TijianjianTableViewCell.h"
#import "TuijianInfo.h"

@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataARR;
@property(nonatomic,strong)TuijianInfo *infof;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    self.dataARR = [[NSMutableArray alloc]init];

#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    NSArray *iconImageNamesArray = @[@"ic_messages_collect_selected",
                                     @"ic_login_weibo",
                                     @"ic_login_connect_wechat_connected",
                                     @"ic_messages_delete",
                                     @"ic_messages_vote_selected",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    _infof = [[TuijianInfo alloc]init];
    
    for (int i = 0; i < 24; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        ThemeInfo *model = [[ThemeInfo alloc]init];
        model.authorIcon = iconImageNamesArray[iconRandomIndex];
        model.authorName = namesArray[nameRandomIndex];
        model.contentstr = textArray[contentRandomIndex];
        if (i == 0 || i==2) {
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://2-im.guokr.com/AuNcw83xhCI9tYYmS8t63HyJ_qb3z0nSG9j6gmpmVZZKAQAA3QAAAEpQ.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg", nil];
        }else if (i%3 == 0){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/005zF09Agy1ft3asfqbzqj30ku0kj0ye.jpg", nil];
        }else if( i == 5){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:@"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg", nil];
        }else if (i == 13){
            model.imageuRLArr = nil;
        }else if (i == 7 || i == 11){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx4.sinaimg.cn/orj360/005zF09Agy1ft3asglpvsj30kt0pwwhc.jpg",
                                 @"https://wx4.sinaimg.cn/orj360/005zF09Agy1ft3asglpvsj30kt0pwwhc.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sldeyw3j20jc0ardgo.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sldeyw3j20jc0ardgo.jpg",
                                 @"https://wx4.sinaimg.cn/orj360/67be458fgy1ft2sldozruj20jc0aft9g.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sle05zjj20jg0ao3zc.jpg", nil];
        }else if (i == 13 ){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sle05zjj20jg0ao3zc.jpg",
                                 @"https://wx4.sinaimg.cn/orj360/005zF09Agy1ft3asglpvsj30kt0pwwhc.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sld06csj20l80bqaaq.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/6b658c6bly1fj8bz0haebj20hs0npajq.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/6b658c6bly1fj8bz0haebj20hs0npajq.jpg", nil];
        }else if (i == 17 ){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg",
                                 @"https://2-im.guokr.com/AuNcw83xhCI9tYYmS8t63HyJ_qb3z0nSG9j6gmpmVZZKAQAA3QAAAEpQ.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg",
                                 @"https://2-im.guokr.com/AuNcw83xhCI9tYYmS8t63HyJ_qb3z0nSG9j6gmpmVZZKAQAA3QAAAEpQ.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",nil];
        }else if (i == 19 ){
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sld06csj20l80bqaaq.jpg",
                                 @"https://wx2.sinaimg.cn/orj360/6b658c6bly1fj8bz0haebj20hs0npajq.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg", nil];
        }
        if (i == 23) {
            model.imageuRLArr = [NSMutableArray arrayWithObjects:
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg",
                                 @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asg7z6lj30ku0kj7b4.jpg", nil];
        }
        if (i == 1) {
            _infof.attentionArr = [NSMutableArray arrayWithObjects:
                                   @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sle05zjj20jg0ao3zc.jpg",
                                   @"https://wx4.sinaimg.cn/orj360/005zF09Agy1ft3asglpvsj30kt0pwwhc.jpg",
                                   @"https://wx3.sinaimg.cn/orj360/005zF09Agy1ft3asf041sj30ku0puguc.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sleajo2j20mg0cnwfd.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/67be458fgy1ft2sld06csj20l80bqaaq.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/6b658c6bly1fj8bz0haebj20hs0npajq.jpg",
                                   @"https://wx2.sinaimg.cn/orj360/6b658c6bly1fj8bz0haebj20hs0npajq.jpg", nil];
            
        }

        
        
        model.sendTime = @"7/06";
        model.dianzanNum = @"2222";
        model.comentNum = @"333";
        model.nothingNum = @"111";
        
        if (i == 1) {
            [self.dataARR addObject:_infof];
        }else{
            [self.dataARR addObject:model];
            
        }
        
        
        
    }

    
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataARR.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        TijianjianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondcell"];
        cell.info = self.dataARR[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }else{
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell"];
        cell.indexpath = indexPath;
        weakObj(self);
        cell.moreButtonClickedBlock = ^(NSIndexPath *indexPath) {
            ThemeInfo *model = selfWeak.dataARR[indexPath.row];
            model.isOpening = !model.isOpening;
            [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.info = self.dataARR[indexPath.row];
        
        return cell;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 240;
    }
    else{
        // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
        id info = self.dataARR[indexPath.row];
        float hei = [self.tableView cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[FirstTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        NSLog(@"rr==%f",hei);
        return hei;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第 xxxxxxx%ld 行", indexPath.row + 1);
    
    
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat H = IS_IPHONE_X ? (kScreenHeight - 44 - 64 - 24 - 34) : kScreenHeight - 44 - 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 解决在iOS11上朋友圈demo文字收折或者展开时出现cell跳动问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[FirstTableViewCell class] forCellReuseIdentifier:@"firstcell"];
        [_tableView registerClass:[TijianjianTableViewCell class] forCellReuseIdentifier:@"secondcell"];
    }
    return _tableView;
}

@end
