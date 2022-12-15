//
//  MultiChartView.h
//  ChartLibraryDemo
//
//  Created by william on 3/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiChartView : ChartView

@property (strong, nonatomic) NSMutableArray<NSString *> * chartClassListOrder;
@property (strong, nonatomic) NSMutableDictionary<NSString *, ChartClass *> * chartClassListDict;
//- (NSArray<ChartClass *> *)chartClassSorted;


- (NSString *)identifierForChartClass:(ChartClass *)chartClass;

- (void)removeAllChartClass;
//- (void)updateChartGlobalSettingForChart:(NSString *)chartName withSetting:(ChartGlobalSetting *)globalSetting;

- (void)updateAllClassForContentOffset:(CGPoint )contentOffset;

@end

NS_ASSUME_NONNULL_END
