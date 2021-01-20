//
//  PurchasePriceView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/28.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PurchasePriceDelegate <NSObject>

- (void)submit_action:(BOOL)isopen price:(NSString *)price detailInfo:(NSString *)detail;
- (void)textfiledEdit_action;
- (void)camare_action;
- (void)cart_action;
- (void)more_action;

@end


@interface PurchasePriceView : UIView<PurchasePriceDelegate>

@property (nonatomic, weak) id<PurchasePriceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *textfiledBackview;
@property (weak, nonatomic) IBOutlet UITextField *priceTextfiled;
@property (weak, nonatomic) IBOutlet UILabel *priceUnitLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@property (weak, nonatomic) IBOutlet UITextView *detailTextview;

@property (weak, nonatomic) IBOutlet UIButton *caremaBtn;

@property (weak, nonatomic) IBOutlet UILabel *camareNumberLab;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cartCheckImg;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)camareBtnClicked:(id)sender;
- (IBAction)cartBtnClicked:(id)sender;


- (IBAction)checkBtnClicked:(id)sender;
- (IBAction)moreBtnClicked:(id)sender;


- (void)congfigView;

@end

NS_ASSUME_NONNULL_END
