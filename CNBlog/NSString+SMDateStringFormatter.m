//
//  NSString+SMDateStringFormatter.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/9.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "NSString+SMDateStringFormatter.h"

@implementation NSString (SMDateStringFormatter)

// 字符串转日期
+ (NSDate *)sm_dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter dateFromString:string];
}

// 日期转字符串
+ (NSString *)sm_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSDate *)sm_dateFromString:(NSString *)string formatterType:(SMDateStringFormatterType)type {
    NSString *dateFormat = type == SMDateStringFormatterTypeNormal ? @"yyyy-MM-dd HH:mm:ss": @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [self sm_dateFromString:string dateFormat:dateFormat];
}

+ (NSString *)sm_stringFromDate:(NSDate *)date formatterType:(SMDateStringFormatterType)type {
    NSString *dateFormat = type == SMDateStringFormatterTypeNormal ? @"yyyy-MM-dd HH:mm:ss": @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [self sm_stringFromDate:date dateFormat:dateFormat];
}

+ (NSDate *)sm_dateFromNormalString:(NSString *)string {
    return [self sm_dateFromString:string formatterType:SMDateStringFormatterTypeNormal];
}

+ (NSDate *)sm_dateFromUTCString:(NSString *)utcString {
    return [self sm_dateFromString:utcString formatterType:SMDateStringFormatterTypeUTC];
}

+ (NSDate *)sm_dateFromUTCDate:(NSDate *)utcDate {
    NSString *string = [self sm_stringFromUTCDate:utcDate];
    return [self sm_dateFromNormalString:string];
}

+ (NSString *)sm_stringFromNormalDate:(NSDate *)date {
    return [self sm_stringFromDate:date formatterType:SMDateStringFormatterTypeNormal];
}

+ (NSString *)sm_stringFromUTCDate:(NSDate *)utcDate {
    return [self sm_stringFromDate:utcDate formatterType:SMDateStringFormatterTypeNormal];
}

+ (NSString *)sm_stringFromUTCString:(NSString *)utcString {
    NSDate *utcDate = [self sm_dateFromUTCString:utcString];
    return [self sm_stringFromUTCDate:utcDate];
}

- (NSString *)sm_stringFromUTCString {
    return [NSString sm_stringFromUTCString:self];
}

- (NSDate *)sm_dateFromUTCString {
    return [NSString sm_dateFromUTCString:self];
}

- (NSDate *)sm_dateFromNormalString {
    return [NSString sm_dateFromNormalString:self];
}

// 日期间隔时间
+ (NSString *)sm_timeBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 formatterType:(SMDateStringFormatterType)type {
    NSInteger betweenTime = fabs([date1 timeIntervalSinceDate:date2]);
    NSInteger betweenHour = betweenTime/60/60;
    if (betweenTime < 60) {
        return @"刚刚";
    }

    if (betweenHour < 1) {
        return [NSString stringWithFormat:@"%i分钟前", (int)(betweenTime/60)];
    }
    if (betweenHour < 24) {
        return [NSString stringWithFormat:@"%i小时前", (int)betweenHour];
    }
    if (betweenHour < 24*30) {
        return [NSString stringWithFormat:@"%i天前", (int)betweenHour/24];
    }
    return [self sm_stringFromDate:date1 formatterType:SMDateStringFormatterTypeNormal];
}

+ (NSString *)sm_timeBetweenDateStr:(NSString *)str1 andDateStr:(NSString *)str2 formatterType:(SMDateStringFormatterType)type {
    return [self sm_timeBetweenDate:[self sm_dateFromString:str1 formatterType:type] andDate:[self sm_dateFromString:str2 formatterType:type] formatterType:SMDateStringFormatterTypeNormal];
}

@end

