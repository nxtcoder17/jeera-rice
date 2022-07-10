#!/usr/bin/env python

import pyperclip
import secrets
import sys

pyperclip.copy(secrets.token_urlsafe(int(sys.argv[1]) or 64))
