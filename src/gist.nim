import gist/services

from parseopt import OptParser, initOptParser, cmdLongOption, cmdArgument, next
from os import commandLineParams

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
      state = true
    else:
      break
  of cmdArgument:
    if state:
      files = parser.key
  else:
    break

case option:
of 'g':
  gGist(uname)
of 'c':
  pGist(descriptions, files)
else:
  gHelp()
