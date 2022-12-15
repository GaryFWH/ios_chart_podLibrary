//
//  OpenClosePrePostModel.m
//  ChartLibraryDemo
//
//  Created by william on 11/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "OpenClosePrePostModel.h"

@implementation OpenClosePrePostModel

+ (OpenClosePrePostModel *)usMarketOC {
//    OpenClosePrePostModel * open
    static OpenClosePrePostModel * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OpenClosePrePostModel alloc] initWithString:@"US,DEFAULT,930,,,,1600,"];
        [sharedInstance setPreOpen:@"400" preClose:@"930" postOpen:@"1600" postClose:@"2000"];
        sharedInstance.timezone = [NSTimeZone timeZoneWithName:@"America/New_York"];
        sharedInstance.extraClose = YES;
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setPreOpen:(NSString *)preOpen preClose:(NSString *)preClose postOpen:(NSString *)postOpen postClose:(NSString *)postClose {
    PRE_OPEN = -1;
    PRE_CLOSE = -1;
    POST_OPEN = -1;
    POST_CLOSE = -1;
    
    if (preOpen && ![preOpen isEqualToString:@""]){
        PRE_OPEN = [preOpen intValue];
    }
    if (preClose && ![preClose isEqualToString:@""]){
        PRE_CLOSE = [preClose intValue];
    }
    if (postOpen && ![postOpen isEqualToString:@""]){
        POST_OPEN = [postOpen intValue];
    }
    if (postClose && ![postClose isEqualToString:@""]){
        POST_CLOSE = [postClose intValue];
    }
}

- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval session:(ChartSessionType)session {
    if (dataInterval == ChartDataIntervalDay || dataInterval == ChartDataIntervalWeek || dataInterval == ChartDataIntervalMonth){
        return formatedDate;
    }
    if ([formatedDate length] == 12 ){
        NSString * timeonly = [formatedDate substringFromIndex:8];
        int groupingTime = 0;
        int time = [timeonly intValue];
//        if (session == ChartSessionTypeCore){
//            return [super groupingKeyForyyyyMMddHHmm:formatedDate forInterval:dataInterval];
//        } else {
            if (PRE_OPEN > 0 && PRE_CLOSE > 0){
                if (session == ChartSessionTypePre){
                    return [self groupingKeyForPreyyyyMMddHHmm:formatedDate forInterval:dataInterval];
                }else if (time >= PRE_OPEN && time < PRE_CLOSE){
                    if (session == ChartSessionTypeCombine){
                        return [self groupingKeyForPreyyyyMMddHHmm:formatedDate forInterval:dataInterval];
                    }
                }
            }
            if (POST_OPEN > 0 && POST_CLOSE > 0){
                if (session == ChartSessionTypePost){
                    return [self groupingKeyForPostyyyyMMddHHmm:formatedDate forInterval:dataInterval];
                } else if (time >= POST_OPEN && time < POST_CLOSE){
                    if (session == ChartSessionTypeCombine){
                        return [self groupingKeyForPostyyyyMMddHHmm:formatedDate forInterval:dataInterval];
                    }
                }
            }
//        NSLog(@"OCPPModel groupingKeyForyyyyMMddHHmm 02 - formatedDate %@ -> %@", formatedDate, [super groupingKeyForyyyyMMddHHmm:formatedDate forInterval:dataInterval session:session]);

        return [super groupingKeyForyyyyMMddHHmm:formatedDate forInterval:dataInterval session:session];
//        }
    }
//    NSLog(@"OCPPModel groupingKeyForyyyyMMddHHmm 02 - formatedDate %@", formatedDate);
    return formatedDate;
}


- (NSArray *)groupingKeyListForPreForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval {
    if ([date length] > 8){
        date = [date substringToIndex:8];
    }
    if (PRE_OPEN < 0 && PRE_CLOSE < 0){
        return @[];
    }
    NSString * startDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, PRE_OPEN / 100, PRE_OPEN % 100];
    NSString * endDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, PRE_CLOSE / 100, PRE_CLOSE % 100];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    [formatter setTimeZone:self.timezone];
    NSDate * refDate = [formatter dateFromString:startDateStr];
    NSDate * endDate = [formatter dateFromString:endDateStr];
    
    NSMutableArray * keyList = [NSMutableArray array];
    NSString * prevKey = @"";
    while ([refDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]){
//        NSLog(@"RefDate: %@", refDate);
        NSString * groupKey = [self groupingKeyForPreyyyyMMddHHmm:[formatter stringFromDate:refDate] forInterval:dataInterval];
//        NSLog(@"GroupKey: %@", groupKey);
        if (groupKey){
            if (![groupKey isEqualToString:prevKey]){
                [keyList addObject:groupKey];
            }
            prevKey = groupKey;
        }
        refDate = [refDate dateByAddingTimeInterval:60];
    }
    return keyList;
}

