//
//  LunarDate.m
//  CalendarLib
//
//  Created by yiping wang on 14-1-15.
//
//

#import "LunarDate.h"
#import "NSDate+Ext.h"
#import "SolarTerm.h"
#import "SolarLunarFestival.h"

@implementation LunarDate
static NSArray *chineseNumber = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七",@"八", @"九", @"十", @"十一", @"十二", @"", @"" ];
static NSArray *chineseMonth = @[@"正", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"冬", @"腊", @"", @"" ];

static NSCalendar *gregorianCalendar = nil;

const int IGCNLC_LUNAR_HOLIDAY_INFO[6] = {101, 115, 505, 707, 815, 909};
static NSArray *IGCNLC_DAY_STR = [NSArray arrayWithObjects:
                                  @"零零",
                                  @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                                  @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                                  @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",
                                  @"卅一", @"卅二", @"卅三", @"卅四", @"卅五", @"卅六", @"卅七", @"卅八", @"卅九", nil];
static NSArray *IGCNLC_MONTH_STR = [NSArray arrayWithObjects:@"正", @"二", @"三", @"四", @"五", @"六",
                                    @"七", @"八", @"九", @"十", @"冬", @"腊", nil];

static NSDate *_date19000131 = nil;

static NSArray *IGCNLC_GAN = [NSArray arrayWithObjects:
                              @"癸", @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", nil];
static NSArray *IGCNLC_ZHI = [NSArray arrayWithObjects:
                              @"亥", @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", nil];

static NSArray *zodiacAnimalNames = [NSArray arrayWithObjects:
                                     @"mouse",
                                     @"cow",
                                     @"tiger",
                                     @"rabbit",
                                     @"dragen",
                                     @"snake",
                                     @"horse",
                                     @"sheep",
                                     @"monkey",
                                     @"chicken",
                                     @"dog",
                                     @"pig",
                                     nil];

typedef struct LunarItemDetail {
    unsigned int leapMonth:4; // 闰月
    unsigned int layue:1;
    unsigned int dongyue:1;
    unsigned int shiyue:1;
    unsigned int jiuyue:1;
    
    unsigned int bayue:1;
    unsigned int qiyue:1;
    unsigned int liuyue:1;
    unsigned int wuyue:1;
    unsigned int siyue:1;
    unsigned int sanyue:1;
    unsigned int eryue:1;
    unsigned int zhengyue:1;
    
    unsigned int runyue:1;
    unsigned int offset:6; // 正月初一与元旦相差天数
    unsigned int leap:1; // 是否闰年
    
    unsigned int reserve:8;
}LunarItemDetail;

typedef struct LunarItem {
    union {
        unsigned int value;
        LunarItemDetail detail;
    };
}LunarItem;

static unsigned int lunarItems[] ={
    0x003c4bd8, // 1900
    0x00624ae0,0x004ca570,0x003854d5,0x00dcd260,0x0044d950,0x00316554,0x005656a0,0x00c09ad0,0x002a55d2,0x00504ae0,  // 1910
    0x003aa5b6,0x00e0a4d0,0x0048d250,0x0033d255,0x0058b540,0x00c2d6a0,0x002cada2,0x005295b0,0x003f4977,0x00e44970,  // 1920
    0x004ca4b0,0x0036b4b5,0x005c6a50,0x00c66d40,0x002fab54,0x00562b60,0x00409570,0x00ac52f2,0x00504970,0x003a6566,  // 1930
    0x005ed4a0,0x00c8ea50,0x00336a95,0x00585ad0,0x00442b60,0x00af86e3,0x005292e0,0x003dc8d7,0x0062c950,0x00ccd4a0,  // 1940
    0x0035d8a6,0x005ab550,0x004656a0,0x00b1a5b4,0x005625d0,0x004092d0,0x002ad2b2,0x00d0a950,0x0038b557,0x005e6ca0,  // 1950
    0x0048b550,0x00b55355,0x00584da0,0x0042a5b0,0x002f4573,0x00d452b0,0x003ca9a8,0x0060e950,0x004c6aa0,0x00b6aea6,  // 1960
    0x005aab50,0x00464b60,0x0030aae4,0x00d6a570,0x00405260,0x0028f263,0x004ed950,0x00ba5b57,0x005e56a0,0x004896d0,  // 1970
    0x00344dd5,0x00da4ad0,0x0042a4d0,0x002cd4d4,0x0052d250,0x00bcd558,0x0060b540,0x004ab6a0,0x003795a6,0x00dc95b0,  // 1980
    0x004649b0,0x0030a974,0x0056a4b0,0x00c0b27a,0x00646a50,0x004e6d40,0x0038af46,0x00deab60,0x00489570,0x00344af5,  // 1990
    0x005a4970,0x00c464b0,0x002c74a3,0x0050ea50,0x003c6b58,0x00e25ac0,0x004aab60,0x003696d5,0x005c92e0,0x00c6c960,  // 2000
    0x002ed954,0x0054d4a0,0x003eda50,0x00aa7552,0x004e56a0,0x0038abb7,0x006025d0,0x00ca92d0,0x0032cab5,0x0058a950,  // 2010
    0x0042b4a0,0x00acbaa4,0x0050ad50,0x003c55d9,0x00624ba0,0x00cca5b0,0x00375176,0x005c52b0,0x0046a930,0x00b07954,  // 2020
    0x00546aa0,0x003ead50,0x002a5b52,0x00d04b60,0x0038a6e6,0x005ea4e0,0x0048d260,0x00b2ea65,0x0056d530,0x00425aa0,  // 2030
    0x002c76a3,0x00d296d0,0x003c4afb,0x00624ad0,0x004ca4d0,0x00b7d0b6,0x005ad250,0x0044d520,0x002edd45,0x00d4b5a0,  // 2040
    0x003e56d0,0x002a55b2,0x005049b0,0x00baa577,0x005ea4b0,0x0048aa50,0x0033b255,0x00d86d20,0x0040ada0,0x002d4b63,  // 2050
    0x00529370,0x00be49f8,0x00624970,0x004c64b0,0x003768a6,0x00daea50,0x00446aa0,0x002fa6c4,0x0054aae0,0x00c092e0,  // 2060
    0x0028d2e3,0x004ec960,0x0038d557,0x00ded4a0,0x0046d850,0x00325d55,0x005856a0,0x00c2a6d0,0x002c55d4,0x005252d0,  // 2070
    0x003ca9b8,0x00e2a950,0x004ab4a0,0x0034b6a6,0x005aad50,0x00c655a0,0x002eaba4,0x0054a5b0,0x004052b0,0x00aab273,  // 2080
    0x004e6930,0x00387337,0x005e6aa0,0x00c8ad50,0x00334b55,0x00584b60,0x0042a570,0x00ae54e4,0x0050d160,0x003ae968,  // 2090
    0x0060d520,0x00cadaa0,0x00356aa6,0x005a56d0,0x00464ae0,0x00b0a9d4,0x0054a2d0,0x003ed150,0x0028f252,0x004ed520,  // 2100
};

static int solarMonthOffsetCommon[] = {0,31,59,90,120,151,181,212,243,273,304,334,365};
static int solarDaysOffsetCommon[] = {0,31,28,31,30,31,30,31,31,30,31,30,31};

static int solarMonthOffsetLeap[] = {0,31,60,91,121,152,182,213,244,274,305,335,366};
static int solarDaysOffsetLeap[] = {0,31,29,31,30,31,30,31,31,30,31,30,31};

+ (void)initialize {
    [self resetDateOf19000131];
}

+ (NSDate *)date19000131 {
    return _date19000131;
}

+ (void)resetDateOf19000131 {
    
    if (gregorianCalendar) {
        [gregorianCalendar release];
        gregorianCalendar = nil;
    }
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorianCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *now = [[NSDate date] getDatePart];
    
    NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay | NSCalendarUnitHour               | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    
    [components setYear:1900];
    [components setMonth:1];
    [components setDay:31];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    
    if (_date19000131) {
        [_date19000131 release];
        _date19000131 = nil;
    }
    
    _date19000131 = [[gregorianCalendar dateFromComponents:components] retain];
}

//======   传回农历   y年的总天数
+ (int)yearDays:(int)year {
    if (year>2099 || year<1900)
        return 0;
    int i, sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1) {
        if ((lunarItems[year - 1900] & i) != 0)
            sum += 1;
    }
    return (sum + [self leapDays:year]);
}

//======   传回农历   y年闰月的天数
+(int)leapDays:(int)year {
    if (year>2099 || year<1900)
        return 0;
    if ([self leapMonth:year] != 0) {
        if ((lunarItems[year - 1900] & 0x10000) != 0)
            return 30;
        else
            return 29;
    }
    return 0;
}

//======   传回农历   y年闰哪个月   1-12   ,   没闰传回   0
+(int)leapMonth:(int)year {
    if (year>2099 || year<1900)
        return 0;
    return (int) (lunarItems[year - 1900] & 0xf);
}

/**
 * 传入农历年月(1-12)，返回该月的总天数
 * Date: 2012-8-19下午5:19:30
 */
+(int)daysOfYear:(int)y inMonth:(int)m {
    if (y>2099 || y<1900)
        return 30;
    if ((lunarItems[y - 1900] & (0x10000 >> m)) == 0)
        return 29;
    else
        return 30;
}

+(int)daysOfYear:(int)y inMonth:(int)m leap:(BOOL *)leap {
    if (y>2099 || y<1900)
        return 30;
    if (*leap) {
        if ([self leapMonth:y] == m) {
            *leap = YES;
        }
        else {
            *leap = NO;
        }
        
        if (*leap) {
            return (((lunarItems[y - 1900] & 0x10000) == 0) ? 29 : 30);
        }
    }
    
    if ((lunarItems[y - 1900] & (0x10000 >> m)) == 0)
        return 29;
    else
        return 30;
}

+ (BOOL)isSolarYearLeap:(int)year {
    return (((year % 4 == 0) && (year % 100 != 0)) || year % 400 == 0);
}
/**
 *
 *   传出y年m月d日对应的农历.
 *   yearCyl3:农历年与1864的相差数                             ?
 *   monCyl4:从1900年1月31日以来,闰月数
 *   dayCyl5:与1900年1月31日相差的天数,再加40             ?
 *   @param   cal
 *   @return
 */
- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithSolarDate:(NSDate *)date {
    if (self = [super init]) {
        [self setSolarDate:date];
    }
    return self;
}

- (id)initWithYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap {
    if (self = [super init]) {
        BOOL l = leap;
        _solarDate = [[self calculateSolarDateWithLunarYear:year month:month day:day leap:l] retain];
        
        NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:_solarDate];
        
        [components setHour:14];
        [components setMinute:0];
        [components setSecond:0];
        
        NSDate *refSolarDate = [gregorianCalendar dateFromComponents:components];
        
        int offset = (int)( ([refSolarDate timeIntervalSinceDate:[LunarDate date19000131]]) / 86400L);
        _offset = offset;
        
        _year = year;
        _month = month;
        _day = day;
        _leap = l;
    }
    return self;
}

