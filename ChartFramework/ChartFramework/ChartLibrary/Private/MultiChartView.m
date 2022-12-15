//
//  MultiChartView.m
//  ChartLibraryDemo
//
//  Created by william on 3/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "MultiChartView.h"
#import "ChartDrawCommon.h"

@implementation MultiChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (CGSize)getContentSize {
//    CGFloat maxWidth = 0;
//    CGFloat maxHeight = 0;
//    for (NSString * key in self.chartClassListOrder){
//        ChartClass * chartClass = [self.chartClassListDict objectForKey:key];
//        CGFloat contentSizeWidth= [chartClass getContentSize].width;
//        if (contentSizeWidth > maxWidth){
//            maxWidth = contentSizeWidth;
//        }
//        CGFloat maxY = chartClass.globalSetting.YOffsetStart + chartClass.globalSetting.chartHeight;
//        if (maxY > maxHeight){
//            maxHeight = maxY;
//        }
//    }
//    return CGSizeMake(maxWidth, maxHeight);
//}
//- (NSArray<ChartClass *> *)chartClassSorted {
//    NSMutableArray * mutArray = [NSMutableArray array];
//    for (NSString * key in self.chartClassListOrder){
//        ChartClass * cClass = [self.chartClassListDict objectForKey:key];
//        [mutArray addObject:cClass];
//    }
//    return [NSArray arrayWithArray:mutArray];
//}

- (NSString *)identifierForChartClass:(ChartClass *)chartClass {
    for (NSString * key in self.chartClassListOrder){
        ChartClass * cClass = [self.chartClassListDict objectForKey:key];
        if (cClass == chartClass){
            return key;
        }
    }
    return nil;
}

//- (void)adjustXAxisPerValueByValue:(CGFloat )adjust{
////    self.chartClass.globalSetting.xAxisPerValue += adjust;
//    for (NSString * key in self.chartClassListOrder){
//        ChartClass * chartClass = [self.chartClassListDict objectForKey:key];
//        [chartClass adjustXAxisPerValueByValue:adjust];
//    }
//}

- (void)removeAllChartClass {
    self.chartClassListOrder = nil;
    self.chartClassListDict = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartClassListOrder && [self.chartClassListOrder count]){
        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGRect cRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
//        CGContextSaveGState(context);
//        CGContextClipToRect(context, cRect);
//        [ChartDrawCommon DrawRectOnContext:context rect:cRect color:[UIColor grayColor] isFill:YES];
        for (NSString * classNameKey in self.chartClassListOrder){
            ChartClass * cClass = [self.chartClassListDict objectForKey:classNameKey];
            if (cClass){
                [cClass drawOnContext:context];
            }
        }
//        CGContextRestoreGState(context);
    }
}


- (void)updateAllClassForContentOffset:(CGPoint)contentOffset {
    for (NSString * key in self.chartClassListOrder){
        ChartClass * chartClass = [self.chartClassListDict objectForKey:key];
        [chartClass updateChartDisplayInfoForContentOffset:contentOffset];
    }
}
@end
