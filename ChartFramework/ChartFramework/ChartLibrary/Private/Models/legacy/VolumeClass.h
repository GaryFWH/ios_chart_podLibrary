/*
 *  VolumeClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
class VolumeClass
{
public:
	void init();
	void setDay(NSInteger day);
	NSInteger getDay();
	void setbShowSma(bool bShow);
	bool getbShowSma();
	void setSma(NSInteger sma);
	NSInteger getSma();
	void* calculate(void* pMapofAllVoid);
    bool CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay);
private:	
	NSInteger day;
	bool bShowSma;
	NSInteger sma;
};
