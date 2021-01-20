//
//  PDHeadInfoTextView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PDHeadInfoTextView.h"
#import <CoreText/CoreText.h>

@interface PDHeadInfoTextView()

@property (nonatomic, strong) UILabel   *msgLabel;
@property (nonatomic, strong) NSString  *originString;
@property (nonatomic, strong) NSArray   *textLineArray;
@property (nonatomic, strong) UIButton  *showBtn;

@property (nonatomic, strong) NSArray   *imageArray;

@end

@implementation PDHeadInfoTextView
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title msg:(NSString *)msg imageArray:(NSArray *)arr showFlag:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lab1 = [[UILabel alloc] init];
        [self addSubview:lab1];
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(22);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(15);
        }];
        lab1.text = title;
        lab1.font = [UIFont boldSystemFontOfSize:13];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.textColor = UIColorFromRGB(0x222222);
        
        self.imageArray = arr;
        
        self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 0)];
        self.msgLabel.numberOfLines = 0;
        self.msgLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.msgLabel];
        self.msgLabel.textColor = UIColorFromRGB(0x666666);
        self.msgLabel.text = msg;
        
        self.originString = msg;
        
        self.textLineArray = [self getSeparatedLinesFromLabel:self.msgLabel];
        if(self.textLineArray.count > 4 && flag == NO)
        {
            NSMutableString *newStr = [[NSMutableString alloc] init];
            NSString *lastLineStr;
            for(int i=0;i<4;i++)
            {
                if(i == 3)
                {
                    NSString *lineString = [self.textLineArray[i] substringWithRange:NSMakeRange(0, 10)];
                    [newStr appendString:lineString];
                    
                    lastLineStr = lineString;
                }
                else
                    [newStr appendString:self.textLineArray[i]];
            }
            [newStr appendString:@"..."];
            
            CGRect rect = [lastLineStr boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            
            self.showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.showBtn.frame = CGRectMake(rect.size.width+10, 5*(rect.size.height)-27, 50, rect.size.height);
            [self.showBtn setImage:IMAGE(@"展开") forState:UIControlStateNormal];
            [self.showBtn setTitle:@"展开" forState:UIControlStateNormal];
            [self.showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.showBtn addTarget:self action:@selector(showAllMethod) forControlEvents:UIControlEventTouchUpInside];
            self.showBtn.titleLabel.font = CUSTOMFONT(12);
            
            self.msgLabel.text = newStr ;
            
            CGSize s = [self calcLabSize:newStr fontSize:12 maxWidth:kScreenWidth-30];
            
            self.msgLabel.frame = CGRectMake(15, 50, kScreenWidth-30, s.height);
            self.msgLabel.userInteractionEnabled = YES;
            [self.msgLabel addSubview:self.showBtn];
            
            [self drawImage:arr h_y:33+self.msgLabel.frame.origin.x+self.msgLabel.frame.size.height];
        }
        else
        {
            CGSize s = [self calcLabSize:msg fontSize:12 maxWidth:kScreenWidth-30];
            self.msgLabel.frame = CGRectMake(15, 50, kScreenWidth-30, s.height);
            
            [self drawImage:arr h_y:33+self.msgLabel.frame.origin.x+self.msgLabel.frame.size.height];
        }
        
        [self addSubview:self.msgLabel];
        
        
    }
    return self;
}

- (void)showAllMethod
{
    CGSize s = [self calcLabSize:self.originString fontSize:12 maxWidth:kScreenWidth-30];
    
    [self.delegate changedMsgShowHeight:s.height];
    
    self.msgLabel.text = self.originString;
    
    self.msgLabel.frame = CGRectMake(15, 50, kScreenWidth-30, s.height);
    self.showBtn.hidden = YES;
    
    [self drawImage:self.imageArray h_y:33+self.msgLabel.frame.origin.x+self.msgLabel.frame.size.height];
}


- (void)drawImage:(NSArray *)imgarray h_y:(int)hy
{
    
    for(UIView *v in self.subviews)
    {
        if([v isKindOfClass:[UIButton class]] && v.tag > 99)
           [v removeFromSuperview];
    }
    
    int perRow = 4;
    int row = (int)imgarray.count / perRow;
    if(imgarray.count % perRow != 0)
        row +=1;
    int x = 15;
    int y = hy+20;
    int w = (kScreenWidth-30)/perRow-1;
    int h = w;
    int endY = y;
    for(int i=0;i<row;i++)
    {
        int temp = 0;
        for(int j=perRow*i;j<imgarray.count;j++)
        {
            UIImageView *imgv = [[UIImageView alloc] init];
            imgv.frame = CGRectMake(x+(w+2)*temp++, y+(h+2)*i, w, h);
//            [imgv setImage:[imgarray objectAtIndex:i] forState:UIControlStateNormal];
            
            [imgv sd_setImageWithURL:[NSURL URLWithString:[imgarray objectAtIndex:j]]];
            
            imgv.tag = 100+j;
            [self addSubview:imgv];
            endY = y+h*i + h;
            if(temp > perRow-1)
                break;
        }
    }
}



- (CGSize)calcLabSize:(NSString *)string fontSize:(int)size maxWidth:(int)w
{
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:size]
    };
    return [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
}




-(NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (int i=0;i<lines.count;i++)
    {
        id line = [lines objectAtIndex:i];
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


@end
