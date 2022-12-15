//
//  SubTIVolumn.m
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//
#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIVolumn.h"
#import "VolumeClass.h"
#import "ChartCommonUtil.h"

@implementation SubTIVolumnUnit

- (NSString *)objectKey:(NSString*)lineKey {
    NSString *rKey = @"";
    
    if ([lineKey isEqualToString:@"VOL"]) {
        rKey = [NSString stringWithFormat:@"VOL"];
    } else if ([lineKey isEqualToString:@"VOLSMA"]) {
        rKey = [NSString stringWithFormat:@"%zd-SMA", self.smaDay];
    }
    
    return rKey;
}

@end

@implementation SubTIVolumn

- (void)createDefaultDataList
{
//    SubTIVolumnUnit *unit = [[SubTIVolumnUnit alloc] init];
    self.unit = [[SubTIVolumnUnit alloc] init];
    
    self.unit.day = 14;
    self.unit.bShowSma = true;
    self.unit.smaDay = 5;
    self.unit.volUpColor = [UIColor redColor];
    self.unit.volDownColor = [UIColor blueColor];
    self.unit.smaColor = [UIColor redColor];
    
    // self.dataList = @[self.unit];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIVolumnUnit alloc] init];
    
    self.unit.day = 14;
    self.unit.bShowSma = tiConfig.tiVOLSMAShow;
    self.unit.smaDay = tiConfig.tiVOLSMA;
    self.unit.volUpColor = colorConfig.tiVolUp;
    self.unit.volDownColor = colorConfig.tiVolDown;
    self.unit.smaColor = colorConfig.tiVolSma;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject* lineObject in self.tiLineObjects) {
            if ([lineObject.refKey isEqualToString:@"VOL"]) {
                if ([lineObject isKindOfClass:[ChartLineObjectHisto class]]) {
                    ((ChartLineObjectHisto*)lineObject).upColor = colorConfig.self.tiVolUp;
                    ((ChartLineObjectHisto*)lineObject).downColor = colorConfig.self.tiVolDown;
                }
            }
            if ([lineObject.refKey isEqualToString:@"VOLSMA"]) {
                if ([lineObject isKindOfClass:[ChartLineObjectLine class]]) {
                    ((ChartLineObjectLine*)lineObject).mainColor = colorConfig.self.tiVolSma;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    VolumeClass *volClass = new VolumeClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        volClass->setDay(self.unit.day);
        volClass->setbShowSma(self.unit.bShowSma);
        volClass->setSma(self.unit.smaDay);
        
        MapofAll *newMapOfAll =(MapofAll*)volClass->calculate((void *)&MapOfAll);
        
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
                        
                        data.groupingKey = oldData.groupingKey;
                        data.date   = oldData.date;
                        data.open   = cData->open;
                        data.close  = cData->close;
                        data.high   = cData->high;
                        data.low    = cData->low;
                        data.volume = cData->volume;
    //                    [chartObjDict setObject:data forKey:oldData.groupingKey];
                        [chartObjAry addObject:data];
                    }
                }
                
                if (chartObjAry) {
                    if ([lineKey isEqualToString:@"VOL"]) {
                        ChartLineObjectHisto *histoObj = [[ChartLineObjectHisto alloc] init];
    //                    histoObj.refKey = NSStringFromClass([self class]);
                        histoObj.refKey = lineKey;
                        histoObj.dataName = [self.unit objectKey:lineKey];
                        histoObj.upColor = self.unit.volUpColor;
                        histoObj.downColor = self.unit.volDownColor;
                        histoObj.displayType = ChartDataDisplayTypeVolume;
                        [histoObj setChartDataByChartDataList:chartObjAry];
                        [resultArray addObject:histoObj];
                    } else if ([lineKey isEqualToString:@"VOLSMA"]) {
                        ChartLineObjectLine *lineObj = [[ChartLineObjectLine alloc] init];
    //                    lineObj.refKey = NSStringFromClass([self class]);
                        lineObj.refKey = lineKey;
                        lineObj.dataName = [self.unit objectKey:lineKey];
                        lineObj.mainColor = self.unit.smaColor;
                        lineObj.displayType = ChartDataDisplayTypeClose;
                        [lineObj setChartDataByChartDataList:chartObjAry];
                        [resultArray addObject:lineObj];
                    }
                }
            }
        }
    }
    
    return resultArray;
}

- (NSArray *)dataDictsForGroupingKey:(NSString *)groupKey {
    //Default
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    if (self.tiLineObjects){
        for (ChartLineObject * obj in self.tiLineObjects){
            ChartData * data = [obj.chartDataDict objectForKey:groupKey];
            if (data){
                //if (![obj.dataName isEqualToString:@""]) {
                    if ([data isEmpty]){
                        [array addObject:
                            @{
                                @"color": [obj colorWithChartData:data],
                                // @"name": obj.refKey,
                                @"name": obj.dataName,
                                @"date" : data.date,
                            }];
                    } else if ([obj isKindOfClass:[ChartLineObjectSingleValue class]]){
                        CGFloat value = [obj getValueForKey:groupKey forDisplayType:((ChartLineObjectSingleValue *)obj).displayType];
                        if (obj.tail != nil && ![obj.tail isEqualToString:@""]) {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:NO],
                                    @"tail"     : obj.tail,
                                }];
                        } else {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:NO],
                                }];
                        }
                        
                    } else {
                        CGFloat value = [obj getValueForKey:groupKey forDisplayType:ChartDataDisplayTypeClose];
                        if (obj.tail != nil && [obj.tail isEqualToString:@""]) {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:NO],
                                    @"tail"     : obj.tail,
                                }];
                        } else {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:NO],
                                }];
                        }
                        

                    }
                    
//                    NSLog(@"Ti.dataDict name %@ value %@", obj.refKey, [self formatValue:data.close]);
               // }
            }
        }
    }
    return array;
}

- (NSString *)formatValue:(CGFloat)value
{
    return [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:YES];
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
            
//            NSLog(@"chartData - high %.2f low %.2f", data.high, data.low);
            pMapOfLine->insert(pair<string, chartData*>(sKey,cData));
        }
        
    }
    pMapOfAll.insert(pair<string, MapofLine*>([@"MainData" UTF8String], pMapOfLine));
    
    return pMapOfAll;
}
@end
