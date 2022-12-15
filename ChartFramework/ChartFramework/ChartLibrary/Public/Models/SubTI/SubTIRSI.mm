//
//  SubTIRSI.m
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//
#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIRSI.h"
#import "RsiClass.h"

@implementation SubTIRSIUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"RSI"]) {
        rKey = [NSString stringWithFormat:@"%zd RSI", self.day];
    } else {
        rKey = [NSString stringWithFormat:@"%zd-SMA", self.smaDay];

    }
    return rKey;
}

@end

@implementation SubTIRSI

- (void)createDefaultDataList
{
//    SubTIRSIUnit *unit = [[SubTIRSIUnit alloc] init];
    self.unit = [[SubTIRSIUnit alloc] init];
    
    self.unit.day = 14;
    self.unit.bShowSma = true;
    self.unit.smaDay = 5;
    self.unit.rsiColor = [UIColor blueColor];
    self.unit.smaColor = [UIColor redColor];
    
//    self.dataList = @[self.unit];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIRSIUnit alloc] init];
    self.unit.day = tiConfig.tiRSIIntervals;
    self.unit.bShowSma = tiConfig.tiRSISMAShow;
    self.unit.smaDay = tiConfig.tiRSISMA;
    self.unit.rsiColor = colorConfig.tiRSIRSI;
    self.unit.smaColor = colorConfig.tiRSISMA;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"RSI"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiRSIRSI;
                }
            }
            if ([lineObj.refKey isEqualToString:@"SMA"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiRSISMA;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    RsiClass *rsiClass = new RsiClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    //for (SubTIRSIUnit * unit in self.dataList) {
    if (self.unit) {
        rsiClass->setDay(self.unit.day);
        rsiClass->setShowSma(self.unit.bShowSma);
        rsiClass->setSmaDay(self.unit.smaDay);
        
        MapofAll *newMapOfAll =(MapofAll*)rsiClass->calculate((void *)&MapOfAll);
        
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
                    ChartLineObjectLine *lineObj = [[ChartLineObjectLine alloc] init];
    //                lineObj.refKey = NSStringFromClass([self class]);
                    lineObj.refKey = lineKey;
                    lineObj.dataName = [self.unit objectKey:lineKey];
                    if ([lineKey isEqualToString:@"RSI"]) {
                        lineObj.mainColor = self.unit.rsiColor;
                    } else if ([lineKey isEqualToString:@"SMA"]) {
                        lineObj.mainColor = self.unit.smaColor;
                    }
    //                [lineObj setChartDataDict:chartObjDict];
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

@end