- (NSString *)groupingKeyForPreyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval {
    if (dataInterval == ChartDataIntervalDay || dataInterval == ChartDataIntervalWeek || dataInterval == ChartDataIntervalMonth){
        return formatedDate;
    }
    if ([formatedDate length] == 12 ){
        NSString * timeonly = [formatedDate substringFromIndex:8];
        int groupingTime = 0;
        int time = [timeonly intValue];
        int ihr = time / 100;
        int imin = time % 100;
        int chartType = 0;
        switch(dataInterval){
            case ChartDataInterval1Min:
                chartType = 1;
                break;
            case ChartDataInterval5Min:
                chartType = 5;
                break;
            case ChartDataInterval15Min:
                chartType = 15;
                break;
            case ChartDataInterval30Min:
                chartType = 30;
                break;
            case ChartDataInterval60Min:
                chartType = 60;
                break;
            default:
                break;
        }
        
        int tem = ceil((double)imin / (double)chartType);
        if (PRE_OPEN > 0 && time < PRE_OPEN){
            switch (chartType) {
                case 1:
                    groupingTime = PRE_OPEN;
                    break;
                default:
                    tem = ceil((double)PRE_OPEN / (double)chartType);
                    imin = (int) (tem * chartType);
                    groupingTime = imin;
                    break;
            }
        } else if (PRE_CLOSE > 0 && time >= PRE_CLOSE) {
            groupingTime = PRE_CLOSE;
        } else {
            switch (chartType) {
                case 1:
                    groupingTime = time;
                    break;
                default:
                    imin = (int) (tem * chartType);
                    if (imin >= 60) {
                        ihr++;
                        imin = 0;
                    }
                    groupingTime = ihr * 100 + imin;
                    
                    break;
            }
        }
        if (groupingTime % 100 >= 60) {
            groupingTime = ((groupingTime / 100) + 1) * 100;
        }
        if (PRE_CLOSE > 0 && groupingTime > PRE_CLOSE)
            groupingTime = PRE_CLOSE;
        
        if (groupingTime < 1000){
            return [NSString stringWithFormat:@"%@0%d", [formatedDate substringToIndex:8], groupingTime];
        }
        return [NSString stringWithFormat:@"%@%d", [formatedDate substringToIndex:8], groupingTime];
    } else {
        return formatedDate;
    }
}

- (CGFloat)percentageOfPreForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval {
    
    
    return 0.f;
}

- (NSArray *)groupingKeyListForPostForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval {
    if ([date length] > 8){
        date = [date substringToIndex:8];
    }
    if (POST_OPEN < 0 && POST_CLOSE < 0){
        return @[];
    }
    NSString * startDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, POST_OPEN / 100, POST_OPEN % 100];
    NSString * endDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, POST_CLOSE / 100, POST_CLOSE % 100];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    [formatter setTimeZone:self.timezone];
    NSDate * refDate = [formatter dateFromString:startDateStr];
    NSDate * endDate = [formatter dateFromString:endDateStr];
    
    NSMutableArray * keyList = [NSMutableArray array];
    NSString * prevKey = @"";
    while ([refDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]){
//        NSLog(@"RefDate: %@", refDate);
        NSString * groupKey = [self groupingKeyForPostyyyyMMddHHmm:[formatter stringFromDate:refDate] forInterval:dataInterval];
//        NSLog(@"GroupKey: %@", groupKey);
        if (groupKey){
            if (![groupKey isEqualToString:prevKey]){
                [keyList addObject:groupKey];
            }
            prevKey = groupKey;
        }
        refDate = [refDate dateByAddingTimeInterval:60];
    }
    return keyList;
}

