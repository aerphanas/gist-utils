# Gist utils

[![asciicast](https://asciinema.org/a/k28htZzmKwBQx7CAd0l99tyuC.svg)](https://asciinema.org/a/k28htZzmKwBQx7CAd0l99tyuC)

gist on terminal

## feature

- get github gist list
- create github gist (need github token set to GITHUB_GIST_TOKEN env)

## compile

``` sh
nimble -d:ssl -d:release build
```

## run

### list all public gist
``` sh
./gist --uname:aerphanas
```

### create new gist
```sh
export GITHUB_GIST_TOKEN=<your token>
./gist --create:<description> <file>
```
