//
//  CompareTI.m
//  ChartLibraryDemo
//
//  Created by william on 18/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "CompareTI.h"

@implementation CompareTI

- (instancetype)init {
    if (self = [super init]){
        self.prevSelfData = kEmptyDataValue;
        self.prevCompareData = kEmptyDataValue;
    }
    return self;
}


- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig {
    NSInteger i = 0;
    NSInteger j = 0;
//    CGFloat prevIClose = NSNotFound;
//    CGFloat prevJClose = NSNotFound;
    CGFloat prevIClose = (self.prevSelfData==kEmptyDataValue)?NSNotFound:self.prevSelfData;
    CGFloat prevJClose = (self.prevCompareData==kEmptyDataValue)?NSNotFound:self.prevCompareData;
    
    NSArray * iDataList = dataList;
    NSArray * jDataList = self.comparedDataList;
    
    if ([iDataList count] == 0){
        return;
    }
    if ([jDataList count] == 0){
        return;
    }
    NSMutableArray * mutArray = [NSMutableArray array];
//    while (i < [iDataList count] && j < [jDataList count]){
    while (!(i >= [iDataList count] && j >= [jDataList count])){
        ChartData * iData = [iDataList objectAtIndex:(i>=[iDataList count]?[iDataList count]-1:i)];
        ChartData * jData = [jDataList objectAtIndex:(j>=[jDataList count]?[jDataList count]-1:j)];
        if (i >= [iDataList count]){
            if (prevIClose != NSNotFound && ![jData isEmpty]){
                ChartData * cData = [[ChartData alloc] init];
                cData.groupingKey = jData.groupingKey;
                cData.date = jData.date;
                cData.open = 0.f;
                cData.close = jData.close - prevIClose;
                cData.high = cData.close;
                cData.low = cData.close;
                cData.volume = 0.f;
                [mutArray addObject:cData];
                prevJClose = jData.close;
            } else {
                ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:jData.groupingKey date:jData.date];
                [mutArray addObject:cData];
            }
            j++;
            continue;
        }
        if (j >= [jDataList count]){
            if (prevJClose != NSNotFound && ![iData isEmpty]){
                ChartData * cData = [[ChartData alloc] init];
                cData.groupingKey = iData.groupingKey;
                cData.date = iData.date;
                cData.open = 0.f;
                cData.close = prevJClose - iData.close;
                cData.high = cData.close;
                cData.low = cData.close;
                cData.volume = 0.f;
                [mutArray addObject:cData];
                prevIClose = iData.close;
            } else {
                ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:iData.groupingKey date:iData.date];
                [mutArray addObject:cData];
            }
            i++;
            continue;
        }
        if ([iData.groupingKey isEqualToString:jData.groupingKey]){
            if ([iData isEmpty] && [jData isEmpty]){
                if (prevIClose != NSNotFound && prevJClose != NSNotFound){
                    ChartData * cData = [[ChartData alloc] init];
                    cData.groupingKey = iData.groupingKey;
                    cData.date = iData.date;
                    cData.open = 0.f;
                    cData.close = prevJClose - prevIClose;
                    cData.high = cData.close;
                    cData.low = cData.close;
                    cData.volume = 0.f;
                    [mutArray addObject:cData];
                    prevJClose = iData.close;
                } else {
                    ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:iData.groupingKey date:iData.date];
                    [mutArray addObject:cData];
                }
            } else
            if ([iData isEmpty]){
                if (prevIClose != NSNotFound){
                    ChartData * cData = [[ChartData alloc] init];
                    cData.groupingKey = jData.groupingKey;
                    cData.date = jData.date;
                    cData.open = 0.f;
                    cData.close = jData.close - prevIClose;
                    cData.high = cData.close;
                    cData.low = cData.close;
                    cData.volume = 0.f;
                    [mutArray addObject:cData];
                    prevJClose = jData.close;
                } else {
                    ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:jData.groupingKey date:jData.date];
                    [mutArray addObject:cData];
                }
            } else
            if ([jData isEmpty]){
                if (prevJClose != NSNotFound){
                    ChartData * cData = [[ChartData alloc] init];
                    cData.groupingKey = iData.groupingKey;
                    cData.date = iData.date;
                    cData.open = 0.f;
                    cData.close = prevJClose - iData.close;
                    cData.high = cData.close;
                    cData.low = cData.close;
                    cData.volume = 0.f;
                    [mutArray addObject:cData];
                    prevIClose = iData.close;
                }else {
                    ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:iData.groupingKey date:iData.date];
                    [mutArray addObject:cData];
                }
            } else {
                ChartData * cData = [[ChartData alloc] init];
                cData.groupingKey = iData.groupingKey;
                cData.date = iData.date;
                cData.open = 0.f;
                cData.close = jData.close - iData.close;
                cData.high = cData.close;
                cData.low = cData.close;
                cData.volume = 0.f;
                [mutArray addObject:cData];
                prevIClose = iData.close;
                prevJClose = jData.close;
            }
            i++;
            j++;
            continue;
        }
        if ([iData.groupingKey integerValue] > [jData.groupingKey integerValue]){
            if (prevIClose != NSNotFound){
                ChartData * cData = [[ChartData alloc] init];
                cData.groupingKey = jData.groupingKey;
                cData.date = jData.date;
                cData.open = 0.f;
                cData.close = jData.close - prevIClose;
                cData.high = cData.close;
                cData.low = cData.close;
                cData.volume = 0.f;
                [mutArray addObject:cData];
                prevJClose = jData.close;
            } else {
                ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:jData.groupingKey date:jData.date];
                [mutArray addObject:cData];
            }
            j++;
            continue;
        } else {
            if (prevJClose != NSNotFound){
                ChartData * cData = [[ChartData alloc] init];
                cData.groupingKey = iData.groupingKey;
                cData.date = iData.date;
                cData.open = 0.f;
                cData.close = prevJClose - iData.close;
                cData.high = cData.close;
                cData.low = cData.close;
                cData.volume = 0.f;
                [mutArray addObject:cData];
                prevIClose = iData.close;
            }else {
                ChartData * cData = [[ChartData alloc] initEmptyDataWithGroupingKey:iData.groupingKey date:iData.date];
                [mutArray addObject:cData];
            }
            i++;
            continue;
        }
    }
    
    ChartLineObjectHisto * histoObj = [[ChartLineObjectHisto alloc] init];
    histoObj.refKey = [self refKeyForChart];
    histoObj.dataName = [self refKeyForChart];
    histoObj.upColor = colorConfig.tiFutureCandleUp;
    histoObj.downColor = colorConfig.tiFutureCandleDown;
    
    [histoObj setChartDataByChartDataList:mutArray forChartDisplayType:ChartDataDisplayTypeClose];
    
    self.tiLineObjects = @[histoObj];
}


- (NSString *)formatValue:(CGFloat)value {
    NSString * valueFormat = @"0.000";
    if (self.chartConfig) {
        valueFormat = self.chartConfig.subChartValueDisplayFormat;
    } else {
        valueFormat = @"0.000";
    }
    
    return [ChartCommonUtil formatFloatValue:value byFormat:valueFormat groupKMB:NO];
}

@end
