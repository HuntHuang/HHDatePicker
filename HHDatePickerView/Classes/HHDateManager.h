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

// 设置首次展示的日期
- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView;

// 设置pickerView的列数
- (NSInteger)numberOfComponentsInPickerView;

// 设置pickerView的行数
- (NSInteger)dateArrayCountWithComponent:(NSInteger)component;

// 每一行展示的数据
- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

// 所选择的数据
- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component;

// 获取年份
- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date;

// 获取月份
- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date;

// 获取日份
- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date;

@end

@interface YearAndMonthManager : HHDateManager

@end

@interface MonthAndDayManager : HHDateManager

@end

@interface OnlyYearManager : HHDateManager

@end

@interface OnlyMonthManager : HHDateManager

@end

@interface OnlyDayManager : HHDateManager

@end

@interface CustomDateManager : HHDateManager

@end
