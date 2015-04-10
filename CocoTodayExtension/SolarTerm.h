//
//  SolarTerm.h
//  CalendarLib
//
//  Created by huangyi on 11-5-19.
//  Copyright 2011年 365rili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLGregorianDate2.h"

@interface SolarTerm : NSObject

/**
 * @brief 根据阳历日期返回节气
 *
 * @param date              阳历时间戳
 *
 * @return 节气
 */
+ (NSString *)getSolarTerm:(NSDate *)date;

/**
 * @brief 根据阳历日期返回节气
 *
 * @param date              阳历日期
 *
 * @return 节气
 */
+ (NSString *)getSolarTermWithGregorianDate:(CLGregorianDate)gDate;

/**
 * @brief 根据年份获得某个节气的日子
 *
 * @param year              年份
 * @param index             节气索引
 *
 * @return 节气的日子
 */
+ (NSInteger)getDayForTerm:(NSInteger)year indexAtTermArray:(NSInteger)index;

/**
 * @brief 根据日期获得三九描述
 *
 * @param year              年份
 * @param month             月份
 * @param day               日子
 *
 * @return 39描述
 */
+ (NSString *)get39WithYear:(int)year month:(int)month day:(int)day;

/**
* @brief 根据所给的年份和月份获得该月所有三九描述
*
* @param year              年份
* @param month             月份
*
* @return {@(day):@"三九描述"}
*/
+ (NSDictionary *)get39MapWithYear:(int)year month:(int)month;

+ (int)getGanWithYear:(int)y month:(int)m day:(int)d;

/**
 * @brief 根据日期获得三伏描述
 *
 * @param year              年份
 * @param month             月份
 * @param day               日子
 *
 * @return 三伏描述
 */
+ (NSString *)get3fWithYear:(int)year month:(int)month day:(int)day;

/**
 * @brief 根据所给的年份和月份获得该月所有三伏描述
 *
 * @param year              年份
 * @param month             月份
 *
 * @return {@(day):@"三伏描述"}
 */
+ (NSDictionary *)get3fMapWithYear:(int)y month:(int)m;
@end
