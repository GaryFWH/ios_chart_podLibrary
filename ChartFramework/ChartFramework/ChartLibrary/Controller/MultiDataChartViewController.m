//
//  MultiDataChartViewController.m
//  ChartLibraryDemo
//
//  Created by william on 17/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "MultiDataChartViewController.h"
#import "MultiChartView.h"
#import "FullChartConfig.h"
#import "CompareTI.h"
#import "TIChartClass.h"
#import "ChartDrawCommon.h"

@implementation MultiDataChartList

- (instancetype)init {
    if (self = [super init]){
        self.prevData = kEmptyDataValue;
    }
    return self;
}

@end


@interface MultiDataChartViewController () <TIChartClassDisplayDelegate>

//@property (nonatomic, strong) ChartConfig * chartConfig;
@property (nonatomic, strong) FullChartConfig * chartConfig;
@property (nonatomic, strong) ChartGlobalSetting * chartSetting;
@property (nonatomic, strong) NSMutableArray * groupingKeyList;
@property (retain, nonatomic) ChartView * chartView;
@property (strong, nonatomic) MultiChartView * tiChartView;

//@property (strong, nonatomic) NSLayoutConstraint * mainChartViewHeightConstraint;
@property (strong, nonatomic) NSMutableArray<ChartData *> * chartDataList;
@property (strong, nonatomic) NSMutableArray<MultiDataChartList *> * multiDataList;

@property (strong, nonatomic) NSArray * subTIList;
@property (strong, nonatomic) NSMutableDictionary<NSString *, ChartGlobalSetting *> * tiChartSetting;

@property (strong, nonatomic) NSArray * xAxisKeyList;

@property (strong, nonatomic) NSString * currentSelectedKey;
@end

@implementation MultiDataChartViewController

//- (ChartGlobalSetting *)globalSettingForChartClass:(ChartClass *)chartClass {
//    if (chartClass == self.chartView.chartClass){
//        return self.chartSetting;
//    } else {
//        NSString * tiKey = [self.tiChartView identifierForChartClass:chartClass];
//        if (tiKey){
//            ChartGlobalSetting * tiSetting = [self.tiChartSetting objectForKey:tiKey];
//            if (tiSetting){
//                return tiSetting;
//            }
//        }
//    }
//    return [[ChartGlobalSetting alloc] init];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)initView {
//    self.chartView = [[ChartView alloc] init];
//    self.tiChartView = [[MultiChartView alloc] init];
////    self.chartView.delegate = self;
////    self.tiChartView.delegate = self;
////
////    self.chartView.touchDelegate = self;
////    self.tiChartView.touchDelegate = self;
//
//    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.tiChartView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.chartView];
//    [self.view addSubview:self.tiChartView];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.chartView}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiChartView}]];
////    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.mainChartView}]];
////    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiChartView}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view1]-0-[view2]-|" options:0 metrics:nil views:@{@"view1":self.chartView, @"view2":self.tiChartView}]];
//    self.mainChartViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(self.chartConfig.mainChartHeight)];
//    [self.chartView addConstraint:self.mainChartViewHeightConstraint];
//
//
//    self.chartView.backgroundColor = self.colorConfig.axisBackgroundColor;
//    self.tiChartView.backgroundColor = self.colorConfig.axisBackgroundColor;
////    self.mainChartView.scrollEnabled = NO;
//
////    [self initCursorView];
//}

//------------------------------------------------------------------------------
#pragma mark - Override
//------------------------------------------------------------------------------
- (NSArray<ChartData *> *)getChartDataList {
    return [self getChartDataListForIndex:0];
}

- (NSArray<ChartData *> *)getChartDataListForIndex:(NSInteger)index {
    if (!self.multiDataList && index > self.multiDataList.count) {
        return @[];
    } else {
        return [self.multiDataList objectAtIndex:index].dataList;
    }
    
}

- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList {
    self.xAxisKeyList = xAxisKeyList;
}

- (NSArray *)getXAxisKeyList {
    if (self.xAxisKeyList){
        return self.xAxisKeyList;
    }
    return @[];
}

