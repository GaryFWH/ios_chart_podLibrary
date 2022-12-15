//
//  ChartViewController.m
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import "FullChartViewController.h"
#import "ChartView.h"
#import "MultiChartView.h"
#import "ChartClass.h"
#import "TIChartClass.h"
#import "ChartLineObject.h"
#import "MainTIList.h"
#import "SubTiList.h"
#import "ChartDrawCommon.h"
#import "CustomDrawView.h"
#import "ChartTICalculator.h"

typedef NS_ENUM(NSInteger, FullChartControlState){
    FullChartControlStateIdle,
    FullChartControlStateScroll,
    FullChartControlStateCursor,
    FullChartControlStateZoom,
};


@interface FullChartViewController () <UIScrollViewDelegate, ChartViewTouchDelegate, ChartClassDisplayDelegate, TIChartClassDisplayDelegate, CustomDrawViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FullChartConfig * chartConfig;
@property (strong, nonatomic) ChartGlobalSetting * chartSetting;
@property (strong, nonatomic) NSMutableArray * groupingKeyList;
@property (strong, nonatomic) NSMutableArray<ChartData *> * chartDataList;
@property (strong, nonatomic) ChartView * chartView;

@property (strong, nonatomic) NSLayoutConstraint * mainChartViewHeightConstraint;

@property (strong, nonatomic) MultiChartView * tiChartView;
@property (strong, nonatomic) ChartTI * mainTI;
@property (strong, nonatomic) NSArray * subTIList;
@property (strong, nonatomic) NSMutableDictionary<NSString *, ChartGlobalSetting *> * tiChartSetting;

@property (strong, nonatomic) CustomDrawView * mainTIValueView;
@property (strong, nonatomic) CustomDrawView * subTIValueView;
@property (strong, nonatomic) NSArray * mainTiDisplayDict;
@property (strong, nonatomic) NSArray * subTiDisplayDict;

@property (assign, nonatomic) FullChartState chartState;
@property (assign, nonatomic) FullChartControlState controlState;

@property (strong, nonatomic) CustomDrawView * cursorView;
@property (assign, nonatomic) UITouch * currentTouch;
@property (assign, nonatomic) CGPoint cursorPoint;
@property (strong, nonatomic) NSString * currentSelectedKey;
@end

@implementation FullChartViewController

#pragma mark - ChartClass Delegate

- (ChartGlobalSetting *)globalSettingForChartClass:(ChartClass *)chartClass {
    if (chartClass == self.chartView.chartClass){
        return self.chartSetting;
    } else {
        NSString * tiKey = [self.tiChartView identifierForChartClass:chartClass];
        if (tiKey){
            ChartGlobalSetting * tiSetting = [self.tiChartSetting objectForKey:tiKey];
            if (tiSetting){
                return tiSetting;
            }
        }
    }
    return [[ChartGlobalSetting alloc] init];
}

- (NSArray *)getXAxisKeyList {
    CGFloat xAxisPerView = 3;
//    NSInteger separate = (self.globalSetting.chartWidth/3)/self.globalSetting.xAxisPerValue;
    CGFloat coorPerAxis = self.chartSetting.chartWidth / xAxisPerView;
    NSInteger dataPerXAxis = ceil(coorPerAxis / self.chartSetting.xAxisPerValue);

    NSInteger i = 0;
    NSMutableArray * xAxisList = [NSMutableArray array];
    while (i < [self.groupingKeyList count]){
        [xAxisList addObject:[self.groupingKeyList objectAtIndex:i]];
        i += dataPerXAxis;
    }
    return xAxisList;
}

- (YAxisInfo *)getYAxisInfoForChartClass:(ChartClass *)chartClass withDataMinValue:(CGFloat)dataMin maxValue:(CGFloat)dataMax {
    YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];
    CGFloat rangeDiff = dataMax - dataMin;
//    CGFloat displayYMaxValue = dataMax + rangeDiff * 0.2;
//    CGFloat displayYMinValue = dataMin - rangeDiff * 0.2;
//
//    if (dataMax < 0 && displayYMaxValue > 0){
//        displayYMaxValue = 0;
//    }
//    if (dataMin > 0 && displayYMinValue < 0){
//        displayYMinValue = 0;
//    }
//
//    if (dataMin > dataMax){
//        displayYMinValue = 0;
//        displayYMaxValue = 0;
//    }
//    yAxisInfo.YValueMax = displayYMaxValue;
//    yAxisInfo.YValueMin = displayYMinValue;
    
    if (chartClass == self.chartView.chartClass){
        return [super getYAxisInfoForChartClass:chartClass withDataMinValue:dataMin maxValue:dataMax];

    } else {
//        CGFloat displayYMaxValue = dataMax + rangeDiff * self.chartConfig.subChartYAxisRangeDiffScale;
//        CGFloat displayYMinValue = dataMin - rangeDiff * self.chartConfig.subChartYAxisRangeDiffScale;
        
//        NSString *tiKey = [self.tiChartView chartClassListOrder].firstObject;
//        ChartGlobalSetting * tiSetting = [self.tiChartSetting objectForKey:tiKey];
        
        CGFloat gapScale = [self.chartConfig getSubChartYAxisRangeDiffGapScaleForChartHeight:chartClass.globalSetting.chartHeight];
        switch (self.chartConfig.subChartYAxisGapType) {
            case ChartYAxisGapTypePixel: {
                gapScale = [self.chartConfig getSubChartYAxisRangeDiffGapScaleForChartHeight:chartClass.globalSetting.chartHeight];
            }  break;
            case ChartYAxisGapTypeScale: {
                gapScale = self.chartConfig.subChartYAxisRangeDiffGapScale;
            } break;
        }
        
//        CGFloat yValuePerPixel = ((dataMax + rangeDiff*gapScale) - (dataMin - rangeDiff*gapScale)) / tiSetting.chartHeight;
//        NSLog(@"\nSubChart");
//        NSLog(@"gapPixel %.2f yValPerPixel %.2f gapScale %.2f rangeDiff %.2f", self.chartConfig.subChartYAxisGapPixel, yValuePerPixel, gapScale, rangeDiff);
//        NSLog(@"Expected space - gapP*yValPerPixel %.2f*%.2f=%.2f ; rangeDiff*gapS  %.2f*%.2f=%.2f",
//              self.chartConfig.subChartYAxisGapPixel, yValuePerPixel, self.chartConfig.subChartYAxisGapPixel *yValuePerPixel,
//              rangeDiff, gapScale, rangeDiff*gapScale);
        
        CGFloat displayYMaxValue = dataMax + rangeDiff * gapScale;
        CGFloat displayYMinValue = dataMin - rangeDiff * gapScale;
        if (rangeDiff == 0){
            if (dataMax > 0){
                dataMin = 0;
            } else {
                dataMax = 0;
            }
            rangeDiff = dataMax - dataMin;
            if (dataMax == 0){
                displayYMaxValue = 0;
                displayYMinValue = dataMin - rangeDiff * gapScale;
            }
            if (dataMin == 0){
                displayYMaxValue = dataMax + rangeDiff * gapScale;
                displayYMinValue = 0;
            }
        }
        
        if (dataMax < 0 && displayYMaxValue > 0){
            displayYMaxValue = 0;
        }
        if (dataMin > 0 && displayYMinValue < 0){
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
//            for (NSString * subTi in [self.tiChartSetting allKeys]){
//                ChartGlobalSetting * subChartSetting = [self.tiChartSetting objectForKey:subTi];
                NSInteger lineNumber = self.chartConfig.subChartYAxisLineNum;
                for (NSInteger i = 0; i <= lineNumber; i++){
                    CGFloat yValue = yAxisInfo.YValueMin + i * valueDiff/lineNumber;
                    [array addObject:@(yValue)];
                }
//            }
        } else if (displayYMaxValue > 0){
//        } else if (self.chartConfig.subChartYAxisLineNum > 0){
            yAxisInfo.YValueMax = displayYMaxValue * 2;
            yAxisInfo.YValueMin = 0;
            if (self.chartConfig.subChartYAxisLineNum > 0){
                [array addObject:@(displayYMaxValue)];
            }
        } else {
            yAxisInfo.YValueMax = 0;
            yAxisInfo.YValueMin = displayYMinValue * 2;
            if (self.chartConfig.subChartYAxisLineNum > 0){
                [array addObject:@(displayYMinValue)];
            }
        }
        yAxisInfo.yAxisList = [NSArray arrayWithArray:array];
    }
    return yAxisInfo;
}

//- (NSMutableArray *)groupingKeyList {
//    return _groupingKeyList;
//}



//- (void)updateChartColorConfig:(ChartColorConfig *)chartColorConfig {
//    self.chartConfig.colorConfig = chartColorConfig;
//    [self updateColor];
//}

