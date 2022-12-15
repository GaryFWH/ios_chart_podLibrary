//
//  ChartDataRequest.m
//  EtnetPod_Chart
//
//  Created by william on 25/5/2021.
//

#import "ChartDataRequest.h"

@implementation ChartDataRequest

- (instancetype)initWithCode:(NSString *)code interval:(ChartDataInterval)interval dataType:(ChartDataType)dataType codeType:(ChartCodeType)codeType {
    if (self = [self init]){
        self.code = code;
        self.interval = interval;
//        self.isToday = isToday;
        self.dataType = dataType;
        self.codeType = codeType;
        self.limit = 400;
    }
    return self;
}

- (instancetype)initWithCode:(NSString *)code interval:(ChartDataInterval)interval dataType:(ChartDataType)dataType codeType:(ChartCodeType)codeType session:(ChartSessionType)session {
    if (self = [self init]){
        self.code = code;
        self.interval = interval;
//        self.isToday = isToday;
        self.dataType = dataType;
        self.codeType = codeType;
        self.limit = 99999;
        self.session = session;
    }
    return self;
}

@end
