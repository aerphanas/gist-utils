import std/[ json, strutils ]

from tables import OrderedTable, keys
from httpcore import newHttpHeaders
from httpclient import newHttpClient, getContent, request, HttpPost, body
from parseopt import OptParser, initOptParser, cmdLongOption, cmdArgument, next
from os import getAppFilename, extractFilename, commandLineParams, existsEnv, getEnv

proc gGist(username: string)
proc pGist(description: string, manyFile: string)
proc gHelp()

if commandLineParams().len == 0:
  gHelp() 

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
      gHelp()
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

proc pGist(description: string, manyFile: string) =
  if not existsEnv("GITHUB_GIST_TOKEN"):
    echo "please set GITHUB_GIST_TOKEN"
    return

  const
    url: string = "https://api.github.com/gists"
    acceptHeader: tuple[key: string, val: string] = (key: "Accept", val: "application/vnd.github+json")
    apiverHeader: tuple[key: string, val: string] = (key: "X-GitHub-Api-Version", val: "2022-11-28")
  let
    authHeader:   tuple[key: string, val: string] = (key: "Authorization", val: "Bearer " & getEnv("GITHUB_GIST_TOKEN"))
    requestHeaders: array[3, tuple[key: string, val: string]] = [acceptHeader, authHeader, apiverHeader]
    content: string = readFile(manyFile)
    requestBody = %*{
      "description": description,
      "public": true,
      "files": {
        manyFile: {
          "content" : content
        }
      }
    }

  try:
    var requestJson = newHttpClient()
    requestJson.headers = newHttpHeaders(requestHeaders)

    let response = requestJson.request(url, HttpPost, $requestBody)
    echo "Github Gist created on : " & response.body.parseJson["html_url"].getStr
  except:
    echo "Connection Error"
    return

proc gHelp() =
  echo getAppFilename().extractFilename(), " --uname:<username>"
