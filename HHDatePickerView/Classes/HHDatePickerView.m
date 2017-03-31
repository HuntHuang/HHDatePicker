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

@property (nonatomic, strong) HHDateManager *dateManager;
@property (nonatomic, weak) UIView *mainView;

@end

@implementation HHDatePickerView

#pragma mark - Public
- (void)showDatePickerWithYear:(BOOL)showYear
                         month:(BOOL)showMonth
                           day:(BOOL)showDay
                      lastDate:(NSString *)lastDate
              completeCallback:(BLOCK)completeCallback
{
    self.dateBlock = completeCallback;
    self.dateManager = [HHDateManager configModelWithYear:showYear
                                                    month:showMonth
                                                      day:showDay];
    [self.dateManager setCurrentSelDateWithLastDate:lastDate];
}

- (void)layoutSubviews
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.7;
    [self addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCancel)];
    [backgroundView addGestureRecognizer:tap];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight, IPhoneWidth, 330)];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    _mainView = mainView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择日期";
    [_mainView addSubview:titleLabel];
    
    UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(IPhoneWidth - 60, 0, 50, 50);
    [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(onClickedOK) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:OKBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(5, 0, 50, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickedCancel) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:cancelBtn];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, IPhoneWidth, 300)];
    pickerView.layer.borderWidth = 1.0;
    pickerView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.dateManager setupDatePickView:pickerView];
    [_mainView addSubview:pickerView];
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight - 330, IPhoneWidth, 330);
    }];
}

- (void)dealloc
{
    _dateBlock = nil;
    _dateManager = nil;
}

#pragma mark - Action
- (void)onClickedOK
{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.mainView.frame = CGRectMake(0, IPhoneHeight, IPhoneWidth, 330);
    } completion:^(BOOL finished) {
        if (weakSelf.dateBlock)
        {
            weakSelf.dateBlock([self.dateManager getDateModel]);
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

@end
