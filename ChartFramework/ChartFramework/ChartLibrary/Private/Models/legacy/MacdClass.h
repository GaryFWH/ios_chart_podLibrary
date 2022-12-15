/*
 *  MacdClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

class MacdClass
{
public:
	void init();
	NSInteger getMacd1();
	NSInteger getMacd2();
	NSInteger getDiff();
	void setMacd1(int iMacd);
	void setMacd2(int iMacd);
	void setDiff(int diff);
	void* calculate(void* pMapofAllVoid);
	bool CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay);
	
private:
	NSInteger iMacd1;
	NSInteger iMacd2;
	NSInteger iDiff;
};