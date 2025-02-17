import os
import pytest
import unittest
from pyfakefs import fake_filesystem_unittest

from . import utils


class Test_get_deployed_version(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_バージョンのテキストファイルを読み込み改行などをトリムする(self):
        MYDOTFILES = os.environ.get("MYDOTFILES")
        self.fs.create_file(MYDOTFILES + "/deployed-version.txt", contents="0.2.0\n")

        assert utils.get_deployed_version() == "0.2.0"


class Test_is_newer_than(unittest.TestCase):
    def test_引数に0_2_0と0_1_0が渡されるとTrueを返す(self):
        assert utils.is_newer_than("0.2.0", "0.1.0") is True

    def test_引数に1_0_0と0_2_0が渡されるとTrueを返す_バージョンの桁が違う場合(self):
        assert utils.is_newer_than("1.0.0", "0.2.0") is True

    def test_引数に0_1_0と0_1_0が渡されるとFalseを返す_バージョンが同じ場合(self):
        assert utils.is_newer_than("0.1.0", "0.1.0") is False

    def test_引数に0_1_0と0_2_0が渡されるとFalseを返す(self):
        assert utils.is_newer_than("0.1.0", "0.2.0") is False

    def test_引数に0_12_0と0_2_0が渡されるとTrueを返す_バージョンが2桁の場合(self):
        assert utils.is_newer_than("0.12.0", "0.2.0") is True

    def test_引数に2_0と2_0_0が渡されるとFalseを返す_バージョンの桁数が違う場合(self):
        assert utils.is_newer_than("2.0", "2.0.0") is False


class Test_is_newer_or_equal(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとFalseを返す(self):
        assert utils.is_newer_or_equal("0.1.0", "0.2.0") is False

    def test_引数に0_2_0と0_2_0が渡されるとTrueを返す(self):
        assert utils.is_newer_or_equal("0.2.0", "0.2.0") is True

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert utils.is_newer_or_equal("0.2.0", "0.1.0") is True


class Test_is_older_than(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとTrueを返す(self):
        assert utils.is_older_than("0.1.0", "0.2.0") is True

    def test_引数に0_2_0と0_2_0が渡されるとFalseを返す(self):
        assert utils.is_older_than("0.2.0", "0.2.0") is False

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert utils.is_older_than("0.2.0", "0.1.0") is False


class Test_is_older_or_equal(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとTrueを返す(self):
        assert utils.is_older_or_equal("0.1.0", "0.2.0") is True

    def test_引数に0_2_0と0_2_0が渡されるとTrueを返す(self):
        assert utils.is_older_or_equal("0.2.0", "0.2.0") is True

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert utils.is_older_or_equal("0.2.0", "0.1.0") is False


class Test_get_patch_files(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_デプロイされたバージョンより新しくかつ現在のバージョンまでのパッチ用pythonスクリプトの一覧を返す(self):
        MYDOTFILES = os.environ.get("MYDOTFILES")

        self.fs.create_file(MYDOTFILES + "/deployed-version.txt", contents="0.1.0\n")
        self.fs.create_file("patches/0.1.0.py", contents="")
        self.fs.create_file("patches/0.1.2.py", contents="")
        self.fs.create_file("patches/0.2.0.py", contents="")
        self.fs.create_file("patches/0.2.1.py", contents="")

        assert utils.get_patch_files() == ["patches/0.1.2.py", "patches/0.2.0.py"]


if __name__ == "__main__":
    pytest.main()
