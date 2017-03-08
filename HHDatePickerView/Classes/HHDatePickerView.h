//
//  HHDatePickerView.h
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BLOCK)(NSDictionary *dateDict);

@interface HHDatePickerView : UIView

/**
 *  block回调
 */
@property (nonatomic, copy) BLOCK dateBlock;

/**
 *  上次选中的日期
 */
@property (nonatomic, copy) NSString *lastDate;

- (void)showDatePickerWithYear:(BOOL)showYear
                         month:(BOOL)showMonth
                           day:(BOOL)showDay
                         title:(NSString *)title
              completeCallback:(BLOCK)completeCallback;

@end
