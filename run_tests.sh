#!/bin/bash

# Script to run MTG Helper unit tests on iOS Simulator
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  MTG Helper - Unit Tests Execution${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Project configuration
PROJECT_NAME="MTG Helper"
SCHEME="MTG Helper"
CONFIGURATION="Debug"
SDK="iphonesimulator"

# Get the project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build paths
BUILD_DIR="$SCRIPT_DIR/build"
DERIVED_DATA_PATH="$BUILD_DIR/DerivedData"

# Test result path
TEST_RESULT_PATH="$BUILD_DIR/TestResults"

# Step 1: Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$TEST_RESULT_PATH"

# Step 2: Get or boot simulator
echo -e "${YELLOW}Checking simulator status...${NC}"

# Get the first available iPhone simulator
SIMULATOR_ID=$(xcrun simctl list devices available | grep "iPhone 15 Pro (623930D0-1B9E-42A4-A991-A7E343E19B80)" | grep -v "unavailable" | head -n 1 | grep -o -E '\([A-F0-9-]+\)' | tr -d '()')

if [ -z "$SIMULATOR_ID" ]; then
    echo -e "${RED}Error: No available iPhone simulator found${NC}"
    echo -e "${YELLOW}Available simulators:${NC}"
    xcrun simctl list devices available
    exit 1
fi

SIMULATOR_NAME=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | sed 's/(.*//' | xargs)
echo -e "${GREEN}Using simulator: $SIMULATOR_NAME${NC}"

# Check if simulator is already booted
SIMULATOR_STATE=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | grep -o "Booted\|Shutdown" || echo "Shutdown")

if [ "$SIMULATOR_STATE" != "Booted" ]; then
    echo -e "${YELLOW}Booting simulator...${NC}"
    xcrun simctl boot "$SIMULATOR_ID"
    # Wait for simulator to boot
    sleep 3
else
    echo -e "${GREEN}Simulator already running${NC}"
fi

# Step 3: Build and run tests
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Running Unit Tests...${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

xcodebuild test \
    -project "$SCRIPT_DIR/$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -sdk "$SDK" \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    -resultBundlePath "$TEST_RESULT_PATH/TestResults.xcresult" \
    -enableCodeCoverage YES \
    | tee "$TEST_RESULT_PATH/test_output.log"

# Capture test exit status
TEST_EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Test Results Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Parse test results
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed successfully!${NC}"
    
    # Extract test statistics from log
    TOTAL_TESTS=$(grep "Test Suite.*passed" "$TEST_RESULT_PATH/test_output.log" | tail -1 | grep -o "[0-9]* test" | grep -o "[0-9]*" || echo "Unknown")
    TEST_TIME=$(grep "Test Suite.*passed" "$TEST_RESULT_PATH/test_output.log" | tail -1 | grep -o "[0-9]*\.[0-9]* seconds" || echo "Unknown")
    
    echo -e "${GREEN}Total tests: $TOTAL_TESTS${NC}"
    echo -e "${GREEN}Execution time: $TEST_TIME${NC}"
    echo -e "${GREEN}Simulator: $SIMULATOR_NAME${NC}"
    echo ""
    echo -e "${GREEN}Test results bundle: $TEST_RESULT_PATH/TestResults.xcresult${NC}"
    echo -e "${YELLOW}To view detailed coverage report, run:${NC}"
    echo -e "${YELLOW}  xcrun xccov view --report $TEST_RESULT_PATH/TestResults.xcresult${NC}"
else
    echo -e "${RED}✗ Tests failed!${NC}"
    echo ""
    echo -e "${RED}Failed tests details:${NC}"
    grep -A 5 "Test Case.*failed" "$TEST_RESULT_PATH/test_output.log" || echo "See full log for details"
    echo ""
    echo -e "${RED}Full test log: $TEST_RESULT_PATH/test_output.log${NC}"
    exit $TEST_EXIT_CODE
fi

echo ""
