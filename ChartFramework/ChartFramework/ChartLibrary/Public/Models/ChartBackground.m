//
//  ChartBackground.m
//  ChartLibraryDemo
//
//  Created by william on 6/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartBackground.h"
#import "ChartConst.h"

@implementation ChartBackgroundColor

- (instancetype)initWithColor:(UIColor *)color percentage:(CGFloat)percentage {
    if (self = [self init]){
        self.color = color;
        self.coverPecentage = percentage;
    }
    return self;
}

@end


@implementation ChartBackground

- (instancetype)initWithKey:(NSString *)key colors:(NSArray *)colors{
    if (self = [self init]){
        self.groupingKey = key;
        self.colorList = colors;
    }
    return self;
}

@end
