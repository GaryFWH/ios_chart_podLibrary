//
//  ChartCommonUtil.m
//  ChartLibraryDemo
//
//  Created by william on 22/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartCommonUtil.h"

static ChartCommonUtil *instance = nil;

@implementation ChartCommonUtil

+ (ChartCommonUtil *)instance {
    if (instance != nil) {
        return instance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[ChartCommonUtil alloc] init];
    });
    
    return instance;
}
+ (BOOL)isUSStock:(NSString *)code {
    BOOL rValue = NO;
    
    if (code && [code length] > 3 && [[code substringToIndex:3] isEqualToString:@"US."]) {
        rValue = YES;
    }
    return rValue;
}
+ (BOOL)isUSPreMarket:(NSDate *)date {
    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"] fromDate:date];
    NSInteger hhmm = components.hour * 100 + components.minute;
    if (hhmm > 400 && hhmm <= 930){
        return YES;
    }
    return NO;
}
+ (BOOL)isUSPostMarket:(NSDate *)date {
    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"] fromDate:date];
    NSInteger hhmm = components.hour * 100 + components.minute;
    if (hhmm > 1600 && hhmm <= 2000){
        return YES;
    }
    return NO;
}

+ (NSString*)convertDate:(FmtType)type Value:(NSDate *)value {
    return [self convertDate:type Value:value Timezone:[NSTimeZone systemTimeZone] WithSign:NO];
}

+ (NSString*)convertDate:(FmtType)type Value:(NSDate *)value Timezone:(NSTimeZone *)timezone WithSign:(BOOL)bSign {
    if (!value) {
        return @"";
    }
    if (!timezone) {
        timezone = [NSTimeZone systemTimeZone];
    }
    
    NSString *rValue = nil;
    
    NSDateFormatter * formatter = [NSDateFormatter alloc];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [formatter setTimeZone:timezone];
    NSString *dateFormat;
       
    switch (type) {
        case FmtTypeTime: {
            dateFormat = @"HH:mm:ss";
        } break;
        case FmtTypeHrMin: {
            dateFormat = @"HH:mm";
        } break;
        case FmtTypeDate: {
            dateFormat = @"yyyy/MM/dd ";
        } break;
        case FmtTypeMthDay: {
            dateFormat = @"MM/dd";
        } break;
        case FmtTypeDay: {
            dateFormat = @"dd";
        } break;
        case FmtTypeDateMth: {
            dateFormat = @"dd/MM";
        } break;
        case FmtTypeYearMth: {
            dateFormat = (bSign) ? @"yyyy/MM" : @"yyyy/MM";
        } break;
        case FmtTypeDateWithTime: {
            dateFormat = @"yyyy/MM/dd HH:mm:ss";
        } break;
        case FmtTypeDateWithTimeNoSec: {
            dateFormat = (bSign) ? @"yyyy/MM/dd HH:mm" : @"yyyyMMddHHmm";
        } break;
        default: {
            dateFormat = (bSign) ? @"yyyy/MM/dd" : @"yyyyMMdd";
        }
    }
    [formatter setDateFormat:dateFormat];
    rValue = [formatter stringFromDate:value];
    
    return rValue ? rValue : @"";
}

+ (NSString *)formatFloatValue:(CGFloat)value byFormat:(NSString *)format groupKMB:(bool)groupKMB {
    NSString * unit = @"";
    CGFloat displayValue = value;
    if (groupKMB){
        if (fabs(value) >= 1000000000) {
            displayValue = value / 1000000000;
            unit = @"B";
        }
        else if (fabs(value) >= 1000000) {
            displayValue = value / 1000000;
            unit = @"M";
        }
        else if (fabs(value) >= 1000) {
            displayValue = value / 1000;
            unit = @"K";
        }
        else {
            displayValue = value;
        }
    }
    if (![unit isEqualToString:@""]){
        format = @"0.000";
    }
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setPositiveFormat:format];
    NSNumber * number = [NSNumber numberWithDouble:displayValue];
    return [[formatter stringFromNumber:number] stringByAppendingString:unit];
}

+ (NSDate *)convertDateFromyyyyMMddHHmm:(NSString *)dateStr timezone:(NSTimeZone *)timezone{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setTimeZone:timezone];
    [objDateformat setDateFormat:@"yyyyMMddHHmm"];
    [objDateformat setLocale:[NSLocale systemLocale]];
    NSDate * date = [objDateformat dateFromString:dateStr];
    return date;
}

@end