+ (LunarDate *)lunarDateWithYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap {
    return [[[LunarDate alloc] initWithYear:year month:month day:day leap:leap] autorelease];
}

/**
 ------ 农历转公历 -----
 year ： 传入转换的年
 month ： 传入转换的月
 day  ： 传入转换的日
 leap ： 是否为闰月
 
 Offset ＝ （农历正月初一 与 公历元旦相差的天数 + 需要转换的日期到正月初一的天数）＝ 从公历元旦开始所度过的天数
 Offset 依次循环减去公历每个月的日期，即可获得公历的日期
 
 **/
- (NSDate *)calculateSolarDateWithLunarYear:(int)year month:(int)month day:(int)day leap:(BOOL &)leap {
    if (year < 1900) {
        return nil;
    }
    else if (year > 2099) {
        return nil;
    }
    LunarItem *item = (LunarItem *)(lunarItems + year - 1900);
    int sYear = year;
    int sMonth = month;
    int sDay = day;
    int mCount = 1;
    int lunarAllDate = 0;
    int offset = item->detail.offset; // 相差的天数
    int leapMonth = item->detail.leapMonth; //闰哪个月
    
    for (int iMonth = 1; iMonth < month; iMonth ++) {
        int daysOfMonth = [LunarDate daysOfYear:year inMonth:iMonth];
        if (iMonth == leapMonth) {
            lunarAllDate =  daysOfMonth + [LunarDate leapDays:year];
        }
        offset += iMonth == leapMonth ? lunarAllDate : daysOfMonth;
    }
    
    if (leap) {  // 如果是闰月需要添加一个月
        offset +=[LunarDate daysOfYear:year inMonth:month];
    }
    
    offset += day;
    BOOL isSolarYearLeap = item->detail.leap;
    int *solarDaysAry = isSolarYearLeap ? solarDaysOffsetLeap: solarDaysOffsetCommon;
    for (int iMonth = 1; iMonth < 13; iMonth ++) {
        int solarDaysm = solarDaysAry[iMonth];
        if (offset > solarDaysm) {
            offset -= solarDaysm;
            mCount ++;
        }else{
            sYear = year;
            sMonth = mCount;
            sDay = offset;
            break;
        }
        if (mCount > 12) {
            sYear = year + 1;
            sMonth = mCount - 12;
            sDay = offset;
        }
    }
    
    NSDateComponents *comp = [gregorianCalendar components:(NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay) fromDate:[LunarDate date19000131]];
    
    [comp setDay:sDay];
    [comp setMonth:sMonth];
    [comp setYear:sYear];
    [comp setHour:12];
    [comp setMinute:0];
    [comp setSecond:0];
    
    return [gregorianCalendar dateFromComponents:comp];
}

