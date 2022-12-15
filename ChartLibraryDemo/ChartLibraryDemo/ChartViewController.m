//
//  ChartViewController.m
//  ChartLibraryDemo
//
//  Created by william on 1/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <ChartFramework/ChartFramework.h>
#import "ChartViewController.h"
//#import "FullChartViewController.h"
//#import "MainTIList.h"
//#import "SubTiList.h"
#import "ChartEtnetDataSource.h"
//#import "ChartHeadView.h"
#import "ChartHeadViewController.h"
//#import "ChartConst.h"
#import "TISelectCollectionViewController.h"
#import "TIConfigViewController.h"
//#import "ChartCommData.h"
//#import "ChartTICalculator.h"
#import "OpenClosePrePostModel.h"

#define CHART_GET_CODEANDNAME @"http://quotese.etnet.com.hk/content/mq3/quoteTitle.php?code=%@"

#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
//#define TOKEN @"%C2%BDQC%C2%A6E%C2%A7JX%C2%91%C2%BB%C2%9C%C2%BD%5Bw%06%29%C2%9E%06%C2%93%C2%8F%C2%A6%C3%B5%C3%85%C3%89"

@interface ChartViewController () <ChartHeadViewControllerDelegate, FullChartViewControllerDelegate, TISelectCollectionViewControllerDelegate, TIConfigViewControllerDelegate>
{
//    NSString * selectedMainTIname;
//    NSMutableArray * selectedSubTIList;
//    ChartMainTIEnum selectedMainTI;
//    NSMutableArray * selectedSubTIList;
}
@property (strong, nonatomic) IBOutlet UIView * headView;
@property (strong, nonatomic) IBOutlet UIButton * closeButton;
@property (strong, nonatomic) IBOutlet UIView * chartContainer;
@property (strong, nonatomic) IBOutlet UIView * typeSettingSelectView;
@property (strong, nonatomic) IBOutlet UIView * timeSettingSelectView;
@property (strong, nonatomic) IBOutlet UIView * sessionSettingSelectView;

@property (strong, nonatomic) FullChartViewController * fullChartViewController;
@property (strong, nonatomic) ChartHeadViewController * chartHeadViewController;
@property (strong, nonatomic) TISelectCollectionViewController * tiSelectCollectionViewController;
@property (strong, nonatomic) TIConfigViewController * tiConfigViewController;

@property (strong, nonatomic) UIView * coverView;


@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField * codeTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;

@property (strong, nonatomic) UIButton * exportBtn;
@property (strong, nonatomic) UIButton * exportCloseBtn;
@property (strong, nonatomic) UIView * exportView;
@property (strong, nonatomic) UITextView * exportTextView;

@property (strong, nonatomic) UIButton * changeContainerBtn;
@property (strong, nonatomic) UIView * changeContainerView;
@property (strong, nonatomic) UITextField * xInput;
@property (strong, nonatomic) UITextField * yInput;
@property (strong, nonatomic) UITextField * widthInput;
@property (strong, nonatomic) UITextField * heightInput;
@property (strong, nonatomic) UIButton * changeConfirmBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartContainerTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartContainerLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartContainerTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartContainerBottom;

@property ChartMinTypeSelection iChartMinType;
//@property ChartDisTypeSelection iChartDisType;
@property ChartColorTypeSelection iChartColorType;
@property ChartLineType iChartLineType;
@property ChartSessionType iChartSessionType;
//@property FinanceChartMinType currMinType;
@property ChartSettingView iSelectType;
//@property int iSelectType;

@property ChartCommData *commData;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:self.closeButton];
//    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
//    [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
//    [self.closeButton addTarget:self action:@selector(closeChart) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.fullChartViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.chartContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.fullChartViewController.view}]];
//    [self.chartContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.fullChartViewController.view}]];
    
    self.iChartMinType = ChartMinTypeSelection5Min;
//    self.iChartDisType = ChartDisTypeSelectionCandlesticks;
    self.iChartLineType = ChartLineTypeCandle;
    self.iChartColorType = ChartColorTypeSelectionLight;
    
    
    
    FullChartConfig * config = [[FullChartConfig alloc] initDefault];
    config.mainChartHeight = SCREENHEIGHT/2;
    config.mainChartLineType = self.iChartLineType;
    config.colorConfig = [ChartColorConfig defaultLightConfig];
    config.axisLineType = ChartAxisLineTypeDash;
//    config.xAxisPerGapScale = 0.1;
    config.xAxisPerGapScale = 0.5;
    config.maxIndexNumDisplay = 1000;
//    config.mainChartYAxisLineNum = 0;
//    config.chartLineTypeLineLineWidth = 5;
//    config.chartLineTypeAreaLineWidth = 20;
//    config.tiChartHeight = 50.f;
    
    self.fullChartViewController = [[FullChartViewController alloc] initWithContainerView:self.chartContainer withConfig:config];
    self.fullChartViewController.chartDelegate = self;
    
//    [self selectedMainTI:[MainTISMA refKeyForChart]];
//    
//    selectedSubTIList = [NSMutableArray arrayWithArray:@[[SubTIRSI refKeyForChart], [SubTIMACD refKeyForChart]]];
//    [self updateSubTIListToFullChart];
    
//    [self.chartContainer addSubview:self.fullChartViewController.view];
    [self.chartContainer setBackgroundColor:[UIColor whiteColor]];
    
    selectView = [[UIView alloc] init];
    selectBtnArray = [NSMutableArray array];
    
    [self initHeadView];
    [self initExportBtn];
    [self initChangeContainerView];
    [self initChangeContainerBtn];
    [self resetFrame];
    
    self.commData = [ChartCommData instance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.fullChartViewController.config.chartWidth = self.view.frame.size.width;
//    [self.fullChartViewController updateChartWidth:self.fullChartViewController.view.frame.size.width];
//    [self.fullChartViewController updateMainChartHeight:(SCREENHEIGHT/2)];
//    [self.fullChartViewController.chartConfig setFullWidth:self.fullChartViewController.view.frame.size.width];
//    [self.fullChartViewController.chartConfig setFullHeight:(SCREENHEIGHT/2)];
//    self.fullChartViewController.chartConfig.mainChartHeight = SCREENHEIGHT/2;
    [self.fullChartViewController updateMainChartHeight:SCREENHEIGHT/2];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self.fullChartViewController updateChartWidth:self.fullChartViewController.view.frame.size.width];
//    [self.fullChartViewController updateMainChartHeight:(SCREENHEIGHT/2)];
//}
//------------------------------------------------------------------------------
#pragma mark - Delegate
//------------------------------------------------------------------------------
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [self.fullChartViewController updateChartWidth:self.fullChartViewController.view.frame.size.width];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    CGSize fullChartView = [self sizeForChildContentContainer:self.fullChartViewController withParentContainerSize:size];
//    [self.fullChartViewController updateChartWidth:fullChartView.width];
//    [self.fullChartViewController updateMainChartHeight:(size.height/2)];
//    [self updateLayoutWithSize:size];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateLayoutWithSize:self.chartContainer.frame.size];
        [self initHeadView];
        [self resetFrame];
