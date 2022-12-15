/*
 *  MomClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "MomClass.h"

void MomClass::init()
{
	iDayInterval = 10;
}
void MomClass::setDayInterval(int day)
{
	this->iDayInterval = day;
}
int MomClass::getDayInterval()
{
	return iDayInterval;
}
void* MomClass::calculate(void* pMapofAllVoid) {
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	MapofAll* pMap = new MapofAll;
	NSInteger size = pMapofAll->size();
	if (size <= 0) {
		return NULL;
	}
	NSInteger lineSize = 0;
	MapofAll::iterator iter;
	for (iter = pMapofAll->begin(); iter != pMapofAll->end(); iter ++) {
		if (strcmp(iter->first.c_str(), "MainData") != 0) {
			continue;
		}
		MapofLine* pMapofLine = iter->second;
		MapofLine::iterator iterOfLine;
		lineSize = pMapofLine->size();
		if (lineSize <= 0)
            return NULL;
        if (lineSize <= iDayInterval)
            return NULL;
		float cList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		NSInteger i = 0;
//		int j = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			cList[i++] = oldData->close;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		MapofLine* pMapofInsertMom = new MapofLine();
        for (i = lineSize - 1; i > iDayInterval - 1; i--) {
            float pDataToday = cList[i];
            float pDataLast = cList[i - iDayInterval];
            float pResult = pDataToday / pDataLast * 100;
			chartData *insertData = new chartData();
			insertData->open = pResult;
			insertData->close = pResult;
			insertData->high = pResult;
			insertData->low = pResult;
			insertData->volume = pResult;
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertMom->insert(pair<string, chartData*>(datakey,insertData));
        }
		pMap->insert(pair<string,MapofLine*>("Mom",pMapofInsertMom));
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}	
	return (void *)pMap;	
}