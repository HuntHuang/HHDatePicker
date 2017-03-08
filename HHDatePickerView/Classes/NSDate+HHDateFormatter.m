//
//  NSDate+HHDateFormatter.m
//  HHDatePickerView
//
//  Created by 黄志航 on 2017/3/8.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "NSDate+HHDateFormatter.h"

@implementation NSDate (HHDateFormatter)

+ (NSDateFormatter *)hh_dateFormatterWithFormatter:(NSString *)formatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[formatter];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:formatter];
                threadDictionary[formatter] = dateFormatter;
            }
        }
    }
    return dateFormatter;
}

@end
