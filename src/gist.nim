import gist/services

from parseopt import OptParser, initOptParser, cmdLongOption, cmdArgument, next
from os import commandLineParams, existsEnv

let input: seq[string] = commandLineParams()
var
  parser: OptParser = initOptParser(input)
  uname: string
  descriptions: string
  files: string
  state: bool
  option: char

# Option Parser
while true:
  parser.next
  case parser.kind:
  of cmdLongOption:
    if parser.key == "uname" and parser.val != "":
      option = 'g'
      uname = parser.val
    elif parser.key == "create" and parser.val != "":
      option = 'c'
      descriptions = parser.val
      state = true # for file
    elif parser.key == "public" and parser.val != "":
      option = 'p'
      uname = parser.val
    else:
      break
  of cmdArgument:
    if state:
      files = parser.key
  else:
    break

case option:
of 'g':
  if not existsEnv("GITHUB_GIST_TOKEN"):
    echo "please set GITHUB_GIST_TOKEN"
  else:
    gGist(uname)
of 'c':
  if not existsEnv("GITHUB_GIST_TOKEN"):
    echo "please set GITHUB_GIST_TOKEN"
  else:
    pGist(descriptions, files)
of 'p':
  pgGist(uname)
else:
  gHelp()