- (void)setSolarDate:(NSDate *)date {
    if (_solarDate) {
        [_solarDate release];
        _solarDate = nil;
    }
    _solarDate = [date retain];
    
    [self calculateLunarYear:_year Month:_month Day:_day Leap:_leap];
}

/**
 ---------公历转农历---------
 
 year ： 传入转换的年
 month ： 传入转换的月
 day  ： 传入转换的日
 leap ： 是否为闰月
 
 mOffset = 公历元旦到当前转换日期所经过的天数
 dOffset = （mOffset - 公历元旦和农历正月初一相差天数）
 如果 dOffset 大于 0  说明公历和农历日期在同一年，如果 dOffset 小于 0 说明公历和农历日期不在同一年
 大于 0  的情况需要依次减去农历每月天数即可农历日期
 小于 0  的情况说明农历是上一年，需要 加 上一年一整年天数 减 上一年公历元旦和农历正月初一相差天数，依次减去农历每月天数即可农历日期
 
 */
-(void)calculateLunarYear:(int &)year Month:(int &)month Day:(int &)day Leap:(BOOL &)leap {
    DateInformation dateInfo = [_solarDate dateInformation];
    LunarItem *item = (LunarItem *)(lunarItems + dateInfo.year - 1900);
    int offset = item->detail.offset;   // 元旦和正月初一相差天数
    BOOL isSolarYearLeap = item->detail.leap;
    int mOffset = (isSolarYearLeap ? solarMonthOffsetLeap[dateInfo.month -1] : solarMonthOffsetCommon[dateInfo.month -1] )+ dateInfo.day;
    int dOffset = mOffset - offset;
    if (dOffset > 0) {
        year = dateInfo.year;
        [self calculateLunarLoopCutWithOffset:dOffset Year:year Month:month Day:day Leap:leap];
    }else{  // 公历和农历年份不是一年
        year = dateInfo.year - 1;
        LunarItem *item = (LunarItem *)(lunarItems + year - 1900);
        BOOL isSolarYearLeap = item->detail.leap;
        int daysOfYear = isSolarYearLeap ? solarMonthOffsetLeap[12]  : solarMonthOffsetCommon[12];
        int offset = item->detail.offset;
        dOffset = mOffset - offset + daysOfYear;
        [self calculateLunarLoopCutWithOffset:dOffset Year:year Month:month Day:day Leap:leap];
    }
}

