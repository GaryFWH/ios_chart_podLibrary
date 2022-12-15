/*
 *  WilliamClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "WilliamClass.h"

void WilliamClass::init()
{
	n_diff = 14;
	smaDay = 5;
	bShowSma = true;
}
void WilliamClass::setDiff(NSInteger diff)
{
	this->n_diff = diff;
}
NSInteger WilliamClass::getDiff()
{
	return n_diff;
}
void WilliamClass::setSmaDay(NSInteger day)
{
	this->smaDay = day;
}
NSInteger WilliamClass::getSmaDay()
{
	return smaDay;
}
void WilliamClass::setShowSma(bool bShow)
{
	this->bShowSma = bShow;
}
bool WilliamClass::getShowSma()
{
	return bShowSma;
}
float WilliamClass::getMaxPrice(float* dataPrices,NSInteger size) {
	float price = dataPrices[0];
	for (int i = 1; i < size; i++) {
		float tempPrices =dataPrices[i];
		if (price < tempPrices) {
			price = tempPrices;
		}
	}
	return price;
}
float WilliamClass::getMinPrice(float* dataPrices,NSInteger size) {
	float price = dataPrices[0];
	for (int i = 1; i < size; i++) {
		float tempPrices = dataPrices[i];
		if (price > tempPrices) {
			price = tempPrices;
		}
	}
	return price;
}
float WilliamClass::getWilliam(float high, float low, float close) {
	float willPrices = (high - close) / (high - low) * (-100.00f);
	return willPrices;
}
bool WilliamClass::CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay) {
	// check if enough day to calc SMA
	if (size < iDay)
		return false;
	
	// check valid start point
	if (lStartPt < 0)
		return false;
	
	// check if enough valid data
	if (size - lStartPt < iDay)
		return false;
	float dTotal = 0.0;
	
	NSInteger lSMADataPos = lStartPt + iDay - 1;
	// calculate first day SMA
	for (NSInteger i = lStartPt; i < iDay + lStartPt; i++) {
		if (inputlist[i] == -0.0001f) {
			return false;
		} // end if
		// System.err.println("i="+i+"\tSma Close:"+inputlist[i]);
		dTotal += inputlist[i];
	} // end for
	outputlist[lSMADataPos] = (dTotal / iDay) / 1.0;
	
	++lSMADataPos;
	
	// calculate SMA from 2nd day
	NSInteger sDayDiff = iDay - 1;
	for (NSInteger i = lStartPt + 1; (size - 1 - i) >= sDayDiff; i++) {
		// get the oldest days's value of last MA range
		if (inputlist[i - 1] == -0.0001f) {
			return false;
		} // end if
		// subtract the oldest value
		dTotal -= inputlist[i - 1];
		
		// get the newest day's value of present MA range
		
		if (inputlist[i + sDayDiff] == -0.0001f) {
			return false;
		} // end if
		// add the newest value
		dTotal += inputlist[i + sDayDiff];
		
		outputlist[lSMADataPos] = (dTotal / iDay) / 1.0;
		++lSMADataPos;
	} // end for
	return true;
}
void* WilliamClass::calculate(void* pMapofAllVoid) {
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
		
		float cList[lineSize];
		float hList[lineSize];
		float lList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		int i = 0;
		int iHigh = 0;
		int iLow = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			cList[i++] = oldData->close;
			hList[iHigh++] = oldData->high;
			lList[iLow++] = oldData->low;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		if (lineSize <= 0) {
            //[dateList release];
            dateList = nil;
            return NULL;
        }
        float willList1[lineSize];
        float smaList1[lineSize];
		for (i = 0; i < lineSize; i++) {
			willList1[i] = -0.0001f;
			smaList1[i] = -0.0001f;
		}
		MapofLine* pMapofInsertWill = new MapofLine();
		for (i = 1; i < lineSize + 1; i++) {
   //     for (i = n_diff; i <lineSize + 1; i++) {
			if (i < n_diff) {
				chartData *insertData = new chartData();
				insertData->open = -0.0001f;
				insertData->close = -0.0001f;
				insertData->high = -0.0001f;
				insertData->low = -0.0001f;
				insertData->volume = -0.0001f;
				NSString* str = [dateList objectAtIndex:i - 1];
				string datakey([str UTF8String]);
				pMapofInsertWill->insert(pair<string, chartData*>(datakey,insertData));
				continue;
			}
			float highTempList[n_diff];
			float lowTempList[n_diff];
			for (int k = 0; k < n_diff; k++) {
				highTempList[k] = hList[i - n_diff + k];
				lowTempList[k] = lList[i - n_diff + k];
			}
			
            float maxHigh = getMaxPrice(highTempList,n_diff);
            float minLow = getMinPrice(lowTempList,n_diff);
			
            float close = cList[i - 1];
            float willPrice = getWilliam(maxHigh, minLow, close);
			if (maxHigh == close) {
				willPrice = 0.0f;
			}
			//if (willPrice == -0.0001f) {
//				continue;
//			}
            willList1[i - 1] = willPrice;
			chartData *insertData = new chartData();
			insertData->open = willPrice;
			insertData->close = willPrice;
			insertData->high = willPrice;
			insertData->low = willPrice;
			insertData->volume = willPrice;
			NSString* str = [dateList objectAtIndex:i - 1];
			string datakey([str UTF8String]);
			pMapofInsertWill->insert(pair<string, chartData*>(datakey,insertData));
        }
		pMap->insert(pair<string,MapofLine*>("WILL",pMapofInsertWill));
        // calculate SMA
        if (bShowSma) {
            int lStartPt = -1;
            for (i = 0; i < lineSize; i++) {
                if (willList1[i] != -0.0001f) {
                    lStartPt = i;
                    break;
                }
            }
			
            if (lStartPt != -1) {
                if (!CalcSMA(willList1, smaList1, lineSize, lStartPt, smaDay)) {
                    //[dateList release];
                    dateList = nil;
                    return NULL;
                } // end if
            }
        }
		MapofLine* pMapofInsertWSma = new MapofLine();
        for (i = 0; i < lineSize; i++) {
            //if (smaList1[i] == -0.0001f) {
//				continue;
//			}
			chartData *insertData = new chartData();
			insertData->open = smaList1[i];
			insertData->close = smaList1[i];
			insertData->high = smaList1[i];
			insertData->low = smaList1[i];
			insertData->volume = smaList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertWSma->insert(pair<string, chartData*>(datakey,insertData));
        }
		pMap->insert(pair<string,MapofLine*>("WSMA",pMapofInsertWSma));
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}	
	return (void *)pMap;	
}