#!/usr/bin/env python3
import io
import sys
import re
import csv

def parse_results(file_path: str): 
    with open(file_path, 'r') as file:
        lines = file.readlines()

    results = []

    names = list[str]()
    it = iter(lines)
    try:
        for line in it:
            match = re.match(r"Benchmark (\S+)", line)
            if not match:
                print(f"no name {line}", file=sys.stderr)
                continue
            benchmark_name = match.group(1)
            names.append(benchmark_name)
            cur_res = list()
            next(it)
            for i in range(4):
                line = next(it)
                if line.__contains__("0 of 0"):
                    print (f"Benchmark {benchmark_name} zero", file=sys.stderr)
                    match = ["0%"]
                else:
                    match = re.findall(r"\d+\.\d\d%", line)
                if not match:
                    print(f"no number {i} in {line}Benchmark {benchmark_name}", file=sys.stderr)
                    continue
                cur_res.append(float(match[0][:-1]))
            results.append(cur_res)
            line = next(it)
            match = re.findall(r"(\d+) tests; (\d+) failure", line)[0]
            if not match:
                print(f"no tests/failures {line}", file=sys.stderr)
                continue
            results[-1].append(int(match[0]))
            results[-1].append(int(match[1]))
    except StopIteration:
        pass

    return names, results


def write_to_csv(output_file : io.TextIOBase, benchmark_name: list[str], results ):
    writer = csv.writer(output_file)
    writer.writerow(['Benchmark', 'Instructions', 'Branches', 'Lines', 'Complexity', 'Tests', 'Failures'])
    for i in range(min(len(benchmark_name), len(results))):
        writer.writerow([benchmark_name[i]] + results[i])
    # writer.writerow([benchmark_name] + results)


if __name__ == "__main__":
    file_path = sys.argv[1]
    # file_path = "./clean.log"
    output_file = sys.stdout 
    benchmark_name, results = parse_results(file_path)
    write_to_csv(output_file, benchmark_name, results)