//        NSLog(@"Transition colorType %ld", self.iChartColorType);
        
        ChartColorConfig * colorConfig = [ChartColorConfig getColorConfigForColorType:self.iChartColorType];
        [self.chartHeadViewController updateColor:colorConfig];
        [self onClick_ChangeContainerButton];
        [self requestChartData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

//- (void)viewSafeAreaInsetsDidChange {
//    [super viewSafeAreaInsetsDidChange];
//    [self updateLayoutWithSize:self.chartContainer.frame.size];
//}

// Chart Head View Delegate
- (IBAction)closeChart {
//    [[ChartEtnetDataSource sharedInstance] stopStreamingForStockInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshChart{
    [self requestChartData];
}

- (void)requestChartName:(NSString *)code {
    [self.chartHeadViewController.codeNameLabel setText:@""];
    [[ChartEtnetDataSource sharedInstance] requestChartNameForCode:code completion:^(NSString * _Nonnull name) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->codename = name;
            [self.chartHeadViewController.codeNameLabel setText:name];
        });
    }];
}

- (void)requestUSChartData {
    NSString * stockCode = code;
//    [self.commData setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
//    [self.fullChartViewController updateTimeZone:self.commData.timeZone];
    ChartDataInterval interval = [self getChartInterval:self.iChartMinType];
    NSString * dateFormat = @"MM/dd HH:mm";
    switch (interval){
        case ChartDataIntervalMonth:
            dateFormat = @"yyyy/MM";
            break;
        case ChartDataIntervalDay:
        case ChartDataIntervalWeek:
            dateFormat = @"yyyy/MM/dd";
            break;
        default:
            break;
    }
    
    ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
    
    ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:stockCode interval:interval dataType:ChartDataTypeAll codeType:ChartCodeTypeUS session:self.iChartSessionType];
    [self initMainChartData:@[]];
    [self.chartHeadViewController updateOHLCdate:@"" open:@"" high:@"" low:@"" close:@""];
//    [dataSource requestUSChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
    [dataSource requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->code = stockCode;
            [self.chartHeadViewController.codeLabel setText:stockCode];
//            [self initMainChartData:chartData];
            [self.fullChartViewController updateDateDisplayFormat:dateFormat];
            
            if (interval < ChartDataIntervalDay && self.iChartSessionType == ChartSessionTypeCombine){
                NSMutableArray * prePostTime = [NSMutableArray array];
                ChartData * prevData = nil;
                for (ChartData * data in chartData){
                    if (prevData){
//                        NSLog(@"prevKey %@ - nowKey %@", prevData.groupingKey, data.groupingKey);
                        NSArray * colorList = [self getBackgroundForUSNowDate:data.date prevDate:prevData.date];
                        if (colorList){
                            [prePostTime addObject:[[ChartBackground alloc] initWithKey:data.groupingKey colors:colorList]];
                        }
                    }
                    prevData = data;
                }
//                [self.fullChartViewController setBackgroundList:[NSArray arrayWithArray:prePostTime]];
                [self.fullChartViewController initMainChartData:chartData backgroundList:[NSArray arrayWithArray:prePostTime]];
            } else {
//                [self.fullChartViewController setBackgroundList:@[]];
                [self.fullChartViewController initMainChartData:chartData];
            } 
        });
    }];
}

- (NSArray<ChartBackgroundColor *>*)getBackgroundForUSNowDate:(NSDate *)date prevDate:(NSDate *)prevDate {
    /*
    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.commData.timeZone fromDate:date];
    
    NSInteger minutesFromMN = components.hour * 60 + components.minute;

    NSDateComponents * prevComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.commData.timeZone fromDate:prevDate];
  
    NSInteger prevMinutesFromMN = prevComponents.hour * 60 + prevComponents.minute;
    
    NSInteger minutesPreOpen = 4 * 60;
    NSInteger minutesPreClose = 9 * 60 + 30;
    NSInteger minutesPostOpen = 16 * 60;
    NSInteger minutesPostClose = 20 * 60;
    
    bool isNowPre    = (minutesFromMN > minutesPreOpen) && (minutesFromMN <= minutesPreClose);
    bool isNowPost   = (minutesFromMN > minutesPostOpen) && (minutesFromMN <= minutesPostClose);
    bool isNowTrade  = (minutesFromMN > minutesPreClose) && (minutesFromMN <= minutesPostOpen);

    bool isPrevPre   = (prevMinutesFromMN > minutesPreOpen) && (prevMinutesFromMN <= minutesPreClose);
    bool isPrevPost  = (prevMinutesFromMN > minutesPostOpen) && (prevMinutesFromMN <= minutesPostClose);
    bool isPrevTrade = (prevMinutesFromMN > minutesPreClose) && (prevMinutesFromMN <= minutesPostOpen);
    
    ChartColorConfig *colorConfig = [ChartColorConfig getColorConfigForColorType:self.iChartColorType];
    UIColor *bgColor = [UIColor clearColor];
    if (isNowPre || (isPrevPre && isNowTrade)) {
        NSLog(@"Orange");
        bgColor = colorConfig.sessionPreBGColor;
    } else if (isNowPost || (isPrevTrade && isNowPost)) {
        NSLog(@"Blue");
        bgColor = colorConfig.sessionPostBGColor;
    } else {
        NSLog(@"Clear");
    }
     */
    
    OpenClosePrePostModel *model = [OpenClosePrePostModel usMarketOC];
    ChartDataInterval interval = [self getChartInterval:self.iChartMinType];
    ChartColorConfig *colorConfig = [ChartColorConfig getColorConfigForColorType:self.iChartColorType];
    ChartBackgroundColor * bgColor = [model getChartBGColor:date PrevDate:prevDate forInterval:interval ColorConfig:colorConfig];

    //    return @[[[ChartBackgroundColor alloc] initWithColor:bgColor percentage:ratio]];
    return @[bgColor];
    
    /*
    if (isNowPre && isPrevPre){
        NSLog(@"PrePre: %ld:%ld-%ld:%ld", prevComponents.hour, prevComponents.minute, components.hour, components.minute);
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPreBGColor percentage:100]
//        ];
    }
    if (isNowPost && isPrevPost){
        NSLog(@"PostPost: %ld:%ld-%ld:%ld", prevComponents.hour, prevComponents.minute, components.hour, components.minute);
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPostBGColor percentage:100]
//        ];
    }
    if (isPrevPost && isNowPre){

        CGFloat percntage_Post = 100 * (minutesPostClose - prevMinutesFromMN) / ((minutesFromMN - minutesPreOpen) + (minutesPostClose - prevMinutesFromMN));
        CGFloat percntage_Pre = 100 * (minutesFromMN - minutesPreOpen) / ((minutesFromMN - minutesPreOpen) + (minutesPostClose - prevMinutesFromMN));
        NSLog(@"PostPre: %ld:%ld(%.2f%%)-%ld:%ld(%.2f%%)", prevComponents.hour, prevComponents.minute, percntage_Post, components.hour, components.minute, percntage_Pre);
        
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPostBGColor percentage:percntage_Post],
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPreBGColor percentage:percntage_Pre]
//        ];
    }
    if (isPrevPre && isNowPost){
        NSLog(@"PrePost: %ld:%ld-%ld:%ld", prevComponents.hour, prevComponents.minute, components.hour, components.minute);
        
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPreBGColor percentage:50],
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPostBGColor percentage:50]
//        ];
    }
    if (isPrevPre && isNowTrade) {
        CGFloat percentage = 100 * (minutesPreClose - prevMinutesFromMN) / (minutesFromMN - prevMinutesFromMN);
        NSLog(@"PreTrade: %ld:%ld(%.2f%%)-%ld:%ld", prevComponents.hour, prevComponents.minute, percentage, components.hour, components.minute);
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPreBGColor percentage:percentage]
//        ];
    }
    if (isPrevTrade && isNowPost) {
        CGFloat percentage = 100 * (minutesFromMN - minutesPostOpen) / (minutesFromMN - prevMinutesFromMN);;
        NSLog(@"TradePost: %ld:%ld-%ld:%ld(%.2f%%)", prevComponents.hour, prevComponents.minute, components.hour, components.minute, percentage);
//        return @[
//            [[ChartBackgroundColor alloc] initWithColor:colorConfig.sessionPostBGColor percentage:percentage]
//        ];
    }
     
    
    if (isNowPre){
        
    }
    if (isPrevPre){
        
    }
    if (isNowPost){
        
    }
    if (isPrevPost){
        
    }
     
    return @[];
     */
//    BOOL isPrev = [self isUSPreMarket:prevDate];
//    BOOL isNow = [self isUSPreMarket:date];
//
//    if (isPrev && isNow){
//        return 100;
//    }
//    if (isPrev && !isNow){
//
//    }
    
}

