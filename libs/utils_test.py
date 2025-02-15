import os
import pytest
from pyfakefs.fake_filesystem_unittest import TestCase

from . import utils

class TestWithPyFakeFs(TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_get_deployed_version(self):
        MYDOTFILES = os.environ.get("MYDOTFILES")
        file_path = MYDOTFILES + "/deployed-version.txt"
        self.fs.create_file(file_path, contents="0.2.0\n")

        assert utils.get_deployed_version() == "0.2.0"


if __name__ == "__main__":
    pytest.main()