-(void)calculateLunarLoopCutWithOffset:(int) mOffset Year:(int &)year Month:(int &)month Day:(int &)day Leap:(BOOL &)leap {
    LunarItem *item = (LunarItem *)(lunarItems + year - 1900);
    int leapMonth,daysOfMonth,lunarAllDate = 0;
    leapMonth = item->detail.leapMonth; //闰哪个月,1-12
    int mCount = 1;
    leap = false;
    for (int iMonth = 1; iMonth < 13; iMonth ++) {
        BOOL same = iMonth == leapMonth; // 正好是闰月
        daysOfMonth = [LunarDate daysOfYear:year inMonth:iMonth];
        if (same)
            lunarAllDate =  daysOfMonth + [LunarDate leapDays:year];// 取出闰月日期
        if (same && mOffset > lunarAllDate) { // 大于两个月的日期，说明在闰月的下一个月
            mOffset -= lunarAllDate;
            mCount ++;
        }else if (mOffset > daysOfMonth) { // 总和大于下月日期，减去
            mOffset -= daysOfMonth;
            if (same){   // 减去一个月正好在闰月上
                leap = true;
                month = iMonth;
                day = mOffset;
                break;
            }else{
                mCount ++;
                leap = false;
            }
        }else{
            month = mCount;
            day = mOffset;
            break;
        }
    }
    
}