//- (BOOL)isUSPreMarket:(NSDate *)date {
////    NSCalendar * usCalendar = [NSCalendar calendarWithIdentifier:@"US"];
////    [usCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
//    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.commData.timeZone fromDate:date];
//    NSInteger hhmm = components.hour * 100 + components.minute;
//    if (hhmm > 400 && hhmm <= 930){
//        return YES;
//    }
//    return NO;
//}

//- (BOOL)isUSPostMarket:(NSDate *)date {
////    NSCalendar * usCalendar = [NSCalendar calendarWithIdentifier:@"US"];
////    [usCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
//    NSDateComponents * components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:self.commData.timeZone fromDate:date];
//    NSInteger hhmm = components.hour * 100 + components.minute;
//    if (hhmm > 1600 && hhmm <= 2000){
//        return YES;
//    }
//    return NO;
//}

- (void)requestChartData {
    NSString * stockCode = code;
    if ([stockCode length] > 3 && [[stockCode substringToIndex:3] isEqualToString:@"US."]){
        [self requestUSChartData];
        return;
    }
    [self.commData setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
    [self.fullChartViewController updateTimeZone:self.commData.timeZone];
    ChartDataInterval interval = [self getChartInterval:self.iChartMinType];
    NSString * dateFormat = @"MM/dd HH:mm";
    switch (interval){
        case ChartDataIntervalMonth:
            dateFormat = @"yyyy/MM";
            break;
        case ChartDataIntervalDay:
        case ChartDataIntervalWeek:
            dateFormat = @"yyyy/MM/dd";
            break;
        default:
            break;
    }
    
    ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
    
    ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:stockCode interval:interval dataType:ChartDataTypeAll codeType:ChartCodeTypeHKStock];
    
    [self initMainChartData:@[]];
    [self.chartHeadViewController updateOHLCdate:@"" open:@"" high:@"" low:@"" close:@""];
    [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//    [dataSource requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->code = stockCode;
            [self.chartHeadViewController.codeLabel setText:stockCode];
            NSLog(@"receive chartData.count %ld", chartData.count);
            [self initMainChartData:chartData];
//            [self.fullChartViewController updateDateFormat:dateFormat];
            
            [[self.fullChartViewController getChartConfig] setMaxIndexNumDisplay:chartData.count];
            [self.fullChartViewController updateDateDisplayFormat:dateFormat];
//                [dataSource streamingDataForStockInfo:request handlingBlock:^(ChartData * _Nonnull data) {
//                    [self.fullChartViewController addMainChartData:data];
//                }];
            
            [self.fullChartViewController setBackgroundList:[NSArray array]];
        });
    }];
}


- (void)searchCode:(NSString *)stockCode {
    if (stockCode && [stockCode length]){
//        code = stockCode;
        [self setStockCode:stockCode];
        [self requestChartData];
//        ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
////        [dataSource loginWithUid:@"BMPuser" token:TOKEN];
//
//        ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:stockCode interval:ChartDataInterval5Min isToday:NO codeType:ChartCodeTypeHKStock];
//
//        [dataSource requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self->code = stockCode;
//                [self.chartHeadViewController.codeLabel setText:stockCode];
//                [self initMainChartData:chartData];
////                [dataSource streamingDataForStockInfo:request handlingBlock:^(ChartData * _Nonnull data) {
////                    [self.fullChartViewController addMainChartData:data];
////                }];
//            });
//        }];
    }
}

- (void)didClickSettingView:(ChartHeadViewController *)chartHeadViewController SelectType:(ChartSettingView)iSelectType {
    if (!selectView.hidden) {
        selectView.hidden = YES;
        
//        if (self.iSelectType == iSelectType){
//            return;
//        }
    }
    
    self.iSelectType = iSelectType;
    if (self.iSelectType == ChartSettingViewMinType) {
        selectView = self.timeSettingSelectView;
        [self openSelectView];
    } else if (iSelectType == ChartSettingViewDisType) {
        selectView = self.typeSettingSelectView;
        [self openSelectView];
    } else if (iSelectType == ChartSettingViewColorType) {
        if (self.iChartColorType == ChartColorTypeSelectionLight) {
            self.iChartColorType = ChartColorTypeSelectionDark;
        } else {
            self.iChartColorType = ChartColorTypeSelectionLight;
        }
        
        [self.chartHeadViewController updateSettingConfig:self.iChartMinType ChartLineType:self.iChartLineType ChartColorType:self.iChartColorType ChartSessionType:self.iChartSessionType];
        
        switch (self.iChartColorType){
            case ChartColorTypeSelectionLight: {
                [self.chartHeadViewController updateColor:[ChartColorConfig defaultLightConfig]];
                [self.fullChartViewController updateChartColorConfig:[ChartColorConfig defaultLightConfig]];
                break;
            }
                
            case ChartColorTypeSelectionDark: {
                [self.chartHeadViewController updateColor:[ChartColorConfig defaultDarkConfig]];
                [self.fullChartViewController updateChartColorConfig:[ChartColorConfig defaultDarkConfig]];
                break;
            }
        }
    } else if (iSelectType == ChartSettingViewSessionType) {
        selectView = self.sessionSettingSelectView;
        [self openSelectView];
    }
}

- (void)onClick_SelectButton:(id)sender {
    UIButton* btn = (UIButton*)sender;
    NSInteger iSelected = btn.tag - 10;
    
    switch (self.iSelectType) {
        case ChartSettingViewMinType: {
            self.iChartMinType = iSelected;
            [self requestChartData];
            break;
        }
        case ChartSettingViewDisType: {
            self.iChartLineType = iSelected;
            [self.fullChartViewController updateMainChartType:self.iChartLineType];
            break;

        }
        case ChartSettingViewColorType:{
            self.iChartColorType = iSelected;
            
            switch (self.iChartColorType){
                case ChartColorTypeSelectionLight:
                    [self.fullChartViewController updateChartColorConfig:[ChartColorConfig defaultLightConfig]];
                    break;
                case ChartColorTypeSelectionDark:
                    [self.fullChartViewController updateChartColorConfig:[ChartColorConfig defaultDarkConfig]];
                    break;
            }
            break;
        }
        case ChartSettingViewSessionType: {
            self.iChartSessionType = iSelected;
            [self requestChartData];
            NSLog(@"iChartSessionType %ld", self.iChartSessionType);
            
            break;
        }
        default:
            break;
    }
    
    if (!selectView.hidden) {
        //[selectView removeFromSuperview];
        selectView.hidden = YES;
    }
    
    [self.chartHeadViewController updateSettingConfig:self.iChartMinType ChartLineType:self.iChartLineType ChartColorType:self.iChartColorType ChartSessionType:self.iChartSessionType];
}

