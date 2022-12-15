//
//  SmallChartPlayerViewController.m
//  ChartLibraryDemo
//
//  Created by william on 28/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <ChartFramework/ChartFramework.h>
#import "SmallChartPlayerViewController.h"
//#import "SmallChartViewController.h"
#import "ChartEtnetDataSource.h"
//#import "ChartConst.h"
//#import "ChartCommData.h"
//#import "ChartCommonUtil.h"
#import "OpenClosePrePostModel.h"

typedef NS_ENUM(NSUInteger, SmallChartPlayerType){
    SmallChartPlayerTypeDay,
    SmallChartPlayerType5Day,
    SmallChartPlayerType3Month,
    SmallChartPlayerType1Year,
    SmallChartPlayerType5Year,
};

@interface SmallChartPlayerViewController ()

@property (nonatomic, strong) IBOutlet UIView * smallViewContainter;
@property (nonatomic, strong) SmallChartViewController * smallChartViewController;
@property (nonatomic, assign) SmallChartPlayerType playerType;

@property (nonatomic ,strong)   NSString * stockCode;
@property (nonatomic ,strong)   IBOutlet UITextField *codeTextField;
@property (weak, nonatomic)     IBOutlet UITextField *prevCloseTextField;
@property (weak, nonatomic)     IBOutlet UIButton *setPrevCloseBtn;

@property (strong, nonatomic) UIButton * exportBtn;
@property (strong, nonatomic) UIButton * exportCloseBtn;
@property (strong, nonatomic) UIView * exportView;
@property (strong, nonatomic) UITextView * exportTextView;

@property (nonatomic, assign) ChartDataInterval interval;
@property (nonatomic, assign) ChartSessionType sessionType;
@property (nonatomic, strong) ChartCommData * commData;

@property (weak, nonatomic) IBOutlet UIButton *candleChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *barChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveDayChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeMthChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveYearChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *preSessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *postSessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *coreSessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *combineSessionBtn;

@end

@implementation SmallChartPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.playerType = SmallChartPlayerTypeDay;
    self.sessionType = ChartSessionTypeCore;
    self.commData = [ChartCommData instance];
    
    self.codeTextField.delegate = self;
    self.prevCloseTextField.delegate = self;
    // self.stockCode = @"5";
    //[self requestData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initExportBtn];
}

//------------------------------------------------------------------------------
#pragma mark - Delegate
//------------------------------------------------------------------------------

// UIButtonDelegate
- (IBAction)changeToLineChart {
    if (self.smallChartViewController){
        [self.smallChartViewController updateMainChartType:ChartLineTypeLine];
    }
}
- (IBAction)changeToCandleChart {
    if (self.smallChartViewController){
        [self.smallChartViewController updateMainChartType:ChartLineTypeCandle];
    }
}
- (IBAction)changeToBarChart {
    if (self.smallChartViewController){
        [self.smallChartViewController updateMainChartType:ChartLineTypeBar];
    }
}
- (IBAction)changeToAreaChart {
    if (self.smallChartViewController){
        [self.smallChartViewController updateMainChartType:ChartLineTypeArea];
    }
}

