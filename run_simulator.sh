#!/bin/bash

# Script to build, install and run MTG Helper on iOS Simulator
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting MTG Helper build and deployment...${NC}"

# Project configuration
PROJECT_NAME="MTG Helper"
SCHEME="MTG Helper"
CONFIGURATION="Debug"
SDK="iphonesimulator"

# Get the project directory (parent of .xcodeproj)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Build paths
BUILD_DIR="$PROJECT_DIR/build"
DERIVED_DATA_PATH="$BUILD_DIR/DerivedData"

# Step 1: Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR"

# Step 2: Build the app
echo -e "${YELLOW}Building the app...${NC}"
xcodebuild \
    -project "$SCRIPT_DIR/$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -sdk "$SDK" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build

# Find the built app
APP_PATH=$(find "$DERIVED_DATA_PATH" -name "*.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo -e "${RED}Error: Could not find built app${NC}"
    exit 1
fi

echo -e "${GREEN}App built successfully at: $APP_PATH${NC}"

# Step 3: Get or boot simulator
echo -e "${YELLOW}Checking simulator status...${NC}"

# Get the first available iPhone simulator already booted
SIMULATOR_ID=$(xcrun simctl list devices available | grep "Booted" | head -n 1 | grep -o -E '\([A-F0-9-]+\)' | tr -d '()')

if [ -z "$SIMULATOR_ID" ]; then
    echo -e "${RED}Error: No available iPhone simulator found${NC}"
    exit 1
fi

SIMULATOR_NAME=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | sed 's/(.*//' | xargs)
echo -e "${GREEN}Using simulator: $SIMULATOR_NAME${NC}"

# Check if simulator is already booted
SIMULATOR_STATE=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | grep -o "Booted\|Shutdown")

if [ "$SIMULATOR_STATE" != "Booted" ]; then
    echo -e "${YELLOW}Booting simulator...${NC}"
    xcrun simctl boot "$SIMULATOR_ID"
    # Wait for simulator to boot
    sleep 3
    # Open Simulator.app
    open -a Simulator
    sleep 2
else
    echo -e "${GREEN}Simulator already running${NC}"
fi

# Step 4: Install the app
echo -e "${YELLOW}Installing app on simulator...${NC}"
xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"

# Step 5: Launch the app
echo -e "${YELLOW}Launching app...${NC}"
BUNDLE_ID=$(defaults read "$APP_PATH/Info.plist" CFBundleIdentifier)
xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID"

echo -e "${GREEN}✓ MTG Helper successfully deployed and launched!${NC}"
echo -e "${GREEN}Bundle ID: $BUNDLE_ID${NC}"
echo -e "${GREEN}Simulator: $SIMULATOR_NAME${NC}"
