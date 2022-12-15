//
//  FullChartConfig.m
//  ChartLibraryDemo
//
//  Created by william on 7/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartConfig.h"
#import "ChartCommonUtil.h"
#import "ChartCommData.h"

@implementation ChartConfig

- (instancetype)initDefault{
    if (self = [self init]){
        [self resetDefault];
        self.colorConfig = [ChartColorConfig defaultLightConfig];
    }
    return self;
}

- (instancetype)initDefaultWithColorConfig:(ChartColorConfig *)colorConfig {
    if (self = [self init]){
        [self resetDefault];
        self.colorConfig = colorConfig;
    }
    return self;
}

- (void)resetDefault {
    self.yAxisWidth = 40.f;
    self.xAxisHeight = 20.f;
    self.xAxisPerGapScale = 0.5;
    self.displayIndexNum = 300;
    
    self.mainChartYAxisLineNum = 5;
    self.mainChartYAxisRangeDiffGapScale = 0.05;
    self.mainChartYAxisGapPixel = CHARTTEXTBOXINFOHEIGHT * 2; // default chartTextBoxInfo.rect.height (mainTI & maxVal)
    
    self.dateDisplayFormat = @"dd/MM HH:mm";
    self.mainChartValueDisplayFormat = @"0.000";
    self.subChartValueDisplayFormat = @"0.000";
    self.minMaxValueFormat = @"0.00000";
    
    self.mainChartLineType = ChartLineTypeCandle;
    
    self.minIndexNumDisplay = 10;
    self.maxIndexNumDisplay = 100;
    
    self.axisFont = [UIFont fontWithName:@"Arial" size:12.f];
    self.axisLineType = ChartAxisLineTypeDash;
    self.yAxisGapType = ChartYAxisGapTypePixel;

//    self.timeZone = [NSTimeZone systemTimeZone];
    self.timeZone = ([ChartCommData instance].timeZone) ? [ChartCommData instance].timeZone : [NSTimeZone systemTimeZone];
    self.bShowMinMax = YES;
    
    self.chartLineTypeLineLineWidth = 1;
    self.chartLineTypeAreaLineWidth = 1.5;
    
    self.chartLineTypeAreaTopColorLocation = 0.8;
    self.chartLineTypeAreaMainColorLocation = 1.0;
}


//- (CGFloat)chartWidth {
//    return self.fullWidth - self.yAxisWidth;
//}
//
//- (CGFloat)chartHeight {
//    return self.fullHeight - self.xAxisHeight;
//}

- (NSString *)formatSelectDate:(NSDate *)date {
    NSString * dateFormat = self.dateDisplayFormat;
    if (self.selectDateFormat){
        dateFormat = self.selectDateFormat;
    }
    if (!dateFormat){
        dateFormat = @"dd/MM HH:mm";
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale systemLocale]];
    if (self.timeZone) {
        [formatter setTimeZone:self.timeZone];
    }
    return [formatter stringFromDate:date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSString * dateFormat = self.dateDisplayFormat;
    if (!dateFormat){
        dateFormat = @"dd/MM HH:mm";
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale systemLocale]];
    
//    if (self.timeZone){
//        [formatter setTimeZone:self.timeZone];
//    } else {
//        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    }
    if (self.timeZone) {
        [formatter setTimeZone:self.timeZone];
    }
    return [formatter stringFromDate:date];
}

- (NSString *)formatValue:(CGFloat)value {
    NSString * valueFormat = self.mainChartValueDisplayFormat;
    if (!valueFormat){
        valueFormat = @"0.000";
    }
    return [ChartCommonUtil formatFloatValue:value byFormat:valueFormat groupKMB:NO];
}

- (NSString *)formatMinMaxValue:(CGFloat)value {
    NSString * valueFormat = self.minMaxValueFormat;
    if (!valueFormat){
        valueFormat = @"0.000";
    }
    return [ChartCommonUtil formatFloatValue:value byFormat:valueFormat groupKMB:NO];
}

- (CGFloat)getMainChartYAxisRangeDiffGapScaleForChartHeight:(CGFloat)chartHeight {
    return self.mainChartYAxisGapPixel /(chartHeight - 2 * self.mainChartYAxisGapPixel);
}

//- (void)setYAxisWidth:(CGFloat)yAxisWidth {
//    _yAxisWidth = yAxisWidth;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateWidth)]){
//        [self.configDelegate chartConfigUpdateWidth];
//    }
//}
//
////- (void)setFullWidth:(CGFloat)fullWidth {
////    _fullWidth = fullWidth;
////    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateWidth)]){
////        [self.configDelegate chartConfigUpdateWidth];
////    }
////}
//
////- (void)setFullHeight:(CGFloat)fullHeight {
////    _fullHeight = fullHeight;
////    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateHeight)]){
////        [self.configDelegate chartConfigUpdateHeight];
////    }
////}
//
//- (void)setXAxisHeight:(CGFloat)xAxisHeight {
//    _xAxisHeight = xAxisHeight;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigUpdateHeight)]){
//        [self.configDelegate chartConfigUpdateHeight];
//    }
//}
//
//- (void)setAxisFont:(UIFont *)axisFont {
//    _axisFont = axisFont;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigRequireRedraw)]){
//        [self.configDelegate chartConfigRequireRedraw];
//    }
//}
//
//- (void)setDateDisplayFormat:(NSString *)dateDisplayFormat {
//    _dateDisplayFormat = dateDisplayFormat;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigRequireRedraw)]){
//        [self.configDelegate chartConfigRequireRedraw];
//    }
//}
//
//- (void)setValueDisplayFormat:(NSString *)valueDisplayFormat {
//    _valueDisplayFormat = valueDisplayFormat;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigRequireRedraw)]){
//        [self.configDelegate chartConfigRequireRedraw];
//    }
//}
//
//- (void)setColorConfig:(ChartColorConfig *)colorConfig {
//    _colorConfig = colorConfig;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigRequireRedraw)]){
//        [self.configDelegate chartConfigRequireRedraw];
//    }
//}
//
//- (void)setMainChartLineType:(ChartLineType)mainChartLineType {
//    _mainChartLineType = mainChartLineType;
//    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(chartConfigMainChartLine)]){
//        [self.configDelegate chartConfigMainChartLine];
//    }
//}

@end
