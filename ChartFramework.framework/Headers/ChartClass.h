//
//  ChartClass.h
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
//#import "ChartView.h"
#import "ChartStructs.h"
#import "ChartLineObject.h"
#import "ChartTI.h"
#import "ChartColorConfig.h"
#import "ChartBackground.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ChartClassDisplayDelegate;

@interface ChartClass : NSObject
//@property (nonatomic, strong) ChartGlobalSetting * globalSetting;

//@property (nonatomic, assign) ChartColorConfig * colorConfig;

- (NSString *)formatValue:(CGFloat)value;
- (NSString *)formatMinMaxValue:(CGFloat)value;
- (NSString *)formatDate:(NSDate *)date;

//- (void)adjustXAxisPerValueByValue:(CGFloat )xAxisPerValue;

- (CGFloat)maximumScrollOffsetX;
- (CGSize)getContentSize;
- (bool)isShowingLatest;
//@property (nonatomic, strong) ChartView * chartView;
//@property (nonatomic, strong) NSDictionary * seriesDict;
- (void)initWithChartObjectList:(NSMutableArray *)chartObjectList displayDelegate:(id<ChartClassDisplayDelegate>)delegate;
//- (void)initWithChartObjectList:(NSMutableArray *)chartObjectList keyList:(NSMutableArray *)keyList globalSetting:(ChartGlobalSetting *)globalSetting xAxis:(NSMutableArray *)xAxis;

- (void)updateChartDisplayInfoForContentOffset:(CGPoint)contentOffset;
- (void)updateChartDisplayInfoForMinXAxis:(CGFloat)minXAxis maxAxis:(CGFloat)maxXAxis;


//- (void)addChartLineObject:(ChartLineObject *)chartLineObject;
- (void)updateChartData:(ChartData *)chartData forRefKey:(NSString *)refKey;

- (void)setYAxisMarginLeft:(CGFloat)x;
- (void)addChartLineObjects:(NSArray<ChartLineObject *> *)chartLineObject;
//- (void)updateChartLineObjectByKey:(NSString *)key withDataDict:(NSDictionary *)dataDict;
- (ChartLineObject *)getChartLineObjectByKey:(NSString *)key;
- (void)removeChartLineObjectByKey:(NSString *)key;
- (void)replaceChartLineObjectByKey:(NSString *)key withLineObject:(ChartLineObject *)chartLineObject;
- (void)removeChartLineObjectOtherThanKey:(NSString *)key;
- (NSArray *)getChartLineObjectList;

- (NSString *)setCursorSelectedIndexByPoint:(CGPoint )point needWithData:(BOOL)needWithData;
- (NSString *)setCursorSelectedIndexByPoint:(CGPoint )point;
- (void)setChartAxisLineType:(ChartAxisLineType)type;
- (void)setBShowMinMax:(BOOL)bShowMinMax;

- (NSArray *)getChartDataByGroupingKey:(NSString *)key;
- (CGPoint)getPoisitionForKey:(NSString *)key;
- (NSMutableArray *)getCustYAxisLines;

- (void)drawOnContext:(CGContextRef)context;
- (void)drawCustomYAxisLine:(CGContextRef)context PrevClose:(CGFloat)prevClose lineColor:(UIColor *)lineColor;

- (YMinMaxInfo *)getYMinMaxInfoForDisplay:(ChartDisplayInfo *)displayInfo forChartObjectList:(NSArray<ChartLineObject *> *)dataList;
//For Child
@property (nonatomic, strong) ChartDisplayInfo * currentDisplayInfo;
- (ChartGlobalSetting *)globalSetting;
- (ChartAxisLineType)axisLineType;
- (NSArray *)getXAxisKeyList;
- (void)drawXAxisOnContext:(CGContextRef)context forKeys:(NSArray *)keys textColor:(UIColor *)textColor lineColor:(UIColor * )lineColor;
- (void)drawYAxisOnContext:(CGContextRef)context lineNumber:(NSInteger)lineNumber textColor:(UIColor *)textColor lineColor:(UIColor * )lineColor;

@end

@protocol ChartClassDisplayDelegate <NSObject>
- (NSArray *)getXAxisKeyList;
- (NSArray *)getBackgroundList;
- (YAxisInfo *)getYAxisInfoForChartClass:(ChartClass *)chartClass withDataMinValue:(CGFloat)dataMin maxValue:(CGFloat)dataMax;
- (ChartGlobalSetting *)globalSettingForChartClass:(ChartClass *)chartClass;
- (NSArray *)groupingKeyList;
- (UIFont *)axisFont;
- (ChartColorConfig *)colorConfig;
- (NSString *)formatDate:(NSDate *)date;
- (NSString *)formatValue:(CGFloat)value;
- (NSString *)formatMinMaxValue:(CGFloat)value;
- (ChartAxisLineType)axisLineType;

@end

NS_ASSUME_NONNULL_END
