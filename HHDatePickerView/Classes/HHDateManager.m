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

+ (HHDateManager *)configModelWithYear:(BOOL)showYear
                                 month:(BOOL)showMonth
                                   day:(BOOL)showDay
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@", showYear?@"Y":@"N", showMonth?@"Y":@"N", showDay?@"Y":@"N"];
    NSDictionary *dic = @{@"YYY": [[HHDateManager alloc] init],
                          @"YYN": [[HHYearAndMonthManager alloc] init],
                          @"NYY": [[HHMonthAndDayManager alloc] init],
                          @"YNN": [[HHOnlyYearManager alloc] init],
                          @"NYN": [[HHOnlyMonthManager alloc] init],
                          @"NNY": [[HHOnlyDayManager alloc] init]};
    return [dic objectForKey:str];
}

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
    
//    NSInteger currentYear  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:[NSDate date]] integerValue];
//    [yearMutableArray addObject:@"9999年"];
    for (int i = MINIMUM_YEAR; i < MAXIMUM_YEAR; i++)
    {
        [yearMutableArray addObject:[NSString stringWithFormat:@"%04d年", i]];
    }
    for (int k = 1; k < 13; k++)
    {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%02d月", k]];
    }
    
    self.yearArray  = yearMutableArray;
    self.monthArray = monthMutableArray;
}

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
//    NSInteger currentYear  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:[NSDate date]] integerValue];
//    _yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - currentYear + 1;
    _yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - MINIMUM_YEAR;
    _monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:date] integerValue] - 1;
    _dayRow   = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:_yearRow  inComponent:0 animated:NO];
    [pickerView selectRow:_monthRow inComponent:1 animated:NO];
    [pickerView selectRow:_dayRow inComponent:2 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView
{
    return 3;
}

- (NSInteger)dateArrayCountWithComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray.count;
    }
    else if (component == 1)
    {
        return self.monthArray.count;
    }
    else
    {
        return [self getDaysCountfromYear:self.yearArray[_yearRow] andMonth:self.monthArray[_monthRow]];
    }
}

- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray[row];
    }
    else if (component == 1)
    {
        return self.monthArray[row];
    }
    else
    {
        return self.dayArray[row];
    }
}

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
{
    if (component == 0)
    {
        self.year  = self.yearArray[row];
        _yearRow = row;
    }
    else if (component == 1)
    {
        self.month = self.monthArray[row];
        _monthRow = row;
    }
    else if (component == 2)
    {
        self.day = self.dayArray[row];
        _dayRow = row;
    }
    if (component == 0 || component == 1)
    {
        [self getDaysCountfromYear:self.yearArray[_yearRow] andMonth:self.monthArray[_monthRow]];
        if (self.dayArray.count - 1 < _dayRow)
        {
            _dayRow = self.dayArray.count - 1;
        }
    }
    [pickerView reloadComponent:2];
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

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [self getYearNumberStringWithCurSelDate:date];
    model.month = [self getMonthNumberStringWithCurSelDate:date];
    model.day = [self getDayNumberStringWithCurSelDate:date];
    return model;
}