- (YAxisInfo *)getYAxisInfoForChartClass:(ChartClass *)chartClass withDataMinValue:(CGFloat)dataMin maxValue:(CGFloat)dataMax {
    if (chartClass == self.chartView.chartClass){
        return [super getYAxisInfoForChartClass:chartClass withDataMinValue:dataMin maxValue:dataMax];
    }
    
    YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];

    yAxisInfo.YValueMax = dataMax;
    yAxisInfo.YValueMin = dataMin;

    if (fabs(dataMax) > fabs(dataMin)){
        yAxisInfo.YValueMax = fabs(dataMax);
        yAxisInfo.YValueMin = -fabs(dataMax);
    } else {
        yAxisInfo.YValueMax = fabs(dataMin);
        yAxisInfo.YValueMin = -fabs(dataMin);
    }
    
//    CGFloat diff = dataMax - dataMin;
//    yAxisInfo.YValueMax = dataMax + diff* 0.05;
//    yAxisInfo.YValueMin = dataMin - diff* 0.05;
    if (yAxisInfo.YValueMax == 0){
        yAxisInfo.YValueMax = 1;
        yAxisInfo.YValueMin = -1;
        yAxisInfo.yAxisList = @[@(0)];
    } else {
        yAxisInfo.yAxisList = @[@(yAxisInfo.YValueMax), @(0), @(yAxisInfo.YValueMin)];
    }

    return yAxisInfo;
}

- (void)addChartData:(ChartData *)chartData forName:(NSString *)name {
    if (!self.chartSetting || !self.multiDataList){
        return;
    }
    for (MultiDataChartList * obj in self.multiDataList){
        if ([obj.name isEqualToString:name]){
            ChartData * lastObject = [obj.dataList lastObject];
            if ([lastObject.groupingKey isEqualToString:chartData.groupingKey]){
                [obj.dataList removeLastObject];
            }
            [obj.dataList addObject:chartData];
            [self.chartView.chartClass updateChartData:chartData forRefKey:name];
        }
    }
    [self updateChartViewDisplay];
    [self initCompareTI];
}

- (void)initChartDataLists:(NSArray<MultiDataChartList *> *)list refList:(NSArray<ChartData *> *)refList {
    
    [self initMainChartData:refList];
    
    self.multiDataList = [NSMutableArray array];
    
    if ( list && [list count] > 0){
        [self.multiDataList addObjectsFromArray:list];
        
        NSMutableArray * lineObjectList = [NSMutableArray array];
        
        for (MultiDataChartList * obj in list){
            
            ChartLineObject * object = [self createLineObjectFromData:obj];
            [lineObjectList addObject:object];
        }
        
        [self.chartView.chartClass addChartLineObjects:lineObjectList];
        
        [self updateChartContentSize];
    }
    
    [self updateChartViewDisplay];
    
    [self initCompareTI];
}

- (void)initChartDataLists:(NSArray<MultiDataChartList *> *)list keyList:(NSArray *)keyList{
    
    
    self.multiDataList = [NSMutableArray array];
    
    if ( list && [list count] > 0){
        [self.multiDataList addObjectsFromArray:list];
//        MultiDataChartList * firstObject = [list firstObject];
//        if (firstObject){
//            [self initMainChartData:firstObject.dataList];
//        }
        
//        NSMutableArray * keyList = [NSMutableArray array];
        [self initMainChartData:[list firstObject].dataList];
        
        NSMutableArray * lineObjectList = [NSMutableArray array];
        
        for (MultiDataChartList * obj in list){
//            for (ChartData * chartData in obj.dataList){
//                if (![keyList containsObject:chartData.groupingKey]){
//                    [keyList addObject:chartData.groupingKey];
//                }
//            }
            
            ChartLineObject * object = [self createLineObjectFromData:obj];
            [lineObjectList addObject:object];
            
        }
        self.groupingKeyList = [NSMutableArray arrayWithArray:keyList];
        
        [self.chartView.chartClass initWithChartObjectList:lineObjectList displayDelegate:self];
        
        [self updateChartContentSize];
    }
    
    [self updateChartViewDisplay];
    
    [self initCompareTI];
}

