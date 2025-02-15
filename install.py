#!/usr/bin/env python3

import argparse
import os
from libs import utils

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def main():
    utils.get_deployed_version()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='dotfiles installer')

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("install", help="Install the application")
    subparsers.add_parser("uninstall", help="Uninstall the application")
    subparsers.add_parser("update", help="Update the application")
    main()
