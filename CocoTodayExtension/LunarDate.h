//
//  LunarDate.h
//  CalendarLib
//
//  Created by yiping wang on 14-1-15.
//
//

#import <Foundation/Foundation.h>

@interface LunarDate : NSObject
@property (nonatomic, assign) int year;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int day;
@property (nonatomic, assign) BOOL leap;

@property (nonatomic, readonly, getter = offsetSince19010131) long offset;
@property (nonatomic, retain) NSDate *solarDate;

/**
 * @brief 给定农历年月日生成农历对象
 *
 * @param year              农历年
 * @param mmonth            农历月份
 * @param day               农历日
 * @param leap              是否闰月
 *
 * @return LunarDate Object
 */
- (id)initWithYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap;

/**
 * @brief 给定农历年月日生成农历对象
 * @see initWithYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap;
 *
 * @param year              农历年
 * @param mmonth            农历月份
 * @param day               农历日
 * @param leap              是否闰月
 *
 * @return LunarDate Object
 */
+ (LunarDate *)lunarDateWithYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap;


/**
 * @brief 给定NSDate生成农历对象
 *
 * @param date              公历时间戳
 *
 * @return LunarDate Object
 */
- (id)initWithSolarDate:(NSDate *)date;
+ (LunarDate *)lunarDateWithSolarDate:(NSDate *)date;

/**
 * @brief 给定农历年返回该年份的天数
 *
 * @param year              农历年
 *
 * @return 农历年天数
 */
+ (int)yearDays:(int)year;

/**
 * @brief 给定农历年返回该年份闰月的天数，如果没有闰月返回0
 *
 * @param year              农历年
 *
 * @return 农历年闰月天数
 */
+(int)leapDays:(int)year;

/**
 * @brief 给定农历年返回该年份的闰月，没有闰月返回0
 *
 * @param year              农历年
 *
 * @return 农历年闰月月份
 */
+(int)leapMonth:(int)year;

/**
 * @brief 给定农历年和月返回该月份的天数
 * @see daysOfYear:(int)y inMonth:(int)m leap:(BOOL *)leap
 *
 * @param year              农历年
 * @param month             农历月
 *
 * @return 该月天数
 */
+(int)daysOfYear:(int)year inMonth:(int)month;

/**
 * @brief 给定农历年和月返回该月份的天数
 *
 * @param year              农历年
 * @param month             农历月
 * @param leap              农历月是否为闰月,该值可能会被改变
 *
 * @return 该月天数
 */
+(int)daysOfYear:(int)y inMonth:(int)m leap:(BOOL *)leap;

/**
 * @brief 1900年1月31号的时间戳，各个时区的时间戳不一样，想要获得某个指定时区的该天时间戳，需要先调用resetDateOf19000131
 *
 * @see resetDateOf19000131
 *
 * @return 1900年1月31号的时间戳
 */
+ (NSDate *)date19000131;

/**
 * @brief 重置1900年1月31号的时间戳
 *
 * @see date19000131
 *
 * @return 重置1900年1月31号的时间戳
 */
+ (void)resetDateOf19000131;

- (NSString *)getLunarMonthDayString;
- (NSString *)getLunarDayDisplay;
- (NSString *)getLunarMonthDisplay;
- (NSString *)getLunarYearDisplay;

+ (NSString *)getLunarDayDisplay:(int)day;
+ (NSString *)getLunarMonthDisplay:(int)month isLeap:(BOOL)isLeap;
+ (NSString *)getLunarDisplayWithMonth:(int)month day:(int)day;
+ (NSString *)getLunarYearDisplay:(int)year;


- (NSString*)lunarDateDescription;

/**
 * @brief 获得属相
 *
 * @return 属相
 */
- (int)zodiacAnimal;

/**
 * @brief 获得属相中文描述
 *
 * @return 属相中文描述
 */
- (NSString *)zodiacAnimalSignChinese;

/**
 * @brief 获得属相英文文描述
 *
 * @return 属相英文描述
 */
- (NSString *)zodiacAnimalSign;

+ (NSString *)chineseNumberWithNumber:(int)n;

- (NSString *)chineseAraYearString;
- (NSString *)chineseAraMonthString;
- (NSString *)chineseAraDayString;

+ (NSString *)chineseAraYearStringWithDate:(NSDate *)sDate;
+ (NSString *)chineseAraMonthStringWithYear:(int)syear month:(int)smonth day:(int)sday;
+ (NSString *)chineseAraDayStringWithYear:(int)syear month:(int)smonth day:(int)sday;

/**
 * @brief 获取给出日历的农历/节日/节气/三伏/三九信息
 * @return {"v":string, "s":1}, v为显示的字符，s为是否节日/节气标记
 */
+ (NSDictionary *)getHelperDisplayForDate:(NSDate *)date;

@end
