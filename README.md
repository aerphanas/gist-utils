# Gist utils

[![Build-Test](https://github.com/aerphanas/gist-utils/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/aerphanas/gist-utils/actions/workflows/main.yml)  
gist on terminal

## feature

- get github gist list
- create github gist (github token set GITHUB_GIST_TOKEN env)

## compile

``` sh
nimble build
```

## run

```sh
 ./gist 
Copyright (c) 2023 by aerphanas

gist [Options]

Options:
  --public:GITHUB_USERNAME      show all public github gist item
  --uname:GITHUB_USERNAME       show all github gist item (need github token)
  --create:DESCRIPTION FILENAME create github gist with description and file (need github token)
```

### list all public gist

``` sh
./gist --public:aerphanas
```

### list gist (need git token)

```sh
./gist --uname:aerphanas
```

### create new gist (need git token)

```sh
./gist --create:<description> <file>
```
