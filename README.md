# dc-multiple-project-makefile

Makefile for handle multiple docker-compose projects based on a directory structure and some files.

![animation](https://user-images.githubusercontent.com/3162324/109684613-ca6e5680-7bc3-11eb-9837-7cf63bca2a9d.gif)

## Typical structure

```text
.
|-- Makefile
|-- preset.mk
|-- gitlab
|   |-- .env
|   |-- .desc
|   `-- docker-compose.yml
|-- pgadmin
|   |-- .env
|   |-- .alias
|   |-- .desc
|   `-- docker-compose.yml
|-- postgres
|   |-- .env
|   |-- .alias
|   |-- .desc
|   |-- docker-compose.yml
|   `-- init
|       `-- init_gitlab.sh
`-- redis
    |-- .env
    |-- .desc
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

- `up`, `upf`, `build`, `pull`, `down`, `start`, `stop`, `restart`, `pause`, `unpause`, `ps`, `logs`, `logsf`, `logs<int>`, `logsf<int>`, `top`
    - `up` executes `up -d` .
    - `upf` executes `up` .
    - `logsf` executes `logs -f` .
    - `logs<int>` executes `logs -n <int>` .
    - `logsf<int>` executes `logs -f -n <int>` .
- `do cmd="[any docker compose command]"`
- `info`
    - Show directory name and description.

### Use independently

- `active`
    - Same as `$ make all ps | grep Up`.
- `ls`
    - Show the directory name, alias, and description of all projects.
- `clean`
    - Remove `.dc_history` and `.dc_latest`.

### Tips

Targets are executed sequentially. (Ref: [GNU Make](https://www.gnu.org/software/make/))

So...

```bash
$ make proj1 down proj2 pull proj3 up
```

This works as follows:

1. Add `proj1` to the processing target
2. Execute `down` to `proj1`
3. Add `proj2` to the processing target
4. Execute `pull` to `proj1 & 2`
5. Add `proj3` to the processing target
6. Execute `up -d` to `proj1 & 2 & 3`

## Preset

Define at the `preset.mk`.

```Makefile
.PHONY: preset_name
preset_name: [dirname|alias|preset|command]...
```

### Example

```Makefile
.PHONY: preset1 preset2 preset3
preset1: proj1 proj3 proj5
preset2: proj2 proj3
preset3: preset1 preset2
```

`preset3` means `proj1 proj3 proj5 proj2`.

### Built-in preset

- `all`
    - All projects.
- `latest`
    - The project(s) that was operated last time. (Written in `.dc_latest`)

## Files

### `./*/docker-compose.yml`

The directory containing `docker-compose.yml` will detect as the docker compose project.

### `./*/.env` (Optional)

Strongly recommended setting the project name using `COMPOSE_PROJECT_NAME`.

### `./*/.desc` (Optional)

Write a short description used in `ls` and `info` commands.

### `./*/.alias` (Optional)

Write a short name that can use as an alternative to the directory name.

### `./preset.mk` (Optional)

To define presets.

### `./.dc_latest`

A temporary file to record the current project being operated.

### `./.dc_history`

Log of executed commands except for `ps` , `logs` , `logsf` and `top`.
