//
//  ChartCommonUtil.h
//  ChartLibraryDemo
//
//  Created by william on 22/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FmtType) {
    FmtTypeTime,
    FmtTypeHrMin,
    FmtTypeDate,
    FmtTypeMthDay,
    FmtTypeDay,
    FmtTypeDateMth,
    FmtTypeYearMth,
    FmtTypeDateWithTime,
    FmtTypeDateWithTimeNoSec,
    FmtTypeSmallChartDay,
    FmtTypeSmallChart5Day,
    FmtTypeSmallChart3Month,
    FmtTypeSmallChart1Year,
    FmtTypeSmallChart5Year,
};

@interface ChartCommonUtil : NSObject

+ (ChartCommonUtil *)instance;

+ (BOOL)isUSStock:(NSString *)code;
+ (BOOL)isUSPreMarket:(NSDate *)date;
+ (BOOL)isUSPostMarket:(NSDate *)date;

+ (NSString *)convertDate:(FmtType)type Value:(NSDate *)value;
+ (NSString *)convertDate:(FmtType)type Value:(NSDate *)value Timezone:(NSTimeZone *)timezone WithSign:(BOOL)bSign ;
+ (NSString *)formatFloatValue:(CGFloat)value byFormat:(NSString *)format groupKMB:(bool)groupKMB;
+ (NSDate *)convertDateFromyyyyMMddHHmm:(NSString *)dateStr timezone:(NSTimeZone *)timezone;

@end

NS_ASSUME_NONNULL_END
