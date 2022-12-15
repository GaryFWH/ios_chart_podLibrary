//
//  ChartTI.h
//  ChartLibraryDemo
//
//  Created by william on 2/6/2021.
//  Copyright © 2021 william. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ChartLineObject.h"
#import "ChartColorConfig.h"
#import "ChartTIConfig.h"
#import "ChartCommonUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartTI : NSObject

@property (retain, nonatomic) NSArray<ChartLineObject *> * tiLineObjects;

+ (NSString *)refKeyForChart;
- (NSString *)refKeyForChart;
//- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList;
//- (void)initChartObjectListFromChartData:(NSArray *)dataList;
- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig;
- (void)createDefaultDataList;

- (NSArray *)dataDictsForGroupingKey:(NSString *)groupKey;
- (NSString *)formatValue:(CGFloat)value;
- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig;
//- (void)updateLineObjectColorByChartTIConfig:(ChartTIConfig *)tiConfig;


@end

NS_ASSUME_NONNULL_END
