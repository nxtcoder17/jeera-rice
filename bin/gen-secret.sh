#!/usr/bin/env python

import secrets
import sys

print(secrets.token_urlsafe(int(sys.argv[1]) or 64))
