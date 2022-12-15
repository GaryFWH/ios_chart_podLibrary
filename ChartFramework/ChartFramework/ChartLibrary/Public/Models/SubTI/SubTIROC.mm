//
//  SubTIROC.m
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIROC.h"
#import "RocClass.h"

@implementation SubTIROCUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"ROC"]) {
        rKey = [NSString stringWithFormat:@"%ld ROC", self.day];
    }
    return rKey;
}
@end

@implementation SubTIROC
- (void)createDefaultDataList
{
    self.unit = [[SubTIROCUnit alloc] init];
    
    self.unit.day = 10;
    self.unit.rocColor = [UIColor blueColor];
    self.unit.ravgColor = [UIColor blackColor];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIROCUnit alloc] init];
    
    self.unit.day = tiConfig.tiROCIntervals;
    self.unit.rocColor = colorConfig.tiROC;
    self.unit.ravgColor = colorConfig.tiROCAvg;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"ROC"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiROC;
                }
            }
            if ([lineObj.refKey isEqualToString:@"RAvg"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiROCAvg;
                }
            }
        }
    }
}
- (NSArray *)dataDictsForGroupingKey:(NSString *)groupKey
{
    NSMutableArray * array = [NSMutableArray array];
    if (self.tiLineObjects){
        if (self.tiLineObjects.count > 0) {
            [self sortTiLineObject:self.tiLineObjects];
        }
        for (ChartLineObject * obj in self.tiLineObjects){
            ChartData * data = [obj.chartDataDict objectForKey:groupKey];
            if (data){
                if ([data isEmpty]){
                    [array addObject:
                        @{
                            @"color"    : [obj colorWithChartData:data],
                            @"name"     : obj.dataName,
                            @"date"     : data.date,
                        }];
                } else if ([obj isKindOfClass:[ChartLineObjectSingleValue class]]){
                    CGFloat value = [obj getValueForKey:groupKey forDisplayType:((ChartLineObjectSingleValue *)obj).displayType];
                    if ([obj.refKey isEqualToString:@"RAvg"]) {
                        continue;
                    }
                    [array addObject:
                        @{
                            @"color"    : [obj colorWithChartData:data],
                            @"name"     : obj.dataName,
                            @"date"     : data.date,
                            @"value"    : [self formatValue:value],
                        }];
                } else {
                    CGFloat value = [obj getValueForKey:groupKey forDisplayType:ChartDataDisplayTypeClose];
                    if ([obj.refKey isEqualToString:@"RAvg"]) {
                        continue;
                    }
                    [array addObject:
                        @{
                            @"color"    : [obj colorWithChartData:data],
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
    RocClass *rocClass = new RocClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        rocClass->setDayInterval((int)self.unit.day);
        
        MapofAll *newMapOfAll =(MapofAll*)rocClass->calculate((void *)&MapOfAll);
        
        if (newMapOfAll != NULL) {
            MapofAll::iterator iterofAll;
            for (iterofAll = newMapOfAll->begin(); iterofAll != newMapOfAll->end(); iterofAll++) {
                NSString *lineKey = [NSString stringWithFormat:@"%s", iterofAll->first.c_str()];
                MapofLine *pMap = iterofAll->second;
                
                NSInteger lineSize = [dataList count];
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

                    [chartObjAry addObject:data];
                }
                
                if (chartObjAry) {
                    ChartLineObjectLine *lineObj = [[ChartLineObjectLine alloc] init];
                    lineObj.refKey = lineKey;
                    lineObj.dataName = [self.unit objectKey:lineKey];
                    
                    UIColor *mainColor = self.unit.rocColor;
                    if ([lineKey isEqualToString:@"ROC"]) {
                        mainColor = self.unit.rocColor;
                    } else if ([lineKey isEqualToString:@"RAvg"]) {
                        mainColor = self.unit.ravgColor;
                    }
                    lineObj.mainColor = mainColor;
                    
                    [lineObj setChartDataByChartDataList:chartObjAry];
                    [resultArray addObject:lineObj];
                }
            }
        }
        

    }
    
    return resultArray;
}

- (NSString *)formatValue:(CGFloat)value {
    return [ChartCommonUtil formatFloatValue:value byFormat:@"0.000" groupKMB:NO];
}

// Private
- (MapofAll)ConvertToMapOfAll:(NSArray*)dataList
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

    rArray = [lineObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ChartLineObject *lineObj1 = obj1;
//        ChartLineObject *lineObj2 = obj2;
        
        NSComparisonResult result = NSOrderedSame;
        
        if ([lineObj1.refKey isEqualToString:@"ROC"]) {
            result = NSOrderedAscending;
        } else if ([lineObj1.refKey isEqualToString:@"RAvg"]) {
            result = NSOrderedDescending;
        }
        return result;
    }];
    return rArray;
}


@end
