#!/usr/bin/env python

import pyperclip
import secrets

pyperclip.copy(secrets.token_urlsafe(64))
