import std/json

from httpcore import newHttpHeaders
from tables import OrderedTable, keys
from httpclient import HttpPost, HttpClient, newHttpClient, getContent, request, body
from os import getAppFilename, extractFilename, existsEnv, getEnv

const
  pUrl: string = "https://api.github.com/gists"
  acceptHeader: tuple[key: string, val: string] = (key: "Accept", val: "application/vnd.github+json")
  apiverHeader: tuple[key: string, val: string] = (key: "X-GitHub-Api-Version", val: "2022-11-28")

let
  authHeader:   tuple[key: string, val: string] = (key: "Authorization", val: "Bearer " & getEnv("GITHUB_GIST_TOKEN"))
  requestHeaders: array[3, tuple[key: string, val: string]] = [acceptHeader, authHeader, apiverHeader]

# GET Public Gist
proc pgGist*(username: string) =
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

      echo "description : ", jsons["description"].getStr
      echo " - web url  : ", jsons["html_url"].getStr
      echo " - git url  : ", jsons["git_pull_url"].getStr
      echo " - created  : ", jsons["created_at"].getStr
      echo " - updated  : ", jsons["updated_at"].getStr

      stdout.write " - file     : "
      for i in jsKey.keys: stdout.write i, " "

      echo "\n"
  except:
    echo "NULL"
    return

# GET Private Gist
proc gGist*(username: string) =
  var responseBody: string
  var connection = newHttpClient()
  connection.headers = newHttpHeaders(requestHeaders)

  try:
    responseBody = connection.getContent(pUrl)
  except:
    echo "Connection Error : Please check your connection"
    return

  let
    responseJson: JsonNode = responseBody.parseJson
    responseLength: int = responseJson.len

  try:
    for i in 0 .. responseLength - 1 :
      let
        jsons: JsonNode = responseJson[i]
        jsKey: OrderedTable[string, JsonNode] = jsons["files"].getFields

      echo "description   : ", jsons["description"].getStr
      echo " - visibility : ", if jsons["public"].getBool: "public" else: "private"
      echo " - web url    : ", jsons["html_url"].getStr
      echo " - git url    : ", jsons["git_pull_url"].getStr
      echo " - created    : ", jsons["created_at"].getStr
      echo " - updated    : ", jsons["updated_at"].getStr

      stdout.write " - file       :\t"
      for i in jsKey.keys: stdout.write i, " "

      echo "\n"
  except:
    echo "NULL"
    return

# POST Gist
proc pGist*(description: string, manyFile: string) =
  let
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
    var requestJson: HttpClient = newHttpClient()
    requestJson.headers = newHttpHeaders(requestHeaders)

    let response = requestJson.request(pUrl, HttpPost, $requestBody)
    echo "Github Gist : " & response.body.parseJson["html_url"].getStr
    echo "git url     : " & response.body.parseJson["git_pull_url"].getStr
  except:
    echo "Connection Error : Please check your connection"
    return

# Hellp Message
proc gHelp*() =
  echo "Copyright (c) 2023 by aerphanas\n"
  echo getAppFilename().extractFilename(), " [Options]"
  echo "\nOptions:"
  echo "\t--uname:GITHUB_USERNAME", "\t\tshow all public github gist item"
  echo "\t--create:DESCRIPTION FILENAME", "\tcreate github gist with description and file"
