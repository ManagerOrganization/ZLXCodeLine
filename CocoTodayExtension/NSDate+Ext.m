//
//  NSDate+Category.m
//  cal365
//
//  Created by Li Xiang
//

#import "NSDate+Ext.h"
#import "SolarTerm.h"
#import "SolarLunarFestival.h"
#import "LunarDate.h"

@implementation NSDate (Ext)

static NSDateFormatter *sUserVisibleDateFormatter = nil;
static NSCalendar      *_chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];


+ (NSDate *)today {
    return [[NSDate date] getDatePart];
}

+ (NSDate*)currentDateTime {
    return [NSDate dateFromDateInformation:[[NSDate date] dateInformation]];
}

- (DateInformation) dateInformation{
	
	DateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
													NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
										  fromDate:self];
	info.day = (int)[comp day];
	info.month = (int)[comp month];
	info.year = (int)[comp year];
	info.weekday = (int)[comp weekday];
	info.hour = (int)[comp hour];
	info.minute = (int)[comp minute];
	info.second = (int)[comp second];
	
	[gregorian release];
	return info;
}

- (NSDateComponents*)dateComponentsDetail {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
													NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth)
										  fromDate:self];
    
	[gregorian release];
	return comp;
}

+ (NSDate*) dateFromDateInformation:(DateInformation)info {
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
    
	return [gregorian dateFromComponents:comp];
}

+ (NSDate*) GMTDateFromDateInformation:(DateInformation)info {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSDate*) dateFromDescriptionString:(NSString *)desStr {
	// desStr: "2010-06-28 00:00:00.0"
	int year = [[desStr substringWithRange:NSMakeRange(0, 4)] intValue];
	int month = [[desStr substringWithRange:NSMakeRange(5, 2)] intValue];
	int day = [[desStr substringWithRange:NSMakeRange(8, 2)] intValue];
    int hour = 0;
    int minute = 0;
    if (desStr.length > 10) {
        hour = [[desStr substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[desStr substringWithRange:NSMakeRange(14, 2)] intValue];
    }
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
	
	[comp setDay:day];
	[comp setMonth:month];
	[comp setYear:year];
	[comp setHour:hour];
	[comp setMinute:minute];
	[comp setSecond:0];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSDate*)dateFromDateString:(NSString *)dateTimeStr {
    // desStr: "2012-12-3 23:1"
    NSArray *dateTimeArr = [dateTimeStr componentsSeparatedByString:@" "];
    if (dateTimeArr.count > 1) {
        NSString *dateStr = dateTimeArr[0];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
        NSString *timeStr = dateTimeArr[1];
        NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
        if (dateArr.count > 2 && timeArr.count > 1) {
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
            NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
            [comp setYear:[dateArr[0] intValue]];
            [comp setMonth:[dateArr[1] intValue]];
            [comp setDay:[dateArr[2] intValue]];
            [comp setHour:[timeArr[0] intValue]];
            [comp setMinute:[timeArr[1] intValue]];
            [comp setSecond:0];
            
            return [gregorian dateFromComponents:comp];
        }
    }
    
    return nil;
}

+ (NSDate*)dateFromYearMonthDayStr:(NSString*)yearMonthDayStr withSep:(NSString *)sepStr{
    // opposite  of  - (NSString *)fullStyleDateWithSep:(NSString *)sepStr
    NSArray *dateTimeArr = [yearMonthDayStr componentsSeparatedByString:sepStr];
    if (dateTimeArr.count == 3) {
        CLGregorianDate gdate = {[dateTimeArr[0] intValue],static_cast<SInt8>([dateTimeArr[1] intValue]),static_cast<SInt8>([dateTimeArr[2] intValue]),0,0,0};
        return [self dateFromCFGregorianDate:gdate];
    }
    return nil;
}


// ------------------

+ (NSDate*) firstOfCurrentMonth{
	
	NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
	[comp setDay:1];
	return [gregorian dateFromComponents:comp];
	
}
+ (NSDate*) lastOfCurrentMonth{
	NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}

- (NSDate*) timelessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:day];
	return [gregorian dateFromComponents:comp];
}
- (NSDate*) monthlessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
	return [gregorian dateFromComponents:comp];
}

- (NSDate*) firstOfCurrentMonthForDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
	[comp setDay:1];
	return [gregorian dateFromComponents:comp];
}

- (NSDate*) firstOfNextMonthForDate {
    // This method is not tested. Confirm it before use.
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    int nxtMonth = (int)(comp.month + 1);
    comp.year += nxtMonth / 12;
    comp.month = nxtMonth % 12;
    [comp setDay:1];
	return [gregorian dateFromComponents:comp];
}

