//
//  FullChartConfig.h
//  ChartLibraryDemo
//
//  Created by william on 7/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChartConst.h"
#import "ChartColorConfig.h"

NS_ASSUME_NONNULL_BEGIN
//@protocol FullChartConfigUpdateDelegate;
//
@protocol ChartConfigUpdateDelegate;
@interface ChartConfig : NSObject

//@property (nonatomic, assign) id<ChartConfigUpdateDelegate> configDelegate;
@property (nonatomic, assign) CGFloat yAxisWidth;
@property (nonatomic, assign) CGFloat xAxisHeight;
@property (nonatomic, assign) CGFloat xAxisPerGapScale;

@property (nonatomic, assign) CGFloat displayIndexNum;
@property (nonatomic, assign) CGFloat minIndexNumDisplay;
@property (nonatomic, assign) CGFloat maxIndexNumDisplay;

@property (nonatomic, assign) NSInteger mainChartYAxisLineNum;
@property (nonatomic, assign) CGFloat   mainChartYAxisRangeDiffGapScale;
@property (nonatomic, assign) CGFloat   mainChartYAxisGapPixel;
//@property (nonatomic, assign) CGFloat fullWidth;
//@property (nonatomic, assign) CGFloat fullHeight;
@property (nonatomic, assign) CGFloat   chartLineTypeLineLineWidth;
@property (nonatomic, assign) CGFloat   chartLineTypeAreaLineWidth;

@property (nonatomic, assign) CGFloat   chartLineTypeAreaTopColorLocation;
@property (nonatomic, assign) CGFloat   chartLineTypeAreaMainColorLocation;

//
//- (CGFloat) chartWidth;
//- (CGFloat) chartHeight;

@property (nonatomic, strong) UIFont * axisFont;
//@property (nonatomic, strong) UIColor * axisColor;
@property (nonatomic, strong) NSString * dateDisplayFormat;
@property (nonatomic, strong) NSString * mainChartValueDisplayFormat;
@property (nonatomic, strong) NSString * subChartValueDisplayFormat;
@property (nonatomic, strong) NSString * minMaxValueFormat;

@property (nonatomic, strong) NSString * selectDateFormat;

@property (nonatomic, copy) NSTimeZone * timeZone;

@property (nonatomic, assign) ChartLineType mainChartLineType;
@property (nonatomic, assign) ChartAxisLineType axisLineType;
@property (nonatomic, assign) ChartYAxisGapType yAxisGapType;

@property (nonatomic, strong) ChartColorConfig * colorConfig;

@property (nonatomic, assign) BOOL bShowMinMax;

- (instancetype)initDefault;

- (instancetype)initDefaultWithColorConfig:(ChartColorConfig *)colorConfig;

- (void)resetDefault;
//- (void)updateFullChartWidth:(CGFloat)width FullHeight:(CGFloat)height ;

- (NSString *)formatValue:(CGFloat)value;
- (NSString *)formatMinMaxValue:(CGFloat)value;
- (NSString *)formatDate:(NSDate *)date;
- (NSString *)formatSelectDate:(NSDate *)date;
- (CGFloat)getMainChartYAxisRangeDiffGapScaleForChartHeight:(CGFloat)chartHeight;

@end

//@protocol ChartConfigUpdateDelegate <NSObject>
//
//- (void)chartConfigUpdateHeight;
//- (void)chartConfigUpdateWidth;
//- (void)chartConfigMainChartLine;
//- (void)chartConfigRequireRedraw;
//
//@end

NS_ASSUME_NONNULL_END
