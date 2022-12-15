/*
 *  WilliamClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
class WilliamClass{
public:
	void init();
	void setDiff(NSInteger diff);
	NSInteger getDiff();
	void setSmaDay(NSInteger day);
	NSInteger getSmaDay();
	void setShowSma(bool bShow);
	bool getShowSma();
	float getMaxPrice(float* dataPrices,NSInteger size);
	float getMinPrice(float* dataPrices,NSInteger size);
	float getWilliam(float high, float low, float close);
	bool CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay);
	void* calculate(void* pMapofAllVoid);
	
private:
	NSInteger n_diff;
	NSInteger smaDay;
	bool bShowSma;
};
