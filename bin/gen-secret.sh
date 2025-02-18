#!/usr/bin/env python

import secrets
import sys
import string

l = 64 if len(sys.argv) == 1 else int(sys.argv[1])

alphabet = (
    string.ascii_letters
    + string.digits
    + "".join([x for x in string.punctuation if x not in "'\"`"])
)

password = "".join(secrets.choice(alphabet) for i in range(l))

print(password, end='')
