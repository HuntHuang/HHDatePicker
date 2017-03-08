//
//  HHDateManager.h
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHDateManager : NSObject

@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

+ (HHDateManager *)configModelWithYear:(BOOL)showYear
                                 month:(BOOL)showMonth
                                   day:(BOOL)showDay;

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView;

- (NSInteger)numberOfComponentsInPickerView;

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component;

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date;

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date;

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date;

@end

@interface YearAndMonthManager : HHDateManager


@end

@interface OnlyYearManager : HHDateManager


@end

@interface OnlyMonthManager : HHDateManager


@end

@interface OnlyDayManager : HHDateManager


@end
