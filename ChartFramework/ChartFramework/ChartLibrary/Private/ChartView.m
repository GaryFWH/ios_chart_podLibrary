//
//  ChartView.m
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartView.h"
#import "ChartDrawCommon.h"
@interface ChartView ()


@end

@implementation ChartView

- (instancetype)init {
    if (self = [super init]){
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
        self.directionalLockEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)initChartClassWithConfig:(ChartGlobalSetting *)dict keyList:(NSMutableArray*)keyList withChartData:(NSMutableArray *)chartObjectList {
//    ChartClass * chartClass = [[ChartClass alloc] init];
//    
//    [chartClass initWithChartObjectList:chartObjectList keyArray:keyList globalSetting:dict];
//    
//    self.chartClass = chartClass;
//}
- (void)getNearestChartPointFromPoint:(CGPoint )point nonEmptyData:(BOOL)nonEmptyData completion:(void(^)(bool found, NSString * key, CGPoint point))completion {
    CGPoint nearestPoint = CGPointMake(0, 0);
    NSString * closestKey = [self.chartClass setCursorSelectedIndexByPoint:point needWithData:nonEmptyData];
    if (closestKey){
        CGPoint position = [self.chartClass getPoisitionForKey:closestKey];
        position.x -= self.contentOffset.x;
        completion(YES, closestKey, position);
    } else {
        completion(NO, nil, nearestPoint);
    }
}


- (void)getNearestChartPointFromPoint:(CGPoint )point completion:(void(^)(bool found, NSString * key, CGPoint point))completion {
    [self getNearestChartPointFromPoint:point nonEmptyData:NO completion:completion];
//    CGPoint nearestPoint = CGPointMake(0, 0);
//    NSString * closestKey = [self.chartClass setCursorSelectedIndexByPoint:point];
//    if (closestKey){
//        CGPoint position = [self.chartClass getPoisitionForKey:closestKey];
//        position.x -= self.contentOffset.x;
//        completion(YES, closestKey, position);
//    } else {
//        completion(NO, nil, nearestPoint);
//    }
}
//
//- (CGSize)getContentSize {
//    return [self.chartClass getContentSize];
//}
//
//- (CGFloat)maximumScrollOffsetX {
//    return [self.chartClass maximumScrollOffsetX];
//}
//
//- (void)adjustXAxisPerValueByValue:(CGFloat )adjust{
////    self.chartClass.globalSetting.xAxisPerValue += adjust;
//    [self.chartClass adjustXAxisPerValueByValue:adjust];
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartClass){
        CGContextRef context = UIGraphicsGetCurrentContext();
//        [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height) color:[UIColor grayColor] isFill:YES];
        [self.chartClass drawOnContext:context];
    } else {
        
    }
}

// UITouchEvent
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchDelegate){
        [self.touchDelegate chartView:self touchesBegan:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchDelegate){
        [self.touchDelegate chartView:self touchesMoved:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchDelegate){
        [self.touchDelegate chartView:self touchesEnded:touches withEvent:event];
    }
}


@end
