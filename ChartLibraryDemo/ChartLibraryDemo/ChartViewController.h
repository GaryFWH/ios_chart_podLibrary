//
//  ChartViewController.h
//  ChartLibraryDemo
//
//  Created by william on 1/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChartFramework/ChartFramework.h>
//#import "ChartData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartViewController : UIViewController {
    NSString *code;
    NSString * codename;
    
    NSMutableArray *selectBtnArray;
    UIView *selectView;
    
}

- (void)initMainChartData:(NSArray<ChartData *> *)dataList;

- (void)setStockCode:(NSString *)stockCode;

- (void)requestChartData;
@end

NS_ASSUME_NONNULL_END