- (IBAction)changeToDayChart {
    if (self.codeTextField.text == nil && [self.codeTextField.text isEqualToString:@""]) {
        return;
    }
    
    self.playerType = SmallChartPlayerTypeDay;
    self.interval = ChartDataInterval1Min;
    [self requestChartDataDict];
    [self searchCode:self.codeTextField.text];
    //[self requestData];
}
- (IBAction)changeTo5DayChart {
    self.playerType = SmallChartPlayerType5Day;
    self.interval = ChartDataInterval5Min;
    //[self requestData];
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeTo3MonthChart {
    self.playerType = SmallChartPlayerType3Month;
    self.interval = ChartDataIntervalDay;
    //[self requestData];
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeTo1YearChart {
    self.playerType = SmallChartPlayerType1Year;
    self.interval = ChartDataIntervalWeek;
    //[self requestData];
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeTo5YearChart {
    self.playerType = SmallChartPlayerType5Year;
    self.interval = ChartDataIntervalMonth;
    //[self requestData];
    [self searchCode:self.codeTextField.text];
}

- (IBAction)changeToSessionPre {
    self.sessionType = ChartSessionTypePre;
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeToSessionPost {
    self.sessionType = ChartSessionTypePost;
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeToSessionCore {
    self.sessionType = ChartSessionTypeCore;
    [self searchCode:self.codeTextField.text];
}
- (IBAction)changeToSessionCombine {
    self.sessionType = ChartSessionTypeCombine;
    [self searchCode:self.codeTextField.text];
}

- (IBAction)closeChart {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtn_CodeTextField:(id)sender {
    self.codeTextField.text = @"";
}
- (IBAction)onBtn_PrevCloseTextField:(id)sender {
    self.prevCloseTextField.text = @"";
}
- (IBAction)onBtn_SetPrevClose:(id)sender {
    NSString* sPrevClose = self.prevCloseTextField.text;
    
    if (sPrevClose != nil && ![sPrevClose isEqualToString:@""]) {
        [self.prevCloseTextField resignFirstResponder];
        [self.smallChartViewController setPrevClose:[sPrevClose floatValue]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.codeTextField){
        NSString* code = self.codeTextField.text;

        if (code != nil && ![code isEqualToString:@""]) {
            [self.codeTextField resignFirstResponder];
            [self searchCode:code];
            return NO;
        } else {
            //
        }
    }
    else if (textField == self.prevCloseTextField) {
        NSString* sPrevClose = self.prevCloseTextField.text;
        
        if (sPrevClose != nil && ![sPrevClose isEqualToString:@""]) {
            [self.prevCloseTextField resignFirstResponder];
            [self.smallChartViewController setPrevClose:[sPrevClose floatValue]];
            return NO;
        }
    }
    return YES;
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
    self.exportView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.exportTextView.frame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
    self.exportCloseBtn.frame = CGRectMake(self.view.frame.size.width-50, 50, 50, 50);
    [self.view addSubview:self.exportView];
    
    NSDictionary * allData = [self.smallChartViewController exportAllChartData];
    if (allData){
        [self.exportTextView setText:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:allData options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
    }
}
- (void)closeExportView {
    [self.exportView removeFromSuperview];
}
//------------------------------------------------------------------------------
#pragma mark - Public
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------
- (void)updateView {
    BOOL bSession = NO;
    
    if ([ChartCommonUtil isUSStock:self.stockCode]) {
        if (self.playerType == SmallChartPlayerTypeDay || self.playerType == SmallChartPlayerType5Day) {
            bSession = YES;
        } else {
            bSession = NO;
        }
    } else {
        bSession = NO;
    }
    
    if (!bSession) {
        self.sessionType = ChartSessionTypeCore;
    }
    
    [self.preSessionBtn setEnabled:bSession];
    [self.postSessionBtn setEnabled:bSession];
    [self.coreSessionBtn setEnabled:bSession];
    [self.combineSessionBtn setEnabled:bSession];
}
- (void)initExportBtn{
    if (!self.exportBtn){
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
    }
    [self.exportBtn setFrame:CGRectMake(self.view.frame.size.width - 50, 200, 50, 50)];
}

- (NSArray *)getXAxisListFromChartData:(NSArray<ChartData *> *)chartData {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if ([ChartCommonUtil isUSStock:self.stockCode]) {
        [self.commData setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    }

    switch(self.playerType){
        case SmallChartPlayerTypeDay: {
            NSMutableArray * array = [NSMutableArray array];
            
            [formatter setDateFormat:@"HHmm"];
//            NSArray * hhmmList  = [self getHHmmList];
            
            for (ChartData * data in chartData){

//                NSDate * date = data.date;
//                NSLog(@"TODAY key(%@) date(%@)", data.groupingKey, data.date);
//                NSString * formatted = [formatter stringFromDate:date];
//                if ([hhmmList containsObject:formatted]){
//                    [array addObject:data.groupingKey];
//                }
                NSString * groupKey = [data.groupingKey substringFromIndex:8];
                if ([[groupKey substringFromIndex:2] isEqualToString:@"00"]){
//                    NSLog(@"Add XAxis - key %@ formatted %@", data.groupingKey, [groupKey substringFromIndex:2]);
                    [array addObject:data.groupingKey];
                }
            }
            return array;
        }
        case SmallChartPlayerType5Day: {
            NSMutableArray * array = [NSMutableArray array];
//            NSArray * hhmmList = [self getHHmmList];
//            NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
            NSString * tempDay;
            
            for (ChartData * data in chartData) {
                NSDate * date = data.date;
                NSLog(@"5-DAY key(%@) date(%@)", data.groupingKey, data.date);

//                if ([ChartCommonUtil isUSStock:self.stockCode]) {
//                    [formatter setDateFormat:@"HHmm"];
//                    NSString * formatted = [formatter stringFromDate:date];
//                    if ([hhmmList containsObject:formatted]) {
//                        NSLog(@"5-Day Add XAxis - key %@ formatted %@", data.groupingKey, formatted);
//                        [array addObject:data.groupingKey];
////                        if (self.sessionType == ChartSessionTypeCombine || self.sessionType == ChartSessionTypeCore) {
////                            if (array.count > 5) {
////                                [array removeObjectAtIndex:0];
////                            }
//                        }
//                } else {
//
//                    [formatter setDateFormat:@"dd"];
//                    NSString * formatted = [formatter stringFromDate:date];
//                    if (!tempDay || ![tempDay isEqualToString:formatted]){
//                        NSLog(@"5-Day Add XAxis - key %@ formatted %@", data.groupingKey, formatted);
//                        [array addObject:data.groupingKey];
//                        tempDay = formatted;
//                    }
//                }
                
                [formatter setDateFormat:@"dd"];
                NSString * formatted = [formatter stringFromDate:date];
                if (!tempDay || ![tempDay isEqualToString:formatted]){
                    NSLog(@"5-Day Add XAxis - key %@ formatted %@", data.groupingKey, formatted);
                    [array addObject:data.groupingKey];
                    tempDay = formatted;
                }
                
                if (array.count > 5) {
                    [array removeObjectAtIndex:0];
                }
                
            }
            return array;
        }
        case SmallChartPlayerType3Month:{
            NSMutableArray * array = [NSMutableArray array];
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM"];
            
//            NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
            NSString * tempDay;
            for (ChartData * data in chartData){
                NSDate * date = data.date;
                NSString * formatted = [formatter stringFromDate:date];
                if (!tempDay || ![tempDay isEqualToString:formatted]){
//                if ([@"0930" isEqualToString:[formatter stringFromDate:date]]){
                    [array addObject:data.groupingKey];
                    tempDay = formatted;
                }
            }
            return array;
        }
        case SmallChartPlayerType1Year:{
            NSMutableArray * array = [NSMutableArray array];
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM"];
            NSArray * monthList = @[@"03",@"06",@"09",@"12"];
//            NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
            NSString * tempDay;
            for (ChartData * data in chartData){
                NSDate * date = data.date;
                NSString * formatted = [formatter stringFromDate:date];
                if ([monthList containsObject:formatted]){
                    if (!tempDay || ![tempDay isEqualToString:formatted]){
    //                if ([@"0930" isEqualToString:[formatter stringFromDate:date]]){
                        [array addObject:data.groupingKey];
                        tempDay = formatted;
                    }
                }
            }
            return array;
        }
        case SmallChartPlayerType5Year:{
            NSMutableArray * array = [NSMutableArray array];
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
//            NSArray * monthList = @[@"03",@"06",@"09",@"12"];
//            NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
            NSString * tempDay;
            for (ChartData * data in chartData){
                NSDate * date = data.date;
                NSString * formatted = [formatter stringFromDate:date];
//                if ([monthList containsObject:formatted]){
                    if (!tempDay || ![tempDay isEqualToString:formatted]){
    //                if ([@"0930" isEqualToString:[formatter stringFromDate:date]]){
                        [array addObject:data.groupingKey];
                        tempDay = formatted;
                    }
//                }
            }
            return array;
        }
    }
    return @[];
}
- (void)searchCode:(NSString *)stockCode {
    if (stockCode && [stockCode length]) {
        [self setStockCode:stockCode];
        if ([ChartCommonUtil isUSStock:stockCode]) {
            [self.commData setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
        } else {
            [self.commData setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
        }
        [self updateView];
        [self requestData];
    }
}

- (void)requestData {
    NSDateFormatter *formatterLog = [[NSDateFormatter alloc] init];
    [formatterLog setDateFormat:@"YYYY/MM/dd HH:mm"];
    
    [self.smallChartViewController.view removeFromSuperview];
    switch(self.playerType){
        case SmallChartPlayerTypeDay:
        {
            ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
            chartConfig.mainChartLineType = ChartLineTypeArea;
            chartConfig.dateDisplayFormat = @"HH";
            chartConfig.selectDateFormat = @"HH:mm";
            chartConfig.axisLineType = ChartAxisLineTypeSolid;
//            chartConfig.chartLineTypeLineLineWidth = 5;
//            chartConfig.chartLineTypeAreaLineWidth = 1.5;
            
            [self requestChartDataDict];

            ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataInterval1Min dataType:ChartDataTypeToday codeType:ChartCodeTypeHKStock];
            if ([ChartCommonUtil isUSStock:self.stockCode]){
                request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataInterval1Min dataType:ChartDataTypeToday codeType:ChartCodeTypeUS session:self.sessionType];
                chartConfig.timeZone = self.commData.timeZone;
            }
            self.smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.smallViewContainter withConfig:chartConfig];
//            [[ChartEtnetDataSource sharedInstance] requestChartTodayDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
            
            
            [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Result.count = %ld", chartData.count);
                    NSArray * keyList = [self getXAxisListFromChartData:chartData];
                    [self.smallChartViewController setShowingXAxisKeyList:keyList];
                    
                    if (chartData && [chartData count]){
                        NSDate * fromDate = chartData.firstObject.date;
                        NSDate * toDate = chartData.lastObject.date;
                        NSLog(@"SmallChart[%ld] From %@ To %@", self.playerType, [formatterLog stringFromDate:fromDate], [formatterLog stringFromDate:toDate]);
                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                    }
                    
//                    [self.smallChartViewController initMainChartData:chartData];
                    
                    if (self.interval < ChartDataIntervalDay &&
                        (self.sessionType == ChartSessionTypeCombine || self.sessionType == ChartSessionTypePre || self.sessionType == ChartSessionTypePost)) {
                        NSMutableArray * prePostTime = [NSMutableArray array];
                        ChartData * prevData = nil;
                        for (ChartData * data in chartData){
                            if (prevData){
                                NSArray * colorList = [self getBackgroundForUSNowDate:data.date prevDate:prevData.date];
                                if (colorList){
                                    [prePostTime addObject:[[ChartBackground alloc] initWithKey:data.groupingKey colors:colorList]];
                                }
                            }
                            prevData = data;
                        }
//                        [self.smallChartViewController setBackgroundList:[NSArray arrayWithArray:prePostTime]];
                        [self.smallChartViewController initMainChartData:chartData backgroundList:[NSArray arrayWithArray:prePostTime]];
                    } else {
//                        [self.smallChartViewController setBackgroundList:@[]];
                        [self.smallChartViewController initMainChartData:chartData];
                    }
//                    ChartTIConfig * tiConfig = [[ChartTIConfig alloc] initDefault];
//                    tiConfig.tiSMADayList = @[@5, @10, @20 ,@50];
//                    [self.smallChartViewController setChartTI:ChartMainTIEnumSMA withTIConfig:tiConfig];
        //            [dataSource streamingDataForStockInfo:request handlingBlock:^(ChartData * _Nonnull cData) {
        //                [smallChartViewController addMainChartData:cData];
        //            }];
                    
                });
            } fillEmpty:YES];
//            } fillEmpty:NO];
    
            break;
        }
        case SmallChartPlayerType5Day:
        {
            ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
            chartConfig.mainChartLineType = ChartLineTypeArea;
            if ([ChartCommonUtil isUSStock:self.stockCode] && (self.sessionType == ChartSessionTypePre || self.sessionType == ChartSessionTypePost)) {
                chartConfig.dateDisplayFormat = @"HH";
            } else {
                chartConfig.dateDisplayFormat = @"MM-dd";
            }
            chartConfig.selectDateFormat = @"HH:mm";
            chartConfig.axisLineType = ChartAxisLineTypeDash;
            chartConfig.mainChartYAxisLineNum = 0;
//            chartConfig.chartLineTypeAreaLineWidth = 10;

            ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataInterval5Min dataType:ChartDataTypeAll codeType:ChartCodeTypeHKStock];
            if ([ChartCommonUtil isUSStock:self.stockCode]){
                request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataInterval5Min dataType:ChartDataTypeAll codeType:ChartCodeTypeUS session:self.sessionType];
                chartConfig.timeZone = self.commData.timeZone;
            }
            self.smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.smallViewContainter withConfig:chartConfig];
//            [[ChartEtnetDataSource sharedInstance] requestChartTodayDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
             [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Result.count = %ld", chartData.count);

                    NSArray * keyList = [self getXAxisListFromChartData:chartData];
                    [self.smallChartViewController setShowingXAxisKeyList:keyList];
                    
                    NSMutableArray<ChartData*> * filteredChartData = [NSMutableArray array];
                    NSDate * fromDate = [NSDate date];
                    NSDate * toDate = [NSDate date];
                    
                    BOOL bStartIdx = NO;
                    
                    if (chartData && [chartData count]) {
                        for (ChartData * data in chartData) {
                            if (data.groupingKey == keyList.firstObject) {
                                fromDate = data.date;
                                bStartIdx = YES;
                            }
                            toDate = chartData.lastObject.date;
                            
                            if (bStartIdx) {
                                [filteredChartData addObject:data];
                            }
                        }
                        NSLog(@"SmallChart[%ld] From %@ To %@", self.playerType, [formatterLog stringFromDate:fromDate], [formatterLog stringFromDate:toDate]);
                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                    }
                    
//                    if (chartData && [chartData count]){
//                        NSDate * fromDate = chartData.firstObject.date;
//                        NSDate * toDate = chartData.lastObject.date;
//                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
//                    }
                    
//                    [self.smallChartViewController initMainChartData:chartData];
                    [self.smallChartViewController initMainChartData:[filteredChartData copy]];
                    
                    if (self.interval < ChartDataIntervalDay &&
                        (self.sessionType == ChartSessionTypeCombine || self.sessionType == ChartSessionTypePre || self.sessionType == ChartSessionTypePost)) {
                        NSMutableArray * prePostTime = [NSMutableArray array];
                        ChartData * prevData = nil;
                        for (ChartData * data in chartData){
                            if (prevData){
//                                NSLog(@"prevKey %@ - nowKey %@", prevData.groupingKey, data.groupingKey);
                                NSArray * colorList = [self getBackgroundForUSNowDate:data.date prevDate:prevData.date];
                                if (colorList){
                                    [prePostTime addObject:[[ChartBackground alloc] initWithKey:data.groupingKey colors:colorList]];
                                }
                            }
                            prevData = data;
                        }
                        [self.smallChartViewController setBackgroundList:[NSArray arrayWithArray:prePostTime]];
                    } 
//                    ChartTIConfig * tiConfig = [[ChartTIConfig alloc] initDefault];
//                    tiConfig.tiSMADayList = @[@5, @10, @20 ,@50];
//                    [self.smallChartViewController setChartTI:ChartMainTIEnumSMA withTIConfig:tiConfig];
                    
                });
            } fillEmpty:YES];
//        } fillEmpty:NO];

            break;
        }
        case SmallChartPlayerType3Month:
        {
            ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
            chartConfig.mainChartLineType = ChartLineTypeCandle;
            chartConfig.dateDisplayFormat = @"yyyy-MM";
            
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalDay dataType:ChartDataTypeAll codeType:ChartCodeTypeHKStock];
            if ([ChartCommonUtil isUSStock:self.stockCode]){
                request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalDay dataType:ChartDataTypeAll codeType:ChartCodeTypeUS session:ChartSessionTypeCore];
                chartConfig.timeZone = self.commData.timeZone;
//                [formatter setTimeZone:chartConfig.timeZone];
            }
            self.smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.smallViewContainter withConfig:chartConfig];