- (void)updateColor {
    [super updateColor];
//    [self.chartView setBackgroundColor:self.colorConfig.axisBackgroundColor];
    [self.tiChartView setBackgroundColor:self.colorConfig.axisBackgroundColor];
//    [self updateMainChart];
//    [self updateMainChartColor];
    [self.mainTI updateLineObjectColorByChartColorConfig:self.colorConfig];
//    for (ChartTI * ti in self.subTIList){
//        [ti updateLineObjectColorByChartColorConfig:self.colorConfig];
//    }
    for (NSString * subTiKey in self.tiChartView.chartClassListDict) {
        TIChartClass * ti = (TIChartClass*)[self.tiChartView.chartClassListDict objectForKey:subTiKey];
        if (ti != nil) {
            [ti.chartTI updateLineObjectColorByChartColorConfig:self.colorConfig];
        }
    }
    
    [self.chartView setNeedsDisplay];
    [self.tiChartView setNeedsDisplay];
    [self displaySelectedChartData:nil];
}


- (ChartTIConfig *)tiConfig {
    if (self.chartConfig && [self.chartConfig isKindOfClass:[FullChartConfig class]]){
        return self.chartConfig.tiConfig;
    }
    return [[ChartTIConfig alloc] initDefault];
}

//- (instancetype)initWithContainerView:(UIView *)view {
//    if (self = [self init]){
//        [view addSubview:self.view];
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
//        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
//        
//        MainTISMA * ti = [[MainTISMA alloc] init];
//        [ti createDefaultDataList];
//        self.mainTI = ti;
//        
//        MainTISMA * ti1 = [[MainTISMA alloc] init];
//        [ti1 createDefaultDataList];
//        
//        MainTIWMA * ti2 = [[MainTIWMA alloc] init];
//        [ti2 createDefaultDataList];
//        
//        MainTIEMA * ti3 = [[MainTIEMA alloc] init];
//        [ti3 createDefaultDataList];
//        
//        self.subTIList = @[ti1, ti2, ti3];
//        
//        self.config = [[FullChartConfig alloc] init];
//    }
//    return self;
//}

#pragma mark - Class Init

//- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config {
//    if (self = [super initWithContainerView:view withConfig:config]){
//        self.chartConfig.configDelegate = self;
//    }
//    return self;
//}

//- (CGFloat)tiChartHeight {
////    return 150.f;
//    return self.chartConfig.tiChartHeight;
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.chartConfig){
//        self.mainChartViewHeightConstraint.constant = self.chartConfig.chartHeight + self.chartConfig.xAxisHeight;
        self.mainChartViewHeightConstraint.constant = self.chartConfig.mainChartHeight;
//        self.mainChartView.chartClass.globalSetting.chartHeight = self.config.mainChartHeight - self.config.xAxisHeight;
//        [self updateColor];
    }
//
}

- (void)setChartViewScrollInset:(UIScrollViewContentInsetAdjustmentBehavior)behavior {
//    [self.chartView setContentInsetAdjustmentBehavior:behavior];
    if (self.chartView && self.tiChartView){
        [self.chartView setContentInsetAdjustmentBehavior:behavior];
        [self.tiChartView setContentInsetAdjustmentBehavior:behavior];
    } else {
//        self.chartViewScrollInset = behavior;
    }
}


//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    [self resetLayerFrame];
//}

- (void)initView {
    self.chartView = [[ChartView alloc] init];
    self.tiChartView = [[MultiChartView alloc] init];
    self.chartView.delegate = self;
    self.tiChartView.delegate = self;
    
    self.chartView.touchDelegate = self;
    self.tiChartView.touchDelegate = self;
    
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tiChartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.chartView];
    [self.view addSubview:self.tiChartView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.chartView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiChartView}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.mainChartView}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiChartView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view1]-0-[view2]-|" options:0 metrics:nil views:@{@"view1":self.chartView, @"view2":self.tiChartView}]];
    self.mainChartViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(self.chartConfig.mainChartHeight)];
    [self.chartView addConstraint:self.mainChartViewHeightConstraint];
    
    
    self.chartView.backgroundColor = self.colorConfig.axisBackgroundColor;
    self.tiChartView.backgroundColor = self.colorConfig.axisBackgroundColor;
//    self.mainChartView.scrollEnabled = NO;
    
    [self initCursorView];
}

- (void)initCursorView {
//    self.overlayView = [[UIView alloc] init];
//    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.overlayView.userInteractionEnabled = NO;
//    [self.view addSubview:self.overlayView];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.overlayView}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.overlayView}]];
//    [self.view setBackgroundColor:[UIColor clearColor]];
//
//    self.cursorLayer = [[CALayer alloc] init];
//    self.cursorLayer.name = @"cursel";
//    [self.overlayView.layer addSublayer:self.cursorLayer];
//    self.cursorLayer.delegate = self;
    
//    self.mainTiValueLayer = [[CALayer alloc] init];
//    self.mainTiValueLayer.name = @"mainTiValueLayer";
//    [self.overlayView.layer addSublayer:self.mainTiValueLayer];
//    self.mainTiValueLayer.delegate = self;
//
//    self.subTiValueLayer = [[CALayer alloc] init];
//    self.subTiValueLayer.name = @"subTiValueLayer";
//    [self.overlayView.layer addSublayer:self.subTiValueLayer];
//    self.subTiValueLayer.delegate = self;
//    self.subTiValueLayer.needsDisplayOnBoundsChange = YES;
    self.cursorView = [[CustomDrawView alloc] initWithDelegate:self];
    self.cursorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.cursorView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tiChartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.mainTIValueView = [[CustomDrawView alloc] initWithDelegate:self];
    self.mainTIValueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainTIValueView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainTIValueView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainTIValueView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mainTIValueView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainTIValueView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    self.subTIValueView = [[CustomDrawView alloc] initWithDelegate:self];
    self.subTIValueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.subTIValueView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tiChartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.subTIValueView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tiChartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.subTIValueView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tiChartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.subTIValueView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tiChartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.subTIValueView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}

//- (void)resetLayerFrame {
//    [self.cursorLayer setFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, self.overlayView.frame.size.height)];
////    [self.mainTiValueLayer setFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, self.mainChartView.frame.size.height)];
////    [self.subTiValueLayer setFrame:CGRectMake(0, self.mainChartView.frame.size.height, self.overlayView.frame.size.width, self.tiChartView.frame.size.height)];
////
//////    [self.overlayView setNeedsDisplay];
//////    [self.overlayView setNeedsLayout];
//    [self.cursorLayer setNeedsDisplay];
////    [self.mainTiValueLayer setNeedsDisplay];
////    [self.subTiValueLayer setNeedsDisplay];
//}


- (void)updateLayoutAfterResize {
    [self.view layoutIfNeeded];
//    [super updateLayoutWithSize:size];
    self.chartSetting.yAxisWidth = self.chartConfig.yAxisWidth;
    self.chartSetting.xAxisHeight = self.chartConfig.xAxisHeight;
    self.chartSetting.chartWidth = self.view.bounds.size.width - self.chartConfig.yAxisWidth;
    self.chartSetting.chartHeight = self.chartConfig.mainChartHeight - self.chartConfig.xAxisHeight;
    self.mainChartViewHeightConstraint.constant = self.chartConfig.mainChartHeight;
    
    for (NSString * subTi in [self.tiChartSetting allKeys]){
        ChartGlobalSetting * subChartSetting = [self.tiChartSetting objectForKey:subTi];
        subChartSetting.chartWidth = self.chartSetting.chartWidth;
        subChartSetting.yAxisWidth = self.chartSetting.yAxisWidth;
//        subChartSetting.subChartYAxisLineNum = 2;
//        subChartSetting.subChartYAxisRangeDiffGapScale = .5f;
    }
    
    [self updateChartContentSize];
    [self updateChartViewDisplay];
//    [self updateSubChartView];
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(didChangeChartViewContentOffset:ContentOffset:)]) {
        [self.chartDelegate didChangeChartViewContentOffset:self.chartView ContentOffset:self.chartView.contentOffset];
    }
}

#pragma mark - Chart Data
- (void)initMainChartData:(NSArray<ChartData *> *)dataList backgroundList:(NSArray *)backgroundList {
//    dataList = @[];
    [super initMainChartData:dataList backgroundList:backgroundList];
    
    [self initMainTI];
    
    [self initSubTIListData];
    
    if (self.chartView && self.chartView.chartClass) {
        [self.chartView.chartClass setChartAxisLineType:self.chartSetting.axisLineType];
        if (dataList.count > 0) {
            [self.chartView.chartClass setBShowMinMax:self.chartConfig.bShowMinMax];
        } else {
            [self.chartView.chartClass setBShowMinMax:NO];
        }
    }
    
    [self scrollToContentOffsetX:[self.chartView.chartClass maximumScrollOffsetX]];
    
    [self updateChartViewDisplay];
    
    [self displaySelectedChartData:nil];
    

//    [self exportAllChartData];
}

