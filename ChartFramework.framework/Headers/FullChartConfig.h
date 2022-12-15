//
//  FullChartConfig.h
//  ChartLibraryDemo
//
//  Created by william on 16/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartConfig.h"
#import "ChartTIConfig.h"
NS_ASSUME_NONNULL_BEGIN



//@protocol FullChartConfigUpdateDelegate;
@interface FullChartConfig : ChartConfig

//@property (nonatomic, assign) id<FullChartConfigUpdateDelegate> configDelegate;
@property (nonatomic, assign) CGFloat mainChartHeight;
@property (nonatomic, assign) CGFloat tiChartHeight;
@property (nonatomic, assign) CGFloat tiChartGap;

@property (nonatomic, assign) NSInteger subChartYAxisLineNum;
@property (nonatomic, assign) CGFloat   subChartYAxisRangeDiffGapScale;
@property (nonatomic, assign) CGFloat   subChartYAxisGapPixel;

@property (nonatomic, assign) ChartYAxisGapType subChartYAxisGapType;
@property (nonatomic, strong) ChartTIConfig * tiConfig;

- (instancetype)initDefaultWithColorConfig:(ChartColorConfig *)colorConfig WithTIConfig:(ChartTIConfig *)tiConfig;

- (CGFloat)getSubChartYAxisRangeDiffGapScaleForChartHeight:(CGFloat)chartHeight;

@end

//@protocol FullChartConfigUpdateDelegate <ChartConfigUpdateDelegate>
//
//- (void)chartConfigUpdateTiHeight;
//
//@end

NS_ASSUME_NONNULL_END
