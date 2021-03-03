# dc-multiple-project-makefile

Makefile for handle multiple docker-compose projects based on a directory structure and some files.

![animation](https://user-images.githubusercontent.com/3162324/109684613-ca6e5680-7bc3-11eb-9837-7cf63bca2a9d.gif)

## File tree

```text
.
|-- Makefile
|-- preset.mk
|-- gitlab
|   |-- .env
|   |-- DESCRIPTION
|   `-- docker-compose.yml
|-- pgadmin
|   |-- .env
|   |-- ALIAS
|   |-- DESCRIPTION
|   `-- docker-compose.yml
|-- postgres
|   |-- .env
|   |-- ALIAS
|   |-- DESCRIPTION
|   |-- docker-compose.yml
|   `-- init
|       `-- init_gitlab.sh
`-- redis
    |-- .env
    |-- DESCRIPTION
    `-- docker-compose.yml
```

## Usage

```bash
$ make [dirname|alias|preset]... [command]
```

or

```bash
$ make [command]
```

## Commands

### Use with dirname/alias/preset

- `up`, `build`, `pull`, `down`, `start`, `stop`, `restart`, `pause`, `unpause`, `ps`, `top`
    - `up` is executed with `-d` option.
- `do cmd="[any docker-compose command]"`
- `info`
    - Show directory name and description.

#### Chain

```bash
$ make proj1 proj2 down pull up
```

as same as

```bash
$ make proj1 proj2 down
$ make proj1 proj2 pull
$ make proj1 proj2 up
```

### Use independently

- `active`
    - Same as `$ make all ps | grep Up`.
- `ls`
    - Show the directory name, alias, and description of all projects.
- `clean`
    - Remove `.dc_history` and `.dc_latest`.

## Preset

Define at the `preset.mk`.

```Makefile
.PHONY: preset_name
preset_name: [dirname|alias|preset]...
```

### Example

```Makefile
.PHONY: preset1 preset2 preset3
preset1: proj1 proj2 proj3
preset2: proj1 proj4
preset3: preset1 preset2
```

`preset3` means `proj1 proj2 proj3 proj4`.

### Built in preset

- `all`
    - All projects.
- `latest`
    - The project(s) that was operated last time. (Written in `.dc_latest`)

## Files

### `./*/docker-compose.yml`

The directory containing this file will be recognized as the project.

### `./*/.env` (Optional)

Strongly recommended to set the project name using `COMPOSE_PROJECT_NAME`.

### `./*/DESCRIPTION` (Optional)

A short text used in `ls` and `info` command.

### `./*/ALIAS` (Optional)

A short name that can be used as a directory name.

### `./preset.mk` (Optional)

To define presets.

### `./.dc_latest`

A temporary file to record the current project being operated.

### `./.dc_history`

Log of executed commands except `ps` and `top`.