- (void)addMainChartData:(ChartData *)data {
//    bool showingLatestBar = (self.mainChartView.contentOffset.x >= [self.mainChartView maximumScrollOffsetX]);
    bool isShowingLatestBar = [self.chartView.chartClass isShowingLatest];
    
//    [super addMainChartData:data];
//    NSLog(@"NewChartData:%@, %@, %f", data.groupingKey, data.date, data.close);
    ChartData * lastObject = [self.chartDataList lastObject];
    if ([lastObject.groupingKey isEqualToString:data.groupingKey]){
        [self.chartDataList removeLastObject];
    }
    [self.chartDataList addObject:data];
    if (![_groupingKeyList containsObject:data.groupingKey]){
        [_groupingKeyList addObject:data.groupingKey];
    }
    [self.chartView.chartClass updateChartData:data forRefKey:@"MainData"];
    
    [self updateChartContentSize];
    
    [self initMainTI];
    
    [self initSubTIListData];
    
    if (isShowingLatestBar){
        [self scrollToContentOffsetX:[self.chartView.chartClass maximumScrollOffsetX]];
    }
    
    [self updateChartViewDisplay];
    
    [self displaySelectedChartData:nil];
    
    
    
    // Temp
//    [self updateOHLCVal:lastObject];
}

//- (void)updateMainChartType:(ChartLineType)lineType {
//    self.config.mainChartLineType = lineType;
//    [self updateMainChart];
//}


#pragma mark - TI

//- (void)setMainTI:(ChartTI *)mainTI {
////    _mainTI = mainTI;
//    
//    [self initMainTI];
//    
//    [self updateChartViewDisplay];
//    
//    [self displaySelectedChartData:nil];
//}
- (void)setMainTi:(ChartMainTIEnum)mainTi {
    if (self.chartConfig && self.chartConfig.tiConfig){
        self.tiConfig.selectedMainTI = mainTi;
        [self initMainTI];
    }
    [self displaySelectedChartData:nil];
}

- (void)setSubTiList:(NSArray *)subTIList {
//    _subTIList = subTIList;
    if (self.chartConfig && self.chartConfig.tiConfig){
        self.tiConfig.selectedSubTI = subTIList;
        
        [self initSubTIListData];
    }
    
    [self displaySelectedChartData:nil];
}

- (void)addSubTI:(ChartSubTIEnum)subTI {
    if (![self.tiConfig.selectedSubTI containsObject:@(subTI)]){
        NSMutableArray * subTIArray = [NSMutableArray arrayWithArray:self.tiConfig.selectedSubTI];
        [subTIArray addObject:@(subTI)];
        self.tiConfig.selectedSubTI = [NSArray arrayWithArray:subTIArray];
        
        [self initSubTIListData];
        
        [self displaySelectedChartData:nil];
    }
}

- (void)removeSubTI:(ChartSubTIEnum)subTI {
    if ([self.tiConfig.selectedSubTI containsObject:@(subTI)]){
        NSMutableArray * subTIArray = [NSMutableArray arrayWithArray:self.tiConfig.selectedSubTI];
        [subTIArray removeObject:@(subTI)];
        self.tiConfig.selectedSubTI = [NSArray arrayWithArray:subTIArray];
        
        [self initSubTIListData];
        
        [self displaySelectedChartData:nil];
    }
}

- (void)initMainTI {
    [self.chartView.chartClass removeChartLineObjectOtherThanKey:@"MainData"];
//    if (self.mainTI){
//        [self.mainTI initChartObjectListFromChartData:self.chartDataList];
//        [self.mainTI updateLineObjectColorByChartColorConfig:self.colorConfig];
//        [self.chartView.chartClass addChartLineObjects:self.mainTI.tiLineObjects];
////        [self.mainChartView.chartClass addChartLineObjects:[self.mainTI calculateChartObjectListFromChartData:self.mainChartDataList]];
////        [self updateMainChartViewWithoutResize];
//    }
    if (!self.chartConfig || !self.chartConfig.tiConfig){
        [self updateChartViewDisplay];
        return;
    }
    
    switch (self.tiConfig.selectedMainTI){
        case ChartMainTIEnumSMA:
        {
            self.mainTI = [[MainTISMA alloc] init];
        }
            break;
        case ChartMainTIEnumWMA:
        {
            self.mainTI = [[MainTIWMA alloc] init];
        }
            break;
        case ChartMainTIEnumEMA:
        {
            self.mainTI = [[MainTIEMA alloc] init];
        }
            break;
        case ChartMainTIEnumBB:
        {
            self.mainTI = [[MainTIBB alloc] init];
        }
            break;
        case ChartMainTIEnumSAR:
        {
            self.mainTI = [[MainTISAR alloc] init];
        }
            break;
        case ChartMainTINone:
        {
            self.mainTI = nil;
        }
            break;
        case ChartMainTITotalCount:
        
        default:
            break;
    }
    if (self.mainTI){
        [self.mainTI createChartObjectListFromChartData:self.chartDataList withTIConfig:self.tiConfig colorConfig:self.colorConfig];
        [self.chartView.chartClass addChartLineObjects:self.mainTI.tiLineObjects];
    }
    [self updateChartViewDisplay];
    
}

- (void)initSubTIListData {
    [self.tiChartView removeAllChartClass];
    self.tiChartSetting = [NSMutableDictionary dictionary];
    if (!self.chartConfig || !self.chartConfig.tiConfig || !self.chartConfig.tiConfig.selectedSubTI){
        [self updateTiChartContentSize];
        [self updateSubChartView];
        return;
    }
//    if (self.chartDataList && self.chartConfig && self.chartConfig.selectedSubTI){
    NSInteger size = [self.chartConfig.tiConfig.selectedSubTI count];
    NSMutableArray * subTIList = [NSMutableArray array];
    NSMutableArray * classNameList = [NSMutableArray array];
    NSMutableDictionary * chartClassDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < size; i++){
        ChartGlobalSetting * globalSetting = [[ChartGlobalSetting alloc] init];
        globalSetting.startXOffset = self.chartSetting.startXOffset;
        globalSetting.endXOffset = self.chartSetting.endXOffset;
        globalSetting.YOffsetStart = i * self.chartConfig.tiChartHeight + i * self.chartConfig.tiChartGap;
        globalSetting.yAxisWidth = self.chartSetting.yAxisWidth;
        globalSetting.chartWidth = self.chartSetting.chartWidth;
        globalSetting.xAxisHeight = 0.f;
        globalSetting.chartHeight = self.chartConfig.tiChartHeight;
        globalSetting.xAxisPerValue = self.chartSetting.xAxisPerValue;
        globalSetting.axisLineType = self.chartConfig.axisLineType;
        globalSetting.chartYAxisLineNum     = self.chartConfig.subChartYAxisLineNum;
        globalSetting.chartYAxisRangeDiffGapScale   = self.chartConfig.subChartYAxisRangeDiffGapScale;
        globalSetting.chartLineTypeLineLineWidth = self.chartConfig.chartLineTypeLineLineWidth;
        globalSetting.chartLineTypeAreaLineWidth = self.chartConfig.chartLineTypeAreaLineWidth;
        globalSetting.chartLineTypeAreaTopColorLocation = self.chartConfig.chartLineTypeAreaTopColorLocation;
        globalSetting.chartLineTypeAreaMainColorLocation = self.chartConfig.chartLineTypeAreaMainColorLocation;
        
//        globalSetting.subChartYAxisLineNum      = self.chartConfig.subChartYAxisLineNum;
//        globalSetting.subChartYAxisRangeDiffGapScale    = self.chartConfig.subChartYAxisRangeDiffScale;
        
        ChartSubTIEnum subti = (ChartSubTIEnum)[[self.chartConfig.tiConfig.selectedSubTI objectAtIndex:i] integerValue];
        ChartTI * subTi = [self chartTIForSubTI:subti];
        if (subTi){
            TIChartClass * chartClass = [[TIChartClass alloc] initWithChartTI:subTi withChartData:self.chartDataList displayDelegate:self];
            [chartClass setChartAxisLineType:self.chartConfig.axisLineType];
            [classNameList addObject:[subTi refKeyForChart]];
            [chartClassDict setObject:chartClass forKey:[subTi refKeyForChart]];
            
            [self.tiChartSetting setObject:globalSetting forKey:[subTi refKeyForChart]];
            [subTIList addObject:subTi];
        }
    }
    self.subTIList = subTIList;
    self.tiChartView.chartClassListDict = chartClassDict;
    self.tiChartView.chartClassListOrder = classNameList;
