//
//  ViewController.m
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <ChartFramework/ChartFramework.h>
#import "ViewController.h"
#import "ChartViewController.h"
//#import "ChartData.h"
#import "ChartEtnetDataSource.h"
//#import "SmallChartViewController.h"
#import "SmallChartPlayerViewController.h"
#import "FutureViewController.h"

#define SECCHARTSERVER @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?minType=5&code=%@&uid=BMPuser&token=%@&limit=400&dataType=hist_today&isDelay=y"
//#define TOKEN @"%C2%BDQC%C2%A6E%C2%A7JX%C2%91%C2%BB%C2%9C%C2%BD%5Bw%06%29%C2%9E%06%C2%93%C2%8F%C2%A6%C3%B5%C3%85%C3%89"

@interface ViewController ()

@property (nonatomic, strong) UITextField * codeTextField;
@property (nonatomic, strong) UIButton * searchButton;
@property (nonatomic, strong) UIButton * smallChartButton;
@property (nonatomic, strong) UIButton * futureChartButton;

@property (nonatomic, strong) UIView * overlayBGView;
@property (nonatomic, strong) UIView * overlayview;
@property (nonatomic, strong) SmallChartViewController * smallChartViewController;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.codeTextField = [[UITextField alloc] init];
    [self.view addSubview:self.codeTextField];
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.searchButton];
    
    self.smallChartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.smallChartButton];
    
    self.futureChartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.futureChartButton];
    
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.smallChartButton setTitle:@"Small" forState:UIControlStateNormal];
    [self.smallChartButton addTarget:self action:@selector(clickSmallPlayer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.futureChartButton setTitle:@"Future" forState:UIControlStateNormal];
    [self.futureChartButton addTarget:self action:@selector(clickFuturePlayer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.codeTextField setFrame:CGRectMake(20, 80, 100, 30)];
    [self.searchButton setFrame:CGRectMake(120, 80, 50, 30)];
    [self.smallChartButton setFrame:CGRectMake(170, 80, 50, 30)];
    [self.futureChartButton setFrame:CGRectMake(220, 80, 50, 30)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.codeTextField.text isEqualToString:@""]) {
        self.codeTextField.text = @"";
    }
    [self.codeTextField setFrame:CGRectMake(20, 80, 100, 30)];
    [self.searchButton setFrame:CGRectMake(120, 80, 50, 30)];
    [self.smallChartButton setFrame:CGRectMake(170, 80, 50, 30)];
    [self.futureChartButton setFrame:CGRectMake(220, 80, 50, 30)];
}

- (void)clickFuturePlayer {
    FutureViewController * futureController = [[FutureViewController alloc] init];
    futureController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:futureController animated:YES completion:nil];
}

- (void)clickSmallPlayer {
    SmallChartPlayerViewController * player = [[SmallChartPlayerViewController alloc] init];
    player.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:player animated:YES completion:nil];
}

- (void)clickSmallChart {
    [self.codeTextField resignFirstResponder];
    if (!self.overlayBGView){
        self.overlayBGView = [[UIView alloc] init];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSmallChart)];
        [self.overlayBGView addGestureRecognizer:tapGesture];
        [self.overlayBGView setUserInteractionEnabled:YES];
    }
    [self.overlayBGView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.overlayBGView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    if (!self.overlayview){
        self.overlayview = [[UIView alloc] init];
    }
    [self.overlayview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.overlayview setCenter:self.view.center];
    
    [self.view addSubview:self.overlayBGView];
    [self.view addSubview:self.overlayview];
    
    ChartConfig * chartConfig = [[ChartConfig alloc] initDefault];
    chartConfig.mainChartLineType = ChartLineTypeArea;
    chartConfig.dateDisplayFormat = @"HH";
    SmallChartViewController * smallChartViewController = [[SmallChartViewController alloc] initWithContainerView:self.overlayview withConfig:chartConfig];
    smallChartViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//    self.smallChartViewController = smallChartViewController;
    
    NSString * code = self.codeTextField.text;
    ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
    ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:code interval:ChartDataInterval1Min dataType:ChartDataTypeToday codeType:ChartCodeTypeHKStock];
