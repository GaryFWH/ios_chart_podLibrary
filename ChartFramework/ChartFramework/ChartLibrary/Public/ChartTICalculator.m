//
//  ChartTICalculator.m
//  ChartLibraryDemo
//
//  Created by william on 29/7/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTICalculator.h"
#import "MainTIList.h"
#import "SubTIList.h"

#define tiNullValue [NSNull null]

@implementation ChartTICalculator

+ (NSDictionary *)getDictionaryFromChartConfig:(ChartTIConfig *)config forChartData:(NSArray<ChartData *> *)dataList
{
    NSMutableArray * groupKeyList = [NSMutableArray array];
    NSMutableArray * filterEmptyAry = [NSMutableArray array];
    for (ChartData * data in dataList){
        if (![data isEmpty]){
            [filterEmptyAry addObject:data];
            [groupKeyList addObject:data.groupingKey];
        }
    }
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    [mutDict addEntriesFromDictionary:[self getOhlcFromData:filterEmptyAry]];
//    [mutDict addEntriesFromDictionary:[self getMainTiFromData:filterEmptyAry withConfig:config withGroupKeyList:groupKeyList]];
    if (config){
        [mutDict setObject:[self getMainTiFromData:filterEmptyAry withConfig:config withGroupKeyList:groupKeyList] forKey:kChartCalMainTi];
        
        [mutDict setObject:[self getExtraTiFromData:filterEmptyAry withConfig:config withGroupKeyList:groupKeyList] forKey:kChartCalExtraTi];
    }
    
    return [NSDictionary dictionaryWithDictionary:mutDict];
}

+ (NSDictionary *)getOhlcFromData:(NSArray<ChartData *> *)dataList {
    NSMutableArray * ary = [NSMutableArray array];
    for (ChartData * data in dataList){
        [ary addObject:@{
            kChartCalOHLCOpen : @(data.open),
            kChartCalOHLCHigh : @(data.high),
            kChartCalOHLCLow : @(data.low),
            kChartCalOHLCClose : @(data.close),
            kChartCalOHLCVolume : @(data.volume),
            kChartCalOHLCTime : [NSString stringWithFormat:@"%.0f000", [data.date timeIntervalSince1970]]
        }];
    }
    return @{
        kChartCalOHLC : ary
    };
}

+ (NSArray *)getValueFromObjectList:(ChartLineObject *)lineObj withGroupKeyList:(NSArray *)keyList{
    NSMutableArray * maData = [NSMutableArray array];
    for (NSString * groupKey in keyList){
        if (groupKey){
            CGFloat value = [lineObj getValueForKey:groupKey forDisplayType:ChartDataDisplayTypeClose];
            if (value == kEmptyDataValue){
                [maData addObject:tiNullValue];
            } else {
                [maData addObject:@(value)];
            }
        }
    }
    return maData;
}

