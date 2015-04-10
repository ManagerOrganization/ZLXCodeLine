//
//  SolarLunarFestival.m
//  CalendarLib
//
//  Created by huangyi on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SolarLunarFestival.h"
#import "CLGregorianDate2.h"

@implementation SolarLunarFestival

+ (int)getWeekday:(CLGregorianDate)date
{
    CFTimeZoneRef tz = CFTimeZoneCopyDefault();
    CFGregorianDate month_date;
    month_date.year = date.year;
    month_date.month = date.month;
    month_date.day = date.day;
    month_date.hour = 0;
    month_date.minute = 0;
    month_date.second = 1;
    int weekday = (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date,tz),tz);
    CFRelease(tz);
    return weekday;
}

+ (NSString *)getSolarFestival:(CLGregorianDate)date{
    
    int monthDay = date.month * 100 + date.day;
    switch (monthDay) {
        case 101: return @"元旦";
        case 214: return @"情人";
        case 308: return @"妇女";
        case 312: return @"植树";
        case 401: return @"愚人";
        case 501: return @"劳动";
        case 504: return @"青年";
        case 601: return @"儿童";
        case 701: return @"建党";
        case 801: return @"建军"; // 1933
        case 910: return @"教师";
        case 1001: return (date.year >= 1949) ? @"国庆" : @"";
        case 1111: return @"光棍";
        case 1224: return @"平安";
        case 1225: return @"圣诞";
        default: {
            switch (date.month) {
                case 5: {
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 7) 
                        if (date.day > 7 && date.day <= 14)
                            return @"母亲";
                    break;    
                }
                case 6: {
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 7) 
                        if (date.day > 14 && date.day <= 21) {
                            return @"父亲";
                        }
                    break;
                }
                case 11: { /*感恩节*/
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 4) {
                        if (date.day > 21 && date.day < 29) {
                            return @"感恩";
                        }
                    }
                    break;
                }
            }
            return @"";
        };
    }
}

+ (NSString *)getSolarFestivalFullName:(CLGregorianDate)date{
    
    int monthDay = date.month * 100 + date.day;
    switch (monthDay) {
        case 101: return @"新年元旦";
        case 214: return @"情人节";
        case 308: return @"国际妇女节";
        case 312: return @"植树节";
        case 401: return @"愚人节";
        case 501: return @"国际劳动节";
        case 504: return @"中国五四青年节";
        case 601: return @"国际儿童节";
        case 701: return @"中国共产党建党日";
        case 801: return @"中国建军节"; // 1933
        case 910: return @"教师节";
        case 1001: return (date.year >= 1949) ? @"国庆" : @"";
        case 1111: return @"光棍节";
        case 1224: return @"平安夜";
        case 1225: return @"圣诞节";
        default: {
            switch (date.month) {
                case 5: {
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 7)
                        if (date.day > 7 && date.day <= 14)
                            return @"母亲节";
                    break;
                }
                case 6: {
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 7)
                        if (date.day > 14 && date.day <= 21) {
                            return @"父亲节";
                        }
                    break;
                }
                case 11: { /*感恩节*/
                    int weekday = [SolarLunarFestival getWeekday:date];
                    if (weekday == 4) {
                        if (date.day > 21 && date.day < 29) {
                            return @"感恩节";
                        }
                    }
                    break;
                }
            }
            
            return @"";
        };
    }
}


+ (NSString *)getLunarFestival:(LunarDate *)date{
    NSString *festival = @"";
    int monthDay = date.month * 100 + date.day;
    switch (monthDay) {
        case 101: 
        {
            festival = @"春节";
            break;
        }
        case 115: {
            festival =  @"元宵";
            break;
        }
        case 505: {
            festival =  @"端午";
            break;
        }
        case 707: {
            festival =  @"七夕";
            break;
        }
        case 715: {
            festival =  @"鬼节";
            break;
        }
        case 815: {
            festival =  @"中秋";
            break;
        }
        case 909: {
            festival =  @"重阳";
            break;
        }
        case 1208: {
            festival =  @"腊八";
            break;
        }
        case 1223: {
            festival =  @"小年";
            break;
        }
        case 1230: {
            festival =  @"除夕";
            break;
        }
        default: 
        {
            if (date.month == 12 && date.day == 29) { // 未考虑闰腊月的情况
                int days = [LunarDate daysOfYear:date.year inMonth:date.month];
                if (days == 29) {
                    festival = @"除夕";
                }
                else {
                    festival = @"";
                }
            }
            else {
                festival = @"";
            }
            break;
        }
    }
    return festival;
}

@end
