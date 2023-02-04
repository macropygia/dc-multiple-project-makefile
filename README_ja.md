# dc-multiple-project-makefile

複数のdocker-composeプロジェクトをディレクトリ構造を元に操作するMakefile。

![animation](https://user-images.githubusercontent.com/3162324/109684613-ca6e5680-7bc3-11eb-9837-7cf63bca2a9d.gif)

## ファイルツリー

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

## 使用法

```bash
$ make [dirname|alias|preset]... [command]
```

または

```bash
$ make [command]
```

## コマンド

### ディレクトリ名・エイリアス・プリセットと共に使用するコマンド

- `up`, `upf`, `build`, `pull`, `down`, `start`, `stop`, `restart`, `pause`, `unpause`, `ps`, `logs`, `logsf`, `logs<int>`, `logsf<int>`, `top`
    - 対応するdocker-composeコマンドを実行する
    - `up` は `up -d` を実行する
    - `upf` は `up` を実行する
    - `logsf` は `logs -f` を実行する
    - `logs<int>` は `logs -n <int>` を実行する
    - `logsf<int>` は `logs -f -n <int>` を実行する
- `do cmd="[any docker-compose command]"`
    - 任意のdocker-composeコマンドを実行する
- `info`
    - ディレクトリ名・エイリアス・説明を表示する

### 単独で使用するコマンド

- `active`
    - `$ make all ps | grep Up` と同じ
    - 全てのプロジェクトに対して `ps` を行うためプロジェクトの数が多いと時間がかかる
- `ls`
    - 全てのプロジェクトのディレクトリ名・エイリアス・説明を表示する
- `clean`
    - `.dc_history` と `.dc_latest` を削除する

### Tips

処理対象の追加もコマンドも実体はmakeのターゲットであり、順次実行される。

```bash
$ make proj1 down proj2 pull proj3 up
```

例えばこれは以下のように動作する。

1. 処理対象に `proj1` を追加
2. 処理対象に `down` を実行（対象はproj1）
3. 処理対象に `proj2` を追加
4. 処理対象に `pull` を実行（対象はproj1,2）
5. 処理対象に `proj3` を追加
6. 処理対象に `up -d` を実行（対象はproj1,2,3）

## プリセット

`preset.mk` に記述する。動作に支障がなければ `.PHONY` は書かなくても構わない。

```Makefile
.PHONY: preset_name
preset_name: [dirname|alias|preset|command]...
```

### 設定例

```Makefile
.PHONY: preset1 preset2 preset3
preset1: proj1 proj3 proj5
preset2: proj2 proj3
preset3: preset1 preset2
```

`preset3` は `proj1 proj3 proj5 proj2` として動作する。

### ビルトインプリセット

- `all`
    - 全てのプロジェクト
- `latest`
    - 最後に実行したプロジェクト（ `.dc_latest` の内容）

## 関連ファイル

### `./*/docker-compose.yml`

`docker-compose.yml` の存在するサブディレクトリがdocker-composeプロジェクトとして認識される。

### `./*/.env`

`COMPOSE_PROJECT_NAME` でプロジェクト名を指定しておくことを強く推奨する。

### `./*/.desc`

`ls` などのコマンドで表示されるプロジェクトの簡単な説明。1行のプレーンテキスト。（任意）

### `./*/.alias`

プロジェクト名（ディレクトリ名）の代わりに使用できる短い名前。1行のプレーンテキスト。（任意）

### `./preset.mk`

プリセット定義用。（任意）

### `./.dc_latest`

実行したプロジェクトが記録される一時ファイル。

### `./.dc_history`

実行したcomposeコマンドのログ。（ `ps` と `top` を除く）
