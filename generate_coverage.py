#!/usr/bin/env python3
import re
import os
import xml.etree.ElementTree as ET
from xml.dom import minidom
from pathlib import Path
import argparse

script_regex = re.compile(r"^SCRIPT ")
function_regex = re.compile(r"^FUNCTION ")
empty_regex = re.compile(r"^$")


def main(input_path, output_path):
    print(f"Parsing {input_path}...")

    script_data = {}
    function_data = {}

    section_state = "NONE"
    tmp_state = {}

    with open(input_path) as f:
        lines = f.readlines()
        for idx, line in enumerate(lines):
            if section_state == "NONE":
                if script_regex.match(line):
                    file_path = re.match(r'^SCRIPT  (.*)$', line).groups()[0]
                    script_data[file_path] = {}
                    section_state = "SCRIPT_HEADER"
                    tmp_state["script_name"] = file_path

                elif function_regex.match(line):
                    function_name = re.match(
                        r'^FUNCTION  (.*)$', line).groups()[0]
                    function_data[function_name] = {}
                    tmp_state["function_name"] = function_name
                    section_state = "FUNCTION_HEADER"

            elif section_state == "SCRIPT_HEADER":
                if empty_regex.match(line):
                    section_state = "SCRIPT_SOURCE"

            elif section_state == "FUNCTION_HEADER":
                if match := re.match(r"    Defined: (.*):([0-9]+)", line):
                    file_path = os.path.expanduser(match.groups()[0])
                    line_num = int(match.groups()[1])
                    function_data[tmp_state["function_name"]] = {
                        "file_path": file_path,
                        "line_num": line_num
                    }

                elif empty_regex.match(line):
                    section_state = "FUNCTION_SOURCE"

            elif section_state == "SCRIPT_SOURCE":
                if re.match(r"^count", line):
                    tmp_state["line_count"] = 0

                elif empty_regex.match(line):
                    tmp_state = {}
                    section_state = "NONE"

                else:
                    if match := re.match(r"^\s{0,4}([0-9]+)", line):
                        count = int(match.groups()[0])
                        continued_line = False
                    elif match := re.match(r"^\s+$", line):
                        # Empty String
                        count = None
                        continued_line = False
                    elif match := re.match(r'^\s+".*$', line):
                        # Comment Out
                        count = None
                        continued_line = False
                    elif match := re.match(r'^\s+endf(\s*|u.*)$', line):
                        # endfunction
                        count = None
                        continued_line = False
                    elif match := re.match(r'^\s+\\.*$', line):
                        # Line Continue
                        # Skip increment line count for function
                        continued_line = True
                    else:
                        count = 0
                        continued_line = False

                    tmp_state["line_count"] = tmp_state["line_count"] + 1

                    if "coverage" not in script_data[tmp_state["script_name"]]:
                        script_data[tmp_state["script_name"]]["coverage"] = []

                    script_data[tmp_state["script_name"]]["coverage"].append({
                        "line_num": tmp_state["line_count"],
                        "continued_line": continued_line,
                        "count": count
                    })

                    if "coverage_dict" not in script_data[tmp_state["script_name"]]:
                        script_data[tmp_state["script_name"]]["coverage_dict"] = {}

                    script_data[tmp_state["script_name"]]["coverage_dict"][tmp_state["line_count"]] = {
                        "continued_line": continued_line,
                        "count": count
                    }

            elif section_state == "FUNCTION_SOURCE":
                if re.match(r"^count", line):
                    tmp_state["line_count"] = 0
                elif empty_regex.match(line):
                    tmp_state = {}
                    section_state = "NONE"
                else:
                    if match := re.match(r"^\s{0,4}([0-9]+)", line):
                        count = int(match.groups()[0])
                    elif match := re.match(r"^\s+$", line):
                        # Empty String
                        count = None
                    elif match := re.match(r'^\s+".*$', line):
                        # Comment Out
                        count = None
                    elif match := re.match(r'^\s+endf(\s*|u.*)$', line):
                        # endfunction (not endfor)
                        count = None
                    elif match := re.match(r'^\s+\\.*$', line):
                        raise Exception("Unexpected line continue")
                    else:
                        count = 0

                    tmp_state["line_count"] = tmp_state["line_count"] + 1

                    if "coverage" not in function_data[tmp_state["function_name"]]:
                        function_data[tmp_state["function_name"]]["coverage"] = []

                    line_num = tmp_state["line_count"] + function_data[tmp_state["function_name"]]["line_num"]
                    function_data[tmp_state["function_name"]]["coverage"].append({
                        "line_num": line_num,
                        "count": count
                    })

                    if "coverage_dict" not in function_data[tmp_state["function_name"]]:
                        function_data[tmp_state["function_name"]]["coverage_dict"] = {}

                    function_data[tmp_state["function_name"]]["coverage_dict"][line_num] = count

    for f_name, function_item in function_data.items():
        script_item = script_data[function_item['file_path']]
        line_num_count = function_item["line_num"]
        for _, count in function_item['coverage_dict'].items():

            # # Skip increment for lambda function
            if not re.match(r'<lambda>.*', f_name):
                line_num_count = line_num_count + 1

            if count is not None:
                script_item['coverage_dict'][line_num_count]['count'] \
                    = script_item['coverage_dict'][line_num_count]['count'] + count

                # Check Ahead
                while script_item['coverage_dict'][line_num_count + 1]['continued_line']:
                    line_num_count = line_num_count + 1
                    script_item['coverage_dict'][line_num_count]['count'] \
                        = script_item['coverage_dict'][line_num_count]['count'] + count

    # Calcurate Summary
    lines_valid_all = 0
    lines_covered_all = 0
    lines_valid = {}
    lines_covered = {}
    for s_name, s_item in script_data.items():
        lines_covered[s_name] = 0
        lines_valid[s_name] = 0
        for s_line_num, s_cov_item in s_item['coverage_dict'].items():
            if s_cov_item['count'] is not None:
                lines_valid[s_name] = lines_valid[s_name] + 1
                lines_valid_all = lines_valid_all + 1
                if s_cov_item['count'] > 0:
                    lines_covered[s_name] = lines_covered[s_name] + 1
                    lines_covered_all = lines_covered_all + 1

    # Create Cobertura XML
    coverage = ET.Element("coverage", {
        "branch-rate": "0.0",
        "branches-covered": "0",
        "branches-valid": "0",
        "complexity": "0.0",
        "line-rate": str(lines_covered_all / lines_valid_all),
        "lines-covered": str(lines_covered_all),
        "lines-valid": str(lines_valid_all),
        "timestamp": "0",
        "version": "1.0"
    })
    sources = ET.SubElement(coverage, "sources")
    source = ET.SubElement(sources, "source")
    source.text = os.getcwd()

    packages = ET.SubElement(coverage, "packages")
    package = ET.SubElement(packages, "package", {
        "name": "vim-profile",
        "line-rate": str(lines_covered_all / lines_valid_all),
        "branch-rate": "0.0",
        "complexity": "0.0"
    })

    classes = ET.SubElement(package, "classes")

    for s_name, s_item in script_data.items():
        class_element = ET.SubElement(classes, "class", {
            "name": Path(s_name).name,
            "filename": s_name,
            "line-rate": str(lines_covered[s_name] / lines_valid[s_name]),
            "branch-rate": "0.0",
            "complexity": "0.0"
        })

        lines_element = ET.SubElement(class_element, "lines")

        for s_line_num, s_cov_item in s_item['coverage_dict'].items():
            if s_cov_item['count'] is not None:
                ET.SubElement(lines_element, "line", {
                    "number": str(s_line_num),
                    "hits": str(s_cov_item['count'])
                })

    cobertura_xml = minidom.parseString(ET.tostring(coverage)).toprettyxml(indent="  ")

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(cobertura_xml)

    print(f"Cobertura XML written to {output_path}")


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Generate Cobetura XML from vim profile log")

    parser.add_argument('-i', '--input', help="Profile log path. Default: ./profile.log", default="./profile.log")
    parser.add_argument('-o', '--output', help="Ouput xml path. Default: ./coverage.xml", default="./coverage.xml")

    args = parser.parse_args()

    main(args.input, args.output)
