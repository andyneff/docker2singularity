#!/usr/bin/env python3

import subprocess
import sys
import json

pid = subprocess.Popen(['docker', 'inspect',
                        '--format={{json .ContainerConfig.Env}}',
                        sys.argv[1]], stdout=subprocess.PIPE)
env = json.loads(pid.communicate()[0])

# This works for ASCII codes 0x01 through 0x0f, 0x10-0x7f, and unicode.
# Did not test anything else.
# Tested on alpine sh 1.30.1, macos bash 3.2, fedora bash 5.0, and dash 0.5.7
#   Special chars will not work on debian 6 dash (0.5.1), since that version of dash
#     doesn't support the $'' notation, but that is too old to care
# docker build --build-arg $'ARG_HARD=f\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0fo\bo\t\nb"a'"'"'r'"😺 😸 😹 😻 😼 😽 🙀 😿 😾"

for e in env:
  key,value = e.split('=', 1)
  # Python repr is almost identical to bash's $'' notation
  value_repr = repr(value)
  # Check to see if special chars are escaped, if so
  if "'" + value + "'" != value_repr:
    # Everything is in bash (including " not being escaped), except how ' are escaped
    value = '$' + value_repr.replace('\\\'', '\'"\'"$\'')
  else:
    value = "'" + value.replace('\\\'', '\'"\'"\'') + "'"

  print('export {}={}'.format(key, value))