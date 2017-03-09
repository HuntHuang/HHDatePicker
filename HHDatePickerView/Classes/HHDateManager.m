//
//  HHDateManager.m
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHDateManager.h"
#import "NSDate+HHDateFormatter.h"

#define MINIMUM_YEAR 1900
#define MAXIMUM_YEAR 3000

@implementation HHDateManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initDateArray];
    }
    return self;
}

- (void)initDateArray
{
    NSMutableArray *yearMutableArray  = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *monthMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *dayMutableArray   = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = MINIMUM_YEAR; i < MAXIMUM_YEAR; i++)
    {
        [yearMutableArray addObject:[NSString stringWithFormat:@"%04d年", i]];
    }
    for (int k = 1; k < 13; k++)
    {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%02d月", k]];
    }
    for (int j = 1; j < 32; j++)
    {
        [dayMutableArray addObject:[NSString stringWithFormat:@"%02d日", j]];
    }
    
    _yearArray  = yearMutableArray;
    _monthArray = monthMutableArray;
    _dayArray   = dayMutableArray;
}

+ (HHDateManager *)configModelWithYear:(BOOL)showYear
                                 month:(BOOL)showMonth
                                   day:(BOOL)showDay
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@", showYear?@"Y":@"N", showMonth?@"Y":@"N", showDay?@"Y":@"N"];
    NSDictionary *dic = @{@"YYY": [[HHDateManager alloc] init],
                          @"YYN": [[YearAndMonthManager alloc] init],
                          @"NYY": [[MonthAndDayManager alloc] init],
                          @"YNN": [[OnlyYearManager alloc] init],
                          @"NYN": [[OnlyMonthManager alloc] init],
                          @"NNY": [[OnlyDayManager alloc] init]};
    return [dic objectForKey:str];
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    return 0;
}

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.year)
    {
        self.year = [[NSDate hh_dateFormatterWithFormatter:@"yyyy年"] stringFromDate:date];
    }
    
    NSMutableString *yearStr = [[NSMutableString alloc] initWithString:self.year];
    [yearStr deleteCharactersInRange:NSMakeRange(4, 1)];
    return yearStr;
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.month)
    {
        self.month = [[NSDate hh_dateFormatterWithFormatter:@"MM月"] stringFromDate:date];
    }
    
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:self.month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return monthStr;
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.day)
    {
        self.day = [[NSDate hh_dateFormatterWithFormatter:@"dd日"] stringFromDate:date];
    }
    
    NSMutableString *dayStr = [[NSMutableString alloc] initWithString:self.day];
    [dayStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return dayStr;
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSInteger)numberOfComponentsInPickerView
{
    return 0;
}

@end


@implementation YearAndMonthManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - MINIMUM_YEAR;
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"]   stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:yearRow  inComponent:0 animated:NO];
    [pickerView selectRow:monthRow inComponent:1 animated:NO];
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.year)
    {
        self.year = [[NSDate hh_dateFormatterWithFormatter:@"yyyy年"] stringFromDate:date];
    }
    
    NSMutableString *yearStr = [[NSMutableString alloc] initWithString:self.year];
    [yearStr deleteCharactersInRange:NSMakeRange(4, 1)];
    return yearStr;
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.month)
    {
        self.month = [[NSDate hh_dateFormatterWithFormatter:@"MM月"] stringFromDate:date];
    }
    
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:self.month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return monthStr;
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSInteger)numberOfComponentsInPickerView
{
    return 2;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray.count;
    }
    else
    {
        return self.monthArray.count;
    }
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray[row];
    }
    else
    {
        return self.monthArray[row];
    }
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.year  = self.yearArray[row];
    }
    else
    {
        self.month = self.monthArray[row];
    }
}
@end

@implementation MonthAndDayManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"]   stringFromDate:date] integerValue] - 1;
    NSInteger dayRow   = [[[NSDate hh_dateFormatterWithFormatter:@"dd"]   stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:monthRow inComponent:0 animated:NO];
    [pickerView selectRow:dayRow  inComponent:1 animated:NO];
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.month)
    {
        self.month = [[NSDate hh_dateFormatterWithFormatter:@"MM月"] stringFromDate:date];
    }
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:self.month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return monthStr;
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.day)
    {
        self.day = [[NSDate hh_dateFormatterWithFormatter:@"dd日"] stringFromDate:date];
    }
    NSMutableString *dayStr = [[NSMutableString alloc] initWithString:self.day];
    [dayStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return dayStr;
}

- (NSInteger)numberOfComponentsInPickerView
{
    return 2;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthArray.count;
    }
    else
    {
        return self.dayArray.count;
    }
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthArray[row];
    }
    else
    {
        return self.dayArray[row];
    }
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.month  = self.monthArray[row];
    }
    else
    {
        self.day = self.dayArray[row];
    }
}
@end

@implementation OnlyYearManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView;
{
    NSInteger yearRow = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - MINIMUM_YEAR;
    
    [pickerView selectRow:yearRow inComponent:0 animated:NO];
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.year)
    {
        self.year = [[NSDate hh_dateFormatterWithFormatter:@"yyyy年"] stringFromDate:date];
    }
    
    NSMutableString *yearStr = [[NSMutableString alloc] initWithString:self.year];
    [yearStr deleteCharactersInRange:NSMakeRange(4, 1)];
    return yearStr;
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSInteger)numberOfComponentsInPickerView;
{
    return 1;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    return self.yearArray.count;
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.yearArray[row];
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.year = self.yearArray[row];
}
@end


@implementation OnlyMonthManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:monthRow inComponent:0 animated:NO];
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.month)
    {
        self.month = [[NSDate hh_dateFormatterWithFormatter:@"MM月"] stringFromDate:date];
    }
    
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:self.month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return monthStr;
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSInteger)numberOfComponentsInPickerView;
{
    return 1;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    return self.monthArray.count;
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.monthArray[row];
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.month = self.monthArray[row];
}
@end


@implementation OnlyDayManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger dayRow = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:dayRow inComponent:0 animated:NO];
}

- (NSString *)getYearNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSString *)getMonthNumberStringWithCurSelDate:(NSDate *)date
{
    return [[NSMutableString alloc] initWithString:@""];
}

- (NSString *)getDayNumberStringWithCurSelDate:(NSDate *)date
{
    if (!self.day)
    {
        self.day = [[NSDate hh_dateFormatterWithFormatter:@"dd日"] stringFromDate:date];
    }
    
    NSMutableString *dayStr = [[NSMutableString alloc] initWithString:self.day];
    [dayStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return dayStr;
}

- (NSInteger)numberOfComponentsInPickerView;
{
    return 1;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    return self.dayArray.count;
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dayArray[row];
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.day = self.dayArray[row];
}
@end

