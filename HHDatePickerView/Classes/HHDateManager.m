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

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"yyyy-MM-dd"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:self.currentDate] integerValue] - MINIMUM_YEAR;
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:self.currentDate] integerValue] - 1;
    NSInteger dayRow   = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:self.currentDate] integerValue] - 1;
    
    [pickerView selectRow:yearRow  inComponent:0 animated:NO];
    [pickerView selectRow:monthRow inComponent:1 animated:NO];
    [pickerView selectRow:dayRow inComponent:2 animated:NO];
    self.pickView = pickerView;
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
        return [self getDaysCountfromYear:self.yearArray[[self.pickView selectedRowInComponent:0]] andMonth:self.monthArray[[self.pickView selectedRowInComponent:1]]];
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
    if (component == 0 || component == 1)
    {
        [self getDaysCountfromYear:self.yearArray[[pickerView selectedRowInComponent:0]] andMonth:self.monthArray[[pickerView selectedRowInComponent:1]]];
    }
    [pickerView reloadComponent:2];
}

- (NSString *)getYearNumberString
{
    NSMutableString *yearStr = [[NSMutableString alloc] initWithString:self.yearArray[[self.pickView selectedRowInComponent:0]]];
    [yearStr deleteCharactersInRange:NSMakeRange(4, 1)];
    return yearStr;
}

- (NSString *)getMonthNumberString
{
    NSMutableString *monthStr = [[NSMutableString alloc] initWithString:self.monthArray[[self.pickView selectedRowInComponent:1]]];
    [monthStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return monthStr;
}

- (NSString *)getDayNumberString
{
    NSMutableString *dayStr = [[NSMutableString alloc] initWithString:self.dayArray[[self.pickView selectedRowInComponent:2]]];
    [dayStr deleteCharactersInRange:NSMakeRange(2, 1)];
    return dayStr;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [self getYearNumberString];
    model.month = [self getMonthNumberString];
    model.day = [self getDayNumberString];
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

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"yyyy-MM"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger yearRow  = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:self.currentDate] integerValue] - MINIMUM_YEAR;
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"]   stringFromDate:self.currentDate] integerValue] - 1;
    
    [pickerView selectRow:yearRow  inComponent:0 animated:NO];
    [pickerView selectRow:monthRow inComponent:1 animated:NO];
    self.pickView = pickerView;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [super getYearNumberString];
    model.month = [super getMonthNumberString];
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
}
@end

@implementation HHMonthAndDayManager

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"MM-dd"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:self.currentDate] integerValue] - 1;
    NSInteger dayRow   = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:self.currentDate] integerValue] - 1;
    
    [pickerView selectRow:monthRow inComponent:0 animated:NO];
    [pickerView selectRow:dayRow  inComponent:1 animated:NO];
    self.pickView = pickerView;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = [super getMonthNumberString];
    model.day = [super getDayNumberString];
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
        return [self getDaysCountWithMonth:self.monthArray[[self.pickView selectedRowInComponent:1]]];
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
        [self getDaysCountWithMonth:self.monthArray[[pickerView selectedRowInComponent:1]]];
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
    return 0;
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

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"yyyy"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger yearRow = [[[NSDate hh_dateFormatterWithFormatter:@"yyyy"] stringFromDate:self.currentDate] integerValue] - MINIMUM_YEAR;
    
    [pickerView selectRow:yearRow inComponent:0 animated:NO];
    self.pickView = pickerView;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [super getYearNumberString];
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
}
@end


@implementation HHOnlyMonthManager

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"MM"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger monthRow = [[[NSDate hh_dateFormatterWithFormatter:@"MM"] stringFromDate:self.currentDate] integerValue] - 1;
    
    [pickerView selectRow:monthRow inComponent:0 animated:NO];
    self.pickView = pickerView;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = [super getMonthNumberString];
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

- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate
{
    NSDate *date = [[NSDate hh_dateFormatterWithFormatter:@"dd"] dateFromString:lastDate];
    self.currentDate = (date == nil || lastDate.length == 0) ? [NSDate date] : date;
}

- (void)setupDatePickView:(UIPickerView *)pickerView
{
    NSInteger dayRow = [[[NSDate hh_dateFormatterWithFormatter:@"dd"] stringFromDate:self.currentDate] integerValue] - 1;
    [pickerView selectRow:dayRow inComponent:0 animated:NO];
    self.pickView = pickerView;
}

- (HHDateModel *)getDateModel
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = @"";
    model.month = @"";
    model.day = [super getDayNumberString];
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
}
@end

