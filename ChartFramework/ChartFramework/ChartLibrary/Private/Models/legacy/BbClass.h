/*
 *  BbClass.h
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年7月22日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
class BbClass{
public:
	void init();
	void* calculate(void* pMapofAllVoid);
	void setBollDays(int day);
	int getBollDays();
	void setnoStdDev(float noDev);
	float getnoStdDev();
	bool CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay);
	
private:
	int bollDays;
	float noStdDev;
};
