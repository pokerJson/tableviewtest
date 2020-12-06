//
//  WriteBoardView.m
//  ControlExtensionLib
//
//  Created by FANTEXIX on 2017/2/19.
//  Copyright © 2017年 FANTEXIX. All rights reserved.
//

#import "WriteBoardView.h"




#define InitialHeight       54
#define TextHeight       34

#define AbleColor           [UIColor colorWithRed:84/255.0 green:162/255.0 blue:236/255.0 alpha:1]
#define DisableColor        [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1]
#define PlaceholderColoer   [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1]



@interface WriteBoardView ()<UITextViewDelegate>

@property(nonatomic, strong)UIView * shadowLine;
@property(nonatomic, strong)UITextView * textView;
@property(nonatomic, strong)UIButton * submitButton;

@property(nonatomic, assign)float y_keyboard;

@end

@implementation WriteBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
        [self addSubviews];
    }
    return self;
}
- (void)initialize {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotice:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotice:) name:UIKeyboardWillHideNotification object:nil];
    
    //_responsive = YES;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)addSubviews {
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, sWidth-74, TextHeight)];
    _textView.backgroundColor = RGBColor(251, 251, 251);
    _textView.delegate = self;
    _textView.placeholder = @"写评论...";
    _textView.scrollEnabled = NO;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = RGBColor(231, 231, 231).CGColor;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.placeholderColor = PlaceholderColoer;
    [self addSubview:_textView];
    
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(sWidth-59, 0, 59, InitialHeight)];
    _submitButton.enabled = NO;
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:AbleColor forState:UIControlStateNormal];
    [_submitButton setTitleColor:DisableColor forState:UIControlStateDisabled];
    [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];

    
    _shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sWidth, 0.4)];
    _shadowLine.backgroundColor = RGBColor(175, 175, 175);
    [self addSubview:_shadowLine];
    
}

- (void)initializeFrame {
    
    self.textView.frame = CGRectMake(15, 10, sWidth-74, TextHeight);
    self.frame = CGRectMake(0, kScreenHeight-kBottomInsets-InitialHeight, self.width, self.height);
}

- (void)keyboardNotice:(NSNotification *)notification {

    self.y_keyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, self.y_keyboard-InitialHeight-(self.textView.height-TextHeight), self.width, self.height);
        } completion:^(BOOL finished) {
            self.responsive = YES;
        }];
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, kScreenHeight-kBottomInsets-InitialHeight-(self.textView.height-TextHeight), self.width, self.height);
        } completion:^(BOOL finished) {
            self.responsive = NO;
        }];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _textView.placeholder = placeholder;
}

- (void)setSubmitName:(NSString *)submitName {
    _submitName = submitName;
    [_submitButton setTitle:submitName forState:UIControlStateNormal];
}


- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""] || textView.text.length == 0) {
        _submitButton.enabled = NO;
    }else {
        _submitButton.enabled = YES;
    }

    CGFloat maxHeight = 72;
    
    CGRect frame = _textView.frame;
    
    CGFloat height = [_textView sizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)].height;
    
    
    if (height > maxHeight) {
        height = maxHeight;
        if (!textView.isScrollEnabled) {
            textView.scrollEnabled = YES;
        }
    }else {
        if (textView.isScrollEnabled) {
            textView.scrollEnabled = NO;
        }
    }
    
    self.frame = CGRectMake(0, self.y_keyboard-InitialHeight-(height-TextHeight), self.width, self.height);
    _textView.frame = CGRectMake(15, 10, frame.size.width, height);
    
}

- (void)becomeResponder {
    //_responsive = YES;
    
    if (_placeholder) {
        _textView.placeholder = _placeholder;
    }else {
        _textView.placeholder = @"优质评论将会被优先展示";
    }
    
    [_textView becomeFirstResponder];
}
- (void)resignResponder {
    
    [_textView resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(writeBoardViewDismiss:)]) {
        [self.delegate writeBoardViewDismiss:self];;
    }
}

- (void)submitButtonClicked:(UIButton *)button{
    NSLog(@"完成");
    
    NSArray * arr = [_textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@" \n"]];
    
    if (_textView.text.length == arr.count - 1) {

        return;
    }
    
    NSString * str = [[_textView.text componentsSeparatedByString:@"\n"] componentsJoinedByString:@" "];
    NSLog(@"%@",str);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(writeBoardView:submitWithStr:)]) {
        [self.delegate writeBoardView:self submitWithStr:str];
        [self reset];
    }
    
    [_textView resignFirstResponder];
}

- (void)reset {
    _placeholder = nil;
    _textView.text = @"";
    _submitButton.enabled = NO;
    [self initializeFrame];
}

- (void)setDelegate:(id<WriteBoardViewDeletgate>)delegate {
    
    _delegate = delegate;
    [self reset];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
