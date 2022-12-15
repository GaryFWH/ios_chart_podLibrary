//
//  SmallChartViewController.h
//  ChartLibraryDemo
//
//  Created by william on 10/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartData.h"
#import "ChartConfig.h"
#import "ChartView.h"
#import "ChartClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseChartViewController : UIViewController <ChartClassDisplayDelegate>


- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config;

- (void)setChartViewScrollInset:(UIScrollViewContentInsetAdjustmentBehavior)behavior API_AVAILABLE(ios(11.0));
//- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList;

//- (void)setShowingRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (void)initMainChartData:(NSArray<ChartData *> *)dataList;
- (void)initMainChartData:(NSArray<ChartData *> *)dataList backgroundList:(NSArray *)backgroundList;
- (void)addMainChartData:(ChartData *)data;
- (void)clearChartData;

- (void)updateMainChartType:(ChartLineType)lineType;
- (void)updateYAxisWidth:(CGFloat)yAxisWidth xAxisHeight:(CGFloat)xAxisHeight;
- (void)updateChartColorConfig:(ChartColorConfig *)chartColorConfig;
- (void)updateDateDisplayFormat:(NSString *)dateDisplayFormat;
- (void)updateSelectDateFormat:(NSString *)format;
- (void)updateChartConfig:(ChartConfig*)config;

//- (void)initBasicConfig;
- (void)initView;
- (void)updateChartContentSize;
- (void)updateColor;
- (void)scrollToContentOffsetX:(CGFloat)x;
- (void)updateChartViewDisplay;
//- (void)updateLayoutWithSize:(CGSize)size;
- (void)updateLayoutAfterResize;
//- (void)initBasicConfig; 

- (void)setBackgroundList:(NSArray *)backgroundList;
- (NSArray *)getBackgroundList;
- (ChartView *)getChartView;
- (ChartConfig *)getChartConfig;
- (ChartGlobalSetting *)getChartGlobalSetting;
- (NSArray<ChartData *> *)getChartDataList;

- (NSDictionary *)exportAllChartData;

- (NSString *)formatSelectDate:(NSDate *)date;
- (void)setShowingRangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)setShowingRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (void)enableCursor:(BOOL)bDrawCursor;
@end

NS_ASSUME_NONNULL_END