//            request.limit = 150;
            [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//            [[ChartEtnetDataSource sharedInstance] requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray * keyList = [self getXAxisListFromChartData:chartData];
                    [self.smallChartViewController setShowingXAxisKeyList:keyList];
                    
//                    [formatter setDateFormat:@"yyyy-MM-dd"];
//                    [self.smallChartViewController setSelectDateFormat:formatter];
                    [self.smallChartViewController updateSelectDateFormat:@"yyyy-MM-dd"];
                    
                    if (chartData && [chartData count]){
                        
//                        NSDate * fromDate = chartData.firstObject.date;
//                        NSDate * toDate = chartData.lastObject.date;
                        NSDate * today = [NSDate date];
                        today = [[NSCalendar currentCalendar] startOfDayForDate:today];
                        NSDateComponents * components = [[NSDateComponents alloc] init];
                        [components setHour:23];
                        [components setMinute:59];
                        [components setSecond:59];
                        NSDate * toDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
                        NSDate * fromDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:-3 toDate:today options:0];
                        
                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                    }
                    
                    [self.smallChartViewController initMainChartData:chartData];
                    ChartTIConfig * tiConfig = [[ChartTIConfig alloc] initDefault];
                    tiConfig.tiSMADayList = @[@10, @20 ,@50];
                    [self.smallChartViewController setChartTI:ChartMainTIEnumSMA withTIConfig:tiConfig];
                    
                });
            }];
            break;
        }
        case SmallChartPlayerType1Year:
        {
            ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
            chartConfig.mainChartLineType = ChartLineTypeCandle;
            chartConfig.dateDisplayFormat = @"yyyy-MM";
            
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalWeek dataType:ChartDataTypeAll codeType:ChartCodeTypeHKStock];
            if ([ChartCommonUtil isUSStock:self.stockCode]) {
                request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalWeek dataType:ChartDataTypeAll codeType:ChartCodeTypeUS session:ChartSessionTypeCore];
                chartConfig.timeZone = self.commData.timeZone;
