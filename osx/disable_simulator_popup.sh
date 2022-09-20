#!/bin/bash

# Script to disable the iOS Simulator app from showing the "Do you want the application xxxx to accept incoming network connections?" pop-up every time the app is run

echo "> Enter password to temporarily shut firewall off"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off

echo "> Add Xcode as a firewall exception"
/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Xcode.app/Contents/MacOS/Xcode

echo "> Add iOS Simulator as a firewall exception"
/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator

echo "> Re-enable firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

exit 0