//    }
    [self updateTiChartContentSize];
    [self updateSubChartView];
}

- (ChartTI *)chartTIForSubTI:(ChartSubTIEnum)subTI {
    ChartTI * subTi = nil;
    switch (subTI) {
        case ChartSubTIEnumVOL:
            subTi = [[SubTIVolumn alloc] init];
            break;
        case ChartSubTIEnumMACD:
            subTi = [[SubTIMACD alloc] init];
            break;
        case ChartSubTIEnumRSI:
            subTi = [[SubTIRSI alloc] init];
            break;
        case ChartSubTIEnumWill:
            subTi = [[SubTIWilliam alloc] init];
            break;
        case ChartSubTIEnumDMI:
            subTi = [[SubTIDMI alloc] init];
            break;
        case ChartSubTIEnumOBV:
            subTi = [[SubTIOBV alloc] init];
            break;
        case ChartSubTIEnumROC:
            subTi = [[SubTIROC alloc] init];
            break;
        case ChartSubTIEnumSTCFast:
            subTi = [[SubTISTCFast alloc] init];
            break;
        case ChartSubTIEnumSTCSlow:
            subTi = [[SubTISTCSlow alloc] init];
            break;

        default:
            break;
    }
    return subTi;
}

- (ChartMainTIEnum)getCurrentMainTI {
//    return self.chartConfig.selectedMainTI;
    if (self.chartConfig && self.chartConfig.tiConfig){
        return self.chartConfig.tiConfig.selectedMainTI;
    }
    return ChartMainTIUnknown;
}

- (NSArray *)getCurrentSubTIList {
//    return self.chartConfig.selectedSubTI;
    if (self.chartConfig && self.chartConfig.tiConfig){
        return self.chartConfig.tiConfig.selectedSubTI;
    }
    return @[];
}

//- (void)settingSubTIList:(NSArray *)subTIList {
//    if (self.subTIList){
//        [self.tiChartView removeAllChartClass];
//    }
//    if (self.mainChartDataList){
//        NSMutableArray * keyList = [NSMutableArray array];
//        for (ChartData * chartData in self.mainChartDataList){
//            [keyList addObject:chartData.groupingKey];
//        }
//
//        self.subTIList = subTIList;
//        NSInteger size = [self.subTIList count];
//        NSMutableArray * classNameList = [NSMutableArray array];
//        NSMutableDictionary * chartClassDict = [NSMutableDictionary dictionary];
//        for (NSInteger i = 0; i < size; i++){
//            ChartGlobalSetting * globalSetting = [[ChartGlobalSetting alloc] init];
//            globalSetting.startXOffset = self.mainChartSetting.startXOffset;
//            globalSetting.endXOffset = self.mainChartSetting.endXOffset;
//            globalSetting.YOffsetStart = i * [self tiChartHeight] + i * 10;
//    //        CGRect mainChartFrame = self.mainChartView.frame;
//            globalSetting.yAxisWidth = self.mainChartSetting.yAxisWidth;
//            globalSetting.chartWidth = self.mainChartSetting.chartWidth;
//            globalSetting.xAxisHeight = 0.f;
//            globalSetting.chartHeight = [self tiChartHeight];
//            globalSetting.xAxisPerValue = self.mainChartSetting.xAxisPerValue;
//
//            ChartClass * chartClass = [[ChartClass alloc] init];
//
//            ChartTI * subTi = [self.subTIList objectAtIndex:i];
//            NSMutableArray * chartLineObjects = [NSMutableArray arrayWithArray:[subTi calculateChartObjectListFromChartData:self.mainChartDataList]];
//            [chartClass initWithChartObjectList:chartLineObjects keyArray:keyList globalSetting:globalSetting];
//
//            [classNameList addObject:[subTi refKeyForChart]];
//            [chartClassDict setObject:chartClass forKey:[subTi refKeyForChart]];
//        }
//        self.tiChartView.chartClassListDict = chartClassDict;
//        self.tiChartView.chartClassListOrder = classNameList;
//    }
//    [self updateSubChartView];
//}


#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.chartView){
        [self scrollToContentOffsetX:scrollView.contentOffset.x];
        
        [self updateChartViewDisplay];
    }
    if (scrollView == self.tiChartView){
//        self.mainChartView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.mainChartView.contentOffset.y);
        [self scrollToContentOffsetX:scrollView.contentOffset.x];
        
        [self updateSubChartView];
        
        
    }
    if (self.controlState == FullChartControlStateCursor && self.currentTouch){
        [self displayCursorAtTouch:self.currentTouch];
    }
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(didChangeChartViewContentOffset:ContentOffset:)]) {
        [self.chartDelegate didChangeChartViewContentOffset:self.chartView ContentOffset:self.chartView.contentOffset];
    }
}

- (void)scrollToContentOffsetX:(CGFloat)x {
    CGFloat maximumOffset = [self.chartView.chartClass maximumScrollOffsetX];
    if (x > maximumOffset){
        x = maximumOffset;
    }
    self.chartView.contentOffset = CGPointMake(x, self.chartView.contentOffset.y);
    self.tiChartView.contentOffset = CGPointMake(x, self.tiChartView.contentOffset.y);
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0];
//    [self.subTiValueLayer setBounds:CGRectMake(self.subTiValueLayer.bounds.origin.x, self.tiChartView.contentOffset.y, self.subTiValueLayer.bounds.size.width, self.subTiValueLayer.bounds.size.height)];
//    [CATransaction commit];
    if (self.tiChartView.contentOffset.y != self.subTIValueView.bounds.origin.y){
        [self.subTIValueView setBounds:CGRectMake(self.subTIValueView.bounds.origin.x, self.tiChartView.contentOffset.y, self.subTIValueView.bounds.size.width, self.subTIValueView.bounds.size.height)];
        [self.subTIValueView setNeedsDisplay];
    }
//    self.mainChartView.contentOffset = CGPointMake(self.mainChartView.contentSize.width-globalSetting.chartWidth-globalSetting.yAxisWidth, 0);
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(didChangeChartViewContentOffset:ContentOffset:)]) {
        [self.chartDelegate didChangeChartViewContentOffset:self.chartView ContentOffset:self.chartView.contentOffset];
    }
}

#pragma mark - Update View

- (void)updateChartContentSize {
    
    self.chartView.contentSize = [self.chartView.chartClass getContentSize];
//    self.tiChartView.contentSize = CGSizeMake(self.mainChartView.contentSize.width, self.tiChartView.frame.size.height);
//    self.tiChartView.contentSize = [self.tiChartView getContentSize];
//    [self updateMainChartViewWithoutResize];
    [self updateTiChartContentSize];
}

- (void)updateTiChartContentSize {
    CGFloat allTiHeight = [self.subTIList count] * (self.chartConfig.tiChartHeight + self.chartConfig.tiChartGap);
    
    self.tiChartView.contentSize = CGSizeMake(self.chartView.contentSize.width, allTiHeight);
}

//- (void)updateMainChartViewWithoutResize {
//    [self.chartView.chartClass updateChartDisplayInfoForContentOffset:self.chartView.contentOffset];
//
//    [self.chartView setNeedsDisplay];
//}
- (void)updateChartViewDisplay {
//    NSLog(@"updateMainChartView - axisLineType %ld", self.chartView.chartClass.axisLineType);
    [super updateChartViewDisplay];
    [self updateSubChartView];
    
    [self.cursorView setNeedsDisplay];
    [self.mainTIValueView setNeedsDisplay];
    [self.subTIValueView setNeedsDisplay];
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(didChangeChartViewContentOffset:ContentOffset:)]) {
        [self.chartDelegate didChangeChartViewContentOffset:self.chartView ContentOffset:self.chartView.contentOffset];
    }
}

- (void)updateSubChartView {
//    NSLog(@"updateTIChartView - axisLineType %ld", self.tiChartView.chartClass.axisLineType);
    [self.tiChartView updateAllClassForContentOffset:self.tiChartView.contentOffset];
    [self.tiChartView setNeedsDisplay];
//    [self.subTiValueLayer setNeedsDisplay];
//    [self.overlayView setNeedsDisplay];
}

