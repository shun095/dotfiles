#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2017 isitaku5522 <ishitaku5522@gmail.com>
#
# Distributed under terms of the MIT license.

"""

"""
def FlagsForFile( filename, **kwargs ):
    return { 'flags': [
                '-x',
                'c++',
                '-Wall',
                '-Wextra',
                '-Werror',
                '-I',
                './'
                ], }
