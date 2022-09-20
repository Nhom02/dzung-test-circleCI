#!/usr/bin/env bash
helpFunction()
{
  echo ""
  echo "Usage: $0 -a PARAMTESTENV -b PARAMTESTSLUG -c PARAMTESTSUITE"
  echo -e "\t-a PARAMTESTENV\t: test environment dev, qa, prod"
  echo -e "\t-b PARAMTESTSLUG\t: test slug name"
  echo -e "\t-c PARAMTESTSUITE\t: test suite name"
  exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:" opt
do
  case "$opt" in
    a ) PARAMTESTENV="$OPTARG" ;;
    b ) PARAMTESTSLUG="$OPTARG" ;;
    c ) PARAMTESTSUITE="$OPTARG" ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case parameters are empty
if [ -z "$PARAMTESTENV" ] || [ -z "$PARAMTESTSLUG" ] || [ -z "$PARAMTESTSUITE" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo ""
echo "Test Environment:\t $PARAMTESTENV"
echo "Test Slug Name :\t $PARAMTESTSLUG"
echo "Test Suite Name :\t $PARAMTESTSUITE"
echo "Test Working Dir:\t $PWD"

# Setup - create a particular test specs for the particular suite
echo ""
echo "1. Setup - Assign a particular test specs for the particular test suite"
# Define test suite master-data, planning
SPECS_MASTER_DATA="**/e2e/manage/**/*.feature"
SPECS_OPTIMISE="**/e2e/optimise/**/*.feature"
SPECS_TRACKING="**/e2e/live_tracking/**/*.feature"
SPECS_PLANNING="!(**/e2e/(manage|optimise|live_tracking)/**/*).feature"
RANDOMSTRING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo $RANDOMSTRING;
echo "$RANDOMSTRING";
echo $RANDOM; echo;
echo $RANDOM | md5sum | head -c 20; echo;
echo md5sum | head -c 20; echo;

if [ "$PARAMTESTSUITE" = "master-data" ]; then
  CYPRESS_SPECS="$SPECS_MASTER_DATA"
elif [ "$PARAMTESTSUITE" = "optimise" ]; then
  CYPRESS_SPECS="$SPECS_OPTIMISE"
elif [ "$PARAMTESTSUITE" = "tracking" ]; then
  CYPRESS_SPECS="$SPECS_TRACKING"
elif [ "$PARAMTESTSUITE" = "planning" ]; then
  CYPRESS_SPECS="$SPECS_PLANNING"
elif [ "$PARAMTESTSUITE" = "all" ]; then
  CYPRESS_SPECS="$SPECS_PLANNING"
else
  echo "\tERROR: \"$PARAMTESTSUITE\" test suite was not defined!"
  exit 1 # Exit script if test suite was not defined!
fi

# Run cypress
echo "3. Starting - Run Cypress! $CYPRESS_SPECS"

# CYPRESS_E2E_TEST_SUITE="$PARAMTESTSUITE" \
#   ./node_modules/@nrwl/cli/bin/nx.js e2e explore-e2e \
#   --configuration "$PARAMTESTENV" \
#   --e2e \
#   --spec "$CYPRESS_SPECS"
detox test -c android --loglevel trace --record-videos all $PARAMTESTENV
echo "Debug $?"

# Force - Exit code 0 - with echo at the last command
echo "Finished - Run Cypress!"
