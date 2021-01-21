//
//  CommentHeaderView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommentHeaderViewDelegate <NSObject>

- (void)showAllCommentAction;

@end

@interface CommentHeaderView : UIView<CommentHeaderViewDelegate>

@property (nonatomic, weak) id<CommentHeaderViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodsRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceLabel;



- (IBAction)showAllComment:(id)sender;

@end

NS_ASSUME_NONNULL_END