- (int)dayOfWeekInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekdayOrdinal fromDate:self];
    int weekdayOrdinal = (int)[comps weekdayOrdinal];
    [gregorian release];
    
    return weekdayOrdinal;
}

- (NSString *)yearStr {
    return [self dateStringWithFormat:@"yyyy"];
}

- (NSString *)monthStr {
    return [self dateStringWithFormat:@"MMMM"];
}

- (NSString *)dayStr {
    return [self dateStringWithFormat:@"d"];
}

- (NSString *)smartDayString {
    long long count = [[NSDate today] differenceInDaysTo:self];
    if (count == -1) { return NSLocalizedString(@"Yesterday", @"昨天");}
    else if (count == 1) { return NSLocalizedString(@"Tomorrow", @"明天");}
    else if (count == 0) { return NSLocalizedString(@"Today", @"今天");}
    return [self dateStringWithFormat:@"MM.d"];
}

- (NSString *)smartDayTimeString {
    long long count = [[NSDate today] differenceInDaysTo:[self getDatePart]];
    if (count == -1) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Yesterday", @"昨天"), [self dateStringWithFormat:@"HH:mm"]];
    }
    else if (count == 1) { return NSLocalizedString(@"Tomorrow", @"明天");}
    else if (count == 0) {
        double intval = [[NSDate date] timeIntervalSinceDate:self];
        
        int h = intval / (60.0 * 60.0);
        int m = (intval - h * 3600.0) / 60.0;
        
        if (h > 0) {
            return [NSString stringWithFormat:@"%d小时前", h];
        }
        else  if (m > 0) {
            return [NSString stringWithFormat:@"%d分钟前", m];
        }
        else {
            return NSLocalizedString(@"Latest", @"刚刚");
        }
        return NSLocalizedString(@"Today", @"今天");
    }
    else if (count < -1 && count > -10) {
        return [NSString stringWithFormat:@"%d天前", abs((int)count)];
    }
    return [self dateStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)hourStr {
    return [self dateStringWithFormat:@"h a"];
}

- (NSString *)simpleChineseWeekdayStr {
    NSArray *weekdayStrAry = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日" , nil];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
	int weekday = (int)[comps weekday];
	[gregorian release];
	
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	if (YES) {
		weekday -= 1;
		if (weekday == 0) {
			weekday = 7;
		}
	}
	CFRelease(currentCalendar);
	
	return [weekdayStrAry objectAtIndex:weekday-1];
}

- (NSString *)chineseWeekdayStr {
    NSArray *weekdayStrAry = [NSArray arrayWithObjects:
                              NSLocalizedString(@"Monday", @"周一"),
                              NSLocalizedString(@"Tuesday", @"周二"),
                              NSLocalizedString(@"Wednesday", @"周三"),
                              NSLocalizedString(@"Thursday", @"周四"),
                              NSLocalizedString(@"Friday", @"周五"),
                              NSLocalizedString(@"Saturday", @"周六"),
                              NSLocalizedString(@"Sunday", @"周日"),
                              nil];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
	int weekday = (int)[comps weekday];
	[gregorian release];
	
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	if (YES) {
		weekday -= 1;
		if (weekday == 0) {
			weekday = 7;
		}
	}
	CFRelease(currentCalendar);
	
	return [weekdayStrAry objectAtIndex:weekday-1];
}

- (NSNumber *)dayNumber {
    return [NSNumber numberWithInt:[[self dateStringWithFormat:@"d"] intValue]];
}

- (NSString*) monthYearString{
    return [self dateStringWithFormat:@"MMMM yyyy"];
}

- (int)weekday {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
	int weekday = (int)[comps weekday];
	[gregorian release];
	return weekday;
}


// Calendar starting on Monday instead of Sunday (Australia, Europe against US american calendar)
- (int)weekdayWithMondayFirst {
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
	int weekday = (int)[comps weekday];
	[gregorian release];
	
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	//if (CFCalendarGetFirstWeekday(currentCalendar) == 2) {
	if (YES) {
		weekday -= 1;
		if (weekday == 0) {
			weekday = 7;
		}
	}
	CFRelease(currentCalendar);
	
	return weekday;
}

- (NSDate *)date19010101 {
    CLGregorianDate gDate = {1901,1,1,0,0,0};
    return [NSDate dateFromCFGregorianDate:gDate];
}

+ (NSDate *)date19010101 {
    CLGregorianDate gDate = {1901,1,1,0,0,0};
    return [NSDate dateFromCFGregorianDate:gDate];
}

