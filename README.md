# Streak

Streak is a utility tool for directly uploading local images to AstroStreaknet.

## Usage

### Available Commands

- **upload:** Upload local images to the AstroStreaknet database. This command allows you to select images, edit metadata, and specify upload options.
  <br>commands: `streak upload`, `streak u`, `streaku`
- **account:** Manage your AstroStreaknet account. This command allows you to log in, log out, and view account information.
  <br>Commands: `streak account`, `streak a`
- **debug:** Get detailed information about warnings or error codes. This command helps you troubleshoot issues with the tool.
  <br>Commands: `streak debug`, `streak x`, `streak whatis`
- **help:** Show help information for a command. This command provides detailed information about each command and its options.
  <br>Commands: `streak help`, `streak h`, `streak --help`, `streak -h`

#### \* `streaku` command could be used as an alias for `streak upload`.


### Working Overview:

- Selecting the images you wish to upload would be parsed.
- A template toml file would be generated, prefilled with all relevant information it could read from the files.
- The information could be edited, either for each file individually, or as a common constant for all files.
- You can specify whether the files should be uploaded as public or private.
- You can specify whether the files can be used for AI training.

### Examples Usecase:

#### 1. Upload all images saved at `~/Pictures/saves`.
```sh
$ streak upload ~/Pictures/saves/*
```

#### 2. Upload all images saved at `~/Pictures/saves` with blue FILTER and FOCALLEN in the range 2000-3000
```sh
$ streak upload find ~/Pictures/saves/* filter blue focallen -gt 2000 -lt 3000
```
PS: Results can be further narrowed down using the [fzf](https://github.com/junegunn/fzf) 
fuzzy-finder with the syntax:<br> `$ streak upload find fzf [PATH] [CONDITIONS....]`

#### 3. Login into your AstroStreaknet account
```sh
$ streak account login
```

#### 4. Get overview, syntax, and examples for find command
```sh
$ streak upload help
```

#### 5. Get more information error code 400 error code, with ways to possibly resolve them
```sh
$ streak debug 400
```


## Troubleshooting
If you encounter any issues with the tool, you can use the streak debug command to get more information. You can also report bugs or submit pull requests on our GitHub page.


## License
The Streak tool is released under the [Apache2](./LICENSE) License.

