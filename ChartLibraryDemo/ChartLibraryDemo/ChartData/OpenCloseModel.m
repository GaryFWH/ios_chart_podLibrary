//
//  OpenCloseModel.m
//  ChartLibraryDemo
//
//  Created by william on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "OpenCloseModel.h"

@implementation OpenCloseModel

- (instancetype)init {
    if (self = [super init]){
        self.timezone = [NSTimeZone systemTimeZone];
        self.overnight = NO;
    }
    return self;
}

+ (OpenCloseModel *)hkStockMarketWithCode:(NSString *)code {
    OpenCloseModel * model = [[OpenCloseModel alloc] initWithType:@"MDF" code:code];
    model.timezone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    return model;
}

+ (OpenCloseModel *)hkIndexMarketWithCode:(NSString *)code {
    OpenCloseModel * model = [[OpenCloseModel alloc] initWithType:@"HSIL" code:code];
    model.timezone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    return model;
}

+ (OpenCloseModel *)hkFutureMarketWithCode:(NSString *)code {
    if (code && [code length] >= 3 && [[code substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"."]){
        code = [code substringToIndex:3];
    }
    OpenCloseModel * model = [[OpenCloseModel alloc] initWithType:@"PRS" code:code];
    model.timezone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    return model;
}

+ (OpenCloseModel *)hkNightFutureMarketWithCode:(NSString *)code {
    if (code && [code length] >= 3 && [[code substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"."]){
        code = [code substringToIndex:3];
    }
//    OpenCloseModel * model = [[OpenCloseModel alloc] initWithType:@"PRS" code:code];
    OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"PRS,DEFAULT,1715,300,300,300,300."];
    model.timezone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    model.overnight = YES;
    return model;
}

- (instancetype)initWithType:(NSString *)type code:(NSString *)code {
    NSArray *typeArray = [OCTimeList componentsSeparatedByString:@"|"];
    for(int i = 0;i < [typeArray count];i++)
    {
        NSArray* listArray = [[typeArray objectAtIndex:i] componentsSeparatedByString:@","];
        if ([type isEqualToString:[listArray objectAtIndex:0]] && [code isEqualToString:[listArray objectAtIndex:1]]) {
            
            return [self initWithString:[listArray componentsJoinedByString:@","]];
        }
    }
    for(int i = 0;i < [typeArray count];i++)
    {
        NSArray* listArray = [[typeArray objectAtIndex:i] componentsSeparatedByString:@","];
        if ([type isEqualToString:[listArray objectAtIndex:0]] && [@"DEFAULT" isEqualToString:[listArray objectAtIndex:1]]) {
//            if ([code isUSShareStockCode]) {
//                // remove morning close and afternoon open time as no lunch break for US market
//                NSMutableArray *USTradeTimeArray = [NSMutableArray arrayWithArray:listArray];
//                [USTradeTimeArray setObject:ETStaticKeyEmptyString atIndexedSubscript:3];
//                [USTradeTimeArray setObject:ETStaticKeyEmptyString atIndexedSubscript:5];
//                listArray = USTradeTimeArray;
//            }
            return [self initWithString:[listArray componentsJoinedByString:@","]];
        }
    }
    return [self initWithString:@""];
}

- (instancetype)initWithString:(NSString *)ocDateString {
    if (self = [self init]){
        NSArray * listArray = [ocDateString componentsSeparatedByString:@","];
        N_MORNING_OPEN = -1;
        N_MORNING_CLOSE = -1;
        N_CUTOFF = -1;
        N_AFTERNOON_OPEN = -1;
        N_AFTERNOON_CLOSE = -1;
        if ([listArray count] >= 7){
            self.type = [listArray objectAtIndex:0];
            self.code = [listArray objectAtIndex:1];
            NSString * moStr = [listArray objectAtIndex:2];
            NSString * mcStr = [listArray objectAtIndex:3];
            NSString * coStr = [listArray objectAtIndex:4];
            NSString * aoStr = [listArray objectAtIndex:5];
            NSString * acStr = [listArray objectAtIndex:6];
            if (![moStr isEqualToString:@""]){
                N_MORNING_OPEN = [moStr intValue];
            }
            if (![mcStr isEqualToString:@""]){
                N_MORNING_CLOSE = [mcStr intValue];
            }
            if (![coStr isEqualToString:@""]){
                N_CUTOFF = [coStr intValue];
            }
            if (![aoStr isEqualToString:@""]){
                N_AFTERNOON_OPEN = [aoStr intValue];
            }
            if (![acStr isEqualToString:@""]){
                N_AFTERNOON_CLOSE = [acStr intValue];
            }
        }
    }
    return self;
}

- (NSArray *)groupingKeyListForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval {
//    NSLog(@"GroupingKeyListForDate");
    if ([date length] > 8){
        date = [date substringToIndex:8];
    }
    NSString * startDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, N_MORNING_OPEN / 100, N_MORNING_OPEN % 100];
    NSString * endDateStr = [NSString stringWithFormat:@"%@%02d%02d", date, N_AFTERNOON_CLOSE / 100, N_AFTERNOON_CLOSE % 100];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    [formatter setTimeZone:self.timezone];
    NSDate * refDate = [formatter dateFromString:startDateStr];
    NSDate * endDate = [formatter dateFromString:endDateStr];
//    if ([endDate timeIntervalSince1970] < [refDate timeIntervalSince1970]){
    if (self.overnight){
        endDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:endDate options:0];
    }
    
    NSMutableArray * keyList = [NSMutableArray array];
    NSString * prevKey = @"";
    while ([refDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]){
//        NSLog(@"RefDate: %@", refDate);
        NSString * groupKey = [self groupingKeyForyyyyMMddHHmm:[formatter stringFromDate:refDate] forInterval:dataInterval session:ChartSessionTypeCore];
//        NSLog(@"GroupKey: %@", groupKey);
        if (groupKey){
            if (![groupKey isEqualToString:prevKey]){
                [keyList addObject:groupKey];
            }
            prevKey = groupKey;
        }
        refDate = [refDate dateByAddingTimeInterval:60];
    }
    
    //No Data At Start
    if (N_MORNING_OPEN != -1){
        NSString * dateStr = [NSString stringWithFormat:@"%@%02d%02d", date, N_MORNING_OPEN / 100, N_MORNING_OPEN % 100];
        [keyList removeObject:dateStr];
    }
    if (N_MORNING_CLOSE != -1){
        NSString * dateStr = [NSString stringWithFormat:@"%@%02d%02d", date, N_MORNING_CLOSE / 100, N_MORNING_CLOSE % 100];
        [keyList removeObject:dateStr];
    }
    if (N_AFTERNOON_OPEN != -1){
        NSString * dateStr = [NSString stringWithFormat:@"%@%02d%02d", date, N_AFTERNOON_OPEN / 100, N_AFTERNOON_OPEN % 100];
        [keyList removeObject:dateStr];
    }
    
    return keyList;
    
}

- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval session:(ChartSessionType)session {
    return [self groupingKeyForyyyyMMddHHmm:formatedDate forInterval:dataInterval];
}

- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval {
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
        if (N_MORNING_OPEN > 0 && time < N_MORNING_OPEN && (!self.overnight || time > N_AFTERNOON_CLOSE)) {
            switch (chartType) {
                case 1:
                    groupingTime = N_MORNING_OPEN;
                    break;
                default:
                    // double mm = (double)N_MORNING_OPEN / chartType + 1.0d;
                    tem = ceil((double)N_MORNING_OPEN / (double)chartType);
                    imin = (int) (tem * chartType);
                    groupingTime = imin;
                    break;
            }
        } else if (N_MORNING_CLOSE > 0 && N_CUTOFF > 0 && time >= N_MORNING_CLOSE && time < N_CUTOFF) {
            switch (chartType) {
                case 1:
                    groupingTime = N_MORNING_CLOSE;
                    break;
                default:
                    tem = ceil((double)N_MORNING_CLOSE / (double)chartType);
                    imin = (int) (tem * chartType);
                    groupingTime = imin;
                    break;
            }
        } else if (N_CUTOFF > 0 && N_AFTERNOON_OPEN > 0 && time >= N_CUTOFF && time < N_AFTERNOON_OPEN) {
            switch (chartType) {
                case 1:
                    groupingTime = N_AFTERNOON_OPEN;
                    break;
                default:{
                    int mm = ceil((double)N_AFTERNOON_OPEN / (double)chartType);
                    // tem = N_AFTERNOON_OPEN /chartType + 1;
                    imin = (int) (mm * chartType);
                    groupingTime = imin;
                }
                    break;
            }
        } else if (N_AFTERNOON_CLOSE > 0 && time >= N_AFTERNOON_CLOSE && (!self.overnight || time < N_MORNING_OPEN)) {
            if (self.extraClose){
//                ihr = N_AFTERNOON_CLOSE / 100;
//                imin = N_AFTERNOON_CLOSE % 100;
//                imin += chartType;
//                if (imin >= 60) {
//                    ihr++;
//                    imin = 0;
//                }
                groupingTime = N_AFTERNOON_CLOSE + chartType;
            } else {
                switch (chartType) {
                    case 1:
                        groupingTime = N_AFTERNOON_CLOSE;
                        break;
                    default:
                        groupingTime = N_AFTERNOON_CLOSE;
                        break;
                }
            }
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
//        NSLog(@"%d", groupingTime);
        if (groupingTime % 100 >= 60) {
            groupingTime = ((groupingTime / 100) + 1) * 100;
        }
        if (N_AFTERNOON_CLOSE > 0 && groupingTime > N_AFTERNOON_CLOSE && !self.extraClose && (!self.overnight || time < N_MORNING_OPEN))
            groupingTime = N_AFTERNOON_CLOSE;
        
        BOOL plus1Day = false;
        if (groupingTime / 100 >= 24){
            plus1Day = true;
//            NSDate * forDate = [NSDate]
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyyMMdd"];
            [format setTimeZone:self.timezone];
            NSDate * date = [format dateFromString:[formatedDate substringToIndex:8]];
            date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            formatedDate = [format stringFromDate:date];
            
            groupingTime = groupingTime - 24 * 100;
        }
        
        if (groupingTime < 1000){
            return [NSString stringWithFormat:@"%@%04d", [formatedDate substringToIndex:8], groupingTime];
        }
        return [NSString stringWithFormat:@"%@%d", [formatedDate substringToIndex:8], groupingTime];
        
    } else {
        return formatedDate;
    }
}

- (int)FormatDate:(int) date {
    int closeHr = date / 100;
    int closeMin = date % 100 - 1;
    if (closeMin < 0) {
        closeHr--;
        closeMin = 59;
    }
    return closeHr * 100 + closeMin;
}

@end