- (NSDate *)date19001231 {
    CLGregorianDate gDate = {1900,12,31,0,0,0};
    return [NSDate dateFromCFGregorianDate:gDate];
}

- (long long)daysSince1901_01_01 {
    return [[self date19010101] differenceInDaysTo:self];
}

- (long long)weeksSince1901_01_01 {
    return [[self date19001231] differenceInWeeksTo:self];
}

- (long long)differenceInDaysTo:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    
    NSInteger days = [components day];
    [gregorian release];
    return days;
}

- (int)differenceInWeeksTo:(NSDate *)toDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekOfYear
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger weeks = (int)[components weekOfYear];
    [gregorian release];
    return (int)weeks;
}

- (int)differenceInMonthsTo:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth
                                                fromDate:[self monthlessDate]
                                                  toDate:[toDate monthlessDate]
                                                 options:0];
    NSInteger months = [components month];
    [gregorian release];
    return (int)months;
}

- (BOOL)isSameDay:(NSDate*)anotherDate{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

- (BOOL)isToday{
	return [self isSameDay:[NSDate date]];
}

+ (NSDate *)date2051 {
    return [NSDate dateWithTimeIntervalSince1970:2556144000];
}


- (NSString*) dateDescription{
	
	return [[self description] substringToIndex:10];
	
}

- (long long)toMilliSecond {
    double timeInterval = [self timeIntervalSince1970];
    return (long long)(timeInterval * 1000.0);
}

+ (id)dateFromMilliSecond:(long long)milliSecond {
    NSDate *result = [[NSDate alloc] initWithTimeIntervalSince1970:milliSecond / 1000.0];
    return [result autorelease];
}

- (NSDate *)getDatePart {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *comp = [cal components:(NSCalendarUnitYear   |
                                              NSCalendarUnitMonth  |
                                              NSCalendarUnitDay    ) fromDate:self];
    [comp setHour:0];
	[comp setMinute:0];
	[comp setSecond:0];
    //[comp setTimeZone:cal.timeZone];
    NSDate *date = [cal dateFromComponents:comp];
    [cal release];
    return date;
}

- (NSDate*)dateWithNewTimeZone:(NSString *)timeZone {
    NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents *comp = [cal components:(NSCalendarUnitYear   |
                                              NSCalendarUnitMonth  |
                                              NSCalendarUnitDay    |
                                              NSCalendarUnitHour   |
                                              NSCalendarUnitMinute |
                                              NSCalendarUnitSecond ) fromDate:self];
    
    [comp setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    return [cal dateFromComponents:comp];
}


- (NSDate *)firstDayOfMonth {
    return [NSDate firstMonthDayOfDate:self];
}

+ (NSDate *)firstMonthDayOfDate:(NSDate *)date {
    CLGregorianDate gDate = [date getGregorianDate];
    gDate.day = 1;
    return [date dateFromCFGregorianDate:gDate];
}

- (NSDate *)lastDayOfMonth {
    return [NSDate lastMonthDayOfDate:self];
}

+ (NSDate *)lastMonthDayOfDate:(NSDate *)date {
    NSDate *nxtMonthFirstDate = [NSDate firstMonthDayOfDate:[[date firstDayOfMonth] dateByAddingTimeInterval:32 * 86400]];
    return [[nxtMonthFirstDate getDatePart] dateByAddingTimeInterval:-86400];
}

+ (NSInteger)weekNumuberOfYear:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    [calendar release];
    return dateComponent.weekOfYear;
}

+ (NSDate *)dateFromFullStyleDateStr:(NSString *)dateStr {
    @synchronized (sUserVisibleDateFormatter) {
        if (sUserVisibleDateFormatter == nil) {
            sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
        }
        [sUserVisibleDateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [sUserVisibleDateFormatter dateFromString:dateStr];
    }
}

+ (NSDate *)dateTimeFromFullStyleDateStr:(NSString *)dateStr {
    @synchronized (sUserVisibleDateFormatter) {
        if (sUserVisibleDateFormatter == nil) {
            sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
        }
        [sUserVisibleDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [sUserVisibleDateFormatter dateFromString:dateStr];
    }
}

- (NSString *)dateStringWithFormat:(NSString *)format {
    @synchronized (sUserVisibleDateFormatter) {
        if (sUserVisibleDateFormatter == nil) {
            sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
        }
        [sUserVisibleDateFormatter setDateFormat:format];
        return [sUserVisibleDateFormatter stringFromDate:self];
    }
}

- (NSString *)fullStyleDateWithBackslash {
    return [self dateStringWithFormat:@"yyyy/MM/dd"];
}

- (NSString *)fullStyleDateWithoutYearWithBackslash {
    return [self dateStringWithFormat:@"MM/dd"];
}

- (NSString *)fullStyleDate {
    return [self dateStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)fullStyleDateChinese {
    return [self dateStringWithFormat:@"yyyy年MM月dd日"];
}

- (NSString *)fullStyleDateWithWeekDay {
    return [NSString stringWithFormat:@"%@ %@", [self fullStyleDateChinese], [self chineseWeekdayStr]];
}

- (NSString *)fullStyleDateWithoutDay {
    return [self dateStringWithFormat:@"yyyy年MM月"];
}

- (NSString *)fullStyleDateWithoutYear {
    return [self dateStringWithFormat:@"MM-dd"];
}

- (NSString *)timeInDay {
    return [self dateStringWithFormat:@"HH:mm"];
}

- (NSString *)secondInDay {
    return [self dateStringWithFormat:@"HH:mm:ss"];
}

- (NSString *)hourInDay{
    return [self dateStringWithFormat:@"HH"];
}

- (NSString *)fullStyleChineseDateWithoutYear {
    return [self dateStringWithFormat:@"MM月dd日"];
}

- (NSString *)fullStyleDateWithSep:(NSString *)sepStr {
    return [self dateStringWithFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd", sepStr, sepStr]];
}

- (NSString *)fullStyleDateTime {
    return [self dateStringWithFormat:@"yyyy-MM-dd HH:mm"];
}

- (BOOL)isSameYear:(NSDate *)anotherDate {
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSCalendarUnitYear) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSCalendarUnitYear) fromDate:anotherDate];
	return ([components1 year] == [components2 year]);
}

- (BOOL)isSameMonth:(NSDate *)anotherDate {
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSCalendarUnitMonth) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSCalendarUnitMonth) fromDate:anotherDate];
	return ([components1 month] == [components2 month]);
}