- (void)onClick_ChangeContainerButton {
    if (self.changeContainerView) {
        self.changeContainerView.hidden = !self.changeContainerView.hidden;
        
//        self.xInput.text     = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.x];
//        self.yInput.text     = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.y];
//        self.widthInput.text = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.size.width];
//        self.heightInput.text  = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.size.height];
        
        self.xInput.text     = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.x - [CommonUtil safeAreaInsetLeft]];
        self.yInput.text     = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.y];
        self.widthInput.text = [NSString stringWithFormat:@"%.2f", SCREENWIDTH - self.chartContainerTrailing.constant - [CommonUtil safeAreaInsetLeft] - [CommonUtil safeAreaInsetRight]];
        self.heightInput.text  = [NSString stringWithFormat:@"%.2f", SCREENHEIGHT - self.headView.frame.size.height - self.chartContainerBottom.constant - [CommonUtil safeAreaInsetTop] - [CommonUtil safeAreaInsetBottom]];
        
        self.xInput.text = [NSString stringWithFormat:@"%.2f",self.chartContainerLeading.constant];
        self.yInput.text = [NSString stringWithFormat:@"%.2f",self.chartContainerTop.constant];
        self.widthInput.text = [NSString stringWithFormat:@"%.2f", SCREENWIDTH - [CommonUtil safeAreaInsetLeft] - [CommonUtil safeAreaInsetRight] - self.chartContainerLeading.constant - self.chartContainerTrailing.constant];
        self.heightInput.text = [NSString stringWithFormat:@"%.2f", SCREENHEIGHT - self.headView.frame.size.height - self.chartContainerBottom.constant - [CommonUtil safeAreaInsetTop] - [CommonUtil safeAreaInsetBottom] - self.chartContainerTop.constant];
    }
}

- (void)didClickTiSetting:(ChartHeadViewController *)chartHeadViewController {
    [self displayTISelectView];
}

- (void)didClickTISetup {
    [self displayTIConfigView];
}

- (void)didClickTIDone {
    [self closeTICoverView];
}

- (void)didClickConfirmBtn:(TIConfigViewController *)tiConfigViewController ChartTIConfig:(ChartTIConfig *)tiConfig {
    [self closeTIConfigView];
    
    if (tiConfig) {
        [self.fullChartViewController updateChartTiConfig:tiConfig];
    }
}

- (void)didClickBackBtn:(TIConfigViewController *)tiConfigViewController {
    [self closeTIConfigView];
}

//------------------------------------------------------------------------------
#pragma mark - Public
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------
- (void)updateLayoutWithSize:(CGSize)size{
//    CGSize fullChartView = [self sizeForChildContentContainer:self.fullChartViewController withParentContainerSize:size];
//    [self.fullChartViewController updateChartWidth:size.width];
//    [self.fullChartViewController updateMainChartHeight:(size.height/2)];
//    [self.fullChartViewController.chartConfig setFullWidth:size.width];
//    [self.fullChartViewController.chartConfig setFullHeight:(size.height/2)];
//    self.fullChartViewController.chartConfig.mainChartHeight = size.height/2;
    [self.fullChartViewController updateMainChartHeight:size.height/2];
//    [self.fullChartViewController updateViewConstraints];
    [self.fullChartViewController updateLayoutAfterResize];
}

- (void)initMainChartData:(NSArray<ChartData *> *)dataList {
    [self.fullChartViewController initMainChartData:dataList];
}

- (void)initHeadView {
//    [self.headView.closeButton addTarget:self action:@selector(closeChart) forControlEvents:UIControlEventTouchUpInside];
    if (self.chartHeadViewController != nil) {
        self.chartHeadViewController.view = nil;
        self.chartHeadViewController = nil;
    }
    
    if (self.chartHeadViewController == nil){
        if (SCREENWIDTH > SCREENHEIGHT) {
            self.chartHeadViewController = [[ChartHeadViewController alloc] initWithNibName:@"ChartHeadViewController" bundle:nil];
            self.headViewHeight.constant = 50.f;
        } else {
            self.chartHeadViewController = [[ChartHeadViewController alloc] initWithNibName:@"ChartHeadViewController_V" bundle:nil];
            self.headViewHeight.constant = 100.f;
        }
        [self.headView addSubview:self.chartHeadViewController.view];
        
        self.chartHeadViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil
                                                                                views:@{@"view":self.chartHeadViewController.view}]];
        [self.headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil
                                                                                views:@{@"view":self.chartHeadViewController.view, }]];
        self.chartHeadViewController.delegate = self;
        
        [self initSelectView];
    }
//    [self resetFrame];
}

- (void)closeExportView {
    [self.exportView removeFromSuperview];
}

- (void)exportBtnAction {
    if (!self.exportView){
        self.exportView = [[UIView alloc] init];
        self.exportView.backgroundColor = [UIColor grayColor];
        self.exportTextView = [[UITextView alloc] init];
        self.exportCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.exportCloseBtn setTitle:@"Close" forState:UIControlStateNormal];
        [self.exportCloseBtn addTarget:self action:@selector(closeExportView) forControlEvents:UIControlEventTouchUpInside];
        [self.exportCloseBtn setBackgroundColor:[UIColor whiteColor]];
        [self.exportCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.exportCloseBtn.layer.borderWidth = 1.f;
        self.exportCloseBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.exportCloseBtn.layer.cornerRadius = 25.f;
        self.exportCloseBtn.layer.masksToBounds = YES;
        [self.exportView addSubview:self.exportTextView];
        [self.exportView addSubview:self.exportCloseBtn];
    }
    self.exportView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.exportTextView.frame = CGRectMake(20, 20, SCREENWIDTH-40, SCREENHEIGHT-40);
    self.exportCloseBtn.frame = CGRectMake(SCREENWIDTH-50, 50, 50, 50);
    [self.view addSubview:self.exportView];
    
    NSDictionary * allData = [self.fullChartViewController exportAllChartData];
    [self.exportTextView setText:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:allData options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
}

- (void)initExportBtn{
    self.exportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exportBtn addTarget:self action:@selector(exportBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.exportBtn setTitle:@"Exp" forState:UIControlStateNormal];
    [self.exportBtn setBackgroundColor:[UIColor whiteColor]];
    [self.exportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.exportBtn.layer.borderWidth = 1.f;
    self.exportBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.exportBtn.layer.cornerRadius = 25.f;
    self.exportBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.exportBtn];
    [self.exportBtn setFrame:CGRectMake(SCREENWIDTH - 50, 200, 50, 50)];
}

- (void)initChangeContainerBtn{
    self.changeContainerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeContainerBtn addTarget:self action:@selector(onClick_ChangeContainerButton) forControlEvents:UIControlEventTouchUpInside];
    [self.changeContainerBtn setTitle:@"Container Frame" forState:UIControlStateNormal];
    [self.changeContainerBtn setBackgroundColor:[UIColor whiteColor]];
    [self.changeContainerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.changeContainerBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    self.changeContainerBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.changeContainerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.changeContainerBtn.layer.borderWidth = 1.f;
    self.changeContainerBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeContainerBtn.layer.cornerRadius = 25.f;
    self.changeContainerBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.changeContainerBtn];
    [self.changeContainerBtn setFrame:CGRectMake(SCREENWIDTH - 50, 150, 50, 50)];
}

