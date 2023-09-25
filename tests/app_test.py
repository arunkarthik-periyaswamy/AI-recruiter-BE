"""
File help yto write the unit test case
"""

import unittest
from app import create_app


class BasicTests(unittest.TestCase):

    def setUp(self):
        self.app = create_app('config.TestingConfig')
        self.app_context = self.app.app_context()
        self.app_context.push()
        self.client = self.app.test_client()

    def tearDown(self):
        pass

    # TODO: write test scripts below


if __name__ == "__main__":
    unittest.main()