+ (LunarDate *)lunarDateWithSolarDate:(NSDate *)date {
    return [[[LunarDate alloc] initWithSolarDate:date] autorelease];
}


- (NSString *)getLunarDayDisplay {
    if(self.day < 0){
        return @"零零";
    }
    else if (self.day > 31) {
        return @"零零";
    }
    return [IGCNLC_DAY_STR objectAtIndex:self.day];
}

- (NSString *)getLunarMonthDisplay {
    int lmonth = self.month;
    if(lmonth <= 0){
        return @"零零";
    }
    else if (lmonth > 12) {
        return @"零零";
    }
    
    BOOL isLeap = self.leap;
    NSString *s = [NSString stringWithString:[IGCNLC_MONTH_STR objectAtIndex:lmonth-1]];
    if (isLeap) s = [@"闰" stringByAppendingString: s];
    return s;
}

+ (NSString *)getLunarDayDisplay:(int)day {
    if(day < 0){
        return @"零零";
    }
    else if (day > 31) {
        return @"零零";
    }
    return [IGCNLC_DAY_STR objectAtIndex:day];
}

+ (NSString *)getLunarMonthDisplay:(int)month isLeap:(BOOL)isLeap {
    NSString *s = [NSString stringWithFormat:@"%@月", [IGCNLC_MONTH_STR objectAtIndex:month-1]];
    if (isLeap) s = [@"闰" stringByAppendingString: s];
    return s;
}

//农历年份显示
- (NSString *)getLunarYearDisplay;
{
    return [LunarDate getLunarYearDisplay:self.year];
}

+ (NSString *)getLunarYearDisplay:(int)year;
{
    int num = year;
    int tmp = num / 1000;
    num = num - tmp * 1000;
    NSString* q = [LunarDate changeNumberToChina:tmp];
    
    tmp = num / 100;
    num = num - tmp * 100;
    NSString* b = [LunarDate changeNumberToChina:tmp];
    
    tmp = num / 10;
    num = num - tmp * 10;
    NSString* s = [LunarDate changeNumberToChina:tmp];
    
    NSString* g = [LunarDate changeNumberToChina:num];
    
    return  [NSString stringWithFormat:@"%@%@%@%@",q,b,s,g];
}

+ (NSString *)changeNumberToChina:(int)number;
{
    NSArray *IGCNLC_YEAR_STR = [NSArray arrayWithObjects:
                                @"零",@"一",@"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", nil];
    NSString* tmp = [IGCNLC_YEAR_STR objectAtIndex:number];
    return tmp;
}

- (NSString *)chineseAraYearString {
    return [LunarDate chineseAraYearStringWithDate:self.solarDate];
}

- (NSString *)chineseAraMonthString {
    CLGregorianDate gDate = [self.solarDate getGregorianDate];
    return [LunarDate chineseAraMonthStringWithYear:gDate.year month:gDate.month day:gDate.day];
}

- (NSString *)chineseAraDayString {
    CLGregorianDate gDate = [self.solarDate getGregorianDate];
    return [LunarDate chineseAraDayStringWithYear:gDate.year month:gDate.month day:gDate.day];
}