- (void)setShowingRangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [super setShowingRangeFromIndex:fromIndex toIndex:toIndex];
    
    for (NSString * tiName in [self.tiChartSetting allKeys]){
        ChartGlobalSetting * chartSetting = [self.tiChartSetting objectForKey:tiName];
        chartSetting.xAxisPerValue = self.chartSetting.xAxisPerValue;
    }
    
    self.tiChartView.contentOffset = CGPointMake(self.chartView.contentOffset.x, self.tiChartView.contentOffset.y);
    [self updateSubChartView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Touch Handle
- (void)setControlState:(FullChartControlState)controlState {
    FullChartControlState prevState = _controlState;
    _controlState = controlState;
    if (prevState == FullChartControlStateCursor){
        [self endCursor];
    }
}

- (void)handlControlStateTouch:(NSSet *)touches {
    self.chartView.scrollEnabled = YES;
    self.chartView.multipleTouchEnabled = YES;
    self.tiChartView.scrollEnabled = YES;
    switch (self.controlState){
        case FullChartControlStateCursor:
        {
            self.chartView.scrollEnabled = NO;
            self.chartView.multipleTouchEnabled = NO;
            self.tiChartView.scrollEnabled = NO;
            [self displayCursorAtTouch:[touches anyObject]];
            break;
        }
        case FullChartControlStateZoom:
        {
            self.chartView.scrollEnabled = NO;
            self.tiChartView.scrollEnabled = NO;
            [self zoomChartForTouch:touches];
            break;
        }
        case FullChartControlStateIdle:
        {
            if ([self.chartView contentOffset].x < 0){
//                [self scrollToContentOffsetX:0];
                [self.tiChartView setContentOffset:CGPointMake(0, self.tiChartView.contentOffset.y) animated:YES];
            }
            break;
        }
        case FullChartControlStateScroll:
        default:
            break;
    }
}
/*
- (void)zoomChartForTouch:(NSSet *)touches {
    if ([touches count] == 2){
        UITouch * firstTouch = [[touches allObjects] objectAtIndex:0];
        UITouch * secondTouch = [[touches allObjects] objectAtIndex:1];
        CGPoint prevFirstPoint = [firstTouch previousLocationInView:self.view];
        CGPoint prevSecondPoint = [secondTouch previousLocationInView:self.view];
        
        CGPoint nowFirstPoint = [firstTouch locationInView:self.view];
        CGPoint nowSecondPoint = [secondTouch locationInView:self.view];
        
//        NSLog(@"Prev1:(%.f,%.f), Prev2:(%.f,%.f), Now1(%.f,%.f), Now2(%.f,%.f)",
//              prevFirstPoint.x, prevFirstPoint.y, prevSecondPoint.x, prevSecondPoint.y, nowFirstPoint.x, nowFirstPoint.y, nowSecondPoint.x, nowSecondPoint.y);
        CGFloat prevDistance = fabs(prevFirstPoint.x - prevSecondPoint.x);
        CGFloat nowDistance = fabs(nowFirstPoint.x - nowSecondPoint.x);
        if (prevDistance == 0 || nowDistance == 0){
            return;
        }
        CGFloat adjustxAxis = nowDistance - prevDistance;
//        CGFloat minXAxisPerValue = 5;
//        CGFloat maxXAxisPerValue = 50;
////        self.mainChartView.chartClass.globalSetting.xAxisPerValue += (nowDistance - pre)
////        CGFloat currentXAxisPerValue = self.mainChartView.chartClass.globalSetting.xAxisPerValue;
////        currentXAxisPerValue += adjustxAxis;
////        if (currentXAxisPerValue < minXAxisPerValue){
////            currentXAxisPerValue = minXAxisPerValue;
////        }
////        if (currentXAxisPerValue > maxXAxisPerValue){
////            currentXAxisPerValue = maxXAxisPerValue;
////        }
        
        CGFloat prevContentOffsetX = self.chartView.contentOffset.x + prevFirstPoint.x;
        CGFloat prevContentSizeWidth = self.chartView.contentSize.width;
        
        CGFloat adjustedXAxis = self.chartSetting.xAxisPerValue + adjustxAxis;
//        if (adjustedXAxis >= self.chartConfig.maxXAxisPerIndex){
//            adjustedXAxis = self.chartConfig.maxXAxisPerIndex;
//        }
//        if (adjustedXAxis < self.chartConfig.minXAxisPerIndex){
//            adjustedXAxis = self.chartConfig.minXAxisPerIndex;
//        }
        if (adjustedXAxis >= self.chartSetting.chartWidth / self.chartConfig.minIndexNumDisplay) {
            adjustedXAxis = self.chartSetting.chartWidth / self.chartConfig.minIndexNumDisplay;
        }
        if (adjustedXAxis < self.chartSetting.chartWidth / self.chartConfig.maxIndexNumDisplay) {
            adjustedXAxis = self.chartSetting.chartWidth / self.chartConfig.maxIndexNumDisplay;
        }
        
//        NSLog(@"Chart.w %.2f KeyList %ld cDataList %ld AdjustedXAxis %.2f -> %.2f",
//              self.chartSetting.chartWidth, self.chartDataList.count, self.chartDataList.count
//              ,self.chartSetting.xAxisPerValue + adjustxAxis, adjustedXAxis);
        
        self.chartSetting.xAxisPerValue = adjustedXAxis;

        for (NSString * tiName in [self.tiChartSetting allKeys]){
            ChartGlobalSetting * chartSetting = [self.tiChartSetting objectForKey:tiName];
            chartSetting.xAxisPerValue = adjustedXAxis;
        }
//        [self.mainChartView adjustXAxisPerValueByValue:adjustxAxis];
//        [self.tiChartView adjustXAxisPerValueByValue:adjustxAxis];
        [self updateChartContentSize];

        
        CGFloat newContentSizeWidth = self.chartView.contentSize.width;
        
        [self scrollToContentOffsetX:(newContentSizeWidth * prevContentOffsetX / prevContentSizeWidth - prevFirstPoint.x)];
        
        [self updateChartViewDisplay];
    }
}
*/
- (void)zoomChartForTouch:(NSSet *)touches {
    if ([touches count] == 2){
        UITouch * firstTouch = [[touches allObjects] objectAtIndex:0];
        UITouch * secondTouch = [[touches allObjects] objectAtIndex:1];
        CGPoint prevFirstPoint = [firstTouch previousLocationInView:self.view];
        CGPoint prevSecondPoint = [secondTouch previousLocationInView:self.view];
        CGPoint nowFirstPoint = [firstTouch locationInView:self.view];
        CGPoint nowSecondPoint = [secondTouch locationInView:self.view];
        
        CGFloat firstPointDiff = nowFirstPoint.x - prevFirstPoint.x;
        CGFloat secondPointDiff = nowSecondPoint.x - prevSecondPoint.x;
//        NSLog(@"1st Pt xDiff {%.2f -> %.2f, %.2f} ; 2nd Pt xDiff {%.2f -> %.2f, %.2f} "
//              , prevFirstPoint.x, nowFirstPoint.x, firstPointDiff
//              , prevSecondPoint.x, nowSecondPoint.x, secondPointDiff);
        
        BOOL shouldScrollXAxis = (firstPointDiff > 0 && secondPointDiff > 0) || (firstPointDiff < 0 && secondPointDiff < 0);
        CGFloat xAxisToScroll = 0;
        if (shouldScrollXAxis) {
            if (firstPointDiff > 0 && secondPointDiff > 0) {
                xAxisToScroll = -MIN(firstPointDiff, secondPointDiff);
            } else {
                xAxisToScroll = -MAX(firstPointDiff, secondPointDiff);
            }
        }
        
//        NSLog(@"%f", xAxisToScroll);
        
//        NSLog(@"Prev1:(%.f,%.f), Prev2:(%.f,%.f), Now1(%.f,%.f), Now2(%.f,%.f)", prevFirstPoint.x, prevFirstPoint.y, prevSecondPoint.x, prevSecondPoint.y, nowFirstPoint.x, nowFirstPoint.y, nowSecondPoint.x, nowSecondPoint.y);
        CGFloat prevDistance = fabs(prevFirstPoint.x - prevSecondPoint.x);
        CGFloat nowDistance = fabs(nowFirstPoint.x - nowSecondPoint.x);
        if (prevDistance == 0 || nowDistance == 0){
            return;
        }
        CGFloat adjustxAxis = nowDistance - prevDistance;
        CGFloat adjustxAxisPercentage = (nowDistance - prevDistance) / prevDistance;
//        NSLog(@"adjustXAxis %.2f = nowD %.2f - prevD %.2f | Percentage %.2f", adjustxAxis, nowDistance, prevDistance, adjustxAxisPercentage);
        
//        CGFloat minXAxisPerValue = 5;
//        CGFloat maxXAxisPerValue = 50;
////        self.mainChartView.chartClass.globalSetting.xAxisPerValue += (nowDistance - pre)
////        CGFloat currentXAxisPerValue = self.mainChartView.chartClass.globalSetting.xAxisPerValue;
////        currentXAxisPerValue += adjustxAxis;
////        if (currentXAxisPerValue < minXAxisPerValue){
////            currentXAxisPerValue = minXAxisPerValue;
////        }
////        if (currentXAxisPerValue > maxXAxisPerValue){
////            currentXAxisPerValue = maxXAxisPerValue;
////        }
        
        CGFloat prevContentOffsetX = self.chartView.contentOffset.x + prevFirstPoint.x;
        CGFloat prevContentSizeWidth = self.chartView.contentSize.width;
        
        CGFloat adjustedXAxis = self.chartSetting.xAxisPerValue * (1 + adjustxAxisPercentage);

//        if (adjustedXAxis >= self.chartConfig.maxXAxisPerIndex){
//            adjustedXAxis = self.chartConfig.maxXAxisPerIndex;
//        }
//        if (adjustedXAxis < self.chartConfig.minXAxisPerIndex){
//            adjustedXAxis = self.chartConfig.minXAxisPerIndex;
//        }
        if (adjustedXAxis >= self.chartSetting.chartWidth / self.chartConfig.minIndexNumDisplay) {
            adjustedXAxis = self.chartSetting.chartWidth / self.chartConfig.minIndexNumDisplay;
        }
        if (adjustedXAxis < self.chartSetting.chartWidth / self.chartConfig.maxIndexNumDisplay) {
            adjustedXAxis = self.chartSetting.chartWidth / self.chartConfig.maxIndexNumDisplay;
        }
        
        self.chartSetting.xAxisPerValue = adjustedXAxis;
        
//        NSLog(@"[After] AdjustedXAxis %.2f ; xAxisPerVal %.2f \n ", adjustedXAxis, self.chartSetting.xAxisPerValue);

        for (NSString * tiName in [self.tiChartSetting allKeys]){
            ChartGlobalSetting * chartSetting = [self.tiChartSetting objectForKey:tiName];
            chartSetting.xAxisPerValue = adjustedXAxis;
        }
//        [self.mainChartView adjustXAxisPerValueByValue:adjustxAxis];
//        [self.tiChartView adjustXAxisPerValueByValue:adjustxAxis];
        [self updateChartContentSize];

        
        CGFloat newContentSizeWidth = self.chartView.contentSize.width;
        
        [self scrollToContentOffsetX:(newContentSizeWidth * prevContentOffsetX / prevContentSizeWidth - prevFirstPoint.x) + xAxisToScroll];
        
        [self updateChartViewDisplay];
    }
}

- (void)displayCursorAtTouch:(UITouch *)touch {
    self.currentTouch = touch;
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.chartView.frame, point)){
//        CGPoint pointInOverlay = [touch locationInView:self.overlayView];
        
        CGPoint pointInMainView = [touch locationInView:self.chartView];
        
//        [self.cursorLayer setFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, self.overlayView.frame.size.height)];
        [self.chartView getNearestChartPointFromPoint:pointInMainView completion:^(bool found, NSString * key, CGPoint point) {
//            self.cursorLayer.hidden = !found;
            self.cursorView.hidden = !found;
            if (found){
                self.cursorPoint = point;
            } else {
                key = [self.chartDataList lastObject].groupingKey;
            }
            if (key){
                [self displaySelectedChartData:key];
            }
//            [self.cursorLayer setNeedsDisplay];
            [self.cursorView setNeedsDisplay];
        }];
    }
}

