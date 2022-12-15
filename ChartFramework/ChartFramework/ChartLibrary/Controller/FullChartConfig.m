//
//  FullChartConfig.m
//  ChartLibraryDemo
//
//  Created by william on 16/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "FullChartConfig.h"

@implementation FullChartConfig

- (instancetype)initDefault {
    if (self = [super initDefault]){
        self.tiConfig = [[ChartTIConfig alloc] initDefault];
    }
    return self;
}

- (instancetype)initDefaultWithColorConfig:(ChartColorConfig *)colorConfig WithTIConfig:(ChartTIConfig *)tiConfig {
    if (self = [self initDefaultWithColorConfig:colorConfig]){
        self.tiConfig = tiConfig;
    }
    return self;
}

- (void)resetDefault {
    [super resetDefault];
    self.mainChartHeight = 200.f;
    self.tiChartHeight = 100.f;
    self.tiChartGap = 10.f;
    self.subChartYAxisLineNum = 2;
    self.subChartYAxisRangeDiffGapScale = 0.2;
    self.subChartYAxisGapPixel = CHARTTEXTBOXINFOHEIGHT; // default chartTextBoxInfo.rect.height
    self.subChartYAxisGapType = ChartYAxisGapTypeScale;
}

- (CGFloat)getSubChartYAxisRangeDiffGapScaleForChartHeight:(CGFloat)chartHeight {
    return self.subChartYAxisGapPixel /(chartHeight - 2 * self.subChartYAxisGapPixel);
}




//- (void)setTiChartGap:(CGFloat)tiChartGap {
//    _tiChartGap = tiChartGap;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateTiHeight)]){
//        [(id<FullChartConfigUpdateDelegate>)self.configDelegate chartConfigUpdateTiHeight];
//    }
//}
//
//- (void)setTiChartHeight:(CGFloat)tiChartHeight {
//    _tiChartHeight = tiChartHeight;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateTiHeight)]){
//        [(id<FullChartConfigUpdateDelegate>)self.configDelegate chartConfigUpdateTiHeight];
//    }
//}

@end