+ (NSString *)chineseAraYearStringWithDate:(NSDate *)sDate {
    CLGregorianDate sDateInfo = [sDate getGregorianDate];
    CLGregorianDate newDateInfo = {sDateInfo.year, 2, static_cast<SInt8>([SolarTerm getDayForTerm:sDateInfo.year indexAtTermArray:2]), 0,0,0};
    NSDate *newDate = [NSDate dateFromCFGregorianDate:newDateInfo];
    
    long timecompare = [sDate timeIntervalSinceDate:newDate];
    int num;
    if (timecompare >= 0) num = sDateInfo.year - 1900 + 36;
    else num = sDateInfo.year - 1900 + 36 - 1;
    NSArray *IGCNLC_GAN = [NSArray arrayWithObjects:
                           @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸", nil];
    NSArray *IGCNLC_ZHI = [NSArray arrayWithObjects:
                           @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥", nil];
    
    return [NSString stringWithFormat:@"%@%@", [IGCNLC_GAN objectAtIndex:num%10], [IGCNLC_ZHI objectAtIndex:num%12]];
}

+ (NSString *)chineseAraMonthStringWithYear:(int)syear month:(int)smonth day:(int)sday{
    NSArray *IGCNLC_GAN = [NSArray arrayWithObjects:
                           @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸", nil];
    NSArray *IGCNLC_ZHI = [NSArray arrayWithObjects:
                           @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥", nil];
    
    int firstNode = (int)[SolarTerm getDayForTerm:syear indexAtTermArray:(smonth-1)*2];
    int num;
    if (sday >= firstNode) num = (syear - 1900) * 12 + smonth + 12;
    else num = (syear - 1900) * 12 + smonth + 11;
    
    return [NSString stringWithFormat:@"%@%@月", [IGCNLC_GAN objectAtIndex:(num % 10)], [IGCNLC_ZHI objectAtIndex:(num % 12)]];
}

+ (NSString *)chineseAraDayStringWithYear:(int)syear month:(int)smonth day:(int)sday {
    int dyear = syear;
    int dmonth = smonth;
    int dday = sday;
    if (dmonth == 1 || dmonth == 2) {
        dyear --;
        dmonth += 12;
    }
    
    int C = dyear / 100;
    int y = dyear % 100;
    int i;
    if (dmonth % 2 == 0) i = 6;
    else i = 0;
    int G = (4 * C + C / 4 + 5 * y + y / 4 + 3 * (dmonth + 1) / 5 + dday - 3) % 10;
    int Z = (8 * C + C / 4 + 5 * y + y / 4 + 3 * (dmonth + 1) / 5 + dday + 7 - i) % 12;
    
    return [NSString stringWithFormat:@"%@%@日", [IGCNLC_GAN objectAtIndex:G], [IGCNLC_ZHI objectAtIndex:Z]];
}

- (NSString *)getLunarMonthDayString {
    NSString *lmonth = [self getLunarMonthDisplay];
    NSString *lday = [self getLunarDayDisplay];
    return [NSString stringWithFormat:@"%@月%@", lmonth, lday];
}

+ (NSString *)getLunarDisplayWithMonth:(int)month day:(int)day {
    NSString *lmonth = [LunarDate getLunarMonthDisplay:month isLeap:NO];
    NSString *lday = [LunarDate getLunarDayDisplay:day];
    
    return [NSString stringWithFormat:@"%@%@", lmonth, lday];
}

- (NSString *)getLunarHoliday{
    int lmonth = self.month;
    int ldate  = self.day;
    //阴历有6个节假日
    for (int i = 0; i < 6; i++) {
        if (lmonth == (int)(IGCNLC_LUNAR_HOLIDAY_INFO[i] / 100) && ldate == IGCNLC_LUNAR_HOLIDAY_INFO[i] % 100) {
            NSArray *IGCNLC_LUNAR_HOLIDAY = [NSArray arrayWithObjects:
                                             @"春节", @"元宵", @"端午", @"七夕", @"中秋", @"重阳", nil];
            
            return [IGCNLC_LUNAR_HOLIDAY objectAtIndex: i];
        }
    }
    return @"";
}

- (NSString *)zodiacAnimalSignChinese {
    int animal = [self zodiacAnimal];
    NSArray *zodiacAnimal = [NSArray arrayWithObjects:@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪", nil];
    return [zodiacAnimal objectAtIndex:animal];
}

- (NSString *)zodiacAnimalSign {
    int animal = [self zodiacAnimal];
    return [zodiacAnimalNames objectAtIndex:animal];
}

- (int)zodiacAnimal {
    // year here is solar year.
    NSDate *solarDate = [self solarDate];
    CLGregorianDate gDate = [solarDate getGregorianDate];
    
    CLGregorianDate springGDate = {gDate.year, 2, static_cast<SInt8>([SolarTerm getDayForTerm:gDate.year indexAtTermArray:2]), 0, 0, 0};
    NSDate *springDate = [NSDate dateFromCFGregorianDate:springGDate];
    
    int num = 0;
    if ([solarDate compare:springDate] != NSOrderedAscending) {
        num = gDate.year - 1900 + 36;
    }
    else {
        num = gDate.year - 1 - 1900 + 36;
    }
    return num % 12;
}

- (NSString*)lunarDateDescription {
    NSDate *solarDate = [self solarDate];
    CLGregorianDate gDate = [solarDate getGregorianDate];
    return [NSString stringWithFormat:@"%@[%@年]%@%@", [LunarDate chineseAraYearStringWithDate:solarDate], [self zodiacAnimalSignChinese],
            [LunarDate chineseAraMonthStringWithYear:gDate.year month:gDate.month day:gDate.day],
            [LunarDate chineseAraDayStringWithYear:gDate.year month:gDate.month day:gDate.day]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%04d-%02d-%02d", self.year, self.month, self.day];
}

+ (NSString *)chineseNumberWithNumber:(int)n {
    return chineseNumber[n - 1];
}

+ (NSDictionary *)getHelperDisplayForDate:(NSDate *)date {
    date = [[date getDatePart] dateByAddingTimeInterval:12 * 60 * 60];
    CLGregorianDate gDate = [date getGregorianDate];
    
    // 农历节日
    LunarDate *lDate = [LunarDate lunarDateWithSolarDate:date];
    NSString *lunarFestival = [SolarLunarFestival getLunarFestival:lDate];
    if (![lunarFestival isEqualToString:@""]) {
        return @{@"v":lunarFestival, @"s":@1};
    }
    
    // 公历节日
    NSString *solarFestival = [SolarLunarFestival getSolarFestival:gDate];
    if (![solarFestival isEqualToString:@""]) {
        return @{@"v":solarFestival, @"s":@1};
    }
    
    // 节气
    NSString *termStr = [SolarTerm getSolarTermWithGregorianDate:gDate];
    if (![termStr isEqualToString:@""]){
        return @{@"v":termStr, @"s":@1};
    }
    
    // 三伏三九
    if (gDate.month == 6 || gDate.month == 7 || gDate.month == 8) {
        NSString *summerDays = [SolarTerm get3fWithYear:gDate.year month:gDate.month day:gDate.day];
        
        if (summerDays && [summerDays length] > 0) {
            return @{@"v":summerDays, @"s":@1};
        }
    } else if (gDate.month == 12 || gDate.month == 1 || gDate.month == 2 || gDate.month == 3) {
        NSString *winterDays = [SolarTerm get39WithYear:gDate.year month:gDate.month day:gDate.day];
        
        if (winterDays && [winterDays length] > 0) {
            return @{@"v":winterDays, @"s":@1};
        }
    }
    
    // 农历日期
    NSString *lunarStr = nil;
    if (lDate.day == 1) {
        lunarStr = [NSString stringWithFormat:@"%@月", [lDate getLunarMonthDisplay]];
    } else {
        lunarStr = [lDate getLunarDayDisplay];
    }
    if (![lunarStr isEqualToString:@""]) {
        return @{@"v":lunarStr, @"s":@0};
    }
    return nil;
}

- (void)setYear:(int)year month:(int)month day:(int)day leap:(BOOL)leap {
    _solarDate = [[self calculateSolarDateWithLunarYear:year month:month day:day leap:leap] retain];
    
    NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:_solarDate];
    
    [components setHour:14];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *refSolarDate = [gregorianCalendar dateFromComponents:components];
    
    int offset = (int)( ([refSolarDate timeIntervalSinceDate:[LunarDate date19000131]]) / 86400L);
    _offset = offset;
    
    _year = year;
    _month = month;
    _day = day;
    _leap = leap;
}

- (void)setYear:(int)year {
    [self setYear:year month:self.month day:self.day leap:self.leap];
}

- (void)setMonth:(int)month {
    [self setYear:self.year month:month day:self.day leap:self.leap];
}

- (void)setDay:(int)day {
    [self setYear:self.year month:self.month day:day leap:self.leap];
}

- (void)setLeap:(BOOL)leap {
    [self setYear:self.year month:self.month day:self.day leap:leap];
}

@end
