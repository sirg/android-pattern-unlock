#!/bin/bash
#
# Android pattern unlock
# Author: Sergey Gleizer
# Forked and rehacked from: Matt Wilson (https://github.com/mattwilson1024/android-pattern-unlock)
# License: Free to use and share. If this helps you, buy someone you like a beer :)
#
# This script sends simulated touch input over ADB for remotely swiping on Android's pattern lockscreen.
# This allows you to unlock the device even if the touch screen is broken.
#
# Note: You must have USB and/or wireless debugging enabled on your device for this script to work (in the developer options).
# This script will not work unless this option is enabled. I recommend turning it on to make life easier if you drop your phone.
# Note: The device does not need to be rooted for this method to work.
#
# You need to have adb on your PATH to run this script.
#
# Customize the variables in the top section of the script with your phone's coordinates
# One way to get the coordinates is to use an eraseable marker
# and put dots on your pattern screen where the Android's dots are.
# Then use a measuring tool of your choice (grid app, ruler app or real ruler)
# to measure and calculate coordinates of each dot.
# Alternatively, use "adb shell getevent -l" to record an unlock
# and decode the output.
#
# Usage:
# PHONE_PATTERN="1 2 3 4 5 6" unlock.sh | adb shell

# =======================================================================================================================

# Variables
#
# Coordinates will vary depending on the screen resolution of your device
# The pattern should be set based on the following layout:
# 1 2 3
# 4 5 6
# 7 8 9

PATTERN=$PHONE_PATTERN      # The unlock pattern to draw, space seperate"d

# Coordinates ballparked from Galaxy S20FE (1080 x 2400)

COL_1=290                   # X coordinate of column 1 (in pixels)
COL_2=532                   # X coordinate of column 2 (in pixels)
COL_3=774                   # X coordinate of column 3 (in pixels)

ROW_1=1241                  # Y coordinate of row 1 (in pixels)
ROW_2=1483                  # Y coordinate of row 2 (in pixels)
ROW_3=1709                  # Y coordinate of row 3 (in pixels)

SWIPE_UP_X=450
SWIPE_UP_Y_FROM=1000
SWIPE_UP_Y_TO=200

# =======================================================================================================================

# Define X&Y coordinates for each of the 9 positions.

X[1]=$(( ${COL_1} ))
X[2]=$(( ${COL_2} ))
X[3]=$(( ${COL_3} ))
X[4]=$(( ${COL_1} ))
X[5]=$(( ${COL_2} ))
X[6]=$(( ${COL_3} ))
X[7]=$(( ${COL_1} ))
X[8]=$(( ${COL_2} ))
X[9]=$(( ${COL_3} ))

Y[1]=$(( ${ROW_1} ))
Y[2]=$(( ${ROW_1} ))
Y[3]=$(( ${ROW_1} ))
Y[4]=$(( ${ROW_2} ))
Y[5]=$(( ${ROW_2} ))
Y[6]=$(( ${ROW_2} ))
Y[7]=$(( ${ROW_3} ))
Y[8]=$(( ${ROW_3} ))
Y[9]=$(( ${ROW_3} ))

# Function definitions

wakeScreen() {
    echo "# wake up"
    echo input keyevent 26
    sleep 0.5   # a little time to wake up
}

swipeUp() {
    echo "# swipe up to get pattern screen"
    echo input swipe ${SWIPE_UP_X} ${SWIPE_UP_Y_FROM} ${SWIPE_UP_X} ${SWIPE_UP_Y_TO}
    sleep 2    # sometimes settling on the pattern takes a while
}

startTouch() {
    echo "# DOWN at $1"
    echo input motionevent DOWN ${X[$1]} ${Y[$1]}
}

moveTo () {
    echo "# MOVE To $1"
    echo input motionevent MOVE ${X[$1]} ${Y[$1]}
}

finishTouch() {
    echo "# UP at $1"
    echo input motionevent UP ${X[$1]} ${Y[$1]}
}

swipePattern() {
    dots=($PATTERN)
    startTouch ${dots[0]}
    for NUM in $PATTERN
    do
        moveTo $NUM
    done
    finishTouch ${dots[-1]}
}

# Actions

wakeScreen
swipeUp
swipePattern
