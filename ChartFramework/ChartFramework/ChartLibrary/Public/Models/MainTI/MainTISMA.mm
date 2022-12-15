//
//  MainTISMA.m
//  ChartLibraryDemo
//
//  Created by william on 1/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import "MainTISMA.h"
#import "SmaClass.h"
#import "ChartColorConfig.h"

@implementation MainTISMAUnit

- (NSString *)objectKey {
    return [NSString stringWithFormat:@"%zd-SMA", self.day];
}

@end

@implementation MainTISMA

- (void)createDefaultDataList {
    MainTISMAUnit * unit1 = [[MainTISMAUnit alloc] init];
    MainTISMAUnit * unit2 = [[MainTISMAUnit alloc] init];
    MainTISMAUnit * unit3 = [[MainTISMAUnit alloc] init];
    MainTISMAUnit * unit4 = [[MainTISMAUnit alloc] init];
    unit1.day = 10;
    unit2.day = 20;
    unit3.day = 50;
    unit4.day = 100;
    
    unit1.color = [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f];
    unit2.color = [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f];
    unit3.color = [ChartColorConfig color255WithRed:244.f green:121.f blue:32.f alpha:1.f];
    unit4.color = [ChartColorConfig color255WithRed:125.f green:168.f blue:0.f alpha:1.f];
    
    self.dataList = @[unit1, unit2, unit3, unit4];
}

- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig {
    NSArray * smaDayList = tiConfig.tiSMADayList;
    NSArray * smaColorList = colorConfig.tiSMAColorList;
    
    NSInteger count = [smaDayList count];
    if ([smaDayList count] > [smaColorList count]){
        count = [smaColorList count];
    }
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++){
        MainTISMAUnit * unit = [[MainTISMAUnit alloc] init];
        unit.day = [[smaDayList objectAtIndex:i] integerValue];
        unit.color = [smaColorList objectAtIndex:i];
        [mutArray addObject:unit];
    }
    
    self.dataList = [NSArray arrayWithArray:mutArray];
    
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}



- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList{
    NSMutableArray * resultArray = [NSMutableArray array];
    SmaClass * smaClass = new SmaClass();
    for (MainTISMAUnit * unit in self.dataList){
        NSInteger lineSize = [dataList count];
        float inputList[lineSize];
        int i = 0;
        for (ChartData * data in dataList){
            inputList[i] = data.close;
            i++;
        }
        float outputList[lineSize];
        for (int m = 0; m < lineSize; m ++) {
            outputList[m] = -0.0001f;
        }
        if (smaClass->CalcSMA(inputList, outputList, lineSize, 0, unit.day)){
//            NSMutableDictionary * chartObjDict = [NSMutableDictionary dictionary];
            NSMutableArray * chartObjList = [NSMutableArray array];
            for (NSInteger i = 0; i < lineSize; i++){
                ChartData * data = [[ChartData alloc] init];
                ChartData * oldData = [dataList objectAtIndex:i];
                data.groupingKey = oldData.groupingKey;
                data.date = oldData.date;
                data.open = outputList[i];
                data.close = outputList[i];
                data.high = outputList[i];
                data.low = outputList[i];
                data.volume = outputList[i];
                [chartObjList addObject:data];
//                [chartObjDict setObject:data forKey:oldData.groupingKey];
            }
//            if (chartObjDict){
            if (chartObjList){
                ChartLineObjectLine * lineObj = [[ChartLineObjectLine alloc] init];
//                lineObj.refKey = NSStringFromClass([self class]);
                
                lineObj.refKey = [unit objectKey];
//                lineObj.dataName = [unit objectKey];

                lineObj.mainColor = unit.color;
                [lineObj setChartDataByChartDataList:chartObjList];
//                [lineObj setChartDataDict:chartObjDict];
                [resultArray addObject:lineObj];
            }
        }
    }
    return resultArray;
}

- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig {
    if (colorConfig && colorConfig.tiSMAColorList && [colorConfig.tiSMAColorList count]){
        for (NSInteger i = 0; i < [self.tiLineObjects count] && i < [colorConfig.tiSMAColorList count]; i++){
            ChartLineObject * lineObj = [self.tiLineObjects objectAtIndex:i];
            UIColor * color = [colorConfig.tiSMAColorList objectAtIndex:i];
            if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
                ((ChartLineObjectLine *)lineObj).mainColor = color;
            }
        }
    }
}


@end
