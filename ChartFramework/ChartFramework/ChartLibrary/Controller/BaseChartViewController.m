//
//  SmallChartViewController.m
//  ChartLibraryDemo
//
//  Created by william on 10/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "BaseChartViewController.h"
#import "ChartView.h"
#import "ChartClass.h"
#import "ChartDrawCommon.h"
#import "CustomDrawView.h"
#import "ChartTICalculator.h"
//
//

@interface BaseChartViewController ()

@property (strong, nonatomic) ChartConfig * chartConfig;
@property (strong, nonatomic) ChartGlobalSetting * chartSetting;
@property (strong, nonatomic) NSMutableArray * groupingKeyList;
@property (strong, nonatomic) NSMutableArray<ChartData *> * chartDataList;
@property (retain, nonatomic) ChartView * chartView;

@property (strong, nonatomic) NSArray * backgroundList;

@end

@implementation BaseChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
//    self.chartView.touchDelegate = self;
//    self.chartView.scrollEnabled = NO;
    
//    self.cursorView = [[CustomDrawView alloc] initWithDelegate:self];
//    [self.view addSubview:self.cursorView];
//    self.cursorView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

- (void)setChartViewScrollInset:(UIScrollViewContentInsetAdjustmentBehavior)behavior {
//    [self.chartView setContentInsetAdjustmentBehavior:behavior];
    if (self.chartView){
        [self.chartView setContentInsetAdjustmentBehavior:behavior];
    } else {
//        self.chartViewScrollInset = behavior;
    }
}

- (void)initView {
    self.chartView = [[ChartView alloc] init];
//    self.chartView.delegate = self;
    
    [self.view addSubview:self.chartView];
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.chartView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.chartView}]];
    self.chartView.backgroundColor = self.colorConfig.axisBackgroundColor;
}

- (ChartGlobalSetting *)globalSettingForChartClass:(ChartClass *)chartClass {
    return self.chartSetting;
}

//- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList {
//    self.xAxisKeyList = xAxisKeyList;
//}
//
//- (NSArray *)getXAxisKeyList {
//    if (self.xAxisKeyList){
//        return self.xAxisKeyList;
//    }
//    NSMutableArray * array = [NSMutableArray array];
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"mm"];
//    if (self.chartDataList){
//        for (ChartData * data in self.chartDataList){
//            NSDate * date = data.date;
//            if ([[formatter stringFromDate:date] isEqualToString:@"00"]){
//                [array addObject:data.groupingKey];
//            }
//        }
//    }
//    return array;
//}

//- (NSMutableArray *)groupingKeyList {
//    return _groupingKeyList;
//}

- (UIFont *)axisFont {
    if (self.chartConfig && self.chartConfig.axisFont){
        return [self.chartConfig axisFont];
    }
    return [UIFont fontWithName:@"Arial" size:12.f];
}

- (UIColor *)axisColor {
    if (self.chartConfig.colorConfig.axisLineColor){
        return self.chartConfig.colorConfig.axisLineColor;
    }
    return [UIColor blackColor];
}

- (NSString *)formatValue:(CGFloat)value {
//    NSString * valueDisplayFormat = @"%.3f";
//    return [NSString stringWithFormat:valueDisplayFormat, value];
    if (self.chartConfig){
        return [self.chartConfig formatValue:value];
    }
//    NSString * valueDisplayFormat = @"%.3f";
//    return [NSString stringWithFormat:valueDisplayFormat, value];
    return @"";
}

- (NSString *)formatMinMaxValue:(CGFloat)value {
    if (self.chartConfig){
        return [self.chartConfig formatMinMaxValue:value];
    }
    
    return @"";
}

- (NSString *)formatDate:(NSDate *)date {
    if (self.chartConfig){
        return [self.chartConfig formatDate:date];
    }
    return @"";
}

- (NSString *)formatSelectDate:(NSDate *)date {
    if (self.chartConfig){
        return [self.chartConfig formatSelectDate:date];
    }
    return @"";
}

- (ChartView *)getChartView {
    return self.chartView;
}
- (ChartConfig *)getChartConfig {
    return self.chartConfig;
}
- (ChartGlobalSetting *)getChartGlobalSetting {
    return self.chartSetting;
}
- (ChartColorConfig *)colorConfig {
    if (self.chartConfig.colorConfig){
        return self.chartConfig.colorConfig;
    }
    return [ChartColorConfig defaultLightConfig];
}
- (NSArray<ChartData*> *)getChartDataList {
    return self.chartDataList;
}

