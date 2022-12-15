//
//  chartData.m
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartData.h"

@implementation ChartData

- (NSString *)description {
    if ([self isEmpty]){
        return [NSString stringWithFormat:@"Key: %@ Date:%@ Empty", self.groupingKey, self.date];
    } else {
        return [NSString stringWithFormat:@"Key: %@ Date:%@ O:%.3f C:%.3f H:%.3f L:%.3f V:%.3f", self.groupingKey, self.date, self.open, self.close, self.high, self.low, self.volume];
    }
}

- (instancetype)initEmptyDataWithGroupingKey:(NSString *)key date:(NSDate *)date {
    if (self = [self init]){
        self.groupingKey = key;
        self.date = date;
        self.open = kEmptyDataValue;
        self.close = kEmptyDataValue;
        self.high = kEmptyDataValue;
        self.low = kEmptyDataValue;
        self.volume = kEmptyDataValue;
    }
    return self;
}

- (instancetype)initSimpleDataWithGroupingKey:(NSString *)key date:(NSDate *)date value:(CGFloat)value {
    if (self = [self init]){
        self.groupingKey = key;
        self.date = date;
        self.open = value;
        self.close = value;
        self.high = value;
        self.low = value;
        self.volume = value;
    }
    return self;
}

- (BOOL)isEmpty {
    return (self.close == kEmptyDataValue);
}

- (NSComparisonResult)compareByKey:(NSString *)key {
    return ([@([self.groupingKey integerValue]) compare:@([key integerValue])]);
    
    
}

- (void)mergeWithData:(ChartData *)data {
    if ([self.groupingKey isEqualToString:data.groupingKey]){
        if ([self isEmpty]){
            self.date = data.date;
        } else {
            self.date = ([self.date timeIntervalSince1970]>[data.date timeIntervalSince1970])?self.date:data.date;
        }
        if (data.high!=kEmptyDataValue){
            if (self.high == kEmptyDataValue){
                self.high = data.high;
            } else {
                self.high = (self.high>data.high)?self.high:data.high;
            }
        }
        if (data.low != kEmptyDataValue){
            if (self.low == kEmptyDataValue){
                self.low = data.low;
            } else {
                self.low = (self.low<data.low)?self.low:data.low;
            }
        }
        if (data.open != kEmptyDataValue){
            if (self.open == kEmptyDataValue){
                self.open = data.open;
            } else {
                self.open = ([self.date timeIntervalSince1970]>[data.date timeIntervalSince1970])?self.open:data.open;
            }
        }
        if (data.close != kEmptyDataValue){
            if (self.close == kEmptyDataValue){
                self.close = data.close;
            } else {
                self.close = ([self.date timeIntervalSince1970]<[data.date timeIntervalSince1970])?self.close:data.close;
            }
        }
        if (data.volume != kEmptyDataValue){
            if (self.volume == kEmptyDataValue){
                self.volume = data.volume;
            } else {
                self.volume += data.volume;
            }
        }
        
    }
}

@end
