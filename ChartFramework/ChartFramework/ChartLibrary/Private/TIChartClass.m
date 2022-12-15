//
//  TIChartClass.m
//  ChartLibraryDemo
//
//  Created by william on 22/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "TIChartClass.h"
#import "ChartDrawCommon.h"

@interface TIChartClass()

@property (nonatomic, assign) id<TIChartClassDisplayDelegate> displayDelegate;

@end

@implementation TIChartClass

- (instancetype)initWithChartTI:(ChartTI *)chartTI withChartData:(NSArray *)chartDataList displayDelegate:(id<TIChartClassDisplayDelegate>)displayDelegate {
    if (self = [self init]){
        self.chartTI = chartTI;
        self.displayDelegate = displayDelegate;
        if (chartDataList && [self.displayDelegate respondsToSelector:@selector(tiConfig)]){
//            [self.chartTI initChartObjectListFromChartData:chartDataList];
//            [self handleHistoAndCandleColor];
//            [self.chartTI updateLineObjectColorByChartColorConfig:self.displayDelegate.colorConfig];
            [self.chartTI createChartObjectListFromChartData:chartDataList withTIConfig:self.displayDelegate.tiConfig colorConfig:self.displayDelegate.colorConfig];
        }
    }
    return self;
}
//
//- (void)handleHistoAndCandleColor {
//    if (self.chartTI.tiLineObjects){
//        for (ChartLineObject * obj in self.chartTI.tiLineObjects){
//            if ([obj isKindOfClass:[ChartLineObjectHisto class]]){
//                ((ChartLineObjectHisto *)obj).upColor = self.displayDelegate.colorConfig.mainCandleUpColor;
//                ((ChartLineObjectHisto *)obj).downColor = self.displayDelegate.colorConfig.mainCandleDownColor;
//            }
//            if ([obj isKindOfClass:[ChartLineObjectCandle class]]){
//                ((ChartLineObjectCandle *)obj).upColor = self.displayDelegate.colorConfig.mainCandleUpColor;
//                ((ChartLineObjectCandle *)obj).downColor = self.displayDelegate.colorConfig.mainCandleDownColor;
//            }
//        }
//    }
//}

- (NSString *)formatValue:(CGFloat)value {
    if (self.chartTI){
        return [self.chartTI formatValue:value];
    } else {
        return [super formatValue:value];
    }
}

- (NSArray *)chartObjectList {
    if (self.chartTI.tiLineObjects){
        return self.chartTI.tiLineObjects;
    }
    return [NSArray array];
}

- (void)addChartLineObjects:(NSArray<ChartLineObject *> *)chartLineObject {
    //Disabled
}

- (void)replaceChartLineObjectByKey:(NSString *)key withLineObject:(ChartLineObject *)chartLineObject {
    //Disabled
}
- (void)removeChartLineObjectByKey:(NSString *)key {
    //Disabled
}

- (NSArray *)getChartDataByGroupingKey:(NSString *)groupingkey {
    if (self.chartTI){
        return [self.chartTI dataDictsForGroupingKey:groupingkey];
    }
    return @[];
}

//- (void)drawOnContext:(CGContextRef)context {
//    if (self.displayDelegate.colorConfig){
//        [self.chartTI updateLineObjectColorByChartColorConfig:self.displayDelegate.colorConfig];
//    }
//    [super drawOnContext:context];
//    if (self.currentDisplayInfo && self.displayDelegate){
//        UIColor * backgroundColor = [UIColor whiteColor];
//        backgroundColor = self.displayDelegate.colorConfig.chartBackgroundColor;
//        CGRect chartRect = CGRectMake(self.currentDisplayInfo.minXAxis, self.globalSetting.YOffsetStart, self.globalSetting.chartWidth, self.globalSetting.chartHeight);
//        [ChartDrawCommon DrawRectOnContext:context rect:chartRect color:backgroundColor isFill:YES];
//        
//        CGContextSaveGState(context);
//        [self drawXAxisOnContext:context forKeys:[self getXAxisKeyList] textColor:self.displayDelegate.colorConfig.axisTextColor lineColor:self.displayDelegate.colorConfig.axisLineColor];
//        [self drawYAxisOnContext:context lineNumber:3 textColor:self.displayDelegate.colorConfig.axisTextColor lineColor:self.displayDelegate.colorConfig.axisLineColor];
//        CGContextRestoreGState(context);
//        
//        for (ChartLineObject * obj in self.chartObjectList){
//            [obj DrawInViewContext:context forDisplayInfo:self.currentDisplayInfo inChartRect:chartRect];
//        }
//    }
//}



@end
