# Roo Excel parser plugin for Embulk

Read Microsoft Excel(xlsx) files from input plugins.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **skip_header_lines**: Skip this number of lines first. Set 1 if the file has header line. (integer, default: 0)
- **sheet**: the name of sheet (string, default: null (first sheet))

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: roo-excel
    skip_header_lines: 1 # first row is header.
    sheet: "beatles"

```

(If guess supported) you don't have to write `parser:` section in the configuration file. After writing `in:` section, you can let embulk guess `parser:` section using this command:

```
$ embulk gem install embulk-parser-roo-excel
$ embulk guess -g roo-excel config.yml -o guessed.yml
```

## Build

```
$ rake
```
