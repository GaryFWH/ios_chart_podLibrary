/*
 *  StcClass.h
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
class StcClass{
public:
	void init();
	void* calculate(void* pMapofAllVoid);
	NSInteger getKDay();
	NSInteger getDDay();
	NSInteger getpKDay();
	NSInteger getpDDay();
	NSInteger getType();
	void setKDay(NSInteger iDay);
	void setDDay(NSInteger iDay);
	void setpKDay(NSInteger iDay);
	void setpDDay(NSInteger iDay);
	void setType(NSInteger type);
	bool calculateSto(float* cList, float* hList, 
					  float* lList,float* stclist, 
					  float* emalist, NSInteger iKDay, NSInteger iDDay,NSInteger size);
	bool CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay);
private:
	NSInteger iPC_K_Day;//fast
	NSInteger iPC_D_Day;//fast
	NSInteger iType;// 0--slow,1--fast
	NSInteger iPC_pK_Day;//slow
	NSInteger iPC_pD_Day;//slow
};