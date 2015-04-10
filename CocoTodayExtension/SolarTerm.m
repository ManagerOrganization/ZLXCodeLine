//
//  SolarTerm.m
//  CalendarLib
//
//  Created by huangyi on 11-5-19.
//  Copyright 2011年 365rili. All rights reserved.
//

#import "SolarTerm.h"
#import "NSDate+Ext.h"
#import "SolarTermExceptionUpdater.h"
#import "LunarDate.h"

const NSInteger SOLAR_TERM_INFO[24] = {0, 21208, 42467, 63836, 85337,
    107014, 128867, 150921, 173149, 195551, 218072, 240693, 263343,
    285989, 308563, 331033, 353350, 375494, 397447, 419210, 440795,
    462224, 483532, 504758};
const double SECONDS_FROM_1970_TO_1900_1_06 = -2208579900.0;

typedef struct SolarTermDetail {
    unsigned char rains:2;
    unsigned char springBegins:2;
    unsigned char greatCold:2;
    unsigned char slightCold:2;
    
    unsigned char grainRain:2;
    unsigned char clearAndBright:2;
    unsigned char vernalEquinox:2;
    unsigned char insectsAwaken:2;
    
    unsigned char summerSolstice:2;
    unsigned char grainInEar:2;
    unsigned char grainBuds:2;
    unsigned char summerBegins:2;
    
    unsigned char stoppingTheHeat:2;
    unsigned char autumnBegins:2;
    unsigned char greatHeat:2;
    unsigned char slightHeat:2;
    
    unsigned char hoarFrostFalls:2;
    unsigned char coldDews:2;
    unsigned char AutumnalEquinox:2;
    unsigned char whiteDews:2;
    
    unsigned char winterSolstice:2;
    unsigned char heavySnow:2;
    unsigned char lightSnow:2;
    unsigned char winterBegins:2;
}SolarTermDetail;

typedef struct SolarTermItem {
    union {
        unsigned char info[6];
        SolarTermDetail detail;
    };
}SolarTermItem;

const int solarTermOffset[] = {4,19,3,18,4,19,4,19,4,20,4,20,6,22,6,22,6,22,7,22,6,21,6,21};
//const int solarTermMax[]    = {7,21,5,20,7,22,6,21,7,22,7,22,8,24,9,24,9,24,9,24,8,23,8,23};