//                [formatter setTimeZone:chartConfig.timeZone];
            }
            self.smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.smallViewContainter withConfig:chartConfig];
//            request.limit = 150;
            [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//            [[ChartEtnetDataSource sharedInstance] requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray * keyList = [self getXAxisListFromChartData:chartData];
                    [self.smallChartViewController setShowingXAxisKeyList:keyList];
//                    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//                    [formatter setDateFormat:@"yyyy-MM-dd"];
//                    [self.smallChartViewController setSelectDateFormat:formatter];
                    [self.smallChartViewController updateSelectDateFormat:@"yyyy-MM-dd"];
                    
                    if (chartData && [chartData count]){
                        
//                        NSDate * fromDate = chartData.firstObject.date;
//                        NSDate * toDate = chartData.lastObject.date;
                        NSDate * today = [NSDate date];
                        today = [[NSCalendar currentCalendar] startOfDayForDate:today];
                        NSDateComponents * components = [[NSDateComponents alloc] init];
                        [components setHour:23];
                        [components setMinute:59];
                        [components setSecond:59];
                        NSDate * toDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
                        NSDate * fromDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitYear value:-1 toDate:today options:0];
                        
                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                    }
                    
                    [self.smallChartViewController initMainChartData:chartData];
                    ChartTIConfig * tiConfig = [[ChartTIConfig alloc] initDefault];
                    tiConfig.tiSMADayList = @[@10, @20 ,@50];
                    [self.smallChartViewController setChartTI:ChartMainTIEnumSMA withTIConfig:tiConfig];
                    
                });
            }];
            break;
        }
        case SmallChartPlayerType5Year:
        {
            ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
            chartConfig.mainChartLineType = ChartLineTypeCandle;
            chartConfig.dateDisplayFormat = @"yyyy";
            
//            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalMonth dataType:ChartDataTypeAll codeType:ChartCodeTypeHKStock];
            if ([ChartCommonUtil isUSStock:self.stockCode]){
                request = [[ChartDataRequest alloc] initWithCode:self.stockCode interval:ChartDataIntervalMonth dataType:ChartDataTypeAll codeType:ChartCodeTypeUS session:ChartSessionTypeCore];
                chartConfig.timeZone = self.commData.timeZone;
//                [formatter setTimeZone:chartConfig.timeZone];
            }
            self.smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.smallViewContainter withConfig:chartConfig];