- (BOOL)isSameYearMonth:(NSDate *)anotherDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month]);
}

- (int)daysInMonth {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	
	int days = (int)[[gregorian components:NSCalendarUnitDay fromDate:[gregorian dateFromComponents:comp]] day];
	[gregorian release];
	
	return days;
}

- (NSString *)yearMonthStrWithSep:(NSString *)sepStr {
    return [self dateStringWithFormat:[NSString stringWithFormat:@"yyyy%@MM", sepStr]];
}

- (CLGregorianDate)getGregorianDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
													NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
										  fromDate:self];
    CLGregorianDate gDate = (CLGregorianDate){(int)[comp year], static_cast<SInt8>([comp month]), static_cast<SInt8>([comp day]),
        static_cast<SInt8>([comp hour]), static_cast<SInt8>([comp minute]), static_cast<double>([comp second])};
	
	[gregorian release];
    
    return gDate;
}


- (NSDate *)dateFromCFGregorianDate:(CLGregorianDate)info {
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
    
	return [gregorian dateFromComponents:comp];
}

+ (NSDate *)dateFromCFGregorianDate:(CLGregorianDate)info {
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
    
	return [gregorian dateFromComponents:comp];
}

+ (NSDate*) GMTDateFromCFGregorianDate:(CLGregorianDate)info {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	
	return [gregorian dateFromComponents:comp];
}

- (int)zodiacAnimalSignIndex {
    CLGregorianDate tDate = [self getGregorianDate];
    CLGregorianDate gDate = {tDate.year, 2, static_cast<SInt8>([SolarTerm getDayForTerm:tDate.year indexAtTermArray:2]), 0, 0, 0};
    NSDate *firstDate = [NSDate dateFromCFGregorianDate:gDate];
    int num = 0;
    if ([self compare:firstDate] != NSOrderedAscending) {
        num = tDate.year - 1900 + 36;
    }
    else {
        num = tDate.year - 1 - 1900 + 36;
    }
    int index = num % 12;
    if (index < 0) {
        index += 12;
    }
    return index;
}

- (int)firstDayWeekDayOfCurrentMonth {
	CFTimeZoneRef tz = CFTimeZoneCopyDefault();
	CLGregorianDate clDate = [self getGregorianDate];
    CFGregorianDate gDate = {clDate.year, clDate.month, clDate.day, clDate.hour, clDate.minute, clDate.second};

	gDate.day = 1;
	gDate.hour = 0;
	gDate.minute = 0;
	gDate.second = 1;
    int monthWeekday = (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(gDate,tz),tz);
    CFRelease(tz);
	return monthWeekday;
}