- (void)initChangeContainerView {
    self.changeContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.chartContainer.frame.origin.x, self.chartContainer.frame.origin.y, self.changeConfirmBtn.frame.origin.x + self.changeConfirmBtn.frame.size.width + 20, 30)];
    self.changeContainerView.backgroundColor = [UIColor lightGrayColor];
    self.changeContainerView.alpha = 0.9;
    self.changeContainerView.hidden = YES;
    
    CGFloat xPos = 5;
    CGFloat txtWidth = 50;
    CGFloat txtHeight = 20;
    
    self.xInput = [[UITextField alloc] initWithFrame:CGRectMake(xPos, 5, txtWidth, txtHeight)];
    self.yInput = [[UITextField alloc] initWithFrame:CGRectMake(xPos*2 + txtWidth, 5, txtWidth, txtHeight)];
    self.widthInput = [[UITextField alloc] initWithFrame:CGRectMake(xPos*3 + txtWidth*2, 5, txtWidth, txtHeight)];
    self.heightInput = [[UITextField alloc] initWithFrame:CGRectMake(xPos*4 + txtWidth*3, 5, txtWidth, txtHeight)];
    
    self.changeConfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changeConfirmBtn.frame = CGRectMake(xPos*5 + txtWidth*4, 5, txtWidth, txtHeight);
    [self.changeConfirmBtn addTarget:self action:@selector(updateChartContainerFrame) forControlEvents:UIControlEventTouchUpInside];
    [self.changeConfirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    
    self.xInput.placeholder = @"x";
    self.yInput.placeholder = @"y";
    self.widthInput.placeholder = @"width";
    self.heightInput.placeholder = @"height";
    
    [self.xInput setFont:[UIFont systemFontOfSize:11]];
    [self.yInput setFont:[UIFont systemFontOfSize:11]];
    [self.widthInput setFont:[UIFont systemFontOfSize:11]];
    [self.heightInput setFont:[UIFont systemFontOfSize:11]];
    
    self.xInput.adjustsFontSizeToFitWidth = YES;
    self.yInput.adjustsFontSizeToFitWidth = YES;
    self.widthInput.adjustsFontSizeToFitWidth = YES;
    self.heightInput.adjustsFontSizeToFitWidth = YES;
    
    [self.changeContainerView addSubview:self.xInput];
    [self.changeContainerView addSubview:self.yInput];
    [self.changeContainerView addSubview:self.widthInput];
    [self.changeContainerView addSubview:self.heightInput];
    [self.changeContainerView addSubview:self.changeConfirmBtn];
    
    [self.view addSubview:self.changeContainerView];
}