//            request.limit = 150;
            [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//            [[ChartEtnetDataSource sharedInstance] requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray * keyList = [self getXAxisListFromChartData:chartData];
                    [self.smallChartViewController setShowingXAxisKeyList:keyList];
//                    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//                    [formatter setDateFormat:@"yyyy-MM"];
//                    [self.smallChartViewController setSelectDateFormat:formatter];
                    [self.smallChartViewController updateSelectDateFormat:@"yyyy-MM"];
                    
                    if (chartData && [chartData count]){
                        
//                        NSDate * fromDate = chartData.firstObject.date;
//                        NSDate * toDate = chartData.lastObject.date;
                        NSDate * today = [NSDate date];
                        today = [[NSCalendar currentCalendar] startOfDayForDate:today];
                        NSDateComponents * components = [[NSDateComponents alloc] init];
                        [components setHour:23];
                        [components setMinute:59];
                        [components setSecond:59];
                        NSDate * toDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
                        NSDate * fromDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitYear value:-5 toDate:today options:0];
                        
                        [self.smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                    }
                    
                    [self.smallChartViewController initMainChartData:chartData];
                    ChartTIConfig * tiConfig = [[ChartTIConfig alloc] initDefault];
                    tiConfig.tiSMADayList = @[@10, @20 ,@50];
                    [self.smallChartViewController setChartTI:ChartMainTIEnumSMA withTIConfig:tiConfig];
                    
                });
            }];
            break;
        }
    }
}
- (void)requestChartDataDict {
    if (!self.stockCode || [self.stockCode isEqualToString:@""]){
        return;
    }
    
    [[ChartEtnetDataSource sharedInstance] requestChartDataDictForCode:self.stockCode completion:^(NSArray * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *dict in result) {
                [self updateChartDataWithDict:dict];

            }
        });
    }];
}
- (void)updateChartDataWithDict:(NSDictionary*)dict {
    if (dict != nil) {
//        NSString *codeName = [dict objectForKey:@"2"];
        NSString *prevClose = [dict objectForKey:@"49"];

        if (self.smallChartViewController ) {
            if (prevClose && ![prevClose isEqualToString:@""]) {
                [self.smallChartViewController setPrevClose:[prevClose floatValue]];
            }
            
        }
    }

}