- (NSString *)festivalDescription {
    CLGregorianDate gDate = [self getGregorianDate];
    //公历节日
    NSString *solarFestival = [SolarLunarFestival getSolarFestival:gDate];
    if (![solarFestival isEqualToString:@""]) {
        return solarFestival;
    }
    
    //农历节日
    LunarDate *lDate = [LunarDate lunarDateWithSolarDate:self];
    NSString *lunarFestival = [SolarLunarFestival getLunarFestival:lDate];
    if (![lunarFestival isEqualToString:@""]) {
        return lunarFestival;
    }
    
    //节气
    NSString *termStr = [SolarTerm getSolarTermWithGregorianDate:gDate];
    if (![termStr isEqualToString:@""]){
        return termStr;
    }
    return nil;
}

- (NSDate *)zeroClock {
    return [self zeroClockWithCalendar:[NSCalendar currentCalendar] timeZone:[NSTimeZone defaultTimeZone]];
}

- (NSDate *)zeroClockWithCalendar:(NSCalendar *)cal timeZone:(NSTimeZone *)timezone {
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}


- (int)weekCountSince1901 {
    return (ceil(([[self zeroClock] timeIntervalSince1970] - (-2176934400 - 1)) / (86400 * 7)) + 1);
}

- (NSString *)dayDiffSinceToday:(BOOL)showToday {
    long long count = [[[NSDate date] getDatePart] differenceInDaysTo:[self getDatePart]];
    if (count < 0) {
        return (count == -1) ? NSLocalizedString(@"Yesterday", @"昨天") :
        [NSString stringWithFormat:NSLocalizedString(@"%lld Day before", @"%lld天前"), -count];
    } else if (count > 0 ) {
        return (count == 1) ? NSLocalizedString(@"Tomorrow", @"明天") :
        [NSString stringWithFormat:NSLocalizedString(@"%lld Day after", @"%lld天后"), count];
    } else {
        return showToday ? NSLocalizedString(@"Today", @"今天") : nil;
    }
}


/*
 下面的代码还有问题，某些公农历转换与现有方法可能不一致
 也就是说系统的农历目前还是有问题的
 */
- (int)lYear {
    NSDateComponents *components = [_chineseCalendar components:NSCalendarUnitYear fromDate:self];
    return (int)components.year;
}

- (int)lMonth {
    NSDateComponents *components = [_chineseCalendar components:NSCalendarUnitMonth fromDate:self];
    return (int)components.month;
}

- (int)lDay {
    NSDateComponents *components = [_chineseCalendar components:NSCalendarUnitDay fromDate:self];
    return (int)components.day;
}

- (void)lunarYear:(int *)year month:(int *)month day:(int *)day {
    NSDateComponents *components = [_chineseCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    *year = (int)components.year;
    *month = (int)components.month;
    *day = (int)components.day;
}

+(NSMutableArray*)datestrArrayFromData:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    if ([fromDate compare:toDate] == NSOrderedDescending) {
        NSLog(@"wrong date");
        return nil;
    }
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    NSInteger dayCount = 0;
    NSMutableArray *dateStrArray = [NSMutableArray array];
    while ( TRUE ) {
        [days setDay:dayCount++];
        NSDate *date = [gregorianCalendar dateByAddingComponents: days toDate: fromDate options: 0];
        [dateStrArray addObject:[date fullStyleDate]];
        if ( [date compare: toDate] == NSOrderedSame )
            break;
        // Do something with date like add it to an array, etc.
    }
    [days release];
    [gregorianCalendar release];
    return dateStrArray;
}

- (NSDate *)firstDayOfPreviousMonth
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	[comp setDay:1];
	[comp setMonth:comp.month-1];
	return [gregorian dateFromComponents:comp];
}

- (NSDate *)firstDayOfNextMonth
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	[comp setDay:1];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}

- (NSDate *)firstDayOfNextNextMonth
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
	[comp setDay:1];
	[comp setMonth:comp.month+2];
	return [gregorian dateFromComponents:comp];
}

- (NSDate *)lastDayOfNextMonth
{
    NSDate *date = [self firstDayOfNextNextMonth] ;
    return [[date getDatePart] dateByAddingTimeInterval:-1] ;
}

- (NSDate *)firstDayOfWeek:(BOOL)sundayFirst {
    NSInteger daysToFirstDayOfWeek = sundayFirst ? self.weekday - 1 : self.weekdayWithMondayFirst - 1;
    return [self dateByAddingTimeInterval:-daysToFirstDayOfWeek * 86400];
}

@end