- (nonnull NSArray *)getXAxisKeyList {
    //Define in SubClass
    return @[];
}

- (YAxisInfo *)getYAxisInfoForChartClass:(ChartClass *)chartClass withDataMinValue:(CGFloat)dataMin maxValue:(CGFloat)dataMax {
    YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];
    CGFloat rangeDiff = dataMax - dataMin;
    yAxisInfo.YValueMax = dataMax;
    yAxisInfo.YValueMin = dataMin;

//    CGFloat displayYMaxValue = dataMax + rangeDiff * self.chartConfig.mainChartYAxisRangeDiffGapScale;
//    CGFloat displayYMinValue = dataMin - rangeDiff * self.chartConfig.mainChartYAxisRangeDiffGapScale;
    
    CGFloat gapScale = [self.chartConfig getMainChartYAxisRangeDiffGapScaleForChartHeight:chartClass.globalSetting.chartHeight];
    switch (self.chartConfig.yAxisGapType) {
        case ChartYAxisGapTypePixel: {
            gapScale = [self.chartConfig getMainChartYAxisRangeDiffGapScaleForChartHeight:chartClass.globalSetting.chartHeight];
        }  break;
        case ChartYAxisGapTypeScale: {
            gapScale = self.chartConfig.mainChartYAxisRangeDiffGapScale;
        } break;
    }
    
//    CGFloat yValuePerPixel = ((dataMax + rangeDiff*gapScale) - (dataMin - rangeDiff*gapScale)) / chartSetting.chartHeight;
//    NSLog(@"\nMain Chart");
//    NSLog(@"gapPixel %.2f yValPerPixel %.2f gapScale %.2f rangeDiff %.2f", self.chartConfig.mainChartYAxisGapPixel, yValuePerPixel, gapScale, rangeDiff);
//    NSLog(@"Expected space - gapP*yValPerPixel %.2f*%.2f=%.2f ; rangeDiff*gapS  %.2f*%.2f=%.2f",
//          self.chartConfig.mainChartYAxisGapPixel, yValuePerPixel, self.chartConfig.mainChartYAxisGapPixel *yValuePerPixel,
//          rangeDiff, gapScale, rangeDiff*gapScale);
    
    CGFloat displayYMaxValue = dataMax + rangeDiff * gapScale;
    CGFloat displayYMinValue = dataMin - rangeDiff * gapScale;
    
    if (dataMax <= 0 && displayYMaxValue >= 0){
        displayYMaxValue = 0;
    }
    if (dataMin >= 0 && displayYMinValue <= 0){
        displayYMinValue = 0;
    }
    
    if (dataMin > dataMax){
        displayYMinValue = 0;
        displayYMaxValue = 0;
    }
    yAxisInfo.YValueMax = displayYMaxValue;
    yAxisInfo.YValueMin = displayYMinValue;
    
    CGFloat valueDiff = displayYMaxValue - displayYMinValue;
    
    NSMutableArray * array = [NSMutableArray array];
    if (valueDiff > 0){
        NSInteger lineNumber = self.chartConfig.mainChartYAxisLineNum;
        if (lineNumber > 0){
            for (NSInteger i = 0; i <= lineNumber; i++){
                CGFloat yValue = yAxisInfo.YValueMin + i * valueDiff/lineNumber;
                [array addObject:@(yValue)];
            }
        }
    } else if (self.chartConfig.mainChartYAxisLineNum > 0){
        yAxisInfo.YValueMax = displayYMinValue * 2;
        yAxisInfo.YValueMin = 0;
        [array addObject:@(displayYMinValue)];
    }
    yAxisInfo.yAxisList = [NSArray arrayWithArray:array];
    
    return yAxisInfo;
}

