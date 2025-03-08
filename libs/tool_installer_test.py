from . import tool_installer
from pyfakefs import fake_filesystem_unittest

# apt, brew, scoop, dnfなどを使ってソフトウェアをインストールする
# - 適切なパッケージマネージャを選ぶ
# - パッケージマネージャで入れたいコマンドに対応するパッケージを探す

class Test_get_deployed_version(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_(self):
       tool_installer.install 
