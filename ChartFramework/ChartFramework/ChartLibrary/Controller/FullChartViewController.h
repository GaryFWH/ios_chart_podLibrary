//
//  ChartViewController.h
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartData.h"
#import "ChartTI.h"
#import "FullChartConfig.h"
#import "BaseChartViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FullChartState){
    FullChartStateDisplay,
    FullChartStateControl,
};

@protocol FullChartViewControllerDelegate;
@interface FullChartViewController : BaseChartViewController


@property (nonatomic, assign) id<FullChartViewControllerDelegate> chartDelegate;
//- (instancetype)initWithContainerView:(UIView *)view;
//- (instancetype)initWithContainerView:(UIView *)view withConfig:(FullChartConfig *)config;

//- (void)initMainChartData:(NSArray<ChartData *> *)dataList;
//- (void)addMainChartData:(ChartData *)data;

//- (void)setMainTI:(ChartTI *)mainTI;
- (void)setMainTi:(ChartMainTIEnum) mainTi;
- (void)setSubTiList:(NSArray *)subTIList;

- (void)addSubTI:(ChartSubTIEnum)subTI;
- (void)removeSubTI:(ChartSubTIEnum)subTI;

- (ChartMainTIEnum)getCurrentMainTI;
- (NSArray *)getCurrentSubTIList;
- (ChartTIConfig*)getTiConfig;
- (FullChartConfig*)getFullChartConfig;

//- (void)updateChartWidth:(CGFloat)width;
//- (void)updateMainChartHeight:(CGFloat)height;
//- (void)updateTiChartHeight:(CGFloat)height;
//- (void)updateValueFormat:(NSString *)valueFormat;
//- (void)updateDateFormat:(NSString *)dateFormat;
//- (void)updateFullChartFrame;
- (void)updateTiChartContentSize;
- (void)updateSubChartView;


- (void)updateMainChartHeight:(CGFloat)height;
- (void)updateTiChartHeight:(CGFloat)height tiGap:(CGFloat)gap;
- (void)updateChartTiConfig:(ChartTIConfig*)tiConfig;
- (void)displaySelectedChartData:(nullable NSString *)key;
//- (ChartData*)getSelectedChartData:(nullable NSString *)key;

- (void)updateTimeZone:(NSTimeZone *)timezone;

@end

@protocol FullChartViewControllerDelegate <NSObject>

- (void)displaySelectedMainChartData:(ChartData *)data;
- (ChartData *)getSelectedChartData:(nullable NSString *)key;
- (void)didChangeChartViewContentOffset:(ChartView*)chartView ContentOffset:(CGPoint)contentOffset;

@end

NS_ASSUME_NONNULL_END
