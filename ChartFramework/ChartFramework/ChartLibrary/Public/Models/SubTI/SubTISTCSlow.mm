//
//  SubTISTCSlow.m
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTISTCSlow.h"
#import "StcClass.h"
#import "ChartCommonUtil.h"

@implementation SubTISTCSlowUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"%SK"]) {
        rKey = [NSString stringWithFormat:@"%zd%%SK", self.skDay];
    } else if ([lineKey isEqualToString:@"%SD"]){
        rKey = [NSString stringWithFormat:@"%zd%%SD", self.sdDay];
    }
    return rKey;
}

@end

@implementation SubTISTCSlow

- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTISTCSlowUnit alloc] init];
    self.unit.skDay = tiConfig.tiSTCSlowSK;
    self.unit.sdDay = tiConfig.tiSTCSlowSD;
    self.unit.skColor = colorConfig.tiSTCSlowK;
    self.unit.sdColor = colorConfig.tiSTCSlowD;
    self.unit.type = 0;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"%SK"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiSTCSlowK;
                }
            }
            if ([lineObj.refKey isEqualToString:@"%SD"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiSTCSlowD;
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
        stcClass->setpKDay(self.unit.skDay);
        stcClass->setpDDay(self.unit.sdDay);
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
                    
                    if ([lineKey isEqualToString:@"%SK"]) {
                        lineObj.mainColor = self.unit.skColor;
                    } else if ([lineKey isEqualToString:@"%SD"]) {
                        lineObj.mainColor = self.unit.sdColor;
                        lineObj.tail = @"STC (Slow)";
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
//    if ([key isEqualToString:@"%SD"])
//        return [ChartCommonUtil formatFloatValue:value byFormat:@"0.000" groupKMB:NO withIndex:key];
//    else
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
        
        if ([lineObj1.refKey containsString:@"%SD"]) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];

    return rArray;
}
@end
