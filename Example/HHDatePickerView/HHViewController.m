//
//  HHViewController.m
//  HHDatePickerView
//
//  Created by Hunt on 03/08/2017.
//  Copyright (c) 2017 Hunt. All rights reserved.
//

#import "HHViewController.h"
#import "HHDatePickerView.h"

#define IPhoneHeight  [[UIScreen mainScreen] bounds].size.height
#define IPhoneWidth   [[UIScreen mainScreen] bounds].size.width
@interface HHViewController ()

@property (nonatomic, assign) BOOL showYear;
@property (nonatomic, assign) BOOL showMonth;
@property (nonatomic, assign) BOOL showDay;
@property (nonatomic, weak) UIButton *button;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 130, 30)];
    yearLabel.text = @"Year Switch";
    [self.view addSubview:yearLabel];
    
    UISwitch *yearSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 100, 50, 30)];
    yearSwitch.on = YES;
    self.showYear = YES;
    [yearSwitch addTarget:self action:@selector(onClickYearSwith:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:yearSwitch];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 130, 30)];
    monthLabel.text = @"Month Switch";
    [self.view addSubview:monthLabel];
    
    UISwitch *monthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 150, 50, 30)];
    monthSwitch.on = YES;
    self.showMonth = YES;
    [monthSwitch addTarget:self action:@selector(onClickMonthSwith:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:monthSwitch];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 130, 30)];
    dayLabel.text = @"Day Switch";
    [self.view addSubview:dayLabel];
    
    UISwitch *daySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 200, 50, 30)];
    daySwitch.on = YES;
    self.showDay = YES;
    [daySwitch addTarget:self action:@selector(onClickDaySwith:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:daySwitch];
    
    self.button.frame = CGRectMake(150, 250, 150, 100);
}

- (void)onClickYearSwith:(UISwitch *)sender
{
    self.showYear = sender.on;
}

- (void)onClickMonthSwith:(UISwitch *)sender
{
    self.showMonth = sender.on;
}

- (void)onClickDaySwith:(UISwitch *)sender
{
    self.showDay = sender.on;
}

- (void)onClickAllDatePicker:(UIButton *)sender
{
    NSString *msg = nil;
    if (self.showYear && self.showDay && self.showMonth == NO)
    {
        msg = @"请选择正确的格式";
    }
    else if (self.showYear == NO && self.showMonth == NO && self.showDay == NO)
    {
        msg = @"请打开开关";
    }
    if (msg != nil)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        HHDatePickerView *pickerView = [[HHDatePickerView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
        [pickerView showDatePickerWithYear:self.showYear month:self.showMonth day:self.showDay title:@"请选择日期" completeCallback:^(HHDateModel *model) {
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", model.year, model.month, model.day];
            NSString *msg = [NSString stringWithFormat:@"这是你选择的日期: \n%@", dateString];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            [self.button setTitle:dateString forState:UIControlStateNormal];
        }];
        [self.view addSubview:pickerView];
    }
}

- (UIButton *)button
{
    if (!_button)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 250, 150, 100)];
        [button setTitle:@"Let\'s Go" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickAllDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _button = button;
    }
    return _button;
}

@end
