/*
 *  golbal.h
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#include <map>
#include <list>
#include <string>
#include <time.h>

using namespace std;
using std::map;
typedef struct 
{
	float high;
	float low;
	float open;
	float close;
	float volume;
} chartData;
typedef map<string,chartData*> MapofLine;
typedef map<string,MapofLine*> MapofAll;
typedef struct
{
	float iv;
	float underlyhv;
	float close;
	float outstanding;
	float peroutstanding;
    float shareStrade;
    float lpBuy;
    float lpSell;
    float others4Common;
    float furtherBuy;
    float furtherSell;
    float others4Further;
} chartWarrantData;
typedef map<string,chartWarrantData*> MapofWarrantLine;
typedef map<string,MapofWarrantLine*> MapofWarrantAll;

#define MAXTICOUNT 4
#define ValueLimit 9953500000000000000
