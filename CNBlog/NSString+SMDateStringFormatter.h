//
//  NSString+SMDateStringFormatter.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/9.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SMDateStringFormatterTypeUTC,
    SMDateStringFormatterTypeNormal
} SMDateStringFormatterType;

@interface NSString (SMDateStringFormatter)

/**
 *  从日期或字符串转字符串
 */
+ (NSString *)sm_stringFromUTCDate:(NSDate *)utcDate;

+ (NSString *)sm_stringFromUTCString:(NSString *)utcString;
- (NSString *)sm_stringFromUTCString;

+ (NSString *)sm_stringFromNormalDate:(NSDate *)date;

/**
 *  从字符串或日期转日期
 */
+ (NSDate *)sm_dateFromUTCDate:(NSDate *)utcDate;

+ (NSDate *)sm_dateFromUTCString:(NSString *)utcString;
- (NSDate *)sm_dateFromUTCString;

+ (NSDate *)sm_dateFromNormalString:(NSString *)string;
- (NSDate *)sm_dateFromNormalString;

/**
 *  日期转字符串
 *
 *  @param date 日期
 *  @param type 日期格式类型
 *
 *  @return 字符串
 */
+ (NSString *)sm_stringFromDate:(NSDate *)date formatterType:(SMDateStringFormatterType)type;

/**
 *  字符串转日期
 *
 *  @param string 字符串
 *  @param type   字符串格式类型
 *
 *  @return 日期
 */
+ (NSDate *)sm_dateFromString:(NSString *)string formatterType:(SMDateStringFormatterType)type;

/**
 *  日期转字符串
 *
 *  @param date 日期
 *  @param type 日期格式
 *
 *  @return 字符串
 */
+ (NSString *)sm_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 *  字符串转日期
 *
 *  @param string 字符串
 *  @param type   字符串格式
 *
 *  @return 日期
 */
+ (NSDate *)sm_dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

/**
 *  两个日期相差时间
 */
+ (NSString *)sm_timeBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 formatterType:(SMDateStringFormatterType)type;
+ (NSString *)sm_timeBetweenDateStr:(NSString *)str1 andDateStr:(NSString *)str2 formatterType:(SMDateStringFormatterType)type;

@end
