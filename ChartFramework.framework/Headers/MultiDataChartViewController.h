//
//  MultiDataChartViewController.h
//  ChartLibraryDemo
//
//  Created by william on 17/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "FullChartViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface MultiDataChartList : NSObject

@property (nonatomic, strong) UIColor * mainColor;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) ChartLineType chartLineType;
@property (nonatomic, strong) NSMutableArray<ChartData *> * dataList;
@property (nonatomic, assign) CGFloat prevData;

@end

@interface MultiDataChartViewController : FullChartViewController


- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList;

- (void)initChartDataLists:(NSArray<MultiDataChartList *> *)list refList:(NSArray<ChartData *> *)refList;

- (void)addChartData:(ChartData *)chartData forName:(NSString *)name;
//- (void)updateMainChartHeight:(CGFloat)height;
//- (void)updateTiChartHeight:(CGFloat)height tiGap:(CGFloat)gap;

- (NSArray<ChartData *> *)getChartDataListForIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
