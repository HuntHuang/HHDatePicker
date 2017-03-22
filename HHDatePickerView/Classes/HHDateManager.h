//
//  HHDateManager.h
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HHDateModel.h"

@interface HHDateManager : NSObject

@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

@property (nonatomic, assign) NSInteger yearRow;
@property (nonatomic, assign) NSInteger monthRow;
@property (nonatomic, assign) NSInteger dayRow;

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
- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView;

// 获取年份
- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date;

// 获取月份
- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date;

// 获取日份
- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date;

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date;
@end

@interface HHYearAndMonthManager : HHDateManager

@end

@interface HHMonthAndDayManager : HHDateManager

@end

@interface HHOnlyYearManager : HHDateManager

@end

@interface HHOnlyMonthManager : HHDateManager

@end

@interface HHOnlyDayManager : HHDateManager

@end