//NO! NOT HERE
- (void)initCompareTI {
    [self.tiChartView removeAllChartClass];
    self.tiChartSetting = [NSMutableDictionary dictionary];
//    if (!self.chartConfig || !self.chartConfig.tiConfig || !self.chartConfig.tiConfig.selectedSubTI){
//        [self updateTiChartContentSize];
//        [self updateSubChartView];
//        return;
//    }
//    if (self.chartDataList && self.chartConfig && self.chartConfig.selectedSubTI){
//    NSInteger size = [self.chartConfig.tiConfig.selectedSubTI count];
    NSMutableArray * subTIList = [NSMutableArray array];
    NSMutableArray * classNameList = [NSMutableArray array];
    NSMutableDictionary * chartClassDict = [NSMutableDictionary dictionary];
//    for (NSInteger i = 0; i < size; i++){
        ChartGlobalSetting * globalSetting = [[ChartGlobalSetting alloc] init];
        globalSetting.startXOffset = self.chartSetting.startXOffset;
        globalSetting.endXOffset = self.chartSetting.endXOffset;
        globalSetting.YOffsetStart = 0;
        globalSetting.yAxisWidth = self.chartSetting.yAxisWidth;
        globalSetting.chartWidth = self.chartSetting.chartWidth;
        globalSetting.xAxisHeight = 0.f;
        globalSetting.chartHeight = self.chartConfig.tiChartHeight;
        globalSetting.xAxisPerValue = self.chartSetting.xAxisPerValue;
        globalSetting.xAxisPerGapScale = self.chartSetting.xAxisPerGapScale;
        globalSetting.axisLineType = self.chartConfig.axisLineType;
        globalSetting.chartLineTypeLineLineWidth = self.chartConfig.chartLineTypeLineLineWidth;
        globalSetting.chartLineTypeAreaLineWidth = self.chartConfig.chartLineTypeAreaLineWidth;
        globalSetting.chartLineTypeAreaTopColorLocation = self.chartConfig.chartLineTypeAreaTopColorLocation;
        globalSetting.chartLineTypeAreaMainColorLocation = self.chartConfig.chartLineTypeAreaMainColorLocation;
    
    if ([self.multiDataList count] >= 2){
    
        CompareTI * ti = [[CompareTI alloc] init];
        ti.comparedDataList = [self.multiDataList objectAtIndex:1].dataList;
        ti.prevSelfData = [self.multiDataList objectAtIndex:0].prevData;
        ti.prevCompareData = [self.multiDataList objectAtIndex:1].prevData;
        ti.chartConfig = self.chartConfig;
        TIChartClass * chartClass = [[TIChartClass alloc] initWithChartTI:ti withChartData:[self.multiDataList objectAtIndex:0].dataList displayDelegate:self];
        [chartClass setChartAxisLineType:self.chartConfig.axisLineType];
        [classNameList addObject:[ti refKeyForChart]];
        [chartClassDict setObject:chartClass forKey:[ti refKeyForChart]];
        
        [self.tiChartSetting setObject:globalSetting forKey:[ti refKeyForChart]];
    //        ChartSubTIEnum subti = (ChartSubTIEnum)[[self.chartConfig.tiConfig.selectedSubTI objectAtIndex:i] integerValue];
    //        ChartTI * subTi = [self chartTIForSubTI:subti];
    //        if (subTi){
    //            TIChartClass * chartClass = [[TIChartClass alloc] initWithChartTI:subTi withChartData:self.chartDataList displayDelegate:self];
    //
    //            [classNameList addObject:[subTi refKeyForChart]];
    //            [chartClassDict setObject:chartClass forKey:[subTi refKeyForChart]];
    //
    //            [self.tiChartSetting setObject:globalSetting forKey:[subTi refKeyForChart]];
                [subTIList addObject:ti];
    //        }
    //    }
        self.subTIList = subTIList;
        self.tiChartView.chartClassListDict = chartClassDict;
        self.tiChartView.chartClassListOrder = classNameList;
    //    }
        [self updateTiChartContentSize];
        [self updateSubChartView];
    }
}


