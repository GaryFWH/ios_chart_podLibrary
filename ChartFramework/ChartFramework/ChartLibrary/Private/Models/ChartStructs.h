//
//  ChartStructs.h
//  ChartLibraryDemo
//
//  Created by william on 27/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChartConst.h"

@interface ChartGlobalSetting : NSObject
@property CGFloat startXOffset;
@property CGFloat endXOffset;
@property CGFloat YOffsetStart;
@property CGFloat xAxisPerValue;
@property CGFloat chartWidth;
@property CGFloat chartHeight;
@property CGFloat yAxisWidth;
@property CGFloat xAxisHeight;
@property CGFloat xAxisPerGapScale;
@property CGFloat chartLineTypeLineLineWidth;
@property CGFloat chartLineTypeAreaLineWidth;
@property CGFloat chartLineTypeAreaTopColorLocation;
@property CGFloat chartLineTypeAreaMainColorLocation;

@property ChartAxisLineType axisLineType;

@property NSInteger chartYAxisLineNum;
//@property NSInteger subChartYAxisLineNum;
@property NSInteger chartYAxisRangeDiffGapScale;
//@property NSInteger subChartYAxisRangeDiffGapScale;

//- (instancetype)initWithFrame:(CGRect)rect xAxisHeight:(CGFloat)xAxisHeight yAxisWidth:(CGFloat)yAxisWidth;
- (CGFloat)GetXCoodinateForIndex:(NSInteger) index;
@end

@interface YAxisInfo : NSObject
@property CGFloat YValueMin;
@property CGFloat YValueMax;
//@property CGFloat yAxisPerValue;
@property NSArray * yAxisList;
@end

@interface ChartDisplayInfo : NSObject
@property ChartGlobalSetting * chartSetting;
@property YAxisInfo * yAxisInfo;
@property CGFloat yAxisPerValue;
@property CGFloat minXAxis;
@property CGFloat maxXAxis;
@property NSMutableDictionary * timestampToIndex;
@property NSMutableArray * timestampSorted;
@property NSMutableIndexSet * indexWithData;

- (CGFloat)GetYCoodinateForValue:(CGFloat) value;

- (CGFloat)GetXCoodinateForTimestamp:(NSString *) key;

- (NSInteger)GetClosestIndexForXCoordinate:(CGFloat)x frameOnly:(BOOL)frameOnly;

@end

@interface YMinMaxInfo : NSObject
@property CGFloat minValue;
@property CGFloat maxValue;
@property NSString * minDataKey;
@property NSString * maxDataKey;
@end