//通过年月求每月天数
- (NSInteger)getDaysCountfromYear:(NSString *)year andMonth:(NSString *)month
{
    NSMutableString *yearStr = [[NSMutableString alloc] initWithString:year];
    [yearStr deleteCharactersInRange:NSMakeRange(4, 1)];
    
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    
    NSInteger num_year  = [yearStr integerValue];
    NSInteger num_month = [monthStr integerValue];
    
    BOOL isLeapYear = num_year%4 == 0 ? (num_year%100 == 0 ? (num_year%400 == 0 ? YES : NO) : YES) : NO;
    switch (num_month)
    {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
        {
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:
        {
            [self setdayArray:30];
            return 30;
        }
        case 2:
        {
            if (isLeapYear)
            {
                [self setdayArray:29];
                return 29;
            }
            else
            {
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    self.dayArray = nil;
    NSMutableArray *dayMutableArray   = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i <= num; i++)
    {
        [dayMutableArray addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
    self.dayArray = dayMutableArray;
}
@end


@implementation HHYearAndMonthManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *yearMutableArray  = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *monthMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = MINIMUM_YEAR; i < MAXIMUM_YEAR; i++)
        {
            [yearMutableArray addObject:[NSString stringWithFormat:@"%04d年", i]];
        }
        for (int k = 1; k < 13; k++)
        {
            [monthMutableArray addObject:[NSString stringWithFormat:@"%02d月", k]];
        }
        self.yearArray  = yearMutableArray;
        self.monthArray = monthMutableArray;
    }
    return self;
}

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - MINIMUM_YEAR;
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"]   stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:yearRow  inComponent:0 animated:NO];
    [pickerView selectRow:monthRow inComponent:1 animated:NO];
}

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [super getYearNumberStringWithCurSelDate:date];
    model.month = [super getMonthNumberStringWithCurSelDate:date];
    model.day = @"";
    return model;
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

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
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

@implementation HHMonthAndDayManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    self.monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"]   stringFromDate:date] integerValue] - 1;
    self.dayRow   = [[[NSDate hh_dateFormatterWithFormatter:@"dd"]   stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:self.monthRow inComponent:0 animated:NO];
    [pickerView selectRow:self.dayRow  inComponent:1 animated:NO];
}

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = [super getMonthNumberStringWithCurSelDate:date];
    model.day = [super getDayNumberStringWithCurSelDate:date];
    return model;
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
        return [self getDaysCountWithMonth:self.monthArray[self.monthRow]];
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

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
{
    if (component == 0)
    {
        self.month = self.monthArray[row];
        self.monthRow = row;
    }
    else
    {
        self.day = self.dayArray[row];
        self.dayRow = row;
    }
    if (component == 0)
    {
        [self getDaysCountWithMonth:self.monthArray[self.monthRow]];
        if (self.dayArray.count - 1 < self.dayRow)
        {
            self.dayRow = self.dayArray.count - 1;
        }
    }
    [pickerView reloadComponent:1];
}

- (NSInteger)getDaysCountWithMonth:(NSString *)month
{
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:month];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    NSInteger num_month = [monthStr integerValue];
    switch (num_month)
    {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
        {
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:
        {
            [self setdayArray:30];
            return 30;
        }
        case 2:
        {
            [self setdayArray:29];
            return 29;
        }
        default:
            break;
    }
}

- (void)setdayArray:(NSInteger)num
{
    self.dayArray = nil;
    NSMutableArray *dayMutableArray   = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i <= num; i++)
    {
        [dayMutableArray addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
    self.dayArray = dayMutableArray;
}
@end

@implementation HHOnlyYearManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *yearMutableArray  = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = MINIMUM_YEAR; i < MAXIMUM_YEAR; i++)
        {
            [yearMutableArray addObject:[NSString stringWithFormat:@"%04d年", i]];
        }
        self.yearArray  = yearMutableArray;
    }
    return self;
}

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView;
{
    NSInteger yearRow = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:date] integerValue] - MINIMUM_YEAR;
    
    [pickerView selectRow:yearRow inComponent:0 animated:NO];
}

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [super getYearNumberStringWithCurSelDate:date];
    model.month = @"";
    model.day = @"";
    return model;
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

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
{
    self.year = self.yearArray[row];
}
@end


@implementation HHOnlyMonthManager

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:monthRow inComponent:0 animated:NO];
}

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = [super getMonthNumberStringWithCurSelDate:date];
    model.day = @"";
    return model;
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

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
{
    self.month = self.monthArray[row];
}
@end


@implementation HHOnlyDayManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *dayMutableArray   = [[NSMutableArray alloc] initWithCapacity:0];
        for (int j = 1; j < 32; j++)
        {
            [dayMutableArray addObject:[NSString stringWithFormat:@"%02d日", j]];
        }
        self.dayArray = dayMutableArray;
    }
    return self;
}

- (void)setupDatePickViewWithCurrentSelDate:(NSDate *)date
                                     inView:(UIPickerView *)pickerView
{
    NSInteger dayRow = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:date] integerValue] - 1;
    
    [pickerView selectRow:dayRow inComponent:0 animated:NO];
}

- (HHDateModel *)getDateModelWithCurSelDate:(NSDate *)date
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = @"";
    model.day = [super getDayNumberStringWithCurSelDate:date];
    return model;
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

- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView
{
    self.day = self.dayArray[row];
}
@end

