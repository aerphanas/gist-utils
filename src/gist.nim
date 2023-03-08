import std/[ httpclient, json, tables, os ]

proc gGist(username: string)
proc gHelp()


# main section
let input: seq[string] = commandLineParams()

if input.len == 0:
  gHelp()
else:
  echo input


proc gGist(username: string) =
  let  url: string = "https://api.github.com/users/" & username & "/gists"
  var  responseBody: string

  try:
    responseBody = newHttpClient().getContent(url)
  except:
    echo "Connection Error"

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
      echo " - public   :\t", jsons["public"].getBool

      stdout.write " - file     :\t"
      for i in jsKey.keys: stdout.write i, " "

      echo "\n"
  except:
    echo "NULL"

proc gHelp() =
  echo getAppFilename().extractFilename(), " -g/--get:<username>"
