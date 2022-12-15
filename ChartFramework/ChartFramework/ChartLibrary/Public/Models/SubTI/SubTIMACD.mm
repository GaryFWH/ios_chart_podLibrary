//
//  SubTIMACD.m
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//
#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIMACD.h"
#import "MacdClass.h"
#import "ChartCommonUtil.h"

@implementation SubTIMACDUnit
- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";

    if ([lineKey isEqualToString:@"Macd1"]) {
        rKey = [NSString stringWithFormat:@"%ld MACD", self.iMacd1];
    } else if ([lineKey isEqualToString:@"Macd2"]) {
        rKey = [NSString stringWithFormat:@"%ld MACD", self.iMacd2];
    } else if ([lineKey isEqualToString:@"Diff"]) {
        rKey = [NSString stringWithFormat:@"%ld Diff", self.iDiff];
    }
    return rKey;
}
@end

@implementation SubTIMACD

//- (void)createDefaultDataList
//{
//    SubTIMACDUnit *unit = [[SubTIMACDUnit alloc] init];
//    self.unit = [[SubTIMACDUnit alloc] init];
//
//    self.unit.iMacd1 = 12;
//    self.unit.iMacd2 = 26;
//    self.unit.iDiff  = 9;
//
//    self.unit.iMacd1Color = [UIColor blueColor];
//    self.unit.iMacd2Color = [UIColor redColor];
//    self.unit.iAboveDiffColor  = [UIColor blueColor];
//    self.unit.iBelowDiffColor  = [UIColor redColor];
//    self.unit.zeroColor   = [UIColor blackColor];
//
//    self.dataList = @[unit];
//}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIMACDUnit alloc] init];
    
    self.unit.iMacd1 = tiConfig.tiMACDMACD1;
    self.unit.iMacd2 = tiConfig.tiMACDMACD2;
    self.unit.iDiff  = tiConfig.tiMACDDiff;
    
    self.unit.iMacd1Color       = colorConfig.tiMACD1;
    self.unit.iMacd2Color       = colorConfig.tiMACD2;
    self.unit.iAboveDiffColor   = colorConfig.tiMACDAboveDiff;
    self.unit.iBelowDiffColor   = colorConfig.tiMACDBelowDiff;
    self.unit.zeroColor         = colorConfig.tiMACDZero;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}

- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
//    if (self.dataList && [self.dataList count]){
    if (self.unit) {
        self.unit.zeroColor = colorConfig.tiMACDZero;
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"Macd1"]){
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiMACD1;
                }
            }
            if ([lineObj.refKey isEqualToString:@"Macd2"]){
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiMACD2;
                }
            }
            if ([lineObj.refKey isEqualToString:@"Zero"]){
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiMACDZero;
                }
            }
            if ([lineObj.refKey isEqualToString:@"Diff"]){
                if ([lineObj isKindOfClass:[ChartLineObjectHisto class]]){
                    ((ChartLineObjectHisto *)lineObj).upColor = colorConfig.tiMACDAboveDiff;
                    ((ChartLineObjectHisto *)lineObj).downColor = colorConfig.tiMACDBelowDiff;
                }
            }
        }
    }
}