+ (NSDictionary * )getMainTiFromData:(NSArray<ChartData *> *)dataList withConfig:(ChartTIConfig *)config withGroupKeyList:(NSArray *)keyList{
    switch (config.selectedMainTI){
        case ChartMainTIEnumSMA:{
            MainTISMA * sma = [[MainTISMA alloc] init];
            NSMutableDictionary * state = [NSMutableDictionary dictionary];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            [sma createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
            for (NSInteger i = 0; i < [sma.dataList count]; i++){
                MainTISMAUnit * unit = [sma.dataList objectAtIndex:i];
                if (unit){
                    [state setObject:@(unit.day) forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiStateMAPeriod, i+1]];
                }
            }
            for (NSInteger i = 0; i < [sma.tiLineObjects count]; i++){
                ChartLineObject * obj = [sma.tiLineObjects objectAtIndex:i];
                if (obj){
                   [data setObject:[self getValueFromObjectList:obj withGroupKeyList:keyList]
                             forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiDataSMA, i+1]];
                }
            }
            return @{
                kChartCalMainTiSMA : @{
                        kChartCalState : state,
                        kChartCalData : data
                }
            };
            break;
        }
        case ChartMainTIEnumWMA:{
            MainTIWMA * wma = [[MainTIWMA alloc] init];
            NSMutableDictionary * state = [NSMutableDictionary dictionary];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            [wma createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
            for (NSInteger i = 0; i < [wma.dataList count]; i++){
                MainTIWMAUnit * unit = [wma.dataList objectAtIndex:i];
                if (unit){
                    [state setObject:@(unit.day) forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiStateMAPeriod, i+1]];
                }
            }
            for (NSInteger i = 0; i < [wma.tiLineObjects count]; i++){
                ChartLineObject * obj = [wma.tiLineObjects objectAtIndex:i];
                if (obj){
                    [data setObject:[self getValueFromObjectList:obj withGroupKeyList:keyList]
                              forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiDataWMA, i+1]];
                }
            }
            return @{
                kChartCalMainTiWMA : @{
                        kChartCalState : state,
                        kChartCalData : data
                }
            };
            break;
        }
        case ChartMainTIEnumEMA: {
            MainTIEMA * ema = [[MainTIEMA alloc] init];
            NSMutableDictionary * state = [NSMutableDictionary dictionary];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            [ema createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
            for (NSInteger i = 0; i < [ema.dataList count]; i++){
                MainTIEMAUnit * unit = [ema.dataList objectAtIndex:i];
                if (unit){
                    [state setObject:@(unit.day) forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiStateMAPeriod, i+1]];
                }
            }
            for (NSInteger i = 0; i < [ema.tiLineObjects count]; i++){
                ChartLineObject * obj = [ema.tiLineObjects objectAtIndex:i];
                if (obj){
                    [data setObject:[self getValueFromObjectList:obj withGroupKeyList:keyList]
                              forKey:[NSString stringWithFormat:@"%@%zd", kChartCalMainTiDataEMA, i+1]];
                }
            }
            return @{
                kChartCalMainTiEMA : @{
                        kChartCalState : state,
                        kChartCalData : data
                }
            };
            break;
        }
        case ChartMainTIEnumBB: {
            MainTIBB * ti = [[MainTIBB alloc] init];
            NSMutableDictionary * state = [NSMutableDictionary dictionary];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
            [state setObject:@(config.tiBBIntervals) forKey:kChartCalMainTiStateBBPeriod];
            [state setObject:@(config.tiBBStdDev) forKey:kChartCalMainTiStateBBStd];
            for (ChartLineObject * lineObj in ti.tiLineObjects) {
                if ([lineObj.refKey containsString:@"Upper"]) {
                    [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                              forKey:kChartCalMainTiDataBBUpper];
                }
                if ([lineObj.refKey containsString:@"Middle"]) {
                    [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                              forKey:kChartCalMainTiDataBBMiddle];
                }
                if ([lineObj.refKey containsString:@"Lower"]) {
                    [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                              forKey:kChartCalMainTiDataBBLower];
                }
            }
            return @{
                kChartCalMainTiBB : @{
                        kChartCalState : state,
                        kChartCalData : data
                }
            };
            break;
        }
        case ChartMainTIEnumSAR: {
            MainTISAR * ti = [[MainTISAR alloc] init];
            [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
            NSMutableDictionary * state = [NSMutableDictionary dictionary];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            [state setObject:@(config.tiSARaccFactor) forKey:kChartCalMainTiStateSARAcc];
            [state setObject:@(config.tiSARmaxAccFactor) forKey:kChartCalMainTiStateSARMaxAcc];
            for (ChartLineObject * lineObj in ti.tiLineObjects) {
                if ([lineObj.refKey containsString:@"SAR"]) {
                    [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                              forKey:kChartCalMainTiDataSARSAR];
                }
            }
            return @{
                kChartCalMainTiSAR : @{
                        kChartCalState : state,
                        kChartCalData : data
                }
            };
            break;
        }
        default: {
            break;
        }
    }
    return @{};
}

