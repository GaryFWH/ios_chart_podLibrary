/*
 *  MomClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

class MomClass{
public:
	void init();
	void setDayInterval(int day);
	int getDayInterval();
	void* calculate(void* pMapofAllVoid);
	
private:
	int iDayInterval;
};