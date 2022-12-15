/*
 *  ObvClass.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
class ObvClass{
public:
	void init();
	void setbWc(bool bc);
	bool getbWc();
	void* calculate(void* pMapofAllVoid);
	
private:
	bool bWc;
};