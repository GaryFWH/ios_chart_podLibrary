//
//  MainTIBB.m
//  ChartLibraryDemo
//
//  Created by Gary on 29/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "MainTIBB.h"
#import "BbClass.h"
#import "ChartCommonUtil.h"

@implementation MainTIBBUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";

    if ([lineKey isEqualToString:@"Upper"]) {
        rKey = [NSString stringWithFormat:@"Upper BB"];
    } else if ([lineKey isEqualToString:@"Middle"]) {
        rKey = [NSString stringWithFormat:@"Middle BB"];
    } else if ([lineKey isEqualToString:@"Lower"]) {
        rKey = [NSString stringWithFormat:@"Lower BB"];
    }
    return rKey;
}

@end

@implementation  MainTIBB

- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[MainTIBBUnit alloc] init];
    self.unit.bollDay = tiConfig.tiBBIntervals;
    self.unit.noStdDev = tiConfig.tiBBStdDev;
    self.unit.upperBBColor = colorConfig.tiBBUpper;
    self.unit.middleBBColor = colorConfig.tiBBMiddle;
    self.unit.lowerBBColor = colorConfig.tiBBLower;


    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
//            if ([lineObj.refKey isEqualToString:@"Upper"]) {
            if ([lineObj.refKey containsString:@"Upper"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiBBUpper;
                }
            }
//            if ([lineObj.refKey isEqualToString:@"Middle"]) {
            if ([lineObj.refKey containsString:@"Middle"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiBBMiddle;
                }
            }
//            if ([lineObj.refKey isEqualToString:@"Lower"]) {
            if ([lineObj.refKey containsString:@"Lower"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiBBLower;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    BbClass *bbClass = new BbClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        bbClass->setBollDays((int)self.unit.bollDay);
        bbClass->setnoStdDev(self.unit.noStdDev);
        
        MapofAll *newMapOfAll =(MapofAll*)bbClass->calculate((void *)&MapOfAll);
        
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
                    lineObj.refKey = [self.unit objectKey:lineKey];
                    
//                    NSLog(@"BB.refKey %@", lineKey);
                    
                    lineObj.dataName = [self.unit objectKey:lineKey];
                    if ([lineKey isEqualToString:@"Upper"]) {
                        lineObj.mainColor = self.unit.upperBBColor;
                    } else if ([lineKey isEqualToString:@"Middle"]) {
                        lineObj.mainColor = self.unit.middleBBColor;
                    } else if ([lineKey isEqualToString:@"Lower"]) {
                        lineObj.mainColor = self.unit.lowerBBColor;
                    } else if ([lineKey isEqualToString:@"MainData"]) {
                        continue;
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
- (NSString *)formatValue:(CGFloat)value
{
//    NSLog(@"BB value %f  formatVal %@", value, [ChartCommonUtil formatFloatValue:value byFormat:@"0.00" groupKMB:NO]);
    return [ChartCommonUtil formatFloatValue:value byFormat:@"0.00" groupKMB:NO];
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
- (NSMutableArray*)sortTiLineObject:(NSMutableArray*)lineObjects
{
    NSMutableArray *rArray = [NSMutableArray array];
    if (lineObjects && [lineObjects count]) {
        rArray = lineObjects;
    }
    
    [lineObjects sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ChartLineObject *lineObj1 = obj1;
        ChartLineObject *lineObj2 = obj2;
        
        NSComparisonResult result = NSOrderedSame;
        
        if ([lineObj1.refKey containsString:@"Lower"]) {
            result = NSOrderedDescending;
        } else if ([lineObj1.refKey containsString:@"Middle"]) {
            if ([lineObj2.refKey containsString:@"Lower"]) {
                result =  NSOrderedAscending;
            } else if ([lineObj2.refKey containsString:@"Upper"]) {
                result =  NSOrderedDescending;
            }
        } else if ([lineObj1.refKey containsString:@"Upper"]) {
            result =  NSOrderedAscending;
        }
        
        return result;
    }];

    return rArray;
}
@end