const SolarTermItem solarTermTable[] = {
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},       //1901
{0XA9,0XAA,0XAE,0XAA,0XAA,0XAA},
{0XAA,0XFA,0XEE,0XAE,0XEA,0XAA},
{0XEA,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XFA,0XEE,0XAE,0XEA,0XAA},
{0XEA,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XFA,0XEE,0XAE,0XEA,0XAA},
{0XEA,0XA5,0X9A,0X59,0X9A,0XA5},
{0X95,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA5,0XA6,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XBA,0XAE,0XAA,0XEA,0XAA},
{0XAA,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA6,0X9A,0X9A,0X9A,0XA5},
{0XA5,0XA6,0XAA,0XAA,0XAA,0XA9},
{0XAA,0XBA,0XAE,0XAA,0XEA,0XAA},
{0XAA,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X9A,0X9A,0XA5},
{0XA5,0XA6,0XAA,0XAA,0XAA,0XA9},
{0XA9,0XAA,0XAE,0XAA,0XEA,0XAA},
{0XAA,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X9A,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAE,0XAA,0XAA,0XAA},
{0XAA,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAE,0XAA,0XAA,0XAA},
{0XAA,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0XAA,0XAA,0XAA,0XAA,0XAA},
{0XAA,0XA5,0X59,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA6,0XAA,0X9A,0X9A,0XA9},
{0XA5,0XA6,0XAA,0XAA,0XAA,0XAA},
{0XAA,0X65,0X59,0X55,0X95,0X55},
{0X55,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X9A,0X9A,0XA9},
{0XA5,0XA6,0XAA,0XAA,0XAA,0XAA},
{0XAA,0X65,0X59,0X55,0X95,0X55},
{0X55,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X9A,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XAA,0X55,0X59,0X55,0X95,0X55},
{0X55,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0X55,0X59,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0X55,0X59,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0XAA,0XA9},
{0XA9,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0XA6,0XAA,0X9A,0X9A,0XA9},
{0XA9,0X51,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X96,0XA5},
{0XA5,0XA6,0X9A,0X9A,0X9A,0XA9},
{0XA9,0X51,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X9A,0X9A,0XA9},
{0XA5,0X51,0X55,0X45,0X55,0X55},
{0X55,0X65,0X59,0X55,0X95,0X55},
{0X55,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X5A,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X55,0X54},
{0X55,0X55,0X59,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X96,0X95},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X59,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X9A,0XA5},
{0XA5,0X51,0X55,0X45,0X45,0X54},
{0X54,0X51,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X96,0XA5},
{0XA5,0X51,0X45,0X45,0X45,0X54},
{0X54,0X51,0X55,0X45,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0XA5,0X9A,0X59,0X96,0X95},
{0X95,0X50,0X45,0X45,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X55},
{0X55,0X65,0X59,0X55,0X95,0X55},
{0X55,0XA5,0X99,0X59,0X96,0X95},
{0X95,0X50,0X45,0X04,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X55,0X55,0X59,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X96,0X95},
{0X95,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X99,0X59,0X95,0X55},
{0X95,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X45,0X45,0X45,0X54},
{0X54,0X51,0X55,0X55,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0X50,0X45,0X04,0X41,0X50},
{0X50,0X50,0X45,0X45,0X45,0X54},
{0X54,0X51,0X55,0X45,0X55,0X55},
{0X55,0XA5,0X59,0X55,0X95,0X55},
{0X95,0X50,0X44,0X04,0X41,0X40},
{0X40,0X50,0X45,0X04,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X55},
{0X55,0X55,0X59,0X55,0X55,0X55},
{0X55,0X50,0X44,0X04,0X41,0X40},
{0X40,0X50,0X45,0X04,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X55},
{0X55,0X55,0X55,0X55,0X55,0X55},
{0X55,0X50,0X44,0X04,0X41,0X40},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X55,0X55,0X55,0X55,0X55,0X55},
{0X55,0X50,0X44,0X04,0X40,0X00},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0X50,0X44,0X04,0X40,0X00},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0X50,0X04,0X00,0X40,0X00},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X45,0X45,0X45,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55},
{0X55,0X50,0X04,0X00,0X40,0X00},
{0X40,0X50,0X45,0X04,0X41,0X50},
{0X50,0X51,0X45,0X45,0X45,0X54},
{0X54,0X51,0X55,0X45,0X55,0X55},
{0X55,0X50,0X04,0X00,0X40,0X00},
{0X40,0X50,0X45,0X04,0X41,0X50},
{0X50,0X50,0X45,0X05,0X45,0X54},
{0X54,0X51,0X55,0X45,0X55,0X55},
{0X55,0X50,0X04,0X00,0X40,0X00},
{0X40,0X50,0X44,0X04,0X41,0X40},
{0X50,0X50,0X45,0X04,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X55},
{0X55,0X00,0X04,0X00,0X00,0X00},
{0X00,0X50,0X44,0X04,0X41,0X40},
{0X40,0X50,0X45,0X04,0X45,0X54},
{0X50,0X51,0X55,0X45,0X55,0X55},
{0X55,0X00,0X00,0X00,0X00,0X00},
{0X00,0X50,0X44,0X04,0X41,0X40},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X55,0X00,0X00,0X00,0X00,0X00},
{0X00,0X50,0X44,0X04,0X40,0X00},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X00,0X00,0X00,0X00,0X00},
{0X00,0X50,0X44,0X00,0X40,0X00},
{0X40,0X50,0X45,0X04,0X45,0X50},
{0X50,0X51,0X55,0X45,0X55,0X54},
{0X54,0X55,0X55,0X55,0X55,0X55}};

static NSArray *SOLAR_TERM = nil;

@interface SolarTerm()

@end

@implementation SolarTerm
static NSMutableDictionary *_termCache = nil;

