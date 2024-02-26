#!/bin/bash

if [ "$(id -u)" != 0 ] ; then
  echo "Script must be run as root"
  exit 0;
fi

if [ $# -ne 3 ] && [ $# -ne 4 ] && [ $# -ne 5 ]
then
  echo "Usage: <tool-path> <benchmarks-path> <bench-name> [runs-number] [time-budget]"
  echo "example: ~/evokex ~/my-benchmarks 3 60"
  echo "example: ./kex-sbst ./benchmarks11th 'TA4J-54'"
  exit 0;
fi

USER=$(stat -c '%u' "${BASH_SOURCE[0]}")
GROUP=$(stat -c '%g' "${BASH_SOURCE[0]}")

echo "User: $USER, group: $GROUP"

TOOL_HOME="$(realpath $1)"
BENCH_PATH="$(realpath $2)"
NAME=$3
RUNS_NUMBER=${4:-"1"}
TIME_BUDGET=${5:-"120"}

SCRIPTS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# filter benchmarks list
sudo -u "#$USER" bash -c "
cd "$BENCH_PATH/conf"
$SCRIPTS_PATH/filter-bench-list.py ./benchmarks.list $NAME
"

$SCRIPTS_PATH/setup-and-run-docker.sh "$TOOL_HOME" "$BENCH_PATH" "$RUNS_NUMBER" "$TIME_BUDGET"

# restore benchmarks list
sudo -u "#$USER" bash -c "
cd "$BENCH_PATH/conf"
cp ./benchmarks.list.bkp ./benchmarks.list
"