- (NSArray *)getBackgroundList {
    return _backgroundList;
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
////    [self.fullChartViewController updateChartWidth:self.fullChartViewController.view.frame.size.width];
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
////    CGSize fullChartView = [self sizeForChildContentContainer:self.fullChartViewController withParentContainerSize:size];
////    [self.fullChartViewController updateChartWidth:fullChartView.width];
////    [self.fullChartViewController updateMainChartHeight:(size.height/2)];
////    [self updateLayoutWithSize:size];
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        [self updateLayoutWithSize:self.view.frame.size];
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//
//    }];
//}

- (void)updateLayoutAfterResize {
    [self.view layoutIfNeeded];
    //    [super updateLayoutWithSize:size];
    self.chartSetting.yAxisWidth = self.chartConfig.yAxisWidth;
    self.chartSetting.xAxisHeight = self.chartConfig.xAxisHeight;
    self.chartSetting.chartWidth = self.view.bounds.size.width - self.chartConfig.yAxisWidth;
    self.chartSetting.chartHeight = self.view.bounds.size.height - self.chartConfig.xAxisHeight;
    
    [self updateChartContentSize];
    [self updateChartViewDisplay];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)updateColor {
    self.chartView.backgroundColor = self.colorConfig.axisBackgroundColor;
    [self updateMainChartColor];
    [self.chartView setNeedsDisplay];
}

- (void)updateMainChartColor {
    //    self.chartView.chartClass
    ChartLineObject * lineObj = [self.chartView.chartClass getChartLineObjectByKey:@"MainData"];
    if (lineObj){
        if ([lineObj isKindOfClass:[ChartLineObjectLine class]]){
            ((ChartLineObjectLine *)lineObj).mainColor = self.colorConfig.mainLineColor;
        }
        if ([lineObj isKindOfClass:[ChartLineObjectBar class]]){
            ((ChartLineObjectBar *)lineObj).upColor = self.colorConfig.mainBarUpColor;
            ((ChartLineObjectBar *)lineObj).downColor = self.colorConfig.mainBarDownColor;
        }
        if ([lineObj isKindOfClass:[ChartLineObjectArea class]]){
            ((ChartLineObjectArea *)lineObj).strokeColor = self.colorConfig.mainAreaLineColor;
            ((ChartLineObjectArea *)lineObj).gradientTopColor = self.colorConfig.mainAreaFillTopColor;
            ((ChartLineObjectArea *)lineObj).gradientMainColor = self.colorConfig.mainAreaFillMainColor;
        }
        if ([lineObj isKindOfClass:[ChartLineObjectCandle class]]){
            ((ChartLineObjectCandle *)lineObj).upColor = self.colorConfig.mainCandleUpColor;
            ((ChartLineObjectCandle *)lineObj).downColor = self.colorConfig.mainCandleDownColor;
        }
        if ([lineObj isKindOfClass:[ChartLineObjectHisto class]]){
            ((ChartLineObjectHisto *)lineObj).upColor = self.colorConfig.mainCandleUpColor;
            ((ChartLineObjectHisto *)lineObj).downColor = self.colorConfig.mainCandleDownColor;
        }
    }
}

- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config{
    if (self = [self init]){
        [view addSubview:self.view];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
        
        self.chartConfig = config;
//        self.chartConfig.configDelegate = self;
        //        _groupingKeyList = [NSMutableArray arrayWithArray:keyList];
        [self updateColor];
    }
    return self;
}

- (void)initBasicConfig {
//    NSLog(@"BaseChartVC - initBasicConfig");
    ChartGlobalSetting * globalSetting = [[ChartGlobalSetting alloc] init];
    globalSetting.startXOffset = 0.f;
    globalSetting.endXOffset = 0.f;
    globalSetting.YOffsetStart = 0.f;
    
    //    CGRect frame = self.view.frame;
    globalSetting.yAxisWidth = self.chartConfig.yAxisWidth;
    globalSetting.chartWidth = self.chartView.bounds.size.width - self.chartConfig.yAxisWidth;
    globalSetting.xAxisHeight = self.chartConfig.xAxisHeight;
    globalSetting.chartHeight = self.chartView.bounds.size.height - self.chartConfig.xAxisHeight;
    globalSetting.xAxisPerGapScale = self.chartConfig.xAxisPerGapScale;
    globalSetting.axisLineType = self.chartConfig.axisLineType;
    
    globalSetting.chartYAxisLineNum     = self.chartConfig.mainChartYAxisLineNum;
    globalSetting.chartYAxisRangeDiffGapScale   = self.chartConfig.mainChartYAxisRangeDiffGapScale;
    
    globalSetting.chartLineTypeLineLineWidth = self.chartConfig.chartLineTypeLineLineWidth;
    globalSetting.chartLineTypeAreaLineWidth = self.chartConfig.chartLineTypeAreaLineWidth;
    globalSetting.chartLineTypeAreaTopColorLocation = self.chartConfig.chartLineTypeAreaTopColorLocation;
    globalSetting.chartLineTypeAreaMainColorLocation = self.chartConfig.chartLineTypeAreaMainColorLocation;
    //    globalSetting.xAxisPerValue = globalSetting.chartWidth / [self.groupingKeyList count];
    
    self.chartSetting = globalSetting;
    
    self.chartView.chartClass = [[ChartClass alloc] init];
    //    self.chartView.chartClass.displayDelegate = self;
    //    [self.chartView.chartClass initWithChartObjectList:[NSMutableArray array] displayDelegate:self];
}

- (ChartLineObject *)createMainLineObject {
    ChartLineObject * chartLineObject;
    switch (self.chartConfig.mainChartLineType){
        case ChartLineTypeBar:
        {
//            chartLineObject = [[ChartLineObjectBar alloc] initWithMainColor:self.colorConfig.mainBarColor];
            chartLineObject = [[ChartLineObjectBar alloc] initWithUpColor:self.colorConfig.mainBarUpColor downColor:self.colorConfig.mainBarDownColor];
        }
            break;
        case ChartLineTypeArea:
        {
            chartLineObject = [[ChartLineObjectArea alloc] initWithStrokeColor:self.colorConfig.mainAreaLineColor gradientTopColor:self.colorConfig.mainAreaFillTopColor mainColor:self.colorConfig.mainAreaFillMainColor];
        }
            break;
        case ChartLineTypeLine:
        {
            chartLineObject = [[ChartLineObjectLine alloc] initWithMainColor:self.colorConfig.mainLineColor];
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
    [chartLineObject setChartDataByChartDataList:self.chartDataList];
    chartLineObject.refKey = @"MainData";
    return chartLineObject;
}

- (void)initMainChartData:(NSArray<ChartData *> *)dataList {
    [self initMainChartData:dataList backgroundList:@[]];
}

- (void)initMainChartData:(NSArray<ChartData *> *)dataList backgroundList:(NSArray *)backgroundList{
    if (!self.chartSetting || !self.chartView.chartClass){
        [self initBasicConfig];
    }
    
    if (self.chartConfig.displayIndexNum < self.chartConfig.minIndexNumDisplay) {
        self.chartConfig.displayIndexNum = self.chartConfig.minIndexNumDisplay;
    }
    if (self.chartConfig.displayIndexNum > self.chartConfig.maxIndexNumDisplay) {
        self.chartConfig.displayIndexNum = self.chartConfig.maxIndexNumDisplay;
    }
    self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/self.chartConfig.displayIndexNum;
    
    NSMutableArray * keyList = [NSMutableArray array];
    NSMutableArray * lineObjectList = [NSMutableArray array];
    
    self.chartDataList = [NSMutableArray arrayWithArray:dataList];
    
    for (ChartData * chartData in dataList){
        if (![keyList containsObject:chartData.groupingKey]){
            [keyList addObject:chartData.groupingKey];
        }
    }
    
    self.groupingKeyList = keyList;
    
    ChartLineObject * chartLineObject = [self createMainLineObject];
    
    [lineObjectList addObject:chartLineObject];
    
    [self.chartView.chartClass initWithChartObjectList:lineObjectList displayDelegate:self];
    
    [self setBackgroundList:backgroundList];
    
    [self updateChartContentSize];
    //    [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
}

- (void)addMainChartData:(ChartData *)data {
    //    if (_groupingKeyList){
    if (!self.chartSetting || !self.chartView.chartClass){
        [self initMainChartData:@[data]];
        return;
    }
    ChartData * lastObject = [self.chartDataList lastObject];
    if ([lastObject.groupingKey isEqualToString:data.groupingKey]){
        [self.chartDataList removeLastObject];
    }
    [self.chartDataList addObject:data];
    if (![self.groupingKeyList containsObject:data.groupingKey]){
        [self.groupingKeyList addObject:data.groupingKey];
    }
    [self.chartView.chartClass updateChartData:data forRefKey:@"MainData"];
    //    [self.chartView setNeedsDisplay];
    [self updateChartContentSize];
    
    [self updateChartViewDisplay];
}

- (void)clearChartData {
    [self initMainChartData:@[] backgroundList:@[]];
    
}

- (void)updateChartContentSize {
    self.chartView.contentSize = [self.chartView.chartClass getContentSize];
}

- (void)scrollToContentOffsetX:(CGFloat)x {
    CGFloat maximumOffset = [self.chartView.chartClass maximumScrollOffsetX];
    if (x > maximumOffset){
        x = maximumOffset;
    }
    self.chartView.contentOffset = CGPointMake(x, self.chartView.contentOffset.y);
}

- (void)updateChartViewDisplay {
        [self.chartView.chartClass updateChartDisplayInfoForContentOffset:self.chartView.contentOffset];
    
    //    CGFloat minXAxis = [self.chartSetting GetXCoodinateForIndex:0];
    //    CGFloat maxXAxis = [self.chartSetting GetXCoodinateForIndex:[self.chartDataList count] -1];
    //    self.chartView.contentOffset = CGPointMake(minXAxis, self.chartView.contentOffset.y);
    //    [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:minXAxis maxAxis:maxXAxis];
    
        [self.chartView setNeedsDisplay];
}

- (void)updateMainChartType:(ChartLineType)lineType {
    self.chartConfig.mainChartLineType = lineType;
    [self.chartView.chartClass replaceChartLineObjectByKey:@"MainData" withLineObject:[self createMainLineObject]];
    [self.chartView setNeedsDisplay];
}

//- (void)setShowingRangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    if (fromIndex > toIndex){
//        return;
//    }
//    if (fromIndex >= [self.chartDataList count]){
//        return;
//    }
//    if (toIndex >= [self.chartDataList count]){
//        return;
//    }
//
//    NSInteger keyCount = toIndex - fromIndex;
//
//    self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/keyCount;
//    [self updateChartContentSize];
//
//    CGFloat minXAxis = [self.chartSetting GetXCoodinateForIndex:fromIndex];
//    CGFloat maxXAxis = [self.chartSetting GetXCoodinateForIndex:toIndex];
//    self.chartView.contentOffset = CGPointMake(minXAxis, self.chartView.contentOffset.y);
//    [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:minXAxis maxAxis:maxXAxis];
//    [self.chartView setNeedsDisplay];
//}
//
//
//- (void)setShowingRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
//    NSString * fromKey = nil;
//    NSString * toKey = nil;
////    NSInteger keyCount = 0;
//
//    for (ChartData * chartData in self.chartDataList){
//        if (!fromKey){
//            fromKey = chartData.groupingKey;
//        }
//        if (!toKey){
//            toKey = chartData.groupingKey;
//        }
//        if ([chartData.date timeIntervalSince1970] > [toDate timeIntervalSince1970]){
//            break;
//        }
//        if ([chartData.date timeIntervalSince1970] < [fromDate timeIntervalSince1970]){
//            fromKey = chartData.groupingKey;
//        }
//        toKey = chartData.groupingKey;
//    }
//    if (!fromKey || !toKey){
//        return;
//    }
//    NSInteger fromIndex = [self.groupingKeyList indexOfObject:fromKey];
//    NSInteger toIndex = [self.groupingKeyList indexOfObject:toKey];
//
//    if (fromIndex == NSNotFound || toIndex == NSNotFound){
//        return;
//    }
//
//    [self setShowingRangeFromIndex:fromIndex toIndex:toIndex];
//
//}

- (void)enableCursor:(BOOL)bDrawCursor {
    //
}

#pragma mark - Update config

- (void)updateYAxisWidth:(CGFloat)yAxisWidth xAxisHeight:(CGFloat)xAxisHeight {
    self.chartConfig.yAxisWidth = yAxisWidth;
    self.chartConfig.xAxisHeight = xAxisHeight;
    [self updateLayoutAfterResize];
}

- (void)updateChartColorConfig:(ChartColorConfig *)chartColorConfig {
    self.chartConfig.colorConfig = chartColorConfig;
    [self updateColor];
}

- (void)updateDateDisplayFormat:(NSString *)dateDisplayFormat {
    self.chartConfig.dateDisplayFormat = dateDisplayFormat;
    [self updateChartViewDisplay];
}

- (void)updateSelectDateFormat:(NSString *)format {
    self.chartConfig.selectDateFormat = format;
}

- (void)updateChartConfig:(ChartConfig*)config {
    self.chartConfig = config;

    [self updateChartContentSize];
    [self updateChartViewDisplay];
}

#pragma mark - Export Data

- (NSDictionary *)exportAllChartData {
    return [ChartTICalculator getDictionaryFromChartConfig:nil forChartData:self.chartDataList];
    
    NSArray * keyList = [self groupingKeyList];
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    for (ChartLineObject * lineObject in [self.chartView.chartClass getChartLineObjectList]){
//        if ([lineObject isKindOfClass:[ChartLineObjectSingleValue class]]){
            NSMutableArray * valueList = [NSMutableArray array];
            for (NSString * key in keyList){
                ChartData * data = [lineObject.chartDataDict objectForKey:key];
                if ([data isEmpty]){
                    continue;
                }
                [valueList addObject:data];
//                if ([lineObject isKindOfClass:[ChartLineObjectSingleValue class]]){
//                    ChartLineObjectSingleValue * lineObjSV = (ChartLineObjectSingleValue *)lineObject;
//                    [valueList addObject:@{
//                        @"key": data.groupingKey,
//                        @"date": data.date,
//                        @"value": @([lineObjSV getValueForKey:data.groupingKey forDisplayType:lineObjSV.displayType]),
//                    }];
//                } else {
//                    [valueList addObject:@{
//                        @"key": data.groupingKey,
//                        @"date": data.date,
//                        @"open": @(data.open),
//                        @"close": @(data.close),
//                        @"high": @(data.high),
//                        @"low": @(data.low),
//                        @"volume": @(data.volume),
//                    }];
//                }
            }
//        }
        [mutDict setObject:valueList forKey:lineObject.refKey];
    }
    return [NSDictionary dictionaryWithDictionary:mutDict];
}


- (void)setShowingRangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex > toIndex){
        return;
    }
    if (fromIndex >= [self.chartDataList count]){
        return;
    }
    if (toIndex >= [self.chartDataList count]){
        return;
    }
    
    NSInteger keyCount = toIndex - fromIndex;
    if (keyCount == 0){
        self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/2;
        [self updateChartContentSize];
        [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:0 maxAxis:self.chartSetting.chartWidth];
        [self.chartView setNeedsDisplay];
    } else {
        if (self.chartConfig.mainChartLineType == ChartLineTypeCandle || self.chartConfig.mainChartLineType == ChartLineTypeBar){
            self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/(keyCount + 1);
        } else {
            self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/keyCount;
        }
        [self updateChartContentSize];
        
        CGFloat minXAxis = [self.chartSetting GetXCoodinateForIndex:fromIndex];
        CGFloat maxXAxis = [self.chartSetting GetXCoodinateForIndex:toIndex];
        if (self.chartConfig.mainChartLineType == ChartLineTypeCandle || self.chartConfig.mainChartLineType == ChartLineTypeBar){
            minXAxis -= self.chartSetting.xAxisPerValue/2;
            maxXAxis += self.chartSetting.xAxisPerValue/2;
        }
        self.chartView.contentOffset = CGPointMake(minXAxis, self.chartView.contentOffset.y);
        [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:minXAxis maxAxis:maxXAxis];
        [self.chartView setNeedsDisplay];
    }
}


- (void)setShowingRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
//    self.fromDate = fromDate;
//    self.toDate = toDate;
//    NSLog(@"setShowingRangeFromDate FROM %@ TO %@", fromDate, toDate);
    NSString * fromKey = nil;
    NSString * toKey = nil;
//    NSInteger keyCount = 0;
    
    for (ChartData * chartData in self.chartDataList){
        if (!fromKey){
            fromKey = chartData.groupingKey;
        }
        if (!toKey){
            toKey = chartData.groupingKey;
        }
        if ([chartData.date timeIntervalSince1970] > [toDate timeIntervalSince1970]){
            break;
        }
        if ([chartData.date timeIntervalSince1970] < [fromDate timeIntervalSince1970]){
            fromKey = chartData.groupingKey;
        }
        toKey = chartData.groupingKey;
    }
    if (!fromKey || !toKey){
        return;
    }
    NSInteger fromIndex = [self.groupingKeyList indexOfObject:fromKey];
    NSInteger toIndex = [self.groupingKeyList indexOfObject:toKey];
    
    if (fromIndex == NSNotFound || toIndex == NSNotFound){
        return;
    }
    
    [self setShowingRangeFromIndex:fromIndex toIndex:toIndex];
    
}
@end