+ (void)initialize {
    _termCache = [[NSMutableDictionary alloc] init];
    SOLAR_TERM = [@[@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至"] retain];
}

+ (NSString *)getSolarTerm:(NSDate *)date {
    CLGregorianDate gDate = [date getGregorianDate];
    int idx = (gDate.month - 1) * 2;

    if ((gDate.day > 2 && gDate.day < 10) || (gDate.day > 17 && gDate.day < 25)) {
        if (gDate.day == [SolarTerm getDayForTerm:gDate.year indexAtTermArray:idx]) {
            return [SOLAR_TERM objectAtIndex:idx];
        }else if(gDate.day == [SolarTerm getDayForTerm:gDate.year indexAtTermArray:idx + 1]){
            return [SOLAR_TERM objectAtIndex:idx+1];
        }
    }
    return @"";
}

+ (NSString *)getSolarTermWithGregorianDate:(CLGregorianDate)gDate {
    int idx = (gDate.month - 1) * 2;
    
    if ((gDate.day > 2 && gDate.day < 10) || (gDate.day > 17 && gDate.day < 25)) {
        if (gDate.day == [SolarTerm getDayForTerm:gDate.year indexAtTermArray:idx]) {
            return [SOLAR_TERM objectAtIndex:idx];
        }else if(gDate.day == [SolarTerm getDayForTerm:gDate.year indexAtTermArray:idx + 1]){
            return [SOLAR_TERM objectAtIndex:idx+1];
        }
    }
    return @"";
}

+ (NSInteger)originalDayForYear:(int)year forTerm:(int)termIndex {
    double yc = year - 1900.0;
    
    double temp = SECONDS_FROM_1970_TO_1900_1_06 + (31556925.9747 * yc + (double)(SOLAR_TERM_INFO[termIndex]) * 60.0);
	//+082644时区
	temp += 26 * 60 + 44;
	
	NSDate *offDate = [NSDate dateWithTimeIntervalSince1970: temp];
    CLGregorianDate offDateInfo = [offDate getGregorianDate];
    if (offDateInfo.year == 2012 && offDateInfo.month == 7 && offDateInfo.day == 5) {
        NSLog(@"debug.");
    }
    switch (year) {
		case 2000:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            break;
		case 2003:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            break;
		case 2004:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            break;
		case 2007:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            break;
		case 2008:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            break;
		case 2009:
			if (termIndex/2+1 == 2 && offDateInfo.day == 3)
				return 4;
            break;
		case 2010:
			if (termIndex/2+1 == 8 && offDateInfo.day == 8)
				return 7;
			else if (termIndex/2+1 == 2 && offDateInfo.day == 5)
				return 4;
            break;
        case 2011:
            if (termIndex/2+1 == 11 && offDateInfo.day == 22)
                return 23;
            break;
        case 2012:
            if (termIndex/2+1 == 1 && offDateInfo.day == 20)
                return 21;
            else if (termIndex/2+1 == 2 && offDateInfo.day == 4)
                return 4;
            else if (termIndex/2+1 == 5 && offDateInfo.day == 21)
                return 20;
            else if (termIndex/2+1 == 12 && offDateInfo.day == 6)
                return 7;
            else if (termIndex/2+1==7 && offDateInfo.day == 6) {
                return 7;
            }
            break;
		case 2013:
			if (termIndex/2+1 == 2 && (offDateInfo.day == 3 || offDateInfo.day == 5))
				return 4;
            else if (termIndex/2+1 == 7 && offDateInfo.day == 23)
				return 22;
            else if (termIndex/2+1 == 12 && offDateInfo.day == 21)
				return 22;
            break;
        case 2014:
            if (termIndex/2+1 == 3 && offDateInfo.day == 5)
				return 6;
            break;
		case 2015:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            else if (termIndex/2+1 == 1 && offDateInfo.day == 5)
				return 6;
            break;
		case 2016:
			if (termIndex/2+1 == 2 && offDateInfo.day == 5)
				return 4;
            else if (termIndex/2+1 == 12 && offDateInfo.day == 6)
				return 7;
            break;
		case 2017:
			if (termIndex/2+1 == 2 && offDateInfo.day == 3)
				return 4;
            else if (termIndex/2+1 == 7 && offDateInfo.day == 23)
				return 22;
            else if (termIndex/2+1 == 12 && offDateInfo.day == 21)
				return 22;
            break;
        case 2018:
			if (termIndex/2+1 == 2 && offDateInfo.day == 18)
				return 19;
            else if (termIndex/2+1 == 3 && offDateInfo.day == 20)
				return 21;    
            break;
		case 2019:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            else if (termIndex/2+1 == 6 && offDateInfo.day == 22)
                    return 21;  
            break;
		case 2020:
			if (termIndex/2+1 == 2 && offDateInfo.day == 4)
				return 5;
            else if (termIndex/2+1 == 7 && offDateInfo.day == 7)
                return 6;  
            else if (termIndex/2+1 == 8 && offDateInfo.day == 23)
                return 22;  
            else if (termIndex/2+1 == 12 && offDateInfo.day == 6)
                return 7;  
            break;
    }
	
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
	NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate: offDate];
    [gregorian release];
    return [dateComponents day];
}

//+ (NSInteger)getDayForTerm:(NSInteger)year indexAtTermArray:(NSInteger)index{
//    if (index >= 0 && index < 24) {
//        int day = [self originalDayForYear:year forTerm:index];
//        return [SolarTermExceptionUpdater amendmentDayOfTerm:index inYear:year originalDay:day];
//    }
//    return 0;
//}

+ (NSInteger)getDayForTerm:(NSInteger)year indexAtTermArray:(NSInteger)index{
    if (index >= 0 && index < 24) {
        SolarTermItem info = solarTermTable[year - 1901];
//        int day = ((info.info[index/4] & ((0xc0) >> ((index % 4) * 2))) >> ((3 - (index % 4)) * 2)) + solarTermOffset[index];
        int day = 0;
        switch (index) {
            case 0:
                day = info.detail.slightCold + solarTermOffset[0];
                break;
            case 1:
                day = info.detail.greatCold + solarTermOffset[1];
                break;
            case 2:
                day = info.detail.springBegins + solarTermOffset[2];
                break;
            case 3:
                day = info.detail.rains + solarTermOffset[3];
                break;
            case 4:
                day = info.detail.insectsAwaken + solarTermOffset[4];
                break;
            case 5:
                day = info.detail.vernalEquinox + solarTermOffset[5];
                break;
            case 6:
                day = info.detail.clearAndBright + solarTermOffset[6];
                break;
            case 7:
                day = info.detail.grainRain + solarTermOffset[7];
                break;
            case 8:
                day = info.detail.summerBegins + solarTermOffset[8];
                break;
            case 9:
                day = info.detail.grainBuds + solarTermOffset[9];
                break;
            case 10:
                day = info.detail.grainInEar + solarTermOffset[10];
                break;
            case 11:
                day = info.detail.summerSolstice + solarTermOffset[11];
                break;
            case 12:
                day = info.detail.slightHeat + solarTermOffset[12];
                break;
            case 13:
                day = info.detail.greatHeat + solarTermOffset[13];
                break;
            case 14:
                day = info.detail.autumnBegins + solarTermOffset[14];
                break;
            case 15:
                day = info.detail.stoppingTheHeat + solarTermOffset[15];
                break;
            case 16:
                day = info.detail.whiteDews + solarTermOffset[16];
                break;
            case 17:
                day = info.detail.AutumnalEquinox + solarTermOffset[17];
                break;
            case 18:
                day = info.detail.coldDews + solarTermOffset[18];
                break;
            case 19:
                day = info.detail.hoarFrostFalls + solarTermOffset[19];
                break;
            case 20:
                day = info.detail.winterBegins + solarTermOffset[20];
                break;
            case 21:
                day = info.detail.lightSnow + solarTermOffset[21];
                break;
            case 22:
                day = info.detail.heavySnow + solarTermOffset[22];
                break;
            case 23:
                day = info.detail.winterSolstice + solarTermOffset[23];
                break;
            default:
                break;
        }
        return [SolarTermExceptionUpdater amendmentDayOfTerm:(int)index inYear:(int)year originalDay:day];
    }
    return 0;
}

+ (NSString *)get39WithYear:(int)y month:(int)m day:(int)d {
    int dongzhi = (int)[self getDayForTerm:y indexAtTermArray:23];
    CLGregorianDate gDate = {y, 12, static_cast<SInt8>(dongzhi), 0, 0, 0};
    
    if (m < 12 || d < dongzhi) {
        dongzhi = (int)[self getDayForTerm:y - 1 indexAtTermArray:23];

        gDate.year = y - 1;
        gDate.month = 12;
        gDate.day = dongzhi;
    }
    
    NSDate *date = [NSDate dateFromCFGregorianDate:gDate];
    NSDate *sDate = [NSDate dateFromCFGregorianDate:(CLGregorianDate){y,static_cast<SInt8>(m),static_cast<SInt8>(d),0,0,0}];
    
    if ([sDate compare:date] != NSOrderedAscending && [date compare:[sDate dateByAddingTimeInterval:86400 * 81]] != NSOrderedDescending) {
        for (int i=1; i<9; i++) {
            date = [date dateByAddingTimeInterval:86400 * 9];
            CLGregorianDate gD = [date getGregorianDate];
            
            if (gD.year == y && gD.month == m && gD.day == d) {
                return [NSString stringWithFormat:@"%@九", [LunarDate chineseNumberWithNumber:i + 1]];
            }
        }
    }
    return @"";
}

+ (NSDictionary *)get39MapWithYear:(int)y month:(int) m {
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    int dongzhi = (int)[self getDayForTerm:y indexAtTermArray:23];
    CLGregorianDate gDate = {y, 12, static_cast<SInt8>(dongzhi), 0, 0, 0};
    
    if (m < 12) {
        dongzhi = (int)[self getDayForTerm:y - 1 indexAtTermArray:23];
        gDate.year = y - 1;
        gDate.month = 12;
        gDate.day = dongzhi;
    }
    
    NSDate *date = [NSDate dateFromCFGregorianDate:gDate];
    for (int i=1; i<9; i++) {
        date = [date dateByAddingTimeInterval:86400 * 9];
        CLGregorianDate gD = [date getGregorianDate];
        if (gD.year == y && gD.month == m) {
            [map setObject:[NSString stringWithFormat:@"%@九", [LunarDate chineseNumberWithNumber:i + 1]] forKey:@(gD.day)];
        }
    }
    return map;
}

+ (int)getGanWithYear:(int)y month:(int)m day:(int)d {
    if(m == 1|| m == 2){
        y = y-1;
        m = m + 12;
    }
    int c = y/100;
    int y1 = y%100;
    
    return (int) (4*c+floor(c/4)+5*y1+floor(y1/4)+floor(3*(m+1)/5)+d-3)%10;
}

+ (NSString *)get3fWithYear:(int)y month:(int)m day:(int)d {
    int xiazhi = (int)[self getDayForTerm:y indexAtTermArray:11];
    CLGregorianDate gDate = {y, 6, static_cast<SInt8>(xiazhi), 0, 0, 0};
    
    int g = [self getGanWithYear:y month:6 day:gDate.day];
    int od = 20+(g>7?(17-g):(7-g));
    
    NSDate *date = [[NSDate dateFromCFGregorianDate:gDate] dateByAddingTimeInterval:od * 86400];
    
    CLGregorianDate gD = [date getGregorianDate];
    
    if (gD.month == m && gD.day == d) {
        return @"初伏";
    }
    
    date = [date dateByAddingTimeInterval:10 * 86400];
    gD = [date getGregorianDate];
    
    if (gD.month == m && gD.day == d) {
        return @"中伏";
    }
    
    int liqiu = (int)[self getDayForTerm:y indexAtTermArray:14];
    gDate = (CLGregorianDate){y, 8, static_cast<SInt8>(liqiu), 0, 0, 0};
    
    g = [self getGanWithYear:y month:8 day:gDate.day];
    od = g>7?(17-g):(7-g);

    date = [[NSDate dateFromCFGregorianDate:gDate] dateByAddingTimeInterval:od * 86400];
    gD = [date getGregorianDate];
    if (gD.month == m && gD.day == d) {
        return @"末伏";
    }
    return @"";
}

+ (NSDictionary *)get3fMapWithYear:(int)y month:(int)m {
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    
    int xiazhi = (int)[self getDayForTerm:y indexAtTermArray:11];
    CLGregorianDate gDate = {y, 6, static_cast<SInt8>(xiazhi), 0, 0, 0};
    
    int g = [self getGanWithYear:y month:6 day:gDate.day];
    int od = 20+(g>7?(17-g):(7-g));
    
    NSDate *date = [[NSDate dateFromCFGregorianDate:gDate] dateByAddingTimeInterval:od * 86400];
    CLGregorianDate gD = [date getGregorianDate];

    if (gD.month == m) {
        [map setObject:@"初伏" forKey:@(gD.day)];
    }
    
    date = [date dateByAddingTimeInterval:10 * 86400];
    gD = [date getGregorianDate];
    
    if (gD.month == m) {
        [map setObject:@"中伏" forKey:@(gD.day)];
    }
    
    int liqiu = (int)[self getDayForTerm:y indexAtTermArray:14];
    gDate = (CLGregorianDate){y, 8, static_cast<SInt8>(liqiu), 0, 0, 0};
    
    g = [self getGanWithYear:y month:8 day:gDate.day];
    od = g>7?(17-g):(7-g);
    
    date = [[NSDate dateFromCFGregorianDate:gDate] dateByAddingTimeInterval:od * 86400];
    gD = [date getGregorianDate];

    if (gD.month == m) {
        [map setObject:@"末伏" forKey:@(gD.day)];
    }    
    return map;
}
@end
