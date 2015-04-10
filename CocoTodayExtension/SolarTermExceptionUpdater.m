//
//  SolarTermExceptionUpdater.m
//  CalendarLib
//
//  Created by yepin wang on 12-6-1.
//  Copyright (c) 2012年 365rili. All rights reserved.
//

#import "SolarTermExceptionUpdater.h"

@implementation SolarTermExceptionUpdater
static NSDictionary *exceptionDict = nil;
+ (NSDictionary*)loadExceptionDictionary {
    if ([SolarTermExceptionUpdater isExceptionExists] && ([[exceptionDict allKeys] count] == 0 || exceptionDict == nil)) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *exceptionFilePath = [NSString stringWithFormat:@"%@/SolarTermException.json", cacheDirectory];
        exceptionDict = [[NSDictionary dictionaryWithContentsOfFile:exceptionFilePath] retain];
    }
    return exceptionDict;
}

+ (void)updateSolarTermException {
    NSString *reqUrl = [NSString stringWithFormat:@"http://www.365rili.com/dl/android/solarterm/SolarTermException"];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (responseData && error == nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *exceptionFilePath = [NSString stringWithFormat:@"%@/SolarTermException.json", cacheDirectory];
        if ([[NSFileManager defaultManager] fileExistsAtPath:exceptionFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:exceptionFilePath error:nil];
        }
        [dict writeToFile:exceptionFilePath atomically:YES];
        if (exceptionDict) {
            [exceptionDict release];
        }
        exceptionDict = [dict retain];
    }
}

+ (BOOL)isExceptionExists {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *exceptionFilePath = [NSString stringWithFormat:@"%@/SolarTermException.json", cacheDirectory];
//    NSLog(@"exception Path:%@", exceptionFilePath);
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:exceptionFilePath];
    return result;
}

+ (int)amendmentDayOfTerm:(int)term inYear:(int)year originalDay:(int)day {
    if (exceptionDict == nil) {
        [SolarTermExceptionUpdater loadExceptionDictionary];
        if (exceptionDict == nil) {
            return day;
        }
    }
    int amendDay = day;
    NSDictionary *amendsInFixYear = [exceptionDict objectForKey:[NSString stringWithFormat:@"%d", year]];
    if (amendsInFixYear) {
        NSDictionary *amend = [amendsInFixYear objectForKey:[NSString stringWithFormat:@"%d", term/2 + 1]];
        if (amend) {
            NSNumber *amendOfDay = [amend objectForKey:[NSString stringWithFormat:@"%d", day]];
            if (amendOfDay) {
                amendDay = [amendOfDay intValue];
            }
        }
    }
    return amendDay;
}
@end