+ (NSDictionary * )getExtraTiFromData:(NSArray<ChartData *> *)dataList withConfig:(ChartTIConfig *)config withGroupKeyList:(NSArray *)keyList{
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    if (config.selectedSubTI && [config.selectedSubTI isKindOfClass:[NSArray class]]){
        for (NSNumber * subTiNum in config.selectedSubTI){
            if ([subTiNum integerValue] < ChartSubTITotalCount){
                ChartSubTIEnum subTi = (ChartSubTIEnum)[subTiNum integerValue];
                switch (subTi){
                    case ChartSubTIEnumDMI:
                    {
                        SubTIDMI * ti = [[SubTIDMI alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiDMIInterval) forKey:kChartCalExtraTiStateDMI];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"+DI"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataDMIpDI];
                            }
                            if ([lineObj.refKey isEqualToString:@"-DI"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataDMInDI];
                            }
                            if ([lineObj.refKey isEqualToString:@"ADX"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataDMIADX];
                            }
                            if ([lineObj.refKey isEqualToString:@"ADXR"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataDMIADXR];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiDMI];
                    }
                        break;
                    case ChartSubTIEnumMACD:
                    {
                        SubTIMACD * ti = [[SubTIMACD alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiMACDMACD1) forKey:kChartCalExtraTiStateMACD1];
                        [state setObject:@(config.tiMACDMACD2) forKey:kChartCalExtraTiStateMACD2];
                        [state setObject:@(config.tiMACDDiff) forKey:kChartCalExtraTiStateMACDDiff];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"Macd1"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataMACD1];
                            }
                            if ([lineObj.refKey isEqualToString:@"Macd2"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataMACD2];
                            }
                            if ([lineObj.refKey isEqualToString:@"Diff"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataMACDDiff];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiMACD];
                    }
                        break;
                    case ChartSubTIEnumOBV:
                    {
                        SubTIOBV * ti = [[SubTIOBV alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiOBVisWeighted) forKey:kChartCalExtraTiStateOBV];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"OBV"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataOBV];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiOBV];
                    }
                        break;
                    case ChartSubTIEnumROC:
                    {
                        SubTIROC * ti = [[SubTIROC alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiROCIntervals) forKey:kChartCalExtraTiStateROC];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"ROC"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataROC];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiROC];
                    }
                        break;
                    case ChartSubTIEnumRSI:
                    {
                        SubTIRSI * ti = [[SubTIRSI alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiRSIIntervals) forKey:kChartCalExtraTiStateRSIPeriod];
                        [state setObject:@(config.tiRSISMA) forKey:kChartCalExtraTiStateRSISMA];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"RSI"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataRSIRSI];
                            }
                            if ([lineObj.refKey isEqualToString:@"SMA"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataRSISMA];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiRSI];
                    }
                        break;
                    case ChartSubTIEnumSTCFast:
                    {
                        SubTISTCFast * ti = [[SubTISTCFast alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiSTCFastD) forKey:kChartCalExtraTiStateSTCFastD];
                        [state setObject:@(config.tiSTCFastK) forKey:kChartCalExtraTiStateSTCFastK];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"%K"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataSTCFastK];
                            }
                            if ([lineObj.refKey isEqualToString:@"%D"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataSTCFastD];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiSTCFast];
                    }
                        break;
                    case ChartSubTIEnumSTCSlow:
                    {
                        SubTISTCSlow * ti = [[SubTISTCSlow alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiSTCSlowSD) forKey:kChartCalExtraTiStateSTCSlowD];
                        [state setObject:@(config.tiSTCSlowSK) forKey:kChartCalExtraTiStateSTCSlowK];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"%SK"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataSTCSlowK];
                            }
                            if ([lineObj.refKey isEqualToString:@"%SD"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataSTCSlowD];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiSTCSlow];
                    }
                        break;
                    case ChartSubTIEnumVOL:
                    {
                        SubTIVolumn * ti = [[SubTIVolumn alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiVOLSMA) forKey:kChartCalExtraTiStateVOL];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"VOL"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataVOL];
                            }
                            if ([lineObj.refKey isEqualToString:@"VOLSMA"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataVOLSMA];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiVOL];
                    }
                        break;
                    case ChartSubTIEnumWill:
                    {
                        SubTIWilliam * ti = [[SubTIWilliam alloc] init];
                        [ti createChartObjectListFromChartData:dataList withTIConfig:config colorConfig:[ChartColorConfig defaultLightConfig]];
                        NSMutableDictionary * state = [NSMutableDictionary dictionary];
                        NSMutableDictionary * data = [NSMutableDictionary dictionary];
                        [state setObject:@(config.tiWillInterval) forKey:kChartCalExtraTiStateWillPeriod];
                        [state setObject:@(config.tiWillSma) forKey:kChartCalExtraTiStateWillPeriodSMA];
                        for (ChartLineObject * lineObj in ti.tiLineObjects) {
                            if ([lineObj.refKey isEqualToString:@"WILL"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataWillR];
                            }
                            if ([lineObj.refKey isEqualToString:@"WSMA"]) {
                                [data setObject:[self getValueFromObjectList:lineObj withGroupKeyList:keyList]
                                          forKey:kChartCalExtraTiDataWillSma];
                            }
                        }
                        [mutDict setObject:
                        @{
                            kChartCalState : state,
                            kChartCalData : data
                        }
                                    forKey:kChartCalExtraTiWill];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    return mutDict;
}


@end
