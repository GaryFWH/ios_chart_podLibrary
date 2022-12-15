/*
 *  SmaClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

class SmaClass
{
public:
	void init();
	void* calculate(void* pMapofAllVoid);
	NSInteger getDay1();
	void setDay1(NSInteger day);
	NSInteger getDay2();
	void setDay2(NSInteger day);
	NSInteger getDay3();
	void setDay3(NSInteger day);
	NSInteger getDay4();
	void setDay4(NSInteger day);
	NSInteger getDay5();
	void setDay5(NSInteger day);
	bool getSma1();
	bool getSma2();
	bool getSma3();
	bool getSma4();
	bool getSma5();
	void setSma1(bool bSma);
	void setSma2(bool bSma);
	void setSma3(bool bSma);
	void setSma4(bool bSma);
	void setSma5(bool bSma);
	bool CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay);
    void setType(NSInteger t);
    bool CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay);
    bool CalcWMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDDay);
private:	
	NSInteger iDay1;
	NSInteger iDay2;
	NSInteger iDay3;
	NSInteger iDay4;
	NSInteger iDay5;
	NSInteger type;// 0--sma,1--ema,2--wma
	bool bSma1;
	bool bSma2;
	bool bSma3;
	bool bSma4;
	bool bSma5;
};
