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

@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *dayString;

@property (nonatomic, assign) NSInteger yearRow;
@property (nonatomic, assign) NSInteger monthRow;
@property (nonatomic, assign) NSInteger dayRow;

@property (nonatomic, strong) NSDate *currentDate;

// 多态匹配model
+ (HHDateManager *)configModelWithYear:(BOOL)showYear
                                 month:(BOOL)showMonth
                                   day:(BOOL)showDay;

// 设置上一次选择的日期
- (void)setCurrentSelDateWithLastDate:(NSString *)lastDate;

// 设置首次展示的日期
- (void)setupDatePickView:(UIPickerView *)pickerView;

// 设置pickerView的列数
- (NSInteger)numberOfComponentsInPickerView;

// 设置pickerView的行数
- (NSInteger)dateArrayCountWithComponent:(NSInteger)component;

// 每一行展示的数据
- (NSString *)pickerViewTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

// 所选择的数据
- (void)pickerViewdidSelectRow:(NSInteger)row inComponent:(NSInteger)component inView:(UIPickerView *)pickerView;

// 获取年份
- (NSString *)getYearNumberString;

// 获取月份
- (NSString *)getMonthNumberString;

// 获取日份
- (NSString *)getDayNumberString;

- (HHDateModel *)getDateModel;
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
