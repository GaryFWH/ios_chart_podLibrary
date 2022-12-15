//
//  MainTISAR.m
//  ChartLibraryDemo
//
//  Created by Gary on 29/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "MainTISAR.h"
#import "SarClass.h"
#import "ChartCommonUtil.h"

@implementation MainTISARUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";

    if ([lineKey isEqualToString:@"SAR"]) {
        rKey = [NSString stringWithFormat:@"SAR"];
    }
    return rKey;
}

@end

@implementation MainTISAR

-(void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[MainTISARUnit alloc] init];
    self.unit.minSpeed = tiConfig.tiSARaccFactor;
    self.unit.maxSpeed = tiConfig.tiSARmaxAccFactor;
    self.unit.sarColor = colorConfig.tiSAR;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"SAR"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectScatter class]]){
                    ((ChartLineObjectScatter *)lineObj).mainColor = colorConfig.tiBBUpper;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    SarClass *sarClass = new SarClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        sarClass->setMinSpeed(self.unit.minSpeed);
        sarClass->setMaxSpeed(self.unit.maxSpeed);
        
        MapofAll *newMapOfAll =(MapofAll*)sarClass->calculate((void *)&MapOfAll);

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
                    ChartLineObjectScatter *lineObj = [[ChartLineObjectScatter alloc] init];
    //                lineObj.refKey = NSStringFromClass([self class]);
                    lineObj.refKey = [self.unit objectKey:lineKey];
                    if ([lineKey isEqualToString:@"SAR"]) {
                        lineObj.mainColor = self.unit.sarColor;
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
    
    return resultArray;
}
- (NSString *)formatValue:(CGFloat)value
{
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
@end