- (NSArray<ChartBackgroundColor *>*)getBackgroundForUSNowDate:(NSDate *)date prevDate:(NSDate *)prevDate {
    OpenClosePrePostModel *model = [OpenClosePrePostModel usMarketOC];
    ChartColorConfig *colorConfig = [ChartColorConfig getColorConfigForColorType:ChartColorTypeSelectionLight];
    ChartBackgroundColor * bgColor = [model getChartBGColor:date PrevDate:prevDate forInterval:self.interval ColorConfig:colorConfig];

    return @[bgColor];
}
- (NSArray*)getHHmmList {
    NSArray * rValue = [NSArray array];
//
//    switch (self.playerType) {
//        case SmallChartPlayerTypeDay: {
//            if ([ChartCommonUtil isUSStock:self.stockCode]) {
//                switch (self.sessionType) {
//                    case ChartSessionTypePre: {
//                        rValue = @[@"1600", @"1700", @"1800", @"1900", @"2000",@"2100"];
//                    } break;
//                    case ChartSessionTypePost: {
//                        rValue = @[@"0400", @"0500", @"0600", @"0700", @"0800"];
//                    } break;
//                    case ChartSessionTypeCore: {
//                        rValue = @[@"2100", @"2200", @"2300", @"0000", @"0100", @"0200", @"0300", @"0400"];
//                    } break;
//                    case ChartSessionTypeCombine: {
//                        rValue = @[@"1600", @"1700", @"1800", @"1900", @"2000",@"2100", @"2200", @"2300", @"0000", @"0100", @"0200", @"0300", @"0400", @"0500", @"0600", @"0700", @"0800"];
//                    } break;
//                    default:
//                        break;
//                }
//            } else {
//                rValue = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
//            }
//        } break;
//        case SmallChartPlayerType5Day: {
//            if ([ChartCommonUtil isUSStock:self.stockCode]) {
//                switch (self.sessionType) {
//                    case ChartSessionTypePre: {
//                        rValue = @[@"1600", @"1700", @"1800", @"1900", @"2000", @"2100"];
//                    } break;
//                    case ChartSessionTypePost: {
//                        rValue = @[@"0400", @"0500", @"0600", @"0700", @"0800"];
//                    } break;
//                    case ChartSessionTypeCore: {
//                        rValue = @[@"2135"];
//                    } break;
//                    case ChartSessionTypeCombine: {
//                        rValue = @[@"1600"];
//                    } break;
//                    default:
//                        break;
//                }
//            }
//        } break;
//        default:
//            break;
//    }
    
    return rValue;
}

@end
