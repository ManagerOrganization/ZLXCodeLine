//
//  NSString+Category.h
//  CalendarLib
//
//  Created by huangyi on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Ext)
- (NSString *)MD5;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
+ (NSString *)encodeBase64WithData:(NSData *)objData;

- (NSString *)firstLine;

- (NSString *)substringWithMaxLength:(int)maxLength;

@end
