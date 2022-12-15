/*
 *  DmiClass.h
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

class DmiClass{
public:
	void init();
	void setShowADXR(bool bShow);
	bool getShowADXR();
	void setDayInterval(int iDay);
	int  getDayInterval();
	void* calculate(void* pMapofAllVoid);
	float FindMax(float value1, float value2);
	float FindMax(float value1, float value2, float value3);
	
private:
	bool bShowADXR;
	int iDMIDay;
};