//    [dataSource requestChartTodayDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
    [dataSource requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray * keyList = [self getXAxisListFromChartData:chartData];
            [smallChartViewController setShowingXAxisKeyList:keyList];
            
            if (chartData && [chartData count]){
                NSDate * fromDate = chartData.firstObject.date;
                NSDate * toDate = chartData.lastObject.date;
                [smallChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
            }
            
            [smallChartViewController initMainChartData:chartData];
            
            
//            [dataSource streamingDataForStockInfo:request handlingBlock:^(ChartData * _Nonnull cData) {
//                [smallChartViewController addMainChartData:cData];
//            }];
            
        });
    }];
}

- (NSArray *)getXAxisListFromChartData:(NSArray<ChartData *> *)chartData {
    NSMutableArray * array = [NSMutableArray array];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmm"];
    
    NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
    
    for (ChartData * data in chartData){
        NSDate * date = data.date;
        if ([hhmmList containsObject:[formatter stringFromDate:date]]){
            [array addObject:data.groupingKey];
        }
    }
    return array;
}

- (void)closeSmallChart {
    [self.overlayBGView removeFromSuperview];
    [self.overlayview removeFromSuperview];
    
//    [[ChartEtnetDataSource sharedInstance] stopStreamingForStockInfo:nil];
}

- (void)clickSearch{
    NSString * code = self.codeTextField.text;
    NSLog(@"Code: %@", code);
    
//    ChartEtnetDataSource * dataSource = [ChartEtnetDataSource sharedInstance];
////    [dataSource loginWithUid:@"BMPuser" token:TOKEN];
//
//    ChartDataRequest * request = [[ChartDataRequest alloc] initWithCode:code interval:ChartDataInterval15Min isToday:NO codeType:ChartCodeTypeHKStock];
//
//    [dataSource requestChartHistoryDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            ChartViewController * chartViewController = [[ChartViewController alloc] init];
            chartViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:chartViewController animated:YES completion:^{
                [chartViewController setStockCode:code];
//                [chartViewController initMainChartData:chartData];
                [chartViewController requestChartData];
            }];
            
//        });
//    }];
    
//    NSString * url = [NSString stringWithFormat:SECCHARTSERVER, code, TOKEN];
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSLog(@"URL:%@", url);
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray * resultArray = [result componentsSeparatedByString:@"\n"];
//        NSArray * chartData = [self extractDataFromResult:resultArray];
//        chartData = [[chartData reverseObjectEnumerator] allObjects];
//
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ChartViewController * chartViewController = [[ChartViewController alloc] init];
//            chartViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:chartViewController animated:YES completion:^{
//                [chartViewController initMainChartData:chartData];
//            }];
//        });
//    }];
}

- (NSArray *)extractDataFromResult:(NSArray *)resultArray {
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * dataStr in resultArray){
        NSArray * valueAry = [dataStr componentsSeparatedByString:@","];
        if ([valueAry count] > 5){
            NSString * key = [valueAry objectAtIndex:0];
            NSString * open = [valueAry objectAtIndex:1];
            NSString * high = [valueAry objectAtIndex:2];
            NSString * low = [valueAry objectAtIndex:3];
            NSString * close = [valueAry objectAtIndex:4];
            NSString * volume = [valueAry objectAtIndex:5];
            
            ChartData * data = [[ChartData alloc] init];
            
            data.groupingKey = key;
            data.date = [self dateFromTimestamp:key];
            data.open = [open floatValue];
            data.high = [high floatValue];
            data.low = [low floatValue];
            data.close = [close floatValue];
            data.volume = [volume floatValue];
            [array addObject:data];
        }
    }
    return array;
}

- (NSDate *)dateFromTimestamp:(NSString *)timestamp {
    unsigned long datetime = [[timestamp substringToIndex:[timestamp length] - 3] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
    return date;
}

@end
