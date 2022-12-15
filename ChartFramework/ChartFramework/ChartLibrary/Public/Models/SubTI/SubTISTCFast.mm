//
//  SubTISTCFast.m
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTISTCFast.h"
#import "StcClass.h"

@implementation SubTISTCFastUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"%K"]) {
        rKey = [NSString stringWithFormat:@"%zd%%K", self.kDay];
    } else if ([lineKey isEqualToString:@"%D"]){
        rKey = [NSString stringWithFormat:@"%zd%%D", self.dDay];
    }
    return rKey;
}

@end

@implementation SubTISTCFast

- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTISTCFastUnit alloc] init];
    self.unit.kDay = tiConfig.tiSTCFastK;
    self.unit.dDay = tiConfig.tiSTCFastD;
    self.unit.kColor = colorConfig.tiSTCFastK;
    self.unit.dColor = colorConfig.tiSTCFastD;
    self.unit.type = 1;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"%K"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiSTCFastK;
                }
            }
            if ([lineObj.refKey isEqualToString:@"%D"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiSTCFastD;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    StcClass *stcClass = new StcClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];

    if (self.unit) {
        stcClass->setKDay(self.unit.kDay);
        stcClass->setDDay(self.unit.dDay);
        stcClass->setType(self.unit.type);
    
        MapofAll *newMapOfAll =(MapofAll*)stcClass->calculate((void *)&MapOfAll);

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
                    if ([lineKey isEqualToString:@"%K"]) {
                        lineObj.mainColor = self.unit.kColor;
                    } else if ([lineKey isEqualToString:@"%D"]) {
                        lineObj.mainColor = self.unit.dColor;
                        lineObj.tail = @"STC";
                    }
    //                [lineObj setChartDataDict:chartObjDict];
                    [lineObj setChartDataByChartDataList:chartObjAry];
                    [resultArray addObject:lineObj];
                }
            }
        }
    }
    
    if (resultArray && [resultArray count]) {
        [self sortTiLineObject:resultArray];
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
- (NSMutableArray*)sortTiLineObject:(NSMutableArray*)lineObjects {
    NSMutableArray *rArray = [NSMutableArray array];
    if (lineObjects && [lineObjects count]) {
        rArray = lineObjects;
    }
    
    [lineObjects sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ChartLineObject *lineObj1 = obj1;
//        ChartLineObject *lineObj2 = obj2;
        
        if ([lineObj1.refKey containsString:@"%D"]) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];

    return rArray;
}
@end
