//
//  SelectedProvinceView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SelectedProvinceView.h"

@interface SelectedProvinceView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *bgscrollview;
@property (nonatomic, strong) NSMutableArray *proviceArray;

@property (nonatomic, strong) NSMutableArray *selectedProviceArray; //选中的省份
@property (nonatomic, assign) BOOL allFalg;     //记录全选
@property (nonatomic, assign) BOOL isEditFalg;  //记录是否全选

@property (nonatomic, strong) NSMutableArray *hadBeenUseArray;


@end

@implementation SelectedProvinceView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame usedArray:(NSMutableArray *)usedArray isEidt:(BOOL)flag EditArray:(NSArray *)eArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        int iphonex_height = 0;
        if(IS_Iphonex_Series)
            iphonex_height = 20;
        
        UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgv.backgroundColor = [UIColor lightGrayColor];
        bgv.alpha = 0.5;
        [self addSubview:bgv];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBgview:)];
        tapgesture.delegate = self;
        [bgv addGestureRecognizer:tapgesture];
        
        
        UIView *whiteView = [[UIView alloc] init];
        [self addSubview:whiteView];
        whiteView.backgroundColor = [UIColor whiteColor];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(350+iphonex_height);
        }];
        
        UILabel *msglab = [[UILabel alloc] init];
        [self addSubview:msglab];
        [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView.mas_top).offset(25);
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.mas_equalTo(16);
        }];
        msglab.text = @"选择地区";
        msglab.textColor = UIColorFromRGB(0x222222);
        msglab.font = CUSTOMFONT(14);
        msglab.textAlignment = NSTextAlignmentLeft;
        
        UIButton *okBtn = [[UIButton alloc] init];
        [self addSubview:okBtn];
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(msglab.mas_centerY).offset(0);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(15);
        }];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        okBtn.titleLabel.font = CUSTOMFONT(14);
        [okBtn setTitleColor:kGetColor(0x46, 0xc6, 0x7b) forState:UIControlStateNormal];
        [okBtn setBackgroundColor:kGetColor(0xff, 0xff, 0xff)];
        [okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineview.backgroundColor = [UIColor lightGrayColor];
        lineview.alpha = 0.3;
        [self addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(okBtn.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
        [allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [allBtn setTitleColor:KTextColor forState:UIControlStateNormal];
        [allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        allBtn.titleLabel.font= CUSTOMFONT(14);
        allBtn.tag = 713;
        [self addSubview:allBtn];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineview.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(25);
        }];
        [allBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.bgscrollview = [[UIScrollView alloc] init];
        [self addSubview:self.bgscrollview];
        [self.bgscrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(allBtn.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        self.allFalg = NO;
        self.proviceArray = [[NSMutableArray alloc] init];
        self.selectedProviceArray = [[NSMutableArray alloc] init];
        if(flag == YES)
        {
            self.selectedProviceArray = [[NSMutableArray alloc] initWithArray:eArray];
        }
        
        if(eArray.count == 34)
        {
            self.allFalg = YES;
            UIButton *allBtn = [self viewWithTag:713];
            [allBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
        }
        else if(eArray.count + usedArray.count == 34)
        {
            self.allFalg = YES;
            UIButton *allBtn = [self viewWithTag:713];
            [allBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
        }
        
        
        NSString *path_1 = [[NSBundle mainBundle] pathForResource:@"thy_area" ofType:@"json"];
        NSData *data_1 = [[NSData alloc] initWithContentsOfFile:path_1];
        NSDictionary *jsonDict_1 = [NSJSONSerialization JSONObjectWithData:data_1 options:NSJSONReadingMutableLeaves error:nil];
                
        NSArray *array = jsonDict_1[@"params"];
        for (int i=0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            NSString *p_name = dic[@"name"];
            
            [self.proviceArray addObject:p_name];
        }
                
        NSMutableArray *btnarray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.proviceArray.count; i++) {
            UIButton *bb = [self getItemBtn:self.proviceArray[i] viewTag:i];
            [btnarray addObject:bb];
        }
        
        
        self.hadBeenUseArray = usedArray;
        self.isEditFalg = flag;
        
        
        int x = -4;
        int y = 5;
        int w = 80;
        int h = 20;
        
        int x_gap = (kScreenWidth-w*3)/4;
        int y_gap = 11;
                
        int row = (int)self.proviceArray.count % 3 == 0 ? (int)self.proviceArray.count/3 : (int)self.proviceArray.count/3+1;
        self.bgscrollview.contentSize = CGSizeMake(self.frame.size.width, y+(y_gap+h)*row);
        
        for(int i=0;i<self.proviceArray.count;i++)
        {
            int r = (int)i % 3; //0 1 2
            int c = (int)i / 3;
            
            int _x = x+x_gap*(r+1) + w*r;
            int _y = y+y_gap*c + h*c;
            
            UIButton *tagBtn = [btnarray objectAtIndex:i];
            tagBtn.frame = CGRectMake(_x, _y, w, h);
            tagBtn.tag = i;
            [self.bgscrollview addSubview:tagBtn];
            
                        
            for(int j=0;j<usedArray.count;j++)
            {
                NSString *_str = [usedArray objectAtIndex:j];
                if([_str isEqualToString:[self.proviceArray objectAtIndex:i]])
                {
                    [tagBtn setImage:IMAGE(@"storeusedicon") forState:UIControlStateNormal];
                    tagBtn.userInteractionEnabled = NO;
                }
            }
            
            
            if(flag == YES)
            {
                for(int j=0;j<eArray.count;j++)
                {
                    NSString *_str = [eArray objectAtIndex:j];
                    if([_str isEqualToString:[self.proviceArray objectAtIndex:i]])
                    {
                        [tagBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
                        tagBtn.userInteractionEnabled = YES;
                    }
                }
            }
            
        }
        
    }
    return self;
}


- (UIButton *)getItemBtn:(NSString *)name viewTag:(int)tag
{
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.tag = tag;
    [itemBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    [itemBtn setTitle:name forState:UIControlStateNormal];
    [itemBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    itemBtn.titleLabel.font= CUSTOMFONT(13);
    [self addSubview:itemBtn];
    itemBtn.frame = CGRectMake(0, 0, 80, 25);
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return itemBtn;
}


- (void)itemBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *pname = btn.titleLabel.text;
    if([self.selectedProviceArray containsObject:pname])
    {
        [btn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
        [btn setTitle:pname forState:UIControlStateNormal];
        [self.selectedProviceArray removeObject:pname];
        
        self.allFalg = NO;
        UIButton *allBtn = [self viewWithTag:713];
        [allBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
        [btn setTitle:pname forState:UIControlStateNormal];
        [self.selectedProviceArray addObject:pname];
        
        if(self.selectedProviceArray.count + self.hadBeenUseArray.count == 34)
        {
            self.allFalg = YES;
            UIButton *allBtn = [self viewWithTag:713];
            [allBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
        }
    }
}


- (void)allBtnClicked:(id)sender
{
    UIButton *allBtn = [self viewWithTag:713];
    for(UIView *v in self.bgscrollview.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            if(self.allFalg == NO)
            {
                
//                self.selectedProviceArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self.proviceArray];
                
                [allBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
                
                
//                if(self.isEditFalg == NO)
                {
                    UIButton *tempbtn = (UIButton *)v;
                    if(tempbtn.userInteractionEnabled == YES)
                    {
                        [(UIButton *)v setImage:IMAGE(@"storeusedicon") forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.proviceArray.count;i++)
                        {
                            NSString *str = [self.proviceArray objectAtIndex:i];
                            if([self.hadBeenUseArray containsObject:str])
                                continue;
                            if(![self.selectedProviceArray containsObject:str])
                            {
                                [self.selectedProviceArray addObject:str];
                            }
                            if([tempbtn.titleLabel.text isEqualToString:str])
                            {
                                [tempbtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
                            }
                        }
                    }
                }
                
            }
            else
            {
                [self.selectedProviceArray removeAllObjects];
                
                [allBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
                                
//                if(self.isEditFalg == NO)
                {
                    UIButton *tempbtn = (UIButton *)v;
                    if(tempbtn.userInteractionEnabled == YES)
                    {
                        [(UIButton *)v setImage:IMAGE(@"storeusedicon") forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.proviceArray.count;i++)
                        {
                            NSString *str = [self.proviceArray objectAtIndex:i];
                            if([self.hadBeenUseArray containsObject:str])
                                continue;
                            [self.selectedProviceArray removeObject:str];
                            if([tempbtn.titleLabel.text isEqualToString:str])
                            {
                                [tempbtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
                            }
                        }
                    }
                }                
            }
        }
    }
    self.allFalg = !self.allFalg;
}


- (void)okBtnClicked:(id)sender
{
    if(self.selectedProviceArray.count > 0)
    {
        [self.delegate confirmProvice:(NSArray *)self.selectedProviceArray];
        self.delegate = nil;
        [self removeFromSuperview];
    }
    else
    {
        [[BaseLoadingView sharedManager]showMessage:@"至少选中一个地区"];
    }
}


- (void)dismissBgview:(id)sender
{
    self.delegate = nil;
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
