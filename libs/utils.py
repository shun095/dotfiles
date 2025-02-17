import os
import re
from packaging.version import Version

VERSION = "0.2.0"


def get_version():
    return VERSION


def get_deployed_version():
    MYDOTFILES = os.environ.get("MYDOTFILES")
    with open(MYDOTFILES + '/deployed-version.txt', 'r', encoding='utf-8') as file:
        lines = file.readlines()
        return [line.strip() for line in lines][0]


def is_newer_than(version_a: str, version_b: str) -> bool:
    return Version(version_a) > Version(version_b)


def is_newer_or_equal(version_a: str, version_b: str) -> bool:
    return Version(version_a) >= Version(version_b)


def is_older_than(version_a: str, version_b: str) -> bool:
    return Version(version_a) < Version(version_b)


def is_older_or_equal(version_a: str, version_b: str) -> bool:
    return Version(version_a) <= Version(version_b)


def get_patch_files():
    patch_dir = "patches"
    patch_files = []
    pattern = re.compile(r"(\d+\.\d+\.\d+)\.py$")  # 例: 0.1.1.py

    for file in os.listdir(patch_dir):
        match = pattern.match(file)
        if match:
            patch_version = match.group(1)
            if is_newer_than(patch_version, get_deployed_version()) \
                    and is_older_or_equal(patch_version, get_version()):
                patch_files.append(os.path.join(patch_dir, file))

    # バージョン順にソート
    patch_files.sort()
    return patch_files
