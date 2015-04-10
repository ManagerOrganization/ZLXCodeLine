//
//  SolarLunarFestival.h
//  CalendarLib
//
//  Created by huangyi on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LunarDate.h"
#import "CLGregorianDate2.h"

@interface SolarLunarFestival : NSObject

+ (NSString *)getSolarFestival:(CLGregorianDate)date;

+ (NSString *)getSolarFestivalFullName:(CLGregorianDate)date;

+ (NSString *)getLunarFestival:(LunarDate *)date;

@end