- (void)endCursor {
    self.currentTouch = nil;
    [self displaySelectedChartData:nil];
//    [self.cursorLayer setNeedsDisplay];
    [self.cursorView setNeedsDisplay];
}

- (void)displaySelectedChartData:(NSString *)key {
    if (!key){
        if (self.currentTouch){
            [self displayCursorAtTouch:self.currentTouch];
            return;
        }
        key = [self.chartDataList lastObject].groupingKey;
    }
    self.currentSelectedKey = key;
    NSArray * chartDataList = [self.chartView.chartClass getChartDataByGroupingKey:key];
//    for (ChartData * cData in chartDataList){
    NSMutableArray * mainTIArray = [NSMutableArray array];
    for (NSDictionary * dataDict in chartDataList){
//        ChartData * cData = [dataDict objectForKey:@"data"];
        NSString * name = [dataDict objectForKey:@"name"];
//        UIColor * color = [dataDict objectForKey:@"color"];
//        NSLog(@"Name:%@ Date:%@ Value:%@", name, [self formatDate:cData.date], [self formatValue:cData.close]);
        if (name && [name isEqualToString:@"MainData"]){
            if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(displaySelectedMainChartData:)]){
                [self.chartDelegate displaySelectedMainChartData:[dataDict objectForKey:@"data"]];
            }
        } else {
            [mainTIArray addObject:dataDict];
        }
        
    }

    self.mainTiDisplayDict = [NSArray arrayWithArray:mainTIArray];
    [self.mainTIValueView setNeedsDisplay];
//    [self.mainTiValueLayer setNeedsDisplay];
    
    NSMutableArray * subTIArray = [NSMutableArray array];
    NSArray * tiChartCLassList = [self.tiChartView chartClassListOrder];
    for (NSString * tiKey in tiChartCLassList){
        NSMutableArray * eachTiArray = [NSMutableArray array];
        ChartGlobalSetting * tiSetting = [self.tiChartSetting objectForKey:tiKey];
        ChartClass * chartClass = [self.tiChartView.chartClassListDict objectForKey:tiKey];
        if (tiSetting && chartClass){
            NSArray * chartDataList = [chartClass getChartDataByGroupingKey:key];
            for (NSDictionary * dataDict in chartDataList){
                [eachTiArray addObject:dataDict];
            }
        }
        NSDictionary * dict = @{
            @"setting": tiSetting,
            @"data": eachTiArray
        };
        [subTIArray addObject:dict];
    }
    self.subTiDisplayDict = [NSArray arrayWithArray:subTIArray];
//    [self.subTiValueLayer setNeedsDisplay];
    [self.subTIValueView setNeedsDisplay];
}

- (ChartData*)getSelectedChartData:(nullable NSString *)key{
    ChartData * chartData = [[ChartData alloc] init];
    
    if (!key){
        key = [self.chartDataList lastObject].groupingKey;
    }
    NSArray * chartDataList = [self.chartView.chartClass getChartDataByGroupingKey:key];
    NSMutableArray * mainTIArray = [NSMutableArray array];
    for (NSDictionary * dataDict in chartDataList){
        NSString * name = [dataDict objectForKey:@"name"];
        if (name && [name isEqualToString:@"MainData"]) {
            chartData = [dataDict objectForKey:@"data"];
//            if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(displaySelectedMainChartData:)]){
//                [self.chartDelegate displaySelectedMainChartData:[dataDict objectForKey:@"data"]];
//            }
        } else {
//            [mainTIArray addObject:dataDict];
        }
        
    }
    return chartData;
}

- (void)chartView:(ChartView *)chartView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    FullChartControlState state = FullChartControlStateIdle;
    if ([touches count] == 2){
//        state = FullChartControlStateIdle;
        state = FullChartControlStateZoom;
    } else {
        CGPoint point = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.chartView.frame, point)){
            state = FullChartControlStateCursor;
//            return;
        } else if (CGRectContainsPoint(self.tiChartView.frame, point)){
            state = FullChartControlStateScroll;
        }
    }
    self.controlState = state;
    [self handlControlStateTouch:touches];
}

- (void)chartView:(ChartView *)chartView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    FullChartControlState state = FullChartControlStateIdle;
//    if ([touches count] == 2){
    if (self.controlState == FullChartControlStateZoom) {
        state = FullChartControlStateZoom;
    } else {
        CGPoint point = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.chartView.frame, point)){
            state = FullChartControlStateCursor;
//            return;
        } else if (CGRectContainsPoint(self.tiChartView.frame, point)){
            state = FullChartControlStateScroll;
        }
    }
    self.controlState = state;
    [self handlControlStateTouch:touches];
}

- (void)chartView:(ChartView *)chartView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = [touches anyObject];
//    if ([touches count] == 2){
//
//    } else {
//        if (chartView == self.mainChartView){
//            [self endTouchMainView];
//        }
//    }
    self.controlState = FullChartControlStateIdle;
    [self handlControlStateTouch:touches];
}

