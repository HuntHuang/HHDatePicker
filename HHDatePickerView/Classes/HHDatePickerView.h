//
//  HHDatePickerView.h
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDateModel.h"

typedef void (^BLOCK)(HHDateModel *model);

@interface HHDatePickerView : UIView

@property (nonatomic, copy) BLOCK dateBlock;

- (void)showDatePickerWithYear:(BOOL)showYear
                         month:(BOOL)showMonth
                           day:(BOOL)showDay
                      lastDate:(NSString *)lastDate
              completeCallback:(BLOCK)completeCallback;

@end