- (NSString *)groupingKeyForPostyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval {
    if (dataInterval == ChartDataIntervalDay || dataInterval == ChartDataIntervalWeek || dataInterval == ChartDataIntervalMonth){
        return formatedDate;
    }
    if ([formatedDate length] == 12 ){
        NSString * timeonly = [formatedDate substringFromIndex:8];
        int groupingTime = 0;
        int time = [timeonly intValue];
        int ihr = time / 100;
        int imin = time % 100;
        int chartType = 0;
        switch(dataInterval){
            case ChartDataInterval1Min:
                chartType = 1;
                break;
            case ChartDataInterval5Min:
                chartType = 5;
                break;
            case ChartDataInterval15Min:
                chartType = 15;
                break;
            case ChartDataInterval30Min:
                chartType = 30;
                break;
            case ChartDataInterval60Min:
                chartType = 60;
                break;
            default:
                break;
        }
        
        int tem = ceil((double)imin / (double)chartType);
        if (POST_OPEN > 0 && time < POST_OPEN){
            switch (chartType) {
                case 1:
                    groupingTime = POST_OPEN;
                    break;
                default:
                    tem = ceil((double)POST_OPEN / (double)chartType);
                    imin = (int) (tem * chartType);
                    groupingTime = imin;
                    break;
            }
        } else if (POST_CLOSE > 0 && time >= POST_CLOSE) {
            groupingTime = POST_CLOSE;
        } else {
            switch (chartType) {
                case 1:
                    groupingTime = time;
                    break;
                default:
                    imin = (int) (tem * chartType);
                    if (imin >= 60) {
                        ihr++;
                        imin = 0;
                    }
                    groupingTime = ihr * 100 + imin;
                    
                    break;
            }
        }
        if (groupingTime % 100 >= 60) {
            groupingTime = ((groupingTime / 100) + 1) * 100;
        }
        if (POST_CLOSE > 0 && groupingTime > POST_CLOSE)
            groupingTime = POST_CLOSE;
        
        if (groupingTime < 1000){
            return [NSString stringWithFormat:@"%@0%d", [formatedDate substringToIndex:8], groupingTime];
        }
        return [NSString stringWithFormat:@"%@%d", [formatedDate substringToIndex:8], groupingTime];
    } else {
        return formatedDate;
    }
}

//- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval {
//    if (dataInterval == ChartDataIntervalDay || dataInterval == ChartDataIntervalWeek || dataInterval == ChartDataIntervalMonth){
//        return formatedDate;
//    }
//    if ([formatedDate length] == 12 ){
//        NSString * timeonly = [formatedDate substringFromIndex:8];
//        int groupingTime = 0;
//        int time = [timeonly intValue];
//        int ihr = time / 100;
//        int imin = time % 100;
//        int chartType = 0;
//        switch(dataInterval){
//            case ChartDataInterval1Min:
//                chartType = 1;
//                break;
//            case ChartDataInterval5Min:
//                chartType = 5;
//                break;
//            case ChartDataInterval15Min:
//                chartType = 15;
//                break;
//            case ChartDataInterval30Min:
//                chartType = 30;
//                break;
//            case ChartDataInterval60Min:
//                chartType = 60;
//                break;
//            default:
//                break;
//        }
//
//        int tem = ceil((double)imin / (double)chartType);
//
//    } else {
//        return formatedDate;
//    }
//}

- (ChartBackgroundColor*)getChartBGColor:(NSDate *)nowDate PrevDate:(NSDate *)prevDate forInterval:(ChartDataInterval)dataInterval ColorConfig:(ChartColorConfig*)colorConfig {
    
    if (!nowDate || !prevDate) {
        return nil;
    }
    
    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.timezone fromDate:nowDate];
    NSInteger minutesFromMN = components.hour * 60 + components.minute;
    NSDateComponents * prevComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.timezone fromDate:prevDate];
    NSInteger prevMinutesFromMN = prevComponents.hour * 60 + prevComponents.minute;
    
    NSInteger minutesPreOpen = PRE_OPEN / 100 * 60 + PRE_OPEN % 100;
    NSInteger minutesPreClose = PRE_CLOSE / 100 * 60 + PRE_CLOSE % 100;
    NSInteger minutesPostOpen = POST_OPEN / 100 * 60 + POST_OPEN % 100;
    NSInteger minutesPostClose = POST_CLOSE / 100 * 60 + POST_CLOSE % 100;
    
    bool isNowPre    = (minutesFromMN > minutesPreOpen) && (minutesFromMN <= minutesPreClose);
    bool isNowPost   = (minutesFromMN > minutesPostOpen) && (minutesFromMN <= minutesPostClose);
//    bool isNowTrade  = (minutesFromMN > minutesPreClose) && (minutesFromMN <= minutesPostOpen);

