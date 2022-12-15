//
//  ChartView.h
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartClass.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ChartViewTouchDelegate;

@interface ChartView : UIScrollView

@property (retain, nonatomic) ChartClass * chartClass;
@property (nonatomic, assign) id<ChartViewTouchDelegate> touchDelegate;
//- (void)initChartClassWithConfig:(ChartGlobalSetting *)dict keyList:(NSMutableArray*)keyList withChartData:(NSMutableArray *)chartObjectList;

//- (void)addChartData:(ChartData *)chartData;
//- (void)updateChartData:(ChartData *)chartData;
//- (CGFloat)maximumScrollOffsetX;
//- (void)adjustXAxisPerValueByValue:(CGFloat )xAxisPerValue;
//- (CGSize)getContentSize;

//- (void)getNearestChartPointWithDataFromPoint:(CGPoint )point completion:(void(^)(bool found, NSString * key, CGPoint point))completion;
- (void)getNearestChartPointFromPoint:(CGPoint )point nonEmptyData:(BOOL)nonEmptyData completion:(void(^)(bool found, NSString * key, CGPoint point))completion;
- (void)getNearestChartPointFromPoint:(CGPoint )point completion:(void(^)(bool found, NSString * key, CGPoint point))completion;

@end

@protocol ChartViewTouchDelegate <NSObject>

-(void)chartView:(ChartView *)chartView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)chartView:(ChartView *)chartView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)chartView:(ChartView *)chartView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
NS_ASSUME_NONNULL_END