- (void)updateTiChartContentSize {
    CGFloat allTiHeight = [self.subTIList count] * (self.chartConfig.tiChartHeight + self.chartConfig.tiChartGap);
    
    self.tiChartView.contentSize = CGSizeMake(self.chartView.contentSize.width, allTiHeight);
}

- (void)updateSubChartView {
    [self.tiChartView updateAllClassForContentOffset:self.tiChartView.contentOffset];
    [self.tiChartView setNeedsDisplay];
}

- (ChartLineObject *)createLineObjectFromData:(MultiDataChartList *)chartList {
    ChartLineObject * chartLineObject;
    switch (chartList.chartLineType){
        case ChartLineTypeBar:
        {
//            chartLineObject = [[ChartLineObjectBar alloc] initWithMainColor:chartList.mainColor];
            chartLineObject = [[ChartLineObjectBar alloc] initWithUpColor:self.colorConfig.mainBarUpColor downColor:self.colorConfig.mainBarDownColor];
        }
            break;
        case ChartLineTypeArea:
        {
            chartLineObject = [[ChartLineObjectArea alloc] initWithStrokeColor:chartList.mainColor gradientTopColor:self.colorConfig.mainAreaFillTopColor mainColor:self.colorConfig.mainAreaFillMainColor];
        }
            break;
        case ChartLineTypeLine:
        {
            chartLineObject = [[ChartLineObjectLine alloc] initWithMainColor:chartList.mainColor];
        }
            break;
        case ChartLineTypeCandle:
        {
            chartLineObject = [[ChartLineObjectCandle alloc] initWithUpColor:self.colorConfig.mainCandleUpColor downColor:self.colorConfig.mainCandleDownColor];
        }
            break;
        case ChartLineTypeHisto:
        {
            chartLineObject = [[ChartLineObjectHisto alloc] initWithUpColor:self.colorConfig.mainCandleUpColor downColor:self.colorConfig.mainCandleDownColor];
        }
            break;
    }
    [chartLineObject setChartDataByChartDataList:chartList.dataList];
    chartLineObject.refKey = chartList.name;
    return chartLineObject;
}


- (void)drawCursorOnSelectedKey:(CGContextRef)context {
    if (self.currentSelectedKey){
        NSArray * dataList = [[self.chartView.chartClass getChartDataByGroupingKey:self.currentSelectedKey] valueForKey:@"data"];
        
        CGFloat xPos = [self.chartView.chartClass.currentDisplayInfo GetXCoodinateForTimestamp:self.currentSelectedKey];
        if (xPos == NSNotFound) {
            return;
        }
        CGPoint xAxis = CGPointMake(xPos, self.chartView.chartClass.globalSetting.chartHeight);
        
        ChartData * fData = [[[self.chartView.chartClass getChartDataByGroupingKey:self.currentSelectedKey] firstObject] objectForKey:@"data"];
        NSDate * date = fData.date;
        chartTextBoxInfo * xAxisInfo = [ChartDrawCommon GetTextRectFromPoint:xAxis pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, self.chartConfig.xAxisHeight) text:[self formatSelectDate:date] initialFont:[self axisFont] fontColor:[UIColor whiteColor]];
        
        if (xAxisInfo.rect.origin.x < 0){
            CGRect xRect = xAxisInfo.rect;
            xRect.origin.x = 0;
            xAxisInfo.rect = xRect;
        }
        
        if (CGRectGetMaxX(xAxisInfo.rect) > self.chartView.chartClass.globalSetting.chartWidth){
            CGRect xRect = xAxisInfo.rect;
            xRect.origin.x = self.chartSetting.chartWidth - xRect.size.width;
            xAxisInfo.rect = xRect;
        }
        
        [ChartDrawCommon DrawRectOnContext:context rect:xAxisInfo.rect color:[UIColor blackColor] isFill:YES];
        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:xAxisInfo];
        
        for (ChartData * data in dataList){
            if (![data isEmpty]){
                CGFloat yPos = [self.chartView.chartClass.currentDisplayInfo GetYCoodinateForValue:data.close];
                CGPoint left = CGPointMake(0, yPos);
                CGPoint right = CGPointMake(self.chartView.chartClass.globalSetting.chartWidth, yPos);
                
                CGPoint yAxis = CGPointMake(self.chartSetting.chartWidth, yPos);
                UIColor * cursorColor = self.colorConfig.cursorLineColor;
                
                [ChartDrawCommon DrawLineOnContext:context pointA:left pointB:right color:cursorColor];
                
                chartTextBoxInfo * yAxisInfo = [ChartDrawCommon GetTextRectFromPoint:yAxis pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(self.chartConfig.yAxisWidth, CGFLOAT_MAX) text:[self formatValue:data.close] initialFont:[self axisFont] fontColor:[UIColor whiteColor]];
                
                [ChartDrawCommon DrawRectOnContext:context rect:yAxisInfo.rect color:[UIColor blackColor] isFill:YES];
                [ChartDrawCommon DrawTextOnContext:context textBoxInfo:yAxisInfo];
            }
        }
