/*
 *  SarClass.h
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年7月21日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

class SarClass{
public:
	void init();
	void* calculate(void* pMapofAllVoid);
	void setMaxSpeed(float maxspeed);
	float getMaxSpeed();
	void setMinSpeed(float minspeed);
	float getMinSpeed();

private:
	float maxSpeed;
	float minSpeed;
};