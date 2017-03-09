//
//  HHDatePickerView.m
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHDatePickerView.h"
#import "HHDateManager.h"
#import "NSDate+HHDateFormatter.h"

#define IPhoneHeight  [[UIScreen mainScreen] bounds].size.height
#define IPhoneWidth   [[UIScreen mainScreen] bounds].size.width

@interface HHDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSString *choseTitle;
@property (nonatomic, strong) NSDate *currentSelDate;
@property (nonatomic, strong) HHDateManager *dateManager;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *lastDate;

@end

@implementation HHDatePickerView

@synthesize currentSelDate = _currentSelDate;

- (void)showDatePickerWithYear:(BOOL)showYear
                         month:(BOOL)showMonth
                           day:(BOOL)showDay
                         title:(NSString *)title
              completeCallback:(BLOCK)completeCallback
{
    self.dateManager = [HHDateManager configModelWithYear:showYear
                                                    month:showMonth
                                                      day:showDay];
    self.choseTitle = title;
    self.dateBlock = completeCallback;
    [self loadBeginView];
    [self setupDatePicker];
    NSDate *lastDate = [self dateWithString:self.lastDate];
    if (self.lastDate.length && lastDate)
    {
        [self.datePicker setDate:lastDate animated:YES];
        _currentSelDate = lastDate;
    }
}

- (void)loadBeginView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.7;
    [self addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCancel)];
    [backgroundView addGestureRecognizer:tap];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight, IPhoneWidth, 330)];
    mainView.backgroundColor = [UIColor whiteColor];
    _mainView = mainView;
    [self addSubview:_mainView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(5, 5, 50, 30);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickedCancel) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:cancelBtn];
    
    UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(IPhoneWidth - 60, 5, 50, 30);
    [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(onClickedOK) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:OKBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, IPhoneWidth, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.choseTitle;
    [_mainView addSubview:titleLabel];
}

- (void)setupDatePicker
{
    if (!_currentSelDate)
    {
        _currentSelDate = [NSDate date];
    }
    if ([self.dateManager isMemberOfClass:[HHDateManager class]])
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 25, IPhoneWidth, 330)];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        datePicker.locale = locale;
        [_mainView addSubview:datePicker];
        _datePicker = datePicker;
    }
    else
    {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, IPhoneWidth, 330)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        _currentSelDate = [NSDate date];
        [self.dateManager setupDatePickViewWithCurrentSelDate:_currentSelDate inView:pickerView];
        [_mainView addSubview:pickerView];
    }
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight - 330, IPhoneWidth, 330);
    }];
}

- (void)onClickedOK
{
    HHDateModel *model = [[HHDateModel alloc] init];
    model.year = [self.dateManager getYearNumberStringWithCurSelDate :_currentSelDate];
    model.month = [self.dateManager getMonthNumberStringWithCurSelDate:_currentSelDate];
    model.day = [self.dateManager getDayNumberStringWithCurSelDate  :_currentSelDate];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight, IPhoneWidth, 330);
    } completion:^(BOOL finished) {
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", model.year, model.month, model.day];
        self.lastDate = [self dateWithString:dateString];
        if (weakSelf.dateBlock) {
            weakSelf.dateBlock(model);
            weakSelf.dateBlock = nil;
        }
        [weakSelf removeFromSuperview];
    }];
}

- (void)onClickedCancel
{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight, IPhoneWidth, 330);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)dateChanged:(UIDatePicker *)sender
{
    NSDate *pickerDate = [sender date];
    _currentSelDate = pickerDate;
}

- (NSDate *)dateWithString:(NSString *)str
{
    if (str.length == 0) return nil;
    return [[NSDate hh_dateFormatterWithFormatter:@"yyyy-MM-dd"] dateFromString:str];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dateManager numberOfComponentsInPickerView];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dateManager dateArrayCountWithComponent:component];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dateManager pickerViewTitleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.dateManager pickerViewdidSelectRow:row inComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 100;
    }
    else
    {
        return 80;
    }
}

@end
