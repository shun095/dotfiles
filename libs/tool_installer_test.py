from pyfakefs import fake_filesystem_unittest
import unittest
import os
from libs.tool_installer import ToolInstaller

class Test_get_deployed_version(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

class TestToolInstaller(unittest.TestCase):

    def test_select_package_manager_darwin(self):
        with self.assertRaises(ValueError):
            ToolInstaller.select_package_manager()
        self.mock_os_uname = self.mock.create_attribute(os, 'uname', return_value=(None, 'Darwin', '19', '', ''))
        self.assertEqual(ToolInstaller.select_package_manager(), 'brew')

    def test_select_package_manager_linux(self):
        with self.assertRaises(ValueError):
            ToolInstaller.select_package_manager()
        self.mock_os_uname = self.mock.create_attribute(os, 'uname', return_value=(None, 'Linux', '5', '', ''))
        self.assertEqual(ToolInstaller.select_package_manager(), 'apt-get')

    def test_select_package_manager_windows(self):
        with self.assertRaises(ValueError):
            ToolInstaller.select_package_manager()
        self.mock_os_uname = self.mock.create_attribute(os, 'uname', return_value=(None, 'NT', '10', '', ''))
        self.assertEqual(ToolInstaller.select_package_manager(), 'winget')

    def test_select_package_manager_unsupported(self):
        with self.assertRaises(ValueError):
            ToolInstaller.select_package_manager()
        self.mock_os_uname = self.mock.create_attribute(os, 'uname', return_value=(None, 'Unknown', '1', '', ''))
        with self.assertRaises(ValueError):
            ToolInstaller.select_package_manager()

if __name__ == '__main__':
    unittest.main()