- (void)initSelectView {
//    UIColor* unSelectedColor    = RGBCOLOR(208,208,208);
    UIColor *unSelectedColor = [ChartColorConfig color255WithString:@"208,208,208"];
    
    self.timeSettingSelectView = [[UIView alloc] init];
    self.timeSettingSelectView.backgroundColor = unSelectedColor;
    self.timeSettingSelectView.hidden = YES;
    [self.timeSettingSelectView.layer setMasksToBounds:YES];
    [self.timeSettingSelectView.layer setCornerRadius:4.0];
    [self.view addSubview:self.timeSettingSelectView];
    
    self.typeSettingSelectView = [[UIView alloc] init];
    self.typeSettingSelectView.backgroundColor = unSelectedColor;
    self.typeSettingSelectView.hidden = YES;
    [self.typeSettingSelectView.layer setMasksToBounds:YES];
    [self.typeSettingSelectView.layer setCornerRadius:4.0];
    [self.view addSubview:self.typeSettingSelectView];
    
    self.sessionSettingSelectView = [[UIView alloc] init];
    self.sessionSettingSelectView.backgroundColor = unSelectedColor;
    self.sessionSettingSelectView.hidden = YES;
    [self.sessionSettingSelectView.layer setMasksToBounds:YES];
    [self.sessionSettingSelectView.layer setCornerRadius:4.0];
    [self.view addSubview:self.sessionSettingSelectView];

    CGFloat btnHeight = 32.5;
    
    self.timeSettingSelectView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect timeSelectViewFrame = CGRectMake(self.chartHeadViewController.timeSettingView.frame.origin.x, self.chartHeadViewController.timeSettingView.frame.origin.y, 100, btnHeight * 8);
    
    NSLayoutConstraint *timeSelectViewHeight = [NSLayoutConstraint constraintWithItem:self.timeSettingSelectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(timeSelectViewFrame)];
    NSLayoutConstraint *timeSelectViewWidth = [NSLayoutConstraint constraintWithItem:self.timeSettingSelectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(timeSelectViewFrame)];
    NSLayoutConstraint *timeSelectViewLeft = [NSLayoutConstraint constraintWithItem:self.timeSettingSelectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.timeSettingView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *timeSelectViewTop = [NSLayoutConstraint constraintWithItem:self.timeSettingSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.timeSettingView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[timeSelectViewTop, timeSelectViewLeft, timeSelectViewHeight, timeSelectViewWidth]];
    [self.view bringSubviewToFront:self.typeSettingSelectView];
    
    self.typeSettingSelectView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect typeSelectViewFrame = CGRectMake(self.chartHeadViewController.typeSettingView.frame.origin.x, self.chartHeadViewController.typeSettingView.frame.origin.y, 100, btnHeight * 4);

    NSLayoutConstraint *typeSelectViewHeight = [NSLayoutConstraint constraintWithItem:self.typeSettingSelectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(typeSelectViewFrame)];
    NSLayoutConstraint *typeSelectViewWidth = [NSLayoutConstraint constraintWithItem:self.typeSettingSelectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(typeSelectViewFrame)];
    NSLayoutConstraint *typeSelectViewLeft = [NSLayoutConstraint constraintWithItem:self.typeSettingSelectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.typeSettingView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *typeSelectViewTop = [NSLayoutConstraint constraintWithItem:self.typeSettingSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.typeSettingView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[typeSelectViewTop, typeSelectViewLeft, typeSelectViewHeight, typeSelectViewWidth]];
    
    self.sessionSettingSelectView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect sessionSelectViewFrame = CGRectMake(self.chartHeadViewController.typeSettingView.frame.origin.x, self.chartHeadViewController.sessionSettingView.frame.origin.y, 100, btnHeight * 2);

    NSLayoutConstraint *sessionSelectViewHeight = [NSLayoutConstraint constraintWithItem:self.sessionSettingSelectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(sessionSelectViewFrame)];
    NSLayoutConstraint *sessionSelectViewWidth = [NSLayoutConstraint constraintWithItem:self.sessionSettingSelectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(sessionSelectViewFrame)];
    NSLayoutConstraint *sessionSelectViewLeft = [NSLayoutConstraint constraintWithItem:self.sessionSettingSelectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.sessionSettingView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *sessionSelectViewTop = [NSLayoutConstraint constraintWithItem:self.sessionSettingSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chartHeadViewController.sessionSettingView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[sessionSelectViewTop, sessionSelectViewLeft, sessionSelectViewHeight, sessionSelectViewWidth]];
}

- (void)openSelectView {
//    if (!dimView.hidden) {
//        dimView.hidden = YES;
//        [dimView removeFromSuperview];
//    }
    for (int i = 0; i < [selectBtnArray count]; i++) {
        UIButton* btn = [selectBtnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
    
    UIColor* txtColor           = [ChartColorConfig color255WithString:@"20,38,71"];
    UIColor* selectedTxtColor   = [ChartColorConfig color255WithString:@"20,38,71"];
    UIColor* selectedColor      = [ChartColorConfig color255WithString:@"255,255,255"];
    UIColor* unSelectedColor    = [ChartColorConfig color255WithString:@"208,208,208"];
    
//    [selectView removeFromSuperview];
    [selectBtnArray removeAllObjects];
    [selectView setBackgroundColor:unSelectedColor];
    
    [selectView setAlpha:0.9];
    int iBtnWidth;
    int iBtnHeight;
    int iGap = 4;
    int iBtnCount;
    if (self.iSelectType == ChartSettingViewMinType) {
        iBtnCount = 8;
//        if (codeType == 2) {
//            if (isAHFT || isNextMonth)
//                iBtnCount = 5;
//        }
        iBtnWidth = 100;
        iBtnHeight = 30;
//        CGRect tFrame = self.chartHeadViewController.timeSettingView.frame;
//        [selectView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y + tFrame.size.height-3, iBtnWidth, iBtnHeight * iBtnCount+10)];
        selectView = self.timeSettingSelectView;
        
        iBtnWidth -= iGap;
        for(int i = 0; i < iBtnCount; i++)
        {
            NSString* str = [[[CommonUtil instance] timeSelectionArray] objectAtIndex:i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:CGRectMake(iGap/2, 5+iBtnHeight * i, iBtnWidth, iBtnHeight)];
            [btn setTag:10+i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            [btn setTitleColor:txtColor forState:UIControlStateNormal];
            if (i == self.iChartMinType) {
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btn setBackgroundColor:selectedColor];
                [btn setTitleColor:selectedTxtColor forState:UIControlStateNormal];
//                [btn setTitle:[NSString stringWithFormat:@"    %@  ✔",[[CommonUtil instance] getMessage:str]] forState:UIControlStateNormal];
            }else
            {
                [btn setBackgroundColor:unSelectedColor];
                //[btn setTitle:[[CommonUtil instance] getMessage:str] forState:UIControlStateNormal];
            }
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick_SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];

            [selectView addSubview:btn];
            [selectBtnArray addObject:btn];
        }
    } else if (self.iSelectType == ChartSettingViewDisType) {
        iBtnCount = 4;
        iBtnWidth = 100;
        iBtnHeight = 30;
        
//        CGRect tFrame = self.chartHeadViewController.typeSettingView.frame;
        //if (SCREENWIDTH > SCREENHEIGHT) {
//            [selectView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y + tFrame.size.height, iBtnWidth, (iBtnHeight) * iBtnCount+10)];
        //} else {
        //    [selectView setFrame:CGRectMake(self.settingView02_V.frame.origin.x, self.view.frame.size.height-3, iBtnWidth, (iBtnHeight) * iBtnCount+10)];
        //}
        selectView = self.typeSettingSelectView;

        iBtnWidth -= iGap;
        for(int i = 0; i < iBtnCount;i++)
        {
            NSString* str = [[[CommonUtil instance] typeSelectionArray] objectAtIndex:i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:CGRectMake(iGap/2, 5+(iBtnHeight) * i, iBtnWidth, iBtnHeight)];
            [btn setTag:10+i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setTitleColor:txtColor forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            if (i == self.iChartLineType) {
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btn setBackgroundColor:selectedColor];
                [btn setTitleColor:selectedTxtColor forState:UIControlStateNormal];
            }else
                [btn setBackgroundColor:unSelectedColor];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick_SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];

            [selectView addSubview:btn];
            [selectBtnArray addObject:btn];
        }
    } else if (self.iSelectType == ChartSettingViewColorType) {
        //
    } else if (self.iSelectType == ChartSettingViewSessionType) {
        iBtnCount = 4;
        iBtnWidth = 100;
        iBtnHeight = 30;
        
        selectView = self.sessionSettingSelectView;

        iBtnWidth -= iGap;
        int row = 0;
        for(int i = 0; i < iBtnCount;i++)
        {
            if (i == ChartSessionTypePre || i == ChartSessionTypePost) {
                continue;
            }
            
            NSString* str = [[[CommonUtil instance] sessionSelectionArray] objectAtIndex:i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:CGRectMake(iGap/2, 5+(iBtnHeight) * row, iBtnWidth, iBtnHeight)];
            [btn setTag:10+i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setTitleColor:txtColor forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            if (i == self.iChartSessionType) {
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btn setBackgroundColor:selectedColor];
                [btn setTitleColor:selectedTxtColor forState:UIControlStateNormal];
            }else
                [btn setBackgroundColor:unSelectedColor];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick_SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];

            [selectView addSubview:btn];
            [selectBtnArray addObject:btn];
            
            row++;
        }
    }
    
    selectView.hidden = NO;
//    [self.view addSubview:selectView];
    [self.view bringSubviewToFront:selectView];
    
}

- (void)resetFrame {
    // Code
    if (![code isEqualToString: @""]) {
        [self.chartHeadViewController.codeLabel setText:code];
    }
    
    // Select view
    if (!selectView.hidden) {
        selectView.hidden = YES;
    }
    
    // Setting view
    [self.chartHeadViewController updateSettingConfig:self.iChartMinType ChartLineType:self.iChartLineType ChartColorType:self.iChartColorType ChartSessionType:self.iChartSessionType];
    if (codename){
        self.chartHeadViewController.codeNameLabel.text = codename;
    }
    
    self.changeContainerView.frame = CGRectMake(self.chartContainer.frame.origin.x, self.chartContainer.frame.origin.y, self.changeConfirmBtn.frame.origin.x + self.changeConfirmBtn.frame.size.width + 20, 30);
//    [self.fullChartViewController displaySelectedChartData:nil];
}

- (void)setStockCode:(NSString *)stockCode {
    code = stockCode;
    self.chartHeadViewController.codeLabel.text = stockCode;
    
    //Get Chart Name
    [self requestChartName:stockCode];
    
}

- (ChartDataInterval)getChartInterval:(ChartMinTypeSelection)minTypeSelection {
    switch (minTypeSelection) {
        case ChartMinTypeSelection1Min:     { return ChartDataInterval1Min; break; }
        case ChartMinTypeSelection5Min:     { return ChartDataInterval5Min; break; }
        case ChartMinTypeSelection15Min:    { return ChartDataInterval15Min; break; }
        case ChartMinTypeSelection30Min:    { return ChartDataInterval30Min; break; }
        case ChartMinTypeSelectionHourly:   { return ChartDataInterval60Min; break; }
        case ChartMinTypeSelectionDaily:    { return ChartDataIntervalDay; break; }
        case ChartMinTypeSelectionWeekly:   { return ChartDataIntervalWeek; break; }
        case ChartMinTypeSelectionMonthly:  { return ChartDataIntervalMonth; break; }
        
        default: { return ChartDataInterval5Min; break;}
    }
}

- (void)updateChartContainerFrame {
    CGFloat x = [self.xInput.text floatValue];
    CGFloat y = [self.yInput.text floatValue];
    CGFloat width = [self.widthInput.text floatValue];
    CGFloat height = [self.heightInput.text floatValue];

    if (self.chartContainer) {
//        [self.chartContainer setFrame:CGRectMake(x, y, width, height)];
//        self.chartContainerTop.constant = y - [CommonUtil safeAreaInsetTop] - self.headView.frame.size.height;
        self.chartContainerTop.constant = y;
        self.chartContainerLeading.constant = x;
        self.chartContainerTrailing.constant = SCREENWIDTH - width - [CommonUtil safeAreaInsetLeft] - [CommonUtil safeAreaInsetRight] - x;
        self.chartContainerBottom.constant = SCREENHEIGHT - self.headView.frame.size.height - height - [CommonUtil safeAreaInsetTop] - [CommonUtil safeAreaInsetBottom] - y;
//        [self.fullChartViewController updateLayoutAfterResize];
    }
    
    NSLog(@"chartVC.contrains top %.2f lead %.2f bottom %.2f trailing %.2f", self.chartContainerTop.constant, self.chartContainerLeading.constant, self.chartContainerBottom.constant, self.chartContainerTrailing.constant);
    
    
//    [self.fullChartViewController.view layoutIfNeeded];
//    [self.fullChartViewController.view layoutSubviews];
    [self.fullChartViewController updateLayoutAfterResize];
    // Update input
//    self.xInput.text      = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.x];
//    self.yInput.text      = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.origin.y];
//    self.widthInput.text  = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.size.width];
//    self.heightInput.text = [NSString stringWithFormat:@"%.2f", self.chartContainer.frame.size.height];
}

//- (FinanceChartMinType)getChartMinType:(ChartMinTypeSelection)minTypeSelection {
//    switch (minTypeSelection) {
//        case ChartMinTypeSelection1Min:     { return FinanceChartMinType1Min; break; }
//        case ChartMinTypeSelection5Min:     { return FinanceChartMinType5Min; break; }
//        case ChartMinTypeSelection15Min:    { return FinanceChartMinType15Min; break; }
//        case ChartMinTypeSelection30Min:    { return FinanceChartMinType30Min; break; }
//        case ChartMinTypeSelectionHourly:   { return FinanceChartMinTypeHourly; break; }
//        case ChartMinTypeSelectionDaily:    { return FinanceChartMinTypeDaily; break; }
//        case ChartMinTypeSelectionWeekly:   { return FinanceChartMinTypeWeekly; break; }
//        case ChartMinTypeSelectionMonthly:  { return FinanceChartMinTypeMonthly; break; }
//
//        default: { return FinanceChartMinType5Min; break;}
//    }
//}

//- (IBAction)setSMATI {
//    MainTISMA * ti = [[MainTISMA alloc] init];
//    [ti createDefaultDataList];
//    [self.fullChartViewController setMainTI:ti];
//}
//
//- (IBAction)setWMATI {
//    MainTIWMA * ti = [[MainTIWMA alloc] init];
//    [ti createDefaultDataList];
//    [self.fullChartViewController setMainTI:ti];
//}
//
//- (IBAction)setEMATI {
//    MainTIEMA * ti = [[MainTIEMA alloc] init];
//    [ti createDefaultDataList];
//    [self.fullChartViewController setMainTI:ti];
//}

- (IBAction)searchClicked {
    NSString * stockCode = self.codeTextField.text;
    if (stockCode && [stockCode length]){
        [self setStockCode:stockCode];
        [self requestChartData];
    }
//    NSString * stockCode = self.codeTextField.text;
//    if (stockCode && [stockCode length]){
//        ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
////        [dataSource loginWithUid:@"BMPuser" token:TOKEN];
//
//        ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:stockCode interval:ChartDataInterval5Min isToday:NO codeType:ChartCodeTypeHKStock];
//
//        [dataSource requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self setStockCode:stockCode];
//                [self initMainChartData:chartData];
//                [dataSource streamingDataForStockInfo:request handlingBlock:^(ChartData * _Nonnull data) {
//                    [self.fullChartViewController addMainChartData:data];
//                }];
//            });
//        }];
//    }
}

#pragma mark - Full Chart Delegate
- (void)displaySelectedMainChartData:(ChartData *)data {
    NSString * date = [NSString stringWithFormat:@"%@", data.date];
    NSString * open = [NSString stringWithFormat:@"%.3f", data.open];
    NSString * close = [NSString stringWithFormat:@"%.3f", data.close];
    NSString * high = [NSString stringWithFormat:@"%.3f", data.high];
    NSString * low = [NSString stringWithFormat:@"%.3f", data.low];
    
    [self.chartHeadViewController updateOHLCdate:date open:open high:high low:low close:close];
}

#pragma mark - TI Select

- (void)displayTISelectView {
    if (!self.tiSelectCollectionViewController){
//        self.tiSelectCollectionViewController = [[TISelectCollectionViewController alloc] initWithMainTIList:
//                                                 @[@{@"displayName":@"SMA",     @"tiname":[MainTISMA refKeyForChart]},
//                                                 @{@"displayName":@"EMA",       @"tiname":[MainTIEMA refKeyForChart]},
//                                                 @{@"displayName":@"WMA",       @"tiname":[MainTIWMA refKeyForChart]}]
//                                                                                                   subTIList:
//                                                 @[@{@"displayName":@"RSI",     @"tiname":[SubTIRSI refKeyForChart]},
//                                                 @{@"displayName":@"Volume",    @"tiname":[SubTIVolumn refKeyForChart]},
//                                                 @{@"displayName":@"MACD",      @"tiname":[SubTIMACD refKeyForChart]},
//                                                 @{@"displayName":@"William",   @"tiname":[SubTIWilliam refKeyForChart]},
//                                                 @{@"displayName":@"DMI",       @"tiname":[SubTIDMI refKeyForChart]},
//                                                 @{@"displayName":@"OBV",       @"tiname":[SubTIOBV refKeyForChart]},
//                                                 @{@"displayName":@"ROC",       @"tiname":[SubTIROC refKeyForChart]},
//                                                 @{@"displayName":@"STC-Fast",  @"tiname":[SubTIRSI refKeyForChart]},
//                                                 @{@"displayName":@"STC-Slow",  @"tiname":[SubTIRSI refKeyForChart]}]];

        self.tiSelectCollectionViewController = [[TISelectCollectionViewController alloc] init];

        self.tiSelectCollectionViewController.tiDelegate = self;
    }
//    [self.view addSubview:self.tiSelectCollectionViewController.view];
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.coverView];
    [self.coverView setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.5f]];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTICoverView)];
    [self.coverView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.tiSelectCollectionViewController.view];
    self.tiSelectCollectionViewController.view.frame = CGRectMake(0, 0, 300, 300);
    self.tiSelectCollectionViewController.view.center = self.view.center;
}

