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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 250, 150, 100)];
    [button setTitle:@"Let\'s Go" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickAllDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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

- (void)onClickAllDatePicker
{
    HHDatePickerView *pickerView = [[HHDatePickerView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
//    [pickerView showCustomDatePickerWithCompleteCallback:^(HHDateModel *model) {
//        NSString *msg = [NSString stringWithFormat:@"This is what you chose: \n%@-%@-%@", model.year, model.month, model.day];
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }];
//    [self.view addSubview:pickerView];

    [pickerView showDatePickerWithYear:self.showYear month:self.showMonth day:self.showDay title:@"Please chose date" completeCallback:^(HHDateModel *model) {
        NSString *msg = [NSString stringWithFormat:@"This is what you chose: \n%@-%@-%@", model.year, model.month, model.day];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [self.view addSubview:pickerView];
}

@end
