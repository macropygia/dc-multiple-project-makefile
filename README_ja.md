# dc-multiple-project-makefile

複数のdocker-composeプロジェクトをディレクトリ構造を元に操作するMakefile。

## ファイルツリー

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

## 使用法

```bash
$ make [dirname|alias|preset]... [command]
```

または

```bash
$ make [command]
```

## コマンド

### ディレクトリ名・エイリアス・プリセットと共に使用

- `up`, `build`, `pull`, `down`, `start`, `stop`, `restart`, `pause`, `unpause`, `ps`, `top`
    - 対応するdocker-composeコマンドを実行する
    - `up` は `up -d` を実行する
- `do cmd="[any docker-compose command]"`
    - 任意のdocker-composeコマンドを実行する
- `info`
    - ディレクトリ名と説明を表示する

### 単独で使用

- `active`
    - `$ make all ps | grep Up` と同じ
    - 全てのプロジェクトに対して `ps` を行うためプロジェクトの数が多いと時間がかかる
- `ls`
    - 全てのプロジェクトのディレクトリ名・エイリアス・説明を表示する
- `clean`
    - `.dc_history` と `.dc_latest` を削除する

## プリセット

`preset.mk` に記述する。

```Makefile
.PHONY: preset_name
preset_name: [dirname|alias|preset]...
```

### 設定例

```Makefile
.PHONY: preset1 preset2 preset3
preset1: proj1 proj2 proj3
preset2: proj1 proj4
preset3: preset1 preset2
```

`preset3` は `proj1 proj2 proj3 proj4` として動作する。

### ビルトインプリセット

- `all`
    - 全てのプロジェクト
- `latest`
    - 最後に実行したプロジェクト（ `.dc_latest` の内容）

## 関連ファイル

### `./*/docker-compose.yml`

`docker-compose.yml` の存在する子ディレクトリがプロジェクトとして認識される。

### `./*/.env`

`COMPOSE_PROJECT_NAME` でプロジェクト名を指定しておくことを強く推奨する。

### `./*/DESCRIPTION`

`ls` などのコマンドで表示されるプロジェクトの簡単な説明。1行のプレーンテキスト。（任意）

### `./*/ALIAS`

プロジェクト名（ディレクトリ名）の代わりに使用できる短い名前。1行のプレーンテキスト。（任意）

### `./preset.mk`

プリセット定義用。（任意）

### `./.dc_latest`

実行したプロジェクトが記録される一時ファイル。

### `./.dc_history`

実行したcomposeコマンドのログ。（ `ps` と `top` を除く）
