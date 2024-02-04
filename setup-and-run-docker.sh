#!/bin/bash

if [ "$(id -u)" != 0 ] ; then
  echo "Script must be run as root"
  exit 0;
fi

if [ $# -ne 4 ] && [ $# -ne 5 ]
then
  echo "Usage: <tool-path> <benchmarks-path> <runs-number> <time-budget> [scripts-path]"
  echo "example: ~/evokex ~/my-benchmarks 3 60"
  echo "example: ~/kex-sbst ~/benchmarks11 3 60 ./sbst_scripts"
  exit 0;
fi

USER=$(stat -c '%u' "${BASH_SOURCE[0]}")
GROUP=$(stat -c '%g' "${BASH_SOURCE[0]}")

echo "User: $USER, group: $GROUP"

TOOL_HOME=$1
BENCH_PATH=$2
RUNS_NUMBER=$3
TIME_BUDGET=$4
SCRIPTS_PATH=${5:-"./sbst_scripts"}

TOOL_NAME=$(basename "$TOOL_HOME")
DOCKER_TOOL_HOME=/home/$TOOL_NAME

DOCKER_SCRIPTS="/var/sbst_scripts"

docker run --rm -d \
  --user $USER:$GROUP \
  --mount type=bind,source="$(realpath "$TOOL_HOME")",target="$DOCKER_TOOL_HOME" \
  --mount type=bind,source="$(realpath "$BENCH_PATH")",target=/var/benchmarks,readonly \
  --mount type=bind,source="$(realpath "$SCRIPTS_PATH")",target="$DOCKER_SCRIPTS",readonly \
  --name="$TOOL_NAME" \
  -it junitcontest/infrastructure:latest > /dev/null

docker exec -w "$DOCKER_TOOL_HOME" "$TOOL_NAME" "$DOCKER_SCRIPTS/run-and-collect.sh" "$TOOL_NAME" "$RUNS_NUMBER" "$TIME_BUDGET"

docker stop "$TOOL_NAME" > /dev/null