//#pragma mark - CALayerDelegate
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
////    [CATransaction begin];
////    [CATransaction setDisableActions:YES];
//    if ([layer.name isEqualToString:@"cursel"]){
//        if (self.controlState == FullChartControlStateCursor){
//            CGPoint left = CGPointMake(0, self.cursorPoint.y);
//            CGPoint right = CGPointMake(layer.frame.size.width, self.cursorPoint.y);
//
//            CGPoint top = CGPointMake(self.cursorPoint.x, 0);
//            CGPoint bottom = CGPointMake(self.cursorPoint.x, layer.frame.size.height);
//            [ChartDrawCommon DrawLineOnContext:ctx pointA:left pointB:right color:[UIColor greenColor]];
//            [ChartDrawCommon DrawLineOnContext:ctx pointA:top pointB:bottom color:[UIColor greenColor]];
//
//            if (self.currentSelectedKey){
//                ChartData * mainData = [[[self.mainChartView.chartClass getChartDataByKey:self.currentSelectedKey] firstObject] objectForKey:@"data"];
//                CGPoint yAxis = CGPointMake(self.config.chartWidth, self.cursorPoint.y);
//                CGPoint xAxis = CGPointMake(self.cursorPoint.x, self.config.chartHeight);
//
//                chartTextBoxInfo * yAxisInfo = [ChartDrawCommon GetTextRectFromPoint:yAxis pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(self.config.yAxisWidth, CGFLOAT_MAX) text:[self formatValue:mainData.close] initialFont:[self axisFont] color:[UIColor whiteColor]];
//
//                chartTextBoxInfo * xAxisInfo = [ChartDrawCommon GetTextRectFromPoint:xAxis pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, self.config.xAxisHeight) text:[self formatDate:mainData.date] initialFont:[self axisFont] color:[UIColor whiteColor]];
//
//                [ChartDrawCommon DrawRectOnContext:ctx rect:yAxisInfo.rect color:[UIColor blackColor] isFill:YES];
//                [ChartDrawCommon DrawRectOnContext:ctx rect:xAxisInfo.rect color:[UIColor blackColor] isFill:YES];
//
//                [ChartDrawCommon DrawTextOnContext:ctx textBoxInfo:yAxisInfo];
//                [ChartDrawCommon DrawTextOnContext:ctx textBoxInfo:xAxisInfo];
//
//            }
//        }
//    }
//    if ([layer.name isEqualToString:@"mainTiValueLayer"]){
//        CGFloat textHeight = 20.f;
//        if (self.mainTiDisplayDict && [self.mainTiDisplayDict isKindOfClass:[NSArray class]]){
//            CGFloat maxWidthEach = self.mainChartSetting.chartWidth/ [self.mainTiDisplayDict count] - 5;
//            CGFloat originX = 0.f;
//            CGFloat originY = 0.f;
//            for (NSDictionary * dict in self.mainTiDisplayDict){
//                NSString * name = [dict objectForKey:@"name"];
//                UIColor * color = [dict objectForKey:@"color"];
//                ChartData * cData = [dict objectForKey:@"data"];
//                NSString * displayData = [NSString stringWithFormat:@"%@: %@", name, [self.config formatValue:cData.close]];
//                chartTextBoxInfo * boxInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(originX, originY) pointDirection:ChartTextBoxPointDirectionFromTopLeft sizeLimit:CGSizeMake(maxWidthEach,textHeight) text:displayData initialFont:[self axisFont] color:color];
//                [ChartDrawCommon DrawTextOnContext:ctx textBoxInfo:boxInfo];
//                originX += boxInfo.rect.size.width;
//                originX += 5;
//            }
//        }
//    }
//    if ([layer.name isEqualToString:@"subTiValueLayer"]){
//        CGFloat textHeight = 20.f;
//        if (self.subTiDisplayDict && [self.subTiDisplayDict isKindOfClass:[NSArray class]]){
//            for (NSDictionary * tiDict in self.subTiDisplayDict){
//                ChartGlobalSetting * setting = [tiDict objectForKey:@"setting"];
//                NSArray * dataList = [tiDict objectForKey:@"data"];
//                if (dataList && [dataList isKindOfClass:[NSArray class]]){
//                    CGFloat maxWidthEach = setting.chartWidth/ [dataList count] -5;
//                    CGFloat originX = 0.f;
//                    CGFloat originY = setting.YOffsetStart;
////                    if ( ((originY + textHeight) > 0.f) && (originY < self.tiChartView.frame.size.height) ){
//                        for (NSDictionary * dict in dataList){
//                            NSString * name = [dict objectForKey:@"name"];
//                            UIColor * color = [dict objectForKey:@"color"];
//                            ChartData * cData = [dict objectForKey:@"data"];
//                            NSString * displayData = [NSString stringWithFormat:@"%@: %@", name, [self.config formatValue:cData.close]];
//                            chartTextBoxInfo * boxInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(originX, originY) pointDirection:ChartTextBoxPointDirectionFromTopLeft sizeLimit:CGSizeMake(maxWidthEach,textHeight) text:displayData initialFont:[self axisFont] color:color];
//                            [ChartDrawCommon DrawTextOnContext:ctx textBoxInfo:boxInfo];
//                            originX += boxInfo.rect.size.width;
//                            originX += 5;
//                        }
////                    }
//                }
//            }
//        }
//    }
////    [CATransaction commit];
//}

- (void)drawCursorOnSelectedKey:(CGContextRef)context {
    if (self.currentSelectedKey){
        ChartData * mainData = [[[self.chartView.chartClass getChartDataByGroupingKey:self.currentSelectedKey] firstObject] objectForKey:@"data"];
        CGPoint yAxis = CGPointMake(self.chartSetting.chartWidth, self.cursorPoint.y);
        CGPoint xAxis = CGPointMake(self.cursorPoint.x, self.chartSetting.chartHeight);
        
        chartTextBoxInfo * yAxisInfo = [ChartDrawCommon GetTextRectFromPoint:yAxis pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(self.chartConfig.yAxisWidth, CGFLOAT_MAX) text:[self formatValue:mainData.close] initialFont:[self axisFont] fontColor:self.chartConfig.colorConfig.selectDataColor bgColor:self.chartConfig.colorConfig.selectDataBGColor];
         
        chartTextBoxInfo * xAxisInfo = [ChartDrawCommon GetTextRectFromPoint:xAxis pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, self.chartConfig.xAxisHeight) text:[self formatSelectDate:mainData.date] initialFont:[self axisFont] fontColor:self.chartConfig.colorConfig.selectDataColor bgColor:self.chartConfig.colorConfig.selectDataBGColor];
        
        if (xAxisInfo.rect.origin.x < 0){
            CGRect xRect = xAxisInfo.rect;
            xRect.origin.x = 0;
            xAxisInfo.rect = xRect;
        }
        
        if (CGRectGetMaxX(xAxisInfo.rect) > self.chartSetting.chartWidth){
            CGRect xRect = xAxisInfo.rect;
            xRect.origin.x = self.chartSetting.chartWidth - xRect.size.width;
            xAxisInfo.rect = xRect;
        }
        
        [ChartDrawCommon DrawRectOnContext:context rect:yAxisInfo.rect color:[UIColor blackColor] isFill:YES];
        [ChartDrawCommon DrawRectOnContext:context rect:xAxisInfo.rect color:[UIColor blackColor] isFill:YES];
        
        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:yAxisInfo];
        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:xAxisInfo];
        
    }
}

