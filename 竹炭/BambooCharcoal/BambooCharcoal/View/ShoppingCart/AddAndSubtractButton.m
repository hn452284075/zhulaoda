//
//  HJCAjustNumButton.m
//  HJCAdjustButtonTest
//
//  Created by HJaycee on 15/6/4.
//  Copyright (c) 2015年 HJaycee. All rights reserved.
//

#import "AddAndSubtractButton.h"

#define   ResutleValue  @"1";
#define   MaxValue  10000000;
#define   ModifiedValue 1 //每次加减的数值
@interface AddAndSubtractButton ()
{
    UIButton *_decreaseBtn;
    UIButton *_increaseBtn;
    UITextField *_textField;
    UIView *_oneLine;
    UIView *_twoLine;
    NSTimer *_timer;
}

@end

@implementation AddAndSubtractButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews{
    [self commonSetup];
}
 
- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    
    self.layer.borderColor = [lineColor CGColor];
    _oneLine.backgroundColor = lineColor;
    _twoLine.backgroundColor = lineColor;
}

- (void)setCurrentNum:(NSString *)currentNum{
    _textField.text = currentNum;
}

- (NSString *)currentNum{
    return _textField.text;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupViews];
        
      
    }
    return self;
}





- (void)setupViews{
    
    
    UIColor *lineColor = [UIColor colorWithRed:213.0/255.0 green:214.0/255.0 blue:215.0/255.0 alpha:1.0];
    
//    self.frame = CGRectMake(0, 0, 83, 26);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 0.5;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [lineColor CGColor];
    
    _oneLine = [[UIView alloc] init];
    _oneLine.backgroundColor = lineColor;
    [self addSubview:_oneLine];
    
    _twoLine = [[UIView alloc] init];
    _twoLine.backgroundColor = lineColor;
    [self addSubview:_twoLine];
    
    _decreaseBtn = [[UIButton alloc] init];
    [_decreaseBtn setTitle:@"-" forState:UIControlStateNormal];
    _decreaseBtn.titleLabel.font=CUSTOMFONT(12);
    [_decreaseBtn setTitleColor:UIColorFromRGB(0x9a9a9a) forState:UIControlStateNormal];
    [self setupButton:_decreaseBtn normalImage:@"删减按钮" HighlightImage:nil];
    [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    _increaseBtn.titleLabel.font=CUSTOMFONT(12);
    [_increaseBtn setTitle:@"+" forState:UIControlStateNormal];
    [_increaseBtn setTitleColor:UIColorFromRGB(0x121212) forState:UIControlStateNormal];
    [self setupButton:_increaseBtn normalImage:@"增加按钮" HighlightImage:nil];
    [self addSubview:_increaseBtn];
    
    _textField = [[UITextField alloc] init];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
//    _textField.rightView = view;
//    _textField.enabled = false;
    _textField.delegate=self;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textField setTextColor:UIColorFromRGB(0x121212)];
    _textField.text = ResutleValue;
    _maxResult = MaxValue;
    [self addSubview:_textField];
    
//    [self commonSetup];
}

- (void)textFieldChanged:(UITextField *)field {

    NSInteger newNum = [_textField.text integerValue];
//     if([_textField.text intValue] >= _maxResult) {
//         _textField.text = [NSString stringWithFormat:@"%ld", (long)newNum];
//         _textField.text = [NSString stringWithFormat:@"%d",_maxResult];
//
//    } else {
//
//         //设置最小值
//            if (newNum < _smallResult) {
//            _textField.text = [NSString stringWithFormat:@"%d", _smallResult];;
//            [[BaseLoadingView sharedManager]showErrorWithStatus:[NSString stringWithFormat:@"最少数量%d起",_smallResult]];
//
//        }
//    }
    
    emptyBlock(self.fieldBack,[_textField.text intValue]);

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
     if ([_textField.text intValue] < _smallResult) {
 
        [[BaseLoadingView sharedManager]showMessage:[NSString stringWithFormat:@"最少数量%d起",_smallResult]];
         WEAK_SELF
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

         weak_self.callBack([textField.text intValue]);

         });
        
         return;
    }
    //大于最小值
    if ([_textField.text intValue]+1 > _smallResult) {
     self.callBack([textField.text intValue]);
    }
}

 
- (void)commonSetup{
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    _oneLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _twoLine.frame = CGRectMake(viewW - viewH, 0, 1, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage{
//    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
}

- (void)btnTouchDown:(UIButton *)btn{
    [_textField resignFirstResponder];
    
    if (btn == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn{
    [self cleanTimer];
}

- (void)increase{
    if (_textField.text.length == 0) {
        _textField.text = ResutleValue;
    }
    int newNum = [_textField.text intValue] + ModifiedValue;
    //设置最大值
    if (newNum <=_maxResult) {
        
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
        self.callBack(newNum);
    }
    
    if (newNum==_maxResult) {
        [_increaseBtn setImage:[UIImage imageNamed:@"增加按钮"] forState:UIControlStateNormal];
    }
    
    
}

- (void)decrease{
//    if (_textField.text.length == 0) {
//        _textField.text = ResutleValue;
//    }
    
    int newNum = [_textField.text intValue] - ModifiedValue;
    
    //设置最小值
    if (newNum >= _smallResult) {
         [_increaseBtn setImage:[UIImage imageNamed:@"增加按钮"] forState:UIControlStateNormal];
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
        self.callBack(newNum);
    } else {
         _textField.text = [NSString stringWithFormat:@"%d", _smallResult];;
        [[BaseLoadingView sharedManager]showMessage:[NSString stringWithFormat:@"最少数量%d起",_smallResult]];

    }
}

- (UIImage *)readImageFromBundle:(NSString *)imageName{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"HJCAdjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *myImg = getBundleImage(imageName);
    return myImg;
}

- (void)dealloc{
    [self cleanTimer];
}

- (void)cleanTimer{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
