//
//  SubTIWilliam.m
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//
#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIWilliam.h"
#import "WilliamClass.h"

@implementation SubTIWilliamUnit
- (NSString *)objectKey:(NSString*)lineKey {
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"WILL"]) {
        rKey = [NSString stringWithFormat:@"%zd WILL %%R", self.diff];
    } else if ([lineKey isEqualToString:@"WSMA"]){
        rKey = [NSString stringWithFormat:@"%zd-SMA", self.smaDay];

    }
    return rKey;
}
@end

@implementation SubTIWilliam

- (void)createDefaultDataList
{
//    SubTIWilliamUnit *unit = [[SubTIWilliamUnit alloc] init];
    self.unit = [[SubTIWilliamUnit alloc] init];
    
    self.unit.diff = 14;
    self.unit.bShowSma = true;
    self.unit.smaDay = 5;
    self.unit.williamColor = [UIColor blueColor];
    self.unit.smaColor = [UIColor redColor];
    
//    self.dataList = @[self.unit];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIWilliamUnit alloc] init];
    
    self.unit.diff = tiConfig.tiWillInterval;
    self.unit.bShowSma = tiConfig.tiWillSmaShow;
    self.unit.smaDay = tiConfig.tiWillSma;
    self.unit.williamColor = colorConfig.tiWillWill;
    self.unit.smaColor = colorConfig.tiWillSMA;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig {
    if (self.unit) {
        for (ChartLineObject* lineObject in self.tiLineObjects) {
            if ([lineObject.refKey isEqualToString:@"WILL"]) {
                if ([lineObject isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine*)lineObject).mainColor = colorConfig.self.tiWillWill;
                }
            }
            if ([lineObject.refKey isEqualToString:@"SMA"]) {
                if ([lineObject isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine*)lineObject).mainColor = colorConfig.self.tiWillSMA;
                }
            }
        }
    }
}

- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    WilliamClass *williamClass = new WilliamClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        williamClass->setDiff(self.unit.diff);
        williamClass->setShowSma(self.unit.bShowSma);
        williamClass->setSmaDay(self.unit.smaDay);
        
        MapofAll *newMapOfAll =(MapofAll*)williamClass->calculate((void *)&MapOfAll);
        
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
                    if ([lineKey isEqualToString:@"WILL"]) {
                        lineObj.mainColor = self.unit.williamColor;
                    } else if ([lineKey isEqualToString:@"WSMA"]){
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

@end