//        ChartData * mainData = [[[self.chartView.chartClass getChartDataByGroupingKey:self.currentSelectedKey] firstObject] objectForKey:@"data"];
//        CGPoint yAxis = CGPointMake(self.chartSetting.chartWidth, self.cursorPoint.y);
//        CGPoint xAxis = CGPointMake(self.cursorPoint.x, self.chartSetting.chartHeight);
//
//        chartTextBoxInfo * yAxisInfo = [ChartDrawCommon GetTextRectFromPoint:yAxis pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(self.chartConfig.yAxisWidth, CGFLOAT_MAX) text:[self formatValue:mainData.close] initialFont:[self axisFont] color:[UIColor whiteColor]];
//
//        chartTextBoxInfo * xAxisInfo = [ChartDrawCommon GetTextRectFromPoint:xAxis pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, self.chartConfig.xAxisHeight) text:[self formatSelectDate:mainData.date] initialFont:[self axisFont] color:[UIColor whiteColor]];
//
//        if (xAxisInfo.rect.origin.x < 0){
//            CGRect xRect = xAxisInfo.rect;
//            xRect.origin.x = 0;
//            xAxisInfo.rect = xRect;
//        }
//
//        if (CGRectGetMaxX(xAxisInfo.rect) > self.chartSetting.chartWidth){
//            CGRect xRect = xAxisInfo.rect;
//            xRect.origin.x = self.chartSetting.chartWidth - xRect.size.width;
//            xAxisInfo.rect = xRect;
//        }
//
//        if (![mainData isEmpty]){
//            [ChartDrawCommon DrawLineOnContext:context pointA:left pointB:right color:cursorColor];
//            [ChartDrawCommon DrawRectOnContext:context rect:yAxisInfo.rect color:[UIColor blackColor] isFill:YES];
//            [ChartDrawCommon DrawTextOnContext:context textBoxInfo:yAxisInfo];
//
//            [ChartDrawCommon DrawLineOnContext:context pointA:top pointB:bottom color:cursorColor];
//            [ChartDrawCommon DrawRectOnContext:context rect:xAxisInfo.rect color:[UIColor blackColor] isFill:YES];
//            [ChartDrawCommon DrawTextOnContext:context textBoxInfo:xAxisInfo];
//        }
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)updateMainChartHeight:(CGFloat)height {
//    self.chartConfig.mainChartHeight = height;
//
//    [self updateLayoutAfterResize];
//}

//- (void)updateTiChartHeight:(CGFloat)height tiGap:(CGFloat)gap{
//    self.chartConfig.tiChartHeight = height;
//    self.chartConfig.tiChartGap = gap;
//    NSInteger i = 0;
//    for (NSString * key in self.tiChartView.chartClassListOrder){
//        ChartGlobalSetting * setting = [self.tiChartSetting objectForKey:key];
//        setting.YOffsetStart = i * self.chartConfig.tiChartHeight + i * self.chartConfig.tiChartGap;
//        setting.chartHeight = self.chartConfig.tiChartHeight;
//    }
//
//    [self updateTiChartContentSize];
//    [self updateSubChartView];
//}

@end
