//
//  SmallChartViewController.h
//  ChartLibraryDemo
//
//  Created by william on 10/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartData.h"
#import "ChartConfig.h"
#import "BaseChartViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallChartViewController : BaseChartViewController

//- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config;

//- (void)setSelectDateFormat:(NSDateFormatter *)format;

- (void)setChartTI:(ChartMainTIEnum)chartTi withTIConfig:(ChartTIConfig *)tiConfig;

- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList;

- (void)setPrevClose:(float)prevClose;

//- (void)initMainChartData:(NSArray<ChartData *> *)dataList;
- (void)addMainChartData:(ChartData *)data;

@end

NS_ASSUME_NONNULL_END
