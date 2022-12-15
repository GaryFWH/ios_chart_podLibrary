//
//  SubTIOBV.m
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#include "golbal.h"
#import <Foundation/Foundation.h>
#import "SubTIOBV.h"
#import "ObvClass.h"
#import "ChartCommonUtil.h"

@implementation SubTIOBVUnit

- (NSString *)objectKey:(NSString*)lineKey
{
    NSString *rKey = @"";
    if (self.bWc) {
        rKey = [NSString stringWithFormat:@"OBV(Weighted)"];
    } else {
        rKey = [NSString stringWithFormat:@"OBV"];
    }
    return rKey;
}
@end

@implementation SubTIOBV
- (void)createDefaultDataList
{
    self.unit = [[SubTIOBVUnit alloc] init];
    
    self.unit.bWc = YES;
    self.unit.obvColor = [UIColor blueColor];
}
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig
{
    self.unit = [[SubTIOBVUnit alloc] init];
    
    self.unit.bWc = tiConfig.tiOBVisWeighted;
    self.unit.obvColor = colorConfig.tiOBV;
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig
{
    if (self.unit) {
        for (ChartLineObject * lineObj in self.tiLineObjects){
            if ([lineObj.refKey isEqualToString:@"OBV"]) {
                if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                    ((ChartLineObjectLine *)lineObj).mainColor = colorConfig.tiOBV;
                }
            }
        }
    }
}
- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList
{
    NSMutableArray * resultArray = [NSMutableArray array];
    ObvClass *obvClass = new ObvClass();
    MapofAll MapOfAll = [self ConvertToMapOfAll:dataList];
    
    if (self.unit) {
        obvClass->setbWc(self.unit.bWc);
        
        MapofAll *newMapOfAll =(MapofAll*)obvClass->calculate((void *)&MapOfAll);
        
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
                    if ([lineKey isEqualToString:@"OBV"]) {
                        lineObj.mainColor = self.unit.obvColor;
                    }
                    lineObj.displayType = ChartDataDisplayTypeVolume;
                    [lineObj setChartDataByChartDataList:chartObjAry];
                    [resultArray addObject:lineObj];
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

- (NSString *)formatValue:(CGFloat)value {
    return [ChartCommonUtil formatFloatValue:value byFormat:@"#,###" groupKMB:YES];
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
