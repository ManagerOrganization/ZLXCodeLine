//
//  CCTodayMonthView.m
//  Coco
//
//  Created by Li Xiang on 10/14/14.
//  Copyright (c) 2014 365rili.com. All rights reserved.
//

#import "CCTodayMonthView.h"

#import "NSDate+Ext.h"
#import "LunarDate.h"

#define WEEK_TITLE_ARR @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];

@implementation CCTodayMonthView

- (void)awakeFromNib {
    self.showWeek = NO;
}

- (int)totalRows {
    BOOL sundayIsFirst = NO;
    NSDate *today = [[NSDate date] getDatePart];
    int totalDays = [today daysInMonth];
    int monthWeekday = [today firstDayWeekDayOfCurrentMonth];
    if (sundayIsFirst) {
        if ((totalDays + monthWeekday - 1) % 7 > 0) {
            return (totalDays + monthWeekday - 1)/7+1;
        } else {
            return (totalDays + monthWeekday - 1)/7;
        }
    }
    
    return (totalDays + monthWeekday - 2) / 7 + 1;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSDate *today = [[NSDate date] getDatePart];
    LunarDate *lunarDate = [LunarDate lunarDateWithSolarDate:today];
    
    NSString *dateStr = [today fullStyleChineseDateWithoutYear];
    NSDictionary *dateStrAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:27],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    [dateStr drawAtPoint:CGPointMake(0, 12) withAttributes:dateStrAttribute];
    CGSize dateStrSize = [dateStr sizeWithAttributes:dateStrAttribute];
    
    NSString *weekStr = [NSString stringWithFormat:@"星期%@", [today simpleChineseWeekdayStr]];
    NSDictionary *weekStrAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.7]};
    [weekStr drawAtPoint:CGPointMake(dateStrSize.width + 5, 15) withAttributes:weekStrAttribute];
    
    NSString *lunarStr = [NSString stringWithFormat:@"%@年%@", [lunarDate chineseAraYearString], [lunarDate getLunarMonthDayString]];
    NSDictionary *lunarStrAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                        NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.3]};
    [lunarStr drawAtPoint:CGPointMake(dateStrSize.width + 5, 32) withAttributes:lunarStrAttribute];
    
    NSArray *weekTitleArray = WEEK_TITLE_ARR;
    CGFloat tileWidth = (self.bounds.size.width - 20) / 7;
    
    // 周视图背景
    CGFloat xOffset = 0;
    CGFloat width = self.bounds.size.width - 20 - xOffset;
    CGFloat yOffset = 60;
    CGFloat height = 14;
    CGFloat radius = 1;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, radius + xOffset, yOffset);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius + xOffset, yOffset);
    CGContextAddArc(context, width - radius + xOffset, radius + yOffset, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width + xOffset, height - radius);
    CGContextAddArc(context, width - radius + xOffset, height - radius + yOffset, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius + xOffset, height + yOffset);
    CGContextAddArc(context, radius + xOffset, height - radius + yOffset, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, xOffset, radius + yOffset);
    CGContextAddArc(context, radius + xOffset, radius + yOffset, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGContextSetRGBFillColor(context, 1, 1, 1, 0.2);
    CGContextDrawPath(context, kCGPathFill);
    
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    pStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *weekTitleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                         NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:1],
                                         NSParagraphStyleAttributeName:pStyle};
    for (int i = 0; i < weekTitleArray.count; i++) {
        CGRect weekTitleRect = CGRectMake(i * tileWidth, 60, tileWidth, 14);
        [weekTitleArray[i] drawInRect:weekTitleRect withAttributes:weekTitleAttribute];
    }
    
    NSInteger firstDay = 0;
    NSDictionary *dayTitleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                        NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:1],
                                        NSParagraphStyleAttributeName:pStyle};
    NSDictionary *lunarAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                     NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.5],
                                     NSParagraphStyleAttributeName:pStyle};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *holidayFlagDict = [defaults objectForKey:HOLIDAY_FLAG_DICT];
    yOffset = 74;
    
    if (self.showWeek) {    // 绘制周视图
        CGFloat tileHeight = 45;
        NSDate *firstWeekDay = [today firstDayOfWeek:firstDay != 0];
        for (int i = 0; i < 7; i++) {
            NSDate *currentDate = [firstWeekDay dateByAddingTimeInterval:86400 * i];
            if ([currentDate isSameDay:today]) {    // 今日背景
                UIImage *todayBg = [UIImage imageNamed:@"TodayExtensionTodayBg"];
                [todayBg drawInRect:CGRectMake(i * tileWidth + (tileWidth - 42) / 2, yOffset + (tileHeight - 42) / 2 + 9, 42, 42)];
            }
            
            // 日期
            CGRect dayTitleRect = CGRectMake(i * tileWidth, yOffset + (tileHeight - 20) / 2, tileWidth, 20);
            NSString *dayStr = [NSString stringWithFormat:@"%@", currentDate.dayStr];
            [dayStr drawInRect:dayTitleRect withAttributes:dayTitleAttribute];
            
            // 农历
            CGRect lunarRect = CGRectMake(i * tileWidth, dayTitleRect.origin.y + dayTitleRect.size.height + 1, tileWidth, 12);
            NSDictionary *lunarDict = [LunarDate getHelperDisplayForDate:currentDate];
            [lunarDict[@"v"] drawInRect:lunarRect withAttributes:lunarAttribute];
            
            // 放假安排
            NSInteger flag = [[holidayFlagDict objectForKey:[currentDate fullStyleDateWithSep:@"-"]] integerValue];
            UIImage *holidayFlag = nil;
            if (flag == 1) {
                holidayFlag = [UIImage imageNamed:@"TodayExtensionHolidayFlag"];
            } else if(flag == 2) {
                holidayFlag = [UIImage imageNamed:@"TodayExtensionWorkFlag"];
            }
            if (holidayFlag != nil) {
                CGSize dayStrSize = [dayStr sizeWithAttributes:dayTitleAttribute];
                [holidayFlag drawInRect:CGRectMake(i * tileWidth + (tileWidth - dayStrSize.width) / 2 - 10, yOffset + (tileHeight - 20) / 2 - 7, 14, 14)];
            }
        }
    } else {
        NSInteger x = 0;
        NSInteger y = 0;
        NSInteger day = 0;
        NSInteger totalDays = [today daysInMonth];
        int monthWeekday = [today firstDayWeekDayOfCurrentMonth];
        
        int totalRows = [self totalRows];
        CGFloat totolMontHeight = 240;
        CGFloat tileHeight = totolMontHeight / totalRows;
        
        NSDate *firstMonthDay = [today firstDayOfMonth];
        for (int i = 1; i <= totalDays; i++) {
            if (firstDay == 0) {
                day = i + monthWeekday - 2;
                x = day % 7; y = day / 7;
            } else {
                day = i + monthWeekday - 1;
                x = day % 7;
                if (monthWeekday == 7) y = day / 7 - 1;
                else y = day / 7;
            }
            
            NSDate *currentDate = [firstMonthDay dateByAddingTimeInterval:(i - 1) * 86400];
            
            if ([currentDate isSameDay:today]) {    // 今日背景
                UIImage *todayBg = [UIImage imageNamed:@"TodayExtensionTodayBg"];
                [todayBg drawInRect:CGRectMake(x * tileWidth + (tileWidth - 42) / 2, yOffset + y * tileHeight + (tileHeight - 42) / 2 + 9, 42, 42)];
            }
            
            // 日期
            CGRect dayTitleRect = CGRectMake(x * tileWidth, yOffset + y * tileHeight + (tileHeight - 20) / 2, tileWidth, 20);
            NSString *dayStr = [NSString stringWithFormat:@"%d", i];
            [dayStr drawInRect:dayTitleRect withAttributes:dayTitleAttribute];
            
            // 农历
            CGRect lunarRect = CGRectMake(x * tileWidth, dayTitleRect.origin.y + dayTitleRect.size.height + 1, tileWidth, 12);
            NSDictionary *lunarDict = [LunarDate getHelperDisplayForDate:currentDate];
            [lunarDict[@"v"] drawInRect:lunarRect withAttributes:lunarAttribute];
            
            // 放假安排
            NSInteger flag = [[holidayFlagDict objectForKey:[currentDate fullStyleDateWithSep:@"-"]] integerValue];
            UIImage *holidayFlag = nil;
            if (flag == 1) {
                holidayFlag = [UIImage imageNamed:@"TodayExtensionHolidayFlag"];
            } else if(flag == 2) {
                holidayFlag = [UIImage imageNamed:@"TodayExtensionWorkFlag"];
            }
            if (holidayFlag != nil) {
                CGSize dayStrSize = [dayStr sizeWithAttributes:dayTitleAttribute];
                [holidayFlag drawInRect:CGRectMake(x * tileWidth + (tileWidth - dayStrSize.width) / 2 - 10, yOffset + y * tileHeight + (tileHeight - 20) / 2 - 7, 14, 14)];
            }
        }
    }
}

@end
