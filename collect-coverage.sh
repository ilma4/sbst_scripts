#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#SCRIPT_DIR=$(pwd)

echo "Pwd is $SCRIPT_DIR"

BASE_PATH=$1
RUNS_NUMBER=$2

#EVO=$SCRIPT_DIR/master/target/evosuite-master-1.1.0.jar
JARS=$SCRIPT_DIR/jars
EVO=$JARS/mockito-core-4.11.0.jar
CONF=/var/benchmarks/conf/benchmarks.list
LOGS=$JARS/coverage_loggers
EXECUTION_TIMEOUT=120

java -Xms16G -Xmx16G -jar "$JARS/coverage.jar" "$CONF" "$BASE_PATH" "$EVO" "$JARS/junit.jar" "$RUNS_NUMBER" "$LOGS" "$EXECUTION_TIMEOUT"
