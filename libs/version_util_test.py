import os
import pytest
import unittest
from pyfakefs import fake_filesystem_unittest
from pyfakefs.fake_filesystem_unittest import (
    PatchMode,
)

from . import version_util


class Test_get_deployed_version(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_バージョンのテキストファイルを読み込み改行などをトリムする(self):
        self.fs.create_file(version_util.get_abs_path("deployed-version.txt"), contents="0.2.0\n")
        assert version_util.get_deployed_version() == "0.2.0"


class Test_is_newer_than(unittest.TestCase):
    def test_引数に0_2_0と0_1_0が渡されるとTrueを返す(self):
        assert version_util.is_newer_than("0.2.0", "0.1.0") is True

    def test_引数に1_0_0と0_2_0が渡されるとTrueを返す_バージョンの桁が違う場合(self):
        assert version_util.is_newer_than("1.0.0", "0.2.0") is True

    def test_引数に0_1_0と0_1_0が渡されるとFalseを返す_バージョンが同じ場合(self):
        assert version_util.is_newer_than("0.1.0", "0.1.0") is False

    def test_引数に0_1_0と0_2_0が渡されるとFalseを返す(self):
        assert version_util.is_newer_than("0.1.0", "0.2.0") is False

    def test_引数に0_12_0と0_2_0が渡されるとTrueを返す_バージョンが2桁の場合(self):
        assert version_util.is_newer_than("0.12.0", "0.2.0") is True

    def test_引数に2_0と2_0_0が渡されるとFalseを返す_バージョンの桁数が違う場合(self):
        assert version_util.is_newer_than("2.0", "2.0.0") is False


class Test_is_newer_or_equal(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとFalseを返す(self):
        assert version_util.is_newer_or_equal("0.1.0", "0.2.0") is False

    def test_引数に0_2_0と0_2_0が渡されるとTrueを返す(self):
        assert version_util.is_newer_or_equal("0.2.0", "0.2.0") is True

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert version_util.is_newer_or_equal("0.2.0", "0.1.0") is True


class Test_is_older_than(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとTrueを返す(self):
        assert version_util.is_older_than("0.1.0", "0.2.0") is True

    def test_引数に0_2_0と0_2_0が渡されるとFalseを返す(self):
        assert version_util.is_older_than("0.2.0", "0.2.0") is False

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert version_util.is_older_than("0.2.0", "0.1.0") is False


class Test_is_older_or_equal(unittest.TestCase):
    def test_引数に0_1_0と0_2_0が渡されるとTrueを返す(self):
        assert version_util.is_older_or_equal("0.1.0", "0.2.0") is True

    def test_引数に0_2_0と0_2_0が渡されるとTrueを返す(self):
        assert version_util.is_older_or_equal("0.2.0", "0.2.0") is True

    def test_引数に0_2_0と0_1_0が渡されるとFalseを返す(self):
        assert version_util.is_older_or_equal("0.2.0", "0.1.0") is False


class Test_get_patch_files(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_デプロイされたバージョンより新しくかつ現在のバージョンまでのパッチ用pythonスクリプトの一覧を返す(self):
        self.fs.create_file(version_util.get_abs_path("deployed-version.txt"), contents="0.1.0\n")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_0.py"),
                            contents="def hello():\n    print(\"0.1.0\")")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_2.py"),
                            contents="def hello():\n    print(\"0.1.2\")")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_0.py"),
                            contents="def hello():\n    print(\"0.2.0\")")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_1.py"),
                            contents="def hello():\n    print(\"0.2.1\")")
        assert version_util.get_patch_files() \
            == [version_util.get_abs_path("libs/patches/patch_0_1_2.py"),
                version_util.get_abs_path("libs/patches/patch_0_2_0.py")]


class Test_get_patch_files_nonfakefs(unittest.TestCase):
    def test_デプロイされたバージョンより新しくかつ現在のバージョンまでのパッチ用pythonスクリプトの一覧を返す(self):
        assert version_util.get_patch_files() == [version_util.get_abs_path("libs/patches/patch_0_2_0.py")]


class Test_import_and_run_modules(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs(patch_open_code=PatchMode.ON)

    def test_一覧化されたpythonスクリプトをインポートして実行する(self):
        self.fs.create_file(version_util.get_abs_path("deployed-version.txt"), contents="0.1.0\n")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_0.py"),
                            contents="def hello():\n    return \"0.1.0\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_2.py"),
                            contents="def hello():\n    return \"0.1.2\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_0.py"),
                            contents="def hello():\n    return \"0.2.0\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_1.py"),
                            contents="def hello():\n    return \"0.2.1\"")

        assert version_util.import_and_run_modules(version_util.get_patch_files(), "hello") == ["0.1.2", "0.2.0"]

    def test_存在しないメソッドを指定したときは例外を送出する(self):
        self.fs.create_file(version_util.get_abs_path("deployed-version.txt"), contents="0.1.0\n")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_0.py"),
                            contents="def hello():\n    return \"0.1.0\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_1_2.py"),
                            contents="def hello():\n    return \"0.1.2\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_0.py"),
                            contents="def hello():\n    return \"0.2.0\"")
        self.fs.create_file(version_util.get_abs_path("libs/patches/patch_0_2_1.py"),
                            contents="def hello():\n    return \"0.2.1\"")

        with pytest.raises(Exception) as e:
            version_util.import_and_run_modules(version_util.get_patch_files(), "world")

        path = version_util.get_abs_path("libs/patches/patch_0_1_2.py")
        assert str(e.value) == f"Method 'world' not found in {path}."


class Test_get_abs_path(unittest.TestCase):
    def test_与えられたMYDOTFILESからの相対パスを絶対パスにして返す(self):
        assert version_util.get_abs_path("files/files/files") == os.environ.get("MYDOTFILES") + "/files/files/files"


if __name__ == "__main__":
    pytest.main()
