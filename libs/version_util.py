import os
import re
import pkgutil
import importlib
from packaging.version import Version

VERSION = "0.2.0"


def get_version():
    return VERSION


def get_abs_path(relative_path):
    script_dir = os.path.dirname(os.path.realpath(__file__))
    return os.path.abspath(os.path.join(script_dir, "..", relative_path))


def get_deployed_version():
    with open(get_abs_path('deployed-version.txt'), 'r', encoding='utf-8') as file:
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


def import_and_run_modules(module_files, method_name, args=None):
    for module_file in module_files:
        spec = importlib.util.spec_from_file_location("module", module_file)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)

        result = []

        if hasattr(module, method_name):
            method = getattr(module, method_name)
            if callable(method):
                if args is not None:
                    result.append(method(args))
                else:
                    result.append(method())
                return result

        raise Exception(f"Method '{method_name}' not found in {module_file}.")



def get_patch_files():
    patch_dir = get_abs_path("libs/patches")
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


def apply_patchs():
    patch_files = get_patch_files()