- (void)closeTISelectView {
    if (self.tiSelectCollectionViewController) {
        [self.tiSelectCollectionViewController.view removeFromSuperview];
    }
//    [self.coverView removeFromSuperview];
//    self.coverView = nil;
}

- (void)displayTIConfigView {
    if (self.fullChartViewController) {
        ChartTIConfig *tiConfig = [self.fullChartViewController getTiConfig];
        self.tiConfigViewController = [[TIConfigViewController alloc] initWithTiConfig:tiConfig];
    }
    if (self.tiConfigViewController) {
        self.tiConfigViewController.view.frame = CGRectMake(0, 0, 300, 300);
        self.tiConfigViewController.view.center = self.view.center;
        self.tiConfigViewController.view.hidden = NO;
        self.tiConfigViewController.delegate = self;
        
        [self.view addSubview:self.tiConfigViewController.view];
        
    }
}

- (void)closeTIConfigView {
    if (self.tiConfigViewController) {
        [self.tiConfigViewController.view removeFromSuperview];
    }
}

- (void)closeTICoverView {
    [self closeTISelectView];
    [self closeTIConfigView];
    
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}

//- (void)selectedMainTI:(NSString *)mainTI {
//    BOOL found = NO;
//    if (mainTI){
//        if ([mainTI isEqualToString:[MainTISMA refKeyForChart]]){
////            MainTISMA * ti = [[MainTISMA alloc] init];
////            [ti createDefaultDataList];
////            [self.fullChartViewController setMainTI:ti];
//            [self.fullChartViewController setMainTi:ChartMainTIEnumSMA];
//            found = YES;
//        }
//        if ([mainTI isEqualToString:[MainTIEMA refKeyForChart]]){
////            MainTIEMA * ti = [[MainTIEMA alloc] init];
////            [ti createDefaultDataList];
////            [self.fullChartViewController setMainTI:ti];
//            [self.fullChartViewController setMainTi:ChartMainTIEnumEMA];
//            found = YES;
//        }
//        if ([mainTI isEqualToString:[MainTIWMA refKeyForChart]]){
////            MainTIWMA * ti = [[MainTIWMA alloc] init];
////            [ti createDefaultDataList];
////            [self.fullChartViewController setMainTI:ti];
//            [self.fullChartViewController setMainTi:ChartMainTIEnumWMA];
//            found = YES;
//        }
//    }
//    if (found){
//        selectedMainTIname = mainTI;
//    }
//}
- (void)selectedMainTI:(ChartMainTIEnum)mainTI {
//    selectedMainTI = mainTI;
    [self.fullChartViewController setMainTi:mainTI];
}

