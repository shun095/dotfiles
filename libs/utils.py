import os

def get_deployed_version():
    MYDOTFILES = os.environ.get("MYDOTFILES")
    with open(MYDOTFILES + '/deployed-version.txt', 'r', encoding='utf-8') as file:
        lines = file.readlines()
        return [line.strip() for line in lines][0]
