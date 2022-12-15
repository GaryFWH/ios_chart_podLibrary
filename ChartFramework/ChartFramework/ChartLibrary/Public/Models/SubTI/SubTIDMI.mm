//
//  SubTIDMI.m
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIDMI.h"
#import "DmiClass.h"

@implementation SubTIDMIUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if ([lineKey isEqualToString:@"+DI"]) {
        rKey = [NSString stringWithFormat:@"+DI"];
    }
    if ([lineKey isEqualToString:@"-DI"]) {
        rKey = [NSString stringWithFormat:@"-DI"];
    }
    if ([lineKey isEqualToString:@"ADX"]) {
        rKey = [NSString stringWithFormat:@"ADX"];
    }
    if ([lineKey isEqualToString:@"ADXR"]) {
        rKey = [NSString stringWithFormat:@"ADXR"];
    }
    return rKey;
}
@end

@implementation SubTIDMI
- (void)createDefaultDataList
{
    self.unit = [[SubTIDMIUnit alloc] init];
    
    self.unit.iDMIDay = 14;
    self.unit.bShowADXR = YES;
    
    self.unit.dmiADIColor = [UIColor blueColor];
    self.unit.dmiBDIColor = [UIColor redColor];
    self.unit.dmiADXColor = [UIColor orangeColor];
    self.unit.dmiADXRColor = [UIColor greenColor];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIDMIUnit alloc] init];
    
    self.unit.iDMIDay = tiConfig.tiDMIInterval;
    self.unit.bShowADXR = tiConfig.tiDMIADXRShow;
    
    self.unit.dmiADIColor = colorConfig.tiDmiADI;
    self.unit.dmiBDIColor = colorConfig.tiDmiBDI;
    self.unit.dmiADXColor = colorConfig.tiDmiADX;
    self.unit.dmiADXRColor = colorConfig.tiDmiADXR;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}

- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"+DI"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiDmiADI;
                }
            }
            if ([lineObj.refKey isEqualToString:@"-DI"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiDmiBDI;
                }
            }
            if ([lineObj.refKey isEqualToString:@"ADX"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiDmiADX;
                }
            }
            if ([lineObj.refKey isEqualToString:@"ADXR"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiDmiADXR;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    DmiClass *dmiClass = new DmiClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        dmiClass->setDayInterval(self.unit.iDMIDay);
        dmiClass->setShowADXR(self.unit.bShowADXR);
        
        MapofAll *newMapOfAll =(MapofAll*)dmiClass->calculate((void *)&MapOfAll);
        
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
                    
                    UIColor *mainColor = self.unit.dmiADIColor;
                    if ([lineKey isEqualToString:@"+DI"]) {
                        mainColor = self.unit.dmiADIColor;
                    }
                    else if ([lineKey isEqualToString:@"-DI"]) {
                        mainColor = self.unit.dmiBDIColor;
                    }
                    else if ([lineKey isEqualToString:@"ADX"]) {
                        mainColor = self.unit.dmiADXColor;
                    }
                    else if ([lineKey isEqualToString:@"ADXR"]) {
                        mainColor = self.unit.dmiADXRColor;
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

@end
