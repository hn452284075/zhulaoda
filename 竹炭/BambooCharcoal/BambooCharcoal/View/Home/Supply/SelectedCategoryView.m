//
//  SelectedCategoryView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/29.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SelectedCategoryView.h"

@interface SelectedCategoryView()

@property (nonatomic, strong) NSMutableArray    *topArray;
@property (nonatomic, strong) UIButton          *cancelBtn;
@property (nonatomic, strong) UIButton          *okBtn;

@end


@implementation SelectedCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        self.cancelBtn = [[UIButton alloc] init];
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(frame.size.width).dividedBy(2);
        }];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        self.okBtn = [[UIButton alloc] init];
        [self addSubview:self.okBtn];
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(frame.size.width).dividedBy(2);
        }];
        [self.okBtn setTitle:@"重置" forState:UIControlStateNormal];
        
    }
    return self;
}



@end
