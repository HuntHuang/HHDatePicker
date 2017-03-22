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

@property (nonatomic, strong) NSDate *currentSelDate;
@property (nonatomic, strong) HHDateManager *dateManager;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *OKBtn;
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIPickerView *pickerView;

@end

@implementation HHDatePickerView

#pragma mark - Public
- (void)showDatePickerWithYear:(BOOL)showYear
                         month:(BOOL)showMonth
                           day:(BOOL)showDay
                      lastDate:(NSString *)lastDate
              completeCallback:(BLOCK)completeCallback
{
    self.dateManager = [HHDateManager configModelWithYear:showYear
                                                    month:showMonth
                                                      day:showDay];
    self.dateBlock = completeCallback;
    _currentSelDate = [self dateWithString:lastDate year:showYear month:showMonth day:showDay];
    if (!_currentSelDate)
    {
        _currentSelDate = [NSDate date];
    }
}

- (void)layoutSubviews
{
    self.backgroundView.frame = CGRectMake(0, 0, IPhoneWidth, IPhoneHeight);
    self.mainView.frame = CGRectMake(0, IPhoneHeight, IPhoneWidth, 330);
    self.cancelBtn.frame = CGRectMake(5, 0, 50, 30);
    self.OKBtn.frame = CGRectMake(IPhoneWidth - 60, 0, 50, 30);
    self.titleLabel.frame = CGRectMake(0, 0, IPhoneWidth, 30);
    self.pickerView.frame = CGRectMake(0, 25, IPhoneWidth, 330);
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight - 330, IPhoneWidth, 330);
    }];
}

#pragma mark - Private
- (NSDate *)dateWithString:(NSString *)string
                      year:(BOOL)showYear
                     month:(BOOL)showMonth
                       day:(BOOL)showDay
{
    if (string.length == 0) return nil;
    NSString *opinion = [NSString stringWithFormat:@"%@%@%@", showYear?@"Y":@"N", showMonth?@"Y":@"N", showDay?@"Y":@"N"];
    NSDictionary *dic = @{
                          @"YYY": [[NSDate hh_dateFormatterWithFormatter:@"yyyy-MM-dd"] dateFromString:string] ?: @"",
                          @"YYN": [[NSDate hh_dateFormatterWithFormatter:@"yyyy-MM"] dateFromString:string] ?: @"",
                          @"NYY": [[NSDate hh_dateFormatterWithFormatter:@"MM-dd"] dateFromString:string] ?: @"",
                          @"YNN": [[NSDate hh_dateFormatterWithFormatter:@"yyyy"] dateFromString:string] ?: @"",
                          @"NYN": [[NSDate hh_dateFormatterWithFormatter:@"MM"] dateFromString:string] ?: @"",
                          @"NNY": [[NSDate hh_dateFormatterWithFormatter:@"dd"] dateFromString:string] ?: @""
                          };
    if ([[dic objectForKey:opinion] isKindOfClass:[NSString class]])
    {
        if ([[dic objectForKey:opinion] isEqualToString:@""])
        {
            return nil;
        }
    }
    else
    {
        return [dic objectForKey:opinion];
    }
}

#pragma mark - Action
- (void)onClickedOK
{
    HHDateModel *model = [self.dateManager getDateModelWithCurSelDate:_currentSelDate];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight, IPhoneWidth, 330);
    } completion:^(BOOL finished) {
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", model.year, model.month, model.day];
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dateManager numberOfComponentsInPickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
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
    [self.dateManager pickerViewdidSelectRow:row inComponent:component inView:pickerView];
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    NSString *string = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSUnderlineColorAttributeName value:[UIColor orangeColor] range:contentRange];
    pickerLabel.attributedText = content;
    return pickerLabel;
}

#pragma mark - getter
- (UIView *)mainView
{
    if (!_mainView)
    {
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        _mainView = mainView;
    }
    return _mainView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"请选择日期";
        [self.mainView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton *)OKBtn
{
    if (!_OKBtn)
    {
        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        OKBtn.frame = CGRectMake(IPhoneWidth - 60, 5, 50, 30);
        [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
        [OKBtn addTarget:self action:@selector(onClickedOK) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:OKBtn];
        _OKBtn = OKBtn;
    }
    return _OKBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = CGRectMake(5, 5, 50, 30);
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:cancelBtn];
        _cancelBtn = cancelBtn;
    }
    return _cancelBtn;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCancel)];
        [backgroundView addGestureRecognizer:tap];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self.dateManager setupDatePickViewWithCurrentSelDate:_currentSelDate inView:pickerView];
        [self.mainView addSubview:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}
@end
