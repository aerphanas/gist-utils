import std/json

from HttpClient import newHttpClient, getContent
from os import getAppFilename, extractFilename, commandLineParams
from parseopt import OptParser, initOptParser, cmdLongOption, next
from tables import OrderedTable, keys

proc gGist(username: string)
proc gHelp()

let input: seq[string] = commandLineParams()

if input.len == 0:
  gHelp()

var parser: OptParser = initOptParser(input)
while true:
  parser.next
  case parser.kind:
  of cmdLongOption:
    if parser.key == "uname" and parser.val != "":
        gGist(parser.val)
    else:
      gHelp()
      break
  else:
    break

# show all github gist
proc gGist(username: string) =
  let  url: string = "https://api.github.com/users/" & username & "/gists"
  var  responseBody: string

  try:
    responseBody = newHttpClient().getContent(url)
  except:
    echo "Connection Error"
    return

  let
    responseJson: JsonNode = responseBody.parseJson
    responseLength: int = responseJson.len

  try:
    # Printing all key that important
    for i in 0 .. responseLength - 1 :
      let
        jsons: JsonNode = responseJson[i]
        jsKey: OrderedTable[string, JsonNode] = jsons["files"].getFields

      echo "description :\t", jsons["description"].getStr
      echo " - url      :\t", jsons["html_url"].getStr
      echo " - created  :\t", jsons["created_at"].getStr
      echo " - updated  :\t", jsons["updated_at"].getStr

      stdout.write " - file     :\t"
      for i in jsKey.keys: stdout.write i, " "

      echo "\n"
  except:
    echo "NULL"
    return

proc gHelp() =
  echo getAppFilename().extractFilename(), " --uname:<username>"
