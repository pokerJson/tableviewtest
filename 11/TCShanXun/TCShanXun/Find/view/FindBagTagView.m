//
//  FindBagTagView.m
//  News
//
//  Created by dzc on 2018/7/16.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "FindBagTagView.h"

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface FindBagTagView()

@property (nonatomic,assign)CGFloat KTagMargin;
@property (nonatomic,assign)CGFloat KBottomMargin;
@property (nonatomic,assign)CGFloat kSelectNum;

@end
@implementation FindBagTagView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _kSelectNum=0;
        self.totalHeight=0;
        self.frame=frame;
        _tagArr=[[NSMutableArray alloc]init];
        /**默认是多选模式 */
        self.isSingleSelect=NO;
        
    }
    return self;
    
}
-(void)setTagWithTagArray:(NSArray*)arr{
    
    weakObj(self);
    self.previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        
        if(selfWeak.signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=selfWeak.signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(selfWeak.canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        
        [tagBtn setTitleColor:R_G_B_16(0x818181) forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];
        //设置字间距
        NSDictionary *dic = @{NSKernAttributeName:@0.5};
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        [tagBtn.titleLabel setAttributedText:attributedString];
        
        [tagBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        tagBtn.tag=KBtnTag+idx;
        tagBtn.layer.cornerRadius=5;
        tagBtn.clipsToBounds=YES;
        //字间距
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
//        Size_str.width += HORIZONTAL_PADDING*5;// 宽度
        Size_str.height += VERTICAL_PADDING*3+5;
        CGRect newRect = CGRectZero;
        //让前六个xxx
        if (selfWeak.tagArr.count > 6) {
            if (idx == 0 || idx == 1 || idx == 2 || idx == 3 || idx == 4 || idx == 5) {
                [tagBtn setImage:[UIImage imageNamed:@"ic_common_hot"] forState:UIControlStateNormal];
                [tagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 10)];
                [tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
                Size_str.width += HORIZONTAL_PADDING*6+5;
            }else{
                [tagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                Size_str.width += HORIZONTAL_PADDING*3;
            }
        }else{
            [tagBtn setImage:[UIImage imageNamed:@"Artboard"] forState:UIControlStateNormal];
            [tagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            [tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            Size_str.width += HORIZONTAL_PADDING*3;
        }

        
        if(selfWeak.KTagMargin&&selfWeak.KBottomMargin){
            
            if (selfWeak.previousFrame.origin.x + selfWeak.previousFrame.size.width + Size_str.width + selfWeak.KTagMargin > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, selfWeak.previousFrame.origin.y + Size_str.height + selfWeak.KBottomMargin);
                selfWeak.totalHeight +=Size_str.height + selfWeak.KBottomMargin;
            }
            else {
                newRect.origin = CGPointMake(selfWeak.previousFrame.origin.x + selfWeak.previousFrame.size.width + selfWeak.KTagMargin, selfWeak.previousFrame.origin.y);
                
            }
            [selfWeak setHight:selfWeak andHight:selfWeak.totalHeight+Size_str.height + selfWeak.KBottomMargin];
            
            
        }else{
            if (selfWeak.previousFrame.origin.x + selfWeak.previousFrame.size.width + Size_str.width + LABEL_MARGIN*2 > selfWeak.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, selfWeak.previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
                selfWeak.totalHeight +=Size_str.height + BOTTOM_MARGIN;
            }
            else {
                newRect.origin = CGPointMake(selfWeak.previousFrame.origin.x + selfWeak.previousFrame.size.width + LABEL_MARGIN, selfWeak.previousFrame.origin.y);
                
            }
            [selfWeak setHight:selfWeak andHight:selfWeak.totalHeight+Size_str.height + BOTTOM_MARGIN];
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        selfWeak.previousFrame=tagBtn.frame;
        [selfWeak setHight:selfWeak andHight:selfWeak.totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        
        
    }];
//    if(_BbackgroundColor){
//        
//        self.backgroundColor=_BbackgroundColor;
//        
//    }else{
//        
//        self.backgroundColor=[UIColor whiteColor];
//        
//    }
    
    
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
-(void)tagBtnClick:(UIButton*)button{
//    if(_isSingleSelect){
//        if(button.selected){
//
//            button.selected=!button.selected;
//
//        }else{
//
//
//        }
//
//    }else{
//
//        button.selected=!button.selected;
//    }
    
    
    self.didselectItemBlock(_tagArr[button.tag-KBtnTag]);

//    [self didSelectItems];
    
    
}
-(void)didSelectItems{
    
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    
    for(UIView*view in self.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            
            UIButton*tempBtn=(UIButton*)view;
            tempBtn.enabled=YES;
            if (tempBtn.selected==YES) {
                [arr addObject:_tagArr[tempBtn.tag-KBtnTag]];
                _kSelectNum=arr.count;
            }
        }
    }
    if(_kSelectNum==self.canTouchNum){
        
        for(UIView*view in self.subviews){
            
            UIButton*tempBtn=(UIButton*)view;
            
            if (tempBtn.selected==YES) {
                tempBtn.enabled=YES;
                
            }else{
                tempBtn.enabled=NO;
                
            }
        }
    }
//    self.didselectItemBlock(arr);
    
    
}
-(void)setMarginBetweenTagLabel:(CGFloat)Margin AndBottomMargin:(CGFloat)BottomMargin{
    
    _KTagMargin=Margin;
    _KBottomMargin=BottomMargin;
    
}


@end
