//
//  SolarTermExceptionUpdater.h
//  CalendarLib
//
//  Created by yepin wang on 12-6-1.
//  Copyright (c) 2012年 365rili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SolarTermExceptionUpdater : NSObject
+ (NSDictionary*)loadExceptionDictionary;
+ (void)updateSolarTermException;
+ (BOOL)isExceptionExists;
+ (int)amendmentDayOfTerm:(int)term inYear:(int)year originalDay:(int)day;
@end