- (NSArray *)dataDictsForGroupingKey:(NSString *)groupKey
{
    NSMutableArray * array = [NSMutableArray array];
    if (self.tiLineObjects){
        NSArray *sortedTiLineObjects = [NSArray array];
        if (self.tiLineObjects.count > 0) {
            sortedTiLineObjects = [self sortTiLineObject:self.tiLineObjects];
        }
        for (ChartLineObject * obj in sortedTiLineObjects){
            ChartData * data = [obj.chartDataDict objectForKey:groupKey];
            if (data){
                UIColor *objColor = [obj colorWithChartData:data];
                if ([data isEmpty]){
                    [array addObject:
                        @{
                            @"color"    : objColor,
                            @"name"     : obj.dataName,
                            @"date"     : data.date,
                        }];
                } else if ([obj isKindOfClass:[ChartLineObjectSingleValue class]]){
                    CGFloat value = [obj getValueForKey:groupKey forDisplayType:((ChartLineObjectSingleValue *)obj).displayType];
                    if ([obj.refKey isEqualToString:@"Zero"]) {
                        continue;
                    }
                    if ([obj.refKey isEqualToString:@"Diff"]) {
                        objColor = self.unit.zeroColor;
                    }
                    [array addObject:
                        @{
                            @"color"    : objColor,
                            @"name"     : obj.dataName,
                            @"date"     : data.date,
                            @"value"    : [self formatValue:value],
                        }];
                } else {
                    CGFloat value = [obj getValueForKey:groupKey forDisplayType:ChartDataDisplayTypeClose];
                    if ([obj.refKey isEqualToString:@"Zero"]) {
                        continue;
                    }
                    [array addObject:
                        @{
                            @"color"    : objColor,
                            @"name"     : obj.dataName,
                            @"date"     : data.date,
                            @"value"    : [self formatValue:value],
                        }];

                }
            }
        }
    }
    
    
    return array;

}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    
    MacdClass *macdClass = new MacdClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        macdClass->setMacd1((int)self.unit.iMacd1);
        macdClass->setMacd2((int)self.unit.iMacd2);
        macdClass->setDiff((int)self.unit.iDiff);
        
        MapofAll *newMapOfAll =(MapofAll*)macdClass->calculate((void *)&MapOfAll);
        
        if (newMapOfAll != NULL) {
            MapofAll::iterator iterofAll;
            for (iterofAll = newMapOfAll->begin(); iterofAll != newMapOfAll->end(); iterofAll++) {
                NSString *lineKey = [NSString stringWithFormat:@"%s", iterofAll->first.c_str()];
                MapofLine *pMap = iterofAll->second;
                
                NSInteger lineSize = [dataList count];
    //            NSMutableDictionary * chartObjDict = [NSMutableDictionary dictionary];
                NSMutableArray * chartObjAry = [NSMutableArray array];

                for (NSInteger i = 0; i < lineSize; i++){
                    ChartData * data = [[ChartData alloc] init];
                    ChartData * oldData = [dataList objectAtIndex:i];
                    chartData * cData = new chartData();
                    
                    NSString *minTimeKey = oldData.groupingKey;
                    MapofLine::iterator iterofLine = pMap->find([minTimeKey UTF8String]);

                    if (iterofLine != (*iterofAll->second).end()){
                        cData = iterofLine->second;
                    }
                    data.groupingKey = oldData.groupingKey;
                    data.date   = oldData.date;
                    data.open   = cData->open;
                    data.close  = cData->close;
                    data.high   = cData->high;
                    data.low    = cData->low;
                    data.volume = cData->volume;
    //                [chartObjDict setObject:data forKey:oldData.groupingKey];
                    [chartObjAry addObject:data];
                }
            
                if (chartObjAry) {
                    if ([lineKey isEqualToString:@"Macd1"] || [lineKey isEqualToString:@"Macd2"] || [lineKey isEqualToString:@"Zero"]) {
                        ChartLineObjectLine *lineObj = [[ChartLineObjectLine alloc] init];
    //                    lineObj.refKey = [unit objectKey:lineKey];
                        lineObj.refKey = lineKey;
                        lineObj.dataName = [self.unit objectKey:lineKey];
                        
//                        NSLog(@"MACD refKey %@", lineObj.refKey);

                        UIColor *mainColor = self.unit.iMacd1Color;
                        if ([lineKey isEqualToString:@"Macd1"]) {
                            mainColor = self.unit.iMacd1Color;
                        } else if ([lineKey isEqualToString:@"Macd2"]) {
                            mainColor = self.unit.iMacd2Color;
                        } else if ([lineKey isEqualToString:@"Zero"]) {
                            mainColor = self.unit.zeroColor;
                        }
                        
                        lineObj.mainColor = mainColor;
    //                    [lineObj setChartDataDict:chartObjDict];
                        [lineObj setChartDataByChartDataList:chartObjAry];
                        [resultArray addObject:lineObj];
                    } else if ([lineKey isEqualToString:@"Diff"] ){
                        ChartLineObjectHisto *histoObj = [[ChartLineObjectHisto alloc] init];
    //                    histoObj.refKey = NSStringFromClass([self class]);
                        histoObj.refKey = lineKey;
                        histoObj.dataName = [self.unit objectKey:lineKey];
                        histoObj.upColor = self.unit.iAboveDiffColor;
                        histoObj.downColor = self.unit.iBelowDiffColor;
                        histoObj.displayType = ChartDataDisplayTypeClose;
    //                    [histoObj setChartDataDict:chartObjDict];
                        [histoObj setChartDataByChartDataList:chartObjAry];
                        [resultArray addObject:histoObj];
                    } else {
                        //
                    }
                }
            }
        }
    }
//    if (resultArray && [resultArray count]) {
//        [self sortTiLineObject:resultArray];
//    }
    return resultArray;
}
- (NSString *)formatValue:(CGFloat)value
{
    return [ChartCommonUtil formatFloatValue:value byFormat:@"0.00000" groupKMB:NO];
}

// Private
- (MapofAll) ConvertToMapOfAll:(NSArray*)dataList
{
    MapofAll pMapOfAll;
    MapofLine *pMapOfLine = new MapofLine();
    
    for (ChartData * data in dataList) {
        NSString *minTimeKey = data.groupingKey;
        if (minTimeKey != nil) {
            string sKey = [minTimeKey UTF8String];
            
            chartData *cData = new chartData();
            cData->open     = data.open;
            cData->high     = data.high;
            cData->low      = data.low;
            cData->close    = data.close;
            cData->volume   = data.volume;
            
            pMapOfLine->insert(pair<string, chartData*>(sKey,cData));
        }
        
    }
    pMapOfAll.insert(pair<string, MapofLine*>([@"MainData" UTF8String], pMapOfLine));
    
    return pMapOfAll;
}
- (NSArray*)sortTiLineObject:(NSArray*)lineObjects
{
    NSArray *rArray = [NSArray array];
//    NSMutableArray *rArray = [NSMutableArray array];
//    if (lineObjects && [lineObjects count]) {
//        rArray = lineObjects;
//    }
    
    rArray = [lineObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ChartLineObject *lineObj1 = obj1;
        ChartLineObject *lineObj2 = obj2;
        
        NSComparisonResult result = NSOrderedSame;
        
        if ([lineObj1.refKey isEqualToString:@"Macd1"]) {
            result = NSOrderedAscending;
        } else if ([lineObj1.refKey isEqualToString:@"Macd2"]) {
            if ([lineObj2.refKey isEqualToString:@"Macd1"]) {
                result = NSOrderedDescending;
            } else if ([lineObj2.refKey isEqualToString:@"Diff"]) {
                result = NSOrderedAscending;
            }
        } else if ([lineObj1.refKey isEqualToString:@"Diff"]) {
            result = NSOrderedDescending;
//            if ([lineObj1 isKindOfClass:[ChartLineObjectHisto class]]) {
//                ChartLineObjectHisto *histoObj = (ChartLineObjectHisto*)lineObj1;
//                histoObj.upColor = self.unit.zeroColor;
//            }
        }
        return result;
    }];
    
//    for (ChartLineObject *obj1 in rArray) {
//        NSLog(@"Sorted Macd.refKey %@ ", obj1.refKey);
//    }
    return rArray;
}
@end
