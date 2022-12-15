/*
 *  RsiClass.h
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

class RsiClass{
public:
	void init();
	void* calculate(void* pMapofAllVoid);
	void setDay(NSInteger tday);
	NSInteger getDay();
	void setSmaDay(NSInteger smaday);
	NSInteger getSmaDay();
	void setShowSma(bool bShow);
	bool getShowSma();
	bool CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay);
private:
	NSInteger day;
	bool bShowSma;
	NSInteger smaDay;
};