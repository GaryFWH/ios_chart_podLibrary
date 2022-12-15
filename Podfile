# Uncomment the next line to define a global platform for your project
workspace 'ChartLibrary'
platform :ios, '9.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
# inhibit_all_warnings!

def shared_pods
    # all the pods go here
    # pod 'Parse' etc.
end

xcodeproj 'ChartLibraryDemo/ChartLibararyDemo'
xcodeproj 'ChartFramework/ChartFramework'

target 'ChartLibararyDemo' do
	xcodeproj 'ChartLibraryDemo/ChartLibararyDemo'
	shared_pods
end

target 'ChartFramework' do
	xcodeproj 'ChartFramework/ChartFramework'
	# shared_pods
end
