#!/bin/sh
wantedConfig="Debug" currentConfig="$CONFIGURATION"    
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

echo "$wantedConfig = $currentConfig"

if [ $currentConfig != $wantedConfig ]; 
then
   echo "Don't Build Chart Framework"
    exit 0
else 

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Next, work out if we're in SIM or DEVICE
if [ "false" == ${ALREADYINVOKED:-false} ]
then

export ALREADYINVOKED="true"

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
else
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
fi

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
echo "\n Step 2"
echo "Copy - ${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework \n To ${UNIVERSAL_OUTPUTFOLDER}/"
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
# NO

echo "\n Step 4"
echo "Lipo OutPut - ${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/${TARGET_NAME} \n
${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME} \n
${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}"

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
cd "PROJECT_DIR - ${PROJECT_DIR}"
cd ..

echo "Remove - ${PROJECT_NAME}.framework"
rm -R "${PROJECT_NAME}.framework"

echo "Copy - ${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework \n To ${PROJECT_NAME}.framework"
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework" "${PROJECT_NAME}.framework"

# Step 6. Convenience step to open the project's directory in Finder
open "${PROJECT_DIR}"

fi

fi