- (BOOL)mainTIIsCurrentSelected:(ChartMainTIEnum)mainTI {
//    return selectedMainTI == mainTI;
    return [self.fullChartViewController getCurrentMainTI] == mainTI;
}

- (void)selectedSubTI:(ChartSubTIEnum)subTI {
//    if (!selectedSubTIList){
//        selectedSubTIList = [NSMutableArray array];
//    }
//    if ([selectedSubTIList containsObject:@(subTI)]){
//        [selectedSubTIList removeObject:@(subTI)];
//    } else {
//        [selectedSubTIList addObject:@(subTI)];
//    }
    NSArray * selectedSubTIList = [self.fullChartViewController getCurrentSubTIList];
    if (!selectedSubTIList){
        [self.fullChartViewController setSubTiList:@[@(subTI)]];
        return;
    }
    NSMutableArray * mutArray = [NSMutableArray arrayWithArray:selectedSubTIList];
    if ([mutArray containsObject:@(subTI)]){
        [mutArray removeObject:@(subTI)];
    } else {
        [mutArray addObject:@(subTI)];
    }
    [self.fullChartViewController setSubTiList:[NSArray arrayWithArray:mutArray]];
}

- (BOOL)subTICurrentSelected:(ChartSubTIEnum)subTI {
//    return NO;
    NSArray * selectedSubTIList = [self.fullChartViewController getCurrentSubTIList];
    if (!selectedSubTIList){
        return NO;
    }
    if ([selectedSubTIList containsObject:@(subTI)]){
        return YES;
    }
    return NO;
}

//- (void)updateSubTIListToFullChart {
//    NSMutableArray * tiArray = [NSMutableArray array];
//    for (NSString * ti in selectedSubTIList){
//        ChartTI * chartTI = nil;
//        if ([ti isEqualToString:[SubTIRSI refKeyForChart]]){
//            chartTI = [[SubTIRSI alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIVolumn refKeyForChart]]){
//            chartTI = [[SubTIVolumn alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIMACD refKeyForChart]]){
//            chartTI = [[SubTIMACD alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIWilliam refKeyForChart]]){
//            chartTI = [[SubTIWilliam alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIDMI refKeyForChart]]) {
//            chartTI = [[SubTIDMI alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIOBV refKeyForChart]]) {
//            chartTI = [[SubTIOBV alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIROC refKeyForChart]]) {
//            chartTI = [[SubTIROC alloc] init];
//        }
////        if ([ti isEqualToString:[SubTISTCFast refKeyForChart]]) {
////            chartTI = [[SubTISTCFast alloc] init];
////        }
////        if ([ti isEqualToString:[SubTISTCSlow refKeyForChart]]) {
////            chartTI = [[SubTISTCSlow alloc] init];
////        }
//        if (chartTI){
//            [chartTI createDefaultDataList];
//        }
//        [tiArray addObject:chartTI];
//    }
//    [self.fullChartViewController setSubTIList:tiArray];
//
//}

//- (BOOL)mainTICurrentSelected:(NSString *)mainTI {
////    if (self.full)
//    return ([mainTI isEqualToString:selectedMainTIname]);
//}

//- (BOOL)subTICurrentSelected:(NSString *)subTI {
//    if (!selectedSubTIList){
//        return NO;
//    }
//    return ([selectedSubTIList containsObject:subTI]);
//}
//
//- (void)selectedSubTI:(NSString *)subTI {
//    if (!selectedSubTIList){
//        selectedSubTIList = [NSMutableArray array];
//    }
//    if ([selectedSubTIList containsObject:subTI]){
//        [selectedSubTIList removeObject:subTI];
//    } else {
//        [selectedSubTIList addObject:subTI];
//    }
//    [self updateSubTIListToFullChart];
//}
//- (void)updateSubTIListToFullChart {
//    NSMutableArray * tiArray = [NSMutableArray array];
//    for (NSString * ti in selectedSubTIList){
//        ChartTI * chartTI = nil;
//        if ([ti isEqualToString:[SubTIRSI refKeyForChart]]){
//            chartTI = [[SubTIRSI alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIVolumn refKeyForChart]]){
//            chartTI = [[SubTIVolumn alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIMACD refKeyForChart]]){
//            chartTI = [[SubTIMACD alloc] init];
//        }
//        if ([ti isEqualToString:[SubTIWilliam refKeyForChart]]){
//            chartTI = [[SubTIWilliam alloc] init];
//        }
//        if (chartTI){
//            [chartTI createDefaultDataList];
//        }
//        [tiArray addObject:chartTI];
//    }
//    [self.fullChartViewController setSubTIList:tiArray];
//
//}

@end
