//
//  ChartTIConfig.m
//  ChartLibraryDemo
//
//  Created by william on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTIConfig.h"

@implementation ChartTIConfig

- (instancetype)initDefault {
    if (self = [self init]){
        
        self.selectedMainTI = ChartMainTINone;
        self.selectedSubTI = @[@(ChartSubTIEnumVOL), @(ChartSubTIEnumRSI)];
        
        [self resetDefault];
    }
    return self;
}

- (void)resetDefault{
    self.tiSMADayList = @[@10, @20, @50, @100];
    self.tiWMADayList = @[@10, @20, @50, @100];
    self.tiEMADayList = @[@10, @20, @50, @100];
    
    self.tiBBIntervals = 20;
    self.tiBBStdDev = 2.f;
    
    self.tiSARaccFactor = 0.02f;
    self.tiSARmaxAccFactor = 0.2f;
    
    self.tiDMIInterval = 14;
    
    self.tiMACDMACD1 = 12;
    self.tiMACDMACD2 = 26;
    self.tiMACDDiff = 9;
    
    self.tiOBVisWeighted = YES;
    
    self.tiROCIntervals = 10;
    
    self.tiRSIIntervals = 14;
    self.tiRSISMA = 5;
    
    self.tiSTCFastK = 18;
    self.tiSTCFastD = 5;
    
    self.tiSTCSlowSK = 18;
    self.tiSTCSlowSD = 5;
    
    self.tiVOLSMA = 5;
    
    self.tiWillInterval = 14;
    self.tiWillSma = 5;
    
    self.tiRSISMAShow = YES;
    self.tiVOLSMAShow = YES;
    self.tiWillSmaShow = YES;
    self.tiDMIADXRShow = YES;
}

@end