//    bool isPrevPre   = (prevMinutesFromMN > minutesPreOpen) && (prevMinutesFromMN <= minutesPreClose);
//    bool isPrevPost  = (prevMinutesFromMN > minutesPostOpen) && (prevMinutesFromMN <= minutesPostClose);
//    bool isPrevTrade = (prevMinutesFromMN > minutesPreClose) && (prevMinutesFromMN <= minutesPostOpen);

    NSInteger minutesFromInterval = 0;

    switch(dataInterval){
        case ChartDataInterval1Min:
            minutesFromInterval = 1;
            break;
        case ChartDataInterval5Min:
            minutesFromInterval = 5;
            break;
        case ChartDataInterval15Min:
            minutesFromInterval = 15;
            break;
        case ChartDataInterval30Min:
            minutesFromInterval = 30;
            break;
        case ChartDataInterval60Min:
            minutesFromInterval = 60;
            break;
        default:
            break;
    }
        
    UIColor *color = [UIColor clearColor];
    if (isNowPre || (prevMinutesFromMN <  minutesPreClose)) {
//        NSLog(@"Orange");
        color = colorConfig.sessionPreBGColor;
    } else if (isNowPost) {
//        NSLog(@"Blue");
        color = colorConfig.sessionPostBGColor;
    } else {
//        NSLog(@"Clear");
    }
    
    CGFloat ratio = [self getBGColorRatio:nowDate forInterval:dataInterval];
    ChartBackgroundColor * bgColor = [[ChartBackgroundColor alloc] initWithColor:color percentage:ratio];
    
//    NSLog(@"prevData %@ - nowData %@ , ratio %.2f", prevDate, nowDate, ratio);
    return bgColor;
}

- (CGFloat)getBGColorRatio:(NSDate *)date forInterval:(ChartDataInterval)dataInterval {
    if (!date) {
        return 0;
    }
    
    CGFloat rRatio = 100;
    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.timezone fromDate:date];
    NSInteger minutesFromMN = components.hour * 60 + components.minute;
    NSInteger minutesFromInterval = 0;
    
    NSInteger minutesPreOpen = PRE_OPEN / 100 * 60 + PRE_OPEN % 100;
    NSInteger minutesPreClose = PRE_CLOSE / 100 * 60 + PRE_CLOSE % 100;
    NSInteger minutesPostOpen = POST_OPEN / 100 * 60 + POST_OPEN % 100;
    NSInteger minutesPostClose = POST_CLOSE / 100 * 60 + POST_CLOSE % 100;
    
    BOOL isPre   = (minutesPreOpen <= minutesFromMN) && (minutesFromMN <= minutesPreClose);
    BOOL isTrade = (minutesPreClose <= minutesFromMN) && (minutesFromMN <= minutesPostOpen);
    BOOL isPost  = (minutesPostOpen <= minutesFromMN) && (minutesFromMN <= minutesPostClose);
    
    switch(dataInterval){
        case ChartDataInterval1Min:
            minutesFromInterval = 1;
            break;
        case ChartDataInterval5Min:
            minutesFromInterval = 5;
            break;
        case ChartDataInterval15Min:
            minutesFromInterval = 15;
            break;
        case ChartDataInterval30Min:
            minutesFromInterval = 30;
            break;
        case ChartDataInterval60Min:
            minutesFromInterval = 60;
            break;
        default:
            break;
    }
    NSInteger bgStart = minutesFromMN - minutesFromInterval;
    if (isPre) {
        if (bgStart < minutesPreOpen) {
            rRatio = 100 * (minutesFromMN - minutesPreOpen) / minutesFromInterval;
        } else {
            rRatio = 100;
        }
//        NSLog(@"Pre - HHmm:%ld:%ld, MM:%ld, ratio %.2f", components.hour, components.minute, minutesFromMN, rRatio);
    }
    else if (isTrade) {

        if (bgStart < minutesPreClose) {
            rRatio = 100 * (minutesFromMN - minutesPreClose) / minutesFromInterval;
        } else {
            rRatio = 100;
        }
//        NSLog(@"Trade - HHmm:%ld:%ld, MM:%ld, ratio %.2f", components.hour, components.minute, minutesFromMN, rRatio);
    }
    else if (isPost) {

        if (bgStart < minutesPostOpen) {
            rRatio = 100 * (minutesFromMN - minutesPostOpen) / minutesFromInterval;
        } else {
            rRatio = 100;
        }
//        NSLog(@"Post - HHmm:%ld:%ld, MM:%ld, ratio %.2f", components.hour, components.minute, minutesFromMN, rRatio);
    }
//    NSLog(@"HHmm:%ld:%ld, MM:%ld, ratio %.2f", components.hour, components.minute, minutesFromMN, rRatio);

    return rRatio;
}

@end
