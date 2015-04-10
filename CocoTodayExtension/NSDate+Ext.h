//
//  NSDate+Category.h
//  cal365
//
//  Created by Li Xiang
//

#import <Foundation/Foundation.h>
#import "CLGregorianDate2.h"

@interface NSDate (Ext)

struct DateInformation {
	int day;
	int month;
	int year;
	int weekday;
	int minute;
	int hour;
	int second;

};
typedef struct DateInformation DateInformation;


- (DateInformation)dateInformation;
- (NSDateComponents*)dateComponentsDetail;
- (NSDate *)dateFromCFGregorianDate:(CLGregorianDate)info;
+ (NSDate*)dateFromDateInformation:(DateInformation)info;
+ (NSDate*)GMTDateFromDateInformation:(DateInformation)info;
+ (NSDate*)dateFromDescriptionString:(NSString *)desStr;
+ (NSDate*)dateFromDateString:(NSString *)dateTimeStr;
+ (NSDate*)dateFromYearMonthDayStr:(NSString*)yearMonthDayStr withSep:(NSString *)sepStr;
+ (NSDate*)currentDateTime;
- (NSDate*)getDatePart;
- (long long)daysSince1901_01_01;
- (long long)weeksSince1901_01_01;
+ (NSDate *)dateTimeFromFullStyleDateStr:(NSString *)dateStr;
+ (NSDate *)date19010101;
+ (NSDate *)date2051;
@property (readonly,nonatomic) int weekdayWithMondayFirst;

- (NSString *)yearStr;
- (NSString *)monthStr;
- (NSString *)dayStr;
- (NSString *)smartDayString;
- (NSString *)smartDayTimeString;
- (NSString *)hourStr;
- (NSString *)simpleChineseWeekdayStr;
- (NSString *)chineseWeekdayStr;
- (NSNumber*) dayNumber;
- (NSString*) monthYearString;

+ (NSDate *)today;

- (BOOL)isSameYear:(NSDate *)anotherDate;
- (BOOL)isSameMonth:(NSDate *)anotherDate;
- (BOOL)isSameYearMonth:(NSDate *)anotherDate;

- (long long)differenceInDaysTo:(NSDate *)toDate;
- (int)differenceInMonthsTo:(NSDate *)toDate;
- (int)differenceInWeeksTo:(NSDate *)toDate;

@property (readonly,nonatomic) BOOL isToday;
- (BOOL)isSameDay:(NSDate*)anotherDate;
- (long long)toMilliSecond;

- (NSString*) dateDescription;
+ (id)dateFromMilliSecond:(long long)milliSecond;
- (NSDate*)dateWithNewTimeZone:(NSString*)timeZone;

- (NSString *)fullStyleDateWithBackslash;
- (NSString *)fullStyleDateWithoutYearWithBackslash;
- (NSString *)fullStyleDate;
- (NSString *)fullStyleDateChinese;
- (NSString *)fullStyleDateWithWeekDay;
- (NSString *)fullStyleDateWithoutYear;
- (NSString *)fullStyleChineseDateWithoutYear;
- (NSString *)fullStyleDateWithoutDay;
- (NSString *)fullStyleDateWithSep:(NSString *)sepStr;
- (NSString *)fullStyleDateTime;
- (NSString *)dateStringWithFormat:(NSString *)format;
- (NSString *)timeInDay;
- (NSString *)hourInDay;
- (NSString *)secondInDay;
+ (NSDate *)dateFromFullStyleDateStr:(NSString *)dateStr;

- (NSDate *)firstDayOfMonth;
+ (NSDate *)firstMonthDayOfDate:(NSDate *)date;
- (NSDate *)lastDayOfMonth;
+ (NSDate *)lastMonthDayOfDate:(NSDate *)date;
+ (NSInteger)weekNumuberOfYear:(NSDate *)date;

- (int)weekday;
- (int)daysInMonth;
- (int)dayOfWeekInMonth;
- (NSString *)yearMonthStrWithSep:(NSString *)sepSt;
- (CLGregorianDate)getGregorianDate;
+ (NSDate *)dateFromCFGregorianDate:(CLGregorianDate)info;
+ (NSDate*) GMTDateFromCFGregorianDate:(CLGregorianDate)info;
- (int)zodiacAnimalSignIndex;

- (NSString *)festivalDescription;

- (NSDate *)zeroClock;
- (NSDate *)zeroClockWithCalendar:(NSCalendar *)cal timeZone:(NSTimeZone *)timezone;
- (int)weekCountSince1901;

/**
 @brief 计算当前日期与今天日期相差的天数
 @param showToday 是否需要返回"今天"
 @return 今天；明天、2天后，N天后；昨天、2天前、N天前
 */
- (NSString *)dayDiffSinceToday:(BOOL)showToday;

/*
 目前还有些问题，某些公农历转换与现有方法可能不一致(比如 2012-08月的公农历转换)
 也就是说系统的农历目前还是有问题的
 */
- (int)lYear;
- (int)lMonth;
- (int)lDay;

- (void)lunarYear:(int *)year month:(int *)month day:(int *)day;

/**
 *  从起始时间到截至时间的时间字符串数组
 *
 *  @param fromDate 起始时间
 *  @param toDate   截至时间
 *
 *  @return 时间字符串数组 {"2014-01-15","2014-01-16"..."2014-01-20"}
 */
+(NSMutableArray*)datestrArrayFromData:(NSDate*)fromDate toDate:(NSDate*)toDate;


- (int)firstDayWeekDayOfCurrentMonth;

- (NSDate *)firstDayOfPreviousMonth;
- (NSDate *)firstDayOfNextMonth;
- (NSDate *)firstDayOfWeek:(BOOL)sundayFirst;

/**
 *  @return 下下个月第一天
 *  @author robbie
 */
- (NSDate *)firstDayOfNextNextMonth ;
/**
 *  @return 下个月最后一天
 *  @author robbie
 */
- (NSDate *)lastDayOfNextMonth ;

@end
