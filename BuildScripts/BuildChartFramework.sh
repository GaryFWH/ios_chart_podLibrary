#!/bin/sh

#  BuildChartFramework.sh
#
#
#  Created by Gary Fan on 01/08/2022.
#

# resolve relative path issues
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

cd ..
# cd ChartFramework
# echo $DIR

xcodebuild build -workspace ChartLibrary.xcworkspace -scheme ChartFramework -sdk iphoneos -destination generic/platform=iOS
CODE_SIGN_IDENTITY="" 
CODE_SIGNING_REQUIRED=NO 

##