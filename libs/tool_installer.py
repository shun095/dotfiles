import os

class ToolInstaller:
    @staticmethod
    def select_package_manager():
        if os.name == 'posix' and 'darwin' in os.uname().sysname.lower():
            return 'brew'
        elif os.name == 'posix':
            return 'apt-get'
        elif os.name == 'nt':
            return 'winget'
        else:
            raise ValueError("Unsupported operating system")

