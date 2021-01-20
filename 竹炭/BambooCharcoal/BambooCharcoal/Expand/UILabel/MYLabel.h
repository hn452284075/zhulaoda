//
//  MYLabel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VerticalAlignmentTop = 0, //default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
} VerticalAlignment;

@interface MYLabel : UILabel {

@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