- (void)customDrawView:(CustomDrawView *)valueView drawRect:(CGRect)rect context:(CGContextRef)context {
    if (valueView == self.cursorView){
        if (self.controlState == FullChartControlStateCursor){
            CGPoint left = CGPointMake(0, self.cursorPoint.y);
            CGPoint right = CGPointMake(rect.size.width - self.chartSetting.yAxisWidth, self.cursorPoint.y);
            
            CGPoint top = CGPointMake(self.cursorPoint.x, 0);
            CGPoint bottom = CGPointMake(self.cursorPoint.x, rect.size.height);
            
            UIColor * cursorColor = self.colorConfig.cursorLineColor;
            
            [ChartDrawCommon DrawLineOnContext:context pointA:left pointB:right color:cursorColor];
            [ChartDrawCommon DrawLineOnContext:context pointA:top pointB:bottom color:cursorColor];
            
            [self drawCursorOnSelectedKey:context];
        }
    }
    if (valueView == self.mainTIValueView){
        CGFloat textHeight = 20.f;
        if (self.mainTiDisplayDict && [self.mainTiDisplayDict isKindOfClass:[NSArray class]]){
            CGFloat maxWidthEach = self.chartSetting.chartWidth/ [self.mainTiDisplayDict count] - 5;
            CGFloat originX = 0.f;
            CGFloat originY = 0.f;
            for (NSDictionary * dict in self.mainTiDisplayDict){
                NSString * name = [dict objectForKey:@"name"];
                UIColor * color = [dict objectForKey:@"color"];
                ChartData * cData = [dict objectForKey:@"data"];
                if (cData && ![cData isEmpty]){
                    NSString * displayData = [NSString stringWithFormat:@"%@: %@", name, [self.chartConfig formatValue:cData.close]];
                    chartTextBoxInfo * boxInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(originX, originY) pointDirection:ChartTextBoxPointDirectionFromTopLeft sizeLimit:CGSizeMake(maxWidthEach,textHeight) text:displayData initialFont:[self axisFont] fontColor:color];
                    [ChartDrawCommon DrawTextOnContext:context textBoxInfo:boxInfo];
                    originX += boxInfo.rect.size.width;
                    originX += 5;
                }
            }
        }
    }
    if (valueView == self.subTIValueView){
        CGFloat textHeight = 20.f;
        if (self.subTiDisplayDict && [self.subTiDisplayDict isKindOfClass:[NSArray class]]){
            for (NSDictionary * tiDict in self.subTiDisplayDict){
                ChartGlobalSetting * setting = [tiDict objectForKey:@"setting"];
                NSArray * dataList = [tiDict objectForKey:@"data"];
                if (dataList && [dataList isKindOfClass:[NSArray class]]){
                    CGFloat maxWidthEach = setting.chartWidth/ [dataList count] -5;
                    CGFloat originX = 0.f;
                    CGFloat originY = setting.YOffsetStart;
//                    if ( ((originY + textHeight) > 0.f) && (originY < self.tiChartView.frame.size.height) ){
                        for (NSDictionary * dict in dataList){
                            NSString * name = [dict objectForKey:@"name"];
                            UIColor * color = [dict objectForKey:@"color"];
//                            ChartData * cData = [dict objectForKey:@"data"];
                            NSString * value = [dict objectForKey:@"value"];
                            NSString * tail = [dict objectForKey:@"tail"];

                            if (value && [value length]) {
                                NSString * displayData;
                                if (tail != nil && ![tail isEqualToString:@""]) {
                                    displayData = [NSString stringWithFormat:@"%@: %@ %@", name, value, tail];
                                } else {
                                    displayData = [NSString stringWithFormat:@"%@: %@", name, value];
                                }
                                chartTextBoxInfo * boxInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(originX, originY) pointDirection:ChartTextBoxPointDirectionFromTopLeft sizeLimit:CGSizeMake(maxWidthEach,textHeight) text:displayData initialFont:[self axisFont] fontColor:color];
                                [ChartDrawCommon DrawTextOnContext:context textBoxInfo:boxInfo];
                                originX += boxInfo.rect.size.width;
                                originX += 5;
                            }
                        }
//                    }
                }
            }
        }
    }
}
#pragma mark - Config Delegate
//- (void)chartConfigUpdateWidth {
//    self.chartSetting.chartWidth = self.chartConfig.chartWidth;
//    self.chartSetting.yAxisWidth = self.chartConfig.yAxisWidth;
////    self.mainChartView.chartClass.globalSetting.chartWidth = self.config.chartWidth - self.config.yAxisWidth;
//
//    for (NSString * key in self.tiChartView.chartClassListOrder){
////        ChartClass * chartClass = [self.tiChartView.chartClassListDict objectForKey:key];
////        chartClass.globalSetting.chartWidth = self.config.chartWidth - self.config.yAxisWidth;
//        [self.tiChartSetting objectForKey:key].chartWidth = self.chartConfig.chartWidth;
//        [self.tiChartSetting objectForKey:key].yAxisWidth = self.chartConfig.yAxisWidth;
//    }
//
//    [self updateChartContentSize];
//
//    [self updateMainChartViewWithoutResize];
//    [self updateSubChartView];
//}
//
//- (void)chartConfigUpdateHeight {
////    self.mainChartViewHeightConstraint.constant = height;
//    self.mainChartViewHeightConstraint.constant = self.chartConfig.chartHeight + self.chartConfig.xAxisHeight;
//
//    self.chartSetting.chartHeight = self.chartConfig.chartHeight;
////    self.mainChartView.chartClass.globalSetting.chartHeight = self.config.mainChartHeight - self.config.xAxisHeight;
//
//    [self updateChartContentSize];
//
//    [self updateMainChartViewWithoutResize];
//    [self updateSubChartView];
//}
- (void)updateMainChartHeight:(CGFloat)height {
    self.chartConfig.mainChartHeight = height;
    
    [self updateLayoutAfterResize];
}

- (void)updateTiChartHeight:(CGFloat)height tiGap:(CGFloat)gap{
    self.chartConfig.tiChartHeight = height;
    self.chartConfig.tiChartGap = gap;
    NSInteger i = 0;
    for (NSString * key in self.tiChartView.chartClassListOrder){
        ChartGlobalSetting * setting = [self.tiChartSetting objectForKey:key];
        setting.YOffsetStart = i * self.chartConfig.tiChartHeight + i * self.chartConfig.tiChartGap;
        setting.chartHeight = self.chartConfig.tiChartHeight;
    }
    
    [self updateTiChartContentSize];
    [self updateSubChartView];
}

- (void)updateChartTiConfig:(ChartTIConfig*)tiConfig {
    if (!self.chartConfig) {
        return;
    }
    
    self.chartConfig.tiConfig = tiConfig;
    
    [self initMainTI];
    
    [self initSubTIListData];
    
    
    [self scrollToContentOffsetX:[self.chartView.chartClass maximumScrollOffsetX]];
    
    [self updateChartViewDisplay];
    
    [self displaySelectedChartData:nil];
}

- (ChartTIConfig*)getTiConfig {
    return self.chartConfig.tiConfig;
}

- (FullChartConfig*)getFullChartConfig {
    return self.chartConfig;
}

- (void)updateTimeZone:(NSTimeZone *)timezone {
    self.chartConfig.timeZone = timezone;
    
    [self updateChartViewDisplay];
    
    [self displaySelectedChartData:nil];

}
#pragma mark - Config

//- (void)updateFullChartFrame {
//    self.config.chartWidth = self.view.frame.size.width - self.config.yAxisWidth;
//    self.config.chartHeight = 
//}
//- (void)updateChartWidth:(CGFloat)width {
//    self.config.chartWidth = width - self.config.yAxisWidth;
//    
//    self.mainChartSetting.chartWidth = self.config.chartWidth;
////    self.mainChartView.chartClass.globalSetting.chartWidth = self.config.chartWidth - self.config.yAxisWidth;
//    
//    for (NSString * key in self.tiChartView.chartClassListOrder){
////        ChartClass * chartClass = [self.tiChartView.chartClassListDict objectForKey:key];
////        chartClass.globalSetting.chartWidth = self.config.chartWidth - self.config.yAxisWidth;
//        [self.tiChartSetting objectForKey:key].chartWidth = self.config.chartWidth;
//    }
//    
//    [self updateChartContentSize];
//    
//    [self updateMainChartViewWithoutResize];
//    [self updateSubChartView];
//    
////    [self resetLayerFrame];
//}
//
//- (void)updateMainChartHeight:(CGFloat)height {
//    self.config.chartHeight = height - self.config.xAxisHeight;
////    self.mainChartViewHeightConstraint.constant = height;
//    self.mainChartViewHeightConstraint.constant = height;
//    
//    self.mainChartSetting.chartHeight = self.config.chartHeight;
////    self.mainChartView.chartClass.globalSetting.chartHeight = self.config.mainChartHeight - self.config.xAxisHeight;
//    
//    [self updateChartContentSize];
//    
//    [self updateMainChartViewWithoutResize];
//    [self updateSubChartView];
//    
////    [self resetLayerFrame];
//}
//
//- (void)updateTiChartHeight:(CGFloat)height {
//    self.config.tiChartHeight = height;
//
//
////    self.tiChartView.contentSize = [self.tiChartView getContentSize];
//    [self updateTiChartContentSize];
//    [self updateSubChartView];
//
////    [self resetLayerFrame];
//}

//- (void)updateValueFormat:(NSString *)valueFormat {
//    self.config.valueDisplayFormat = valueFormat;
//}
//
//- (void)updateDateFormat:(NSString *)dateFormat {
//    self.config.dateDisplayFormat = dateFormat;
//}

#pragma mark - Export Data

- (NSDictionary *)exportAllChartData {
//    NSDictionary * superDict = [super exportAllChartData];
//    NSMutableDictionary * mutDict = [NSMutableDictionary dictionaryWithDictionary:superDict];
//    for (ChartClass * tiClass in [self.tiChartView.chartClassListDict allValues]){
//
//    }
//
//    return mutDict;
    return [ChartTICalculator getDictionaryFromChartConfig:self.tiConfig forChartData:self.chartDataList];
}
//    NSArray * keyList = [self groupingKeyList];
//    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
////    for (ChartLineObject * lineObject in [self.chartView.chartClass getChartLineObjectList]){
//    ChartLineObject * mainDataObject = [self.chartView.chartClass getChartLineObjectByKey:@"MainData"];
////        if ([lineObject isKindOfClass:[ChartLineObjectSingleValue class]]){
//            NSMutableArray * valueList = [NSMutableArray array];
//            for (NSString * key in keyList){
//                ChartData * data = [lineObject.chartDataDict objectForKey:key];
//                if ([data isEmpty]){
//                    continue;
//                }
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
//            }
////        }
//        [mutDict setObject:valueList forKey:lineObject.refKey];
//    }
//    return [NSDictionary dictionaryWithDictionary:mutDict];
//}

@end
