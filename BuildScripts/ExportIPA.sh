#!/bin/sh
#
# ExportIPA.sh
#

EXPORT_ARCHIVE="ExportArchive"
EXPORT_IPA="ExportIPA"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cd ..

echo "Current Path: ${PWD} \n"

# Remove & new folder
if [ -e $EXPORT_ARCHIVE ]
then
	rm -R $EXPORT_ARCHIVE
fi
mkdir -p $EXPORT_ARCHIVE

# Clean
xcodebuild clean -workspace ChartLibrary.xcworkspace -scheme ChartLibararyDemo 

# Archive
echo "Export Archive"
xcodebuild archive -archivePath ${PWD}/$EXPORT_ARCHIVE/ChartLibararyDemo.xcarchive \
			-workspace ChartLibrary.xcworkspace -scheme ChartLibararyDemo \
			-destination 'generic/platform=iOS'

# Remove & new folder
if [ -e $EXPORT_IPA ]
then
	rm -R $EXPORT_IPA
fi
mkdir -p $EXPORT_IPA

# Copy ExportOptions.plist
cp -r ${PWD}/ExportOptions.plist ${PWD}/$EXPORT_IPA

# Export IPA
echo "Export IPA"
xcodebuild -exportArchive -archivePath ${PWD}/$EXPORT_ARCHIVE/ChartLibararyDemo.xcarchive \
		 	-exportPath ${PWD}/$EXPORT_IPA/ \
		 	-exportOptionsPlist ${PWD}/$EXPORT_IPA/ExportOptions.plist

