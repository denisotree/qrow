# qrow

<div align="center">

[![CI](https://github.com/denisotree/qrow/actions/workflows/ci.yml/badge.svg)](https://github.com/denisotree/qrow/actions/workflows/ci.yml)
[![crates.io](https://img.shields.io/crates/v/qrow.svg)](https://crates.io/crates/qrow)
[![docs.rs](https://img.shields.io/docsrs/qrow)](https://docs.rs/qrow)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/denisotree/qrow/blob/master/LICENSE)

**Query rows in tables, documents and databases — from the terminal or through an AI assistant.**

Open **CSV · JSON · YAML · TOML · Parquet · Excel · SQLite · DuckDB** straight from your shell —
filter, sort, pivot, join, compute columns, and chart distributions without
leaving the terminal.

![qrow demo — open, sort, chart, describe](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/demo.gif)

</div>

> **qrow was called tuitab until 0.12.0.** Coming from it? See
> [Coming from tuitab](#coming-from-tuitab).

```sh
qrow data.csv                   # open a file
qrow config.toml                # JSON / YAML / TOML open as a browsable tree
qrow deploy.conf                # unknown extension? the contents decide
qrow -t yaml weird.dat          # or force a format outright
qrow orders.csv customers.csv   # browse several files as a list
cat data.csv | qrow -t csv      # read from a pipe
```

> **New to qrow?** Jump to the [Quick start](#quick-start), or read the full
> [**Documentation**](#documentation) — available in **English** and **Русский**.

---

## Highlights

- **Tabular and structured formats** — CSV (auto-delimiter), TSV, JSON, JSONL/NDJSON,
  YAML, TOML, Parquet, Arrow/Feather, Excel (xlsx/xls), SQLite, DuckDB, and Markdown
  with frontmatter. Databases are recognised by their header, whatever the file is
  called. Browse a whole directory, or pipe data in over stdin.
- **Nested data, edited in place** — JSON/YAML/TOML open as a table over the real
  document: `Enter` dives into a nested object or list, `(` expands a nested column
  into one column per key, `m` switches between record and key/value layouts, and edits
  write back into the document, not into a flattened copy. Saving re-serialises the
  tree, so structure survives.
- **Files larger than memory** — a JSONL file of gigabytes opens at once in the
  terminal and fills in behind the sheet as you look at it, taking about its own size
  in memory; the MCP server streams CSV, TSV, Parquet, Arrow and JSONL past a
  sixteenth of its memory budget, so `frequency` over a 16 GB log holds the counts,
  not the file.
- **Vim-style navigation** — `hjkl`, `gg`/`G`, page jumps, sticky pinned columns.
- **Instant analysis** — per-column statistics, frequency tables, and charts
  (histogram, bar, line, grouped bar) rendered right in the terminal.
- **Reshape on the fly** — pivot tables, JOINs across files, a `git diff`-style
  comparison of two tables, transpose, group by,
  deduplication, computed columns and window functions (rank, running total,
  lag/lead, share of a group) from an expression language with `and` / `or` / `not`.
- **Clean, fast, type-aware** — Polars-backed engine, Everforest theme, undo/redo,
  currency / percentage / date column types.
- **Build a database from nothing** — `qrow inventory.sqlite` on a file that does not
  exist opens a blank sheet. Add columns (`zi`), give them types (`t`), add rows (`o`,
  or `O` for a form that checks each value against its column type), `Ctrl+S`. qrow
  asks what to call the table and writes a real
  typed one: an Integer column is declared `INTEGER` and stores integers, NULL stays
  NULL. SQLite and DuckDB both.
- **Edit a database table and save it back** — open a SQLite or DuckDB table, edit
  cells, delete or paste rows, add/drop/rename columns, then `Ctrl+S` onto the same
  file. qrow shows every `ALTER TABLE`/`UPDATE`/`INSERT`/`DELETE` it is about to run
  and waits for confirmation, then runs them in one transaction; the rest of the
  database — other tables, indexes, views, triggers — is untouched. Reordering columns
  (and changing a type on SQLite) rebuilds the table, which the popup says out loud
  first. Anything the engine would reject, or that a rebuild could not carry across
  intact, is refused with a sentence before a single statement runs. Save to a different `.db` instead and the
  whole database is copied first, leaving the original alone. NULL is shown as `NULL`
  and typed as `\N`, so it never silently becomes an empty string.
- **Export and convert** — write back to CSV, TSV, Parquet, Arrow, JSON, JSONL, YAML,
  TOML, Excel, SQLite, or DuckDB. Converting between structured formats is just a
  different extension: open `config.toml`, save as `config.yaml`. Markdown is read
  only — a page comes in as a row, and nothing writes one back out. Yank rows to the
  clipboard as TSV, CSV, JSON, or Markdown.
- **MCP server** — `qrow --mcp` exposes the same engine to an AI assistant, so it
  computes over your data instead of guessing at it. It reads databases properly:
  tables *and* views, with each column's declared SQL type, keys and defaults.
  Add `--mcp-write` and it can change things too — rows in a table, a table
  replaced wholesale, a file overwritten — but never in one call: the first
  returns the exact statements and what they would destroy, and writes nothing,
  so the assistant has to show you what it is about to run. Creating something
  that does not exist yet needs no flag and no handshake; there is nothing there
  to lose.

---

## See it in action

### Charts — histogram, bar, line, grouped bar

Press `V` on any column. Numeric columns get a Freedman–Diaconis histogram;
categorical columns get a frequency bar chart. [Pin](#keybindings) a date or
category column first with `!` to draw line charts and grouped bars.

![Charts](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/charts.gif)

### Pivot tables

Pin the column(s) to group by, place the cursor on the column to spread across,
press `W`, and type an aggregation formula such as `sum(revenue)`.

![Pivot](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/pivot.gif)

### JOIN across files

Press `J` for a step-by-step wizard: pick another file (or an open sheet),
choose `INNER` / `LEFT` / `RIGHT` / `OUTER` / `ANTI` / `SEMI`, and select the key
columns. `DIFF` compares two tables like `git diff`: unchanged, changed (with the
differing cells marked), removed and added rows, each in its own colour.

![JOIN](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/join.gif)

### Computed columns

Press `=` and type an expression. Arithmetic, string and date functions, and
conditionals are all supported — the new column appears right next to the cursor.

![Computed columns](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/compute.gif)

### Editing a database table

Open a SQLite or DuckDB table, edit it, and `Ctrl+S` back onto the same file.
Every `UPDATE`, `INSERT`, `DELETE` and `ALTER TABLE` is shown before anything
runs, and the whole list goes in one transaction.

![Editing a database table](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/database.gif)

### The new-row form

`O` builds a form out of the sheet: one field per column, labelled with its type
and checked as you type. A value the column cannot hold is refused with the
reason instead of quietly turning the column into text.

![The new-row form](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/rowform.gif)

### JSON, YAML and TOML as a document

`Enter` dives into a nested object or list, edits write back into the document
rather than a flattened copy, and converting is just a different extension.

![Structured formats as a tree](https://raw.githubusercontent.com/denisotree/qrow/master/.github/assets/tree.gif)

---

## Installation

### Cargo (crates.io)

```sh
cargo install qrow
```

Installs two commands: `qrow` and its short alias `qrw`.

To skip the build, [cargo-binstall](https://github.com/cargo-bins/cargo-binstall)
fetches the pre-built binary from the release instead — `qrow` only, without the
alias:

```sh
cargo binstall qrow
```

### Homebrew (macOS / Linux)

```sh
brew tap denisotree/qrow
brew install qrow
```

### Arch Linux (AUR)

```sh
yay -S qrow            # pre-built binary: qrow-bin
# or build from source:
git clone https://aur.archlinux.org/qrow.git && cd qrow && makepkg -si
```

### Debian / Ubuntu (APT)

```sh
curl -fsSL https://qrow.dev/apt/qrow.gpg \
  | sudo tee /usr/share/keyrings/qrow.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/qrow.gpg] https://qrow.dev/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/qrow.list
sudo apt update && sudo apt install qrow
```

`apt upgrade` then picks up new releases. amd64 and arm64; Debian 12+ and Ubuntu
22.04+. A single `.deb` is also attached to every
[release](https://github.com/denisotree/qrow/releases): `sudo apt install ./qrow_*.deb`.

### Pre-built binaries

Grab a tarball for your platform (Linux / macOS, x86_64 / aarch64) from the
[Releases page](https://github.com/denisotree/qrow/releases).

<details>
<summary><b>Building from source</b></summary>

```sh
cargo build --release
```

The default build bundles DuckDB and SQLite from source, so the binary is fully
self-contained — no system libraries required. This compiles DuckDB's C++ core
(~10 min the first time; a C++17 compiler is needed).

To skip that and link a **system** DuckDB instead — it has to be DuckDB 2.0, which
some distributions do not ship yet:

```sh
brew install duckdb                # macOS
sudo apt install libduckdb-dev     # Debian / Ubuntu
cargo build --release --no-default-features --features aliases
```

| Feature | Default | Description |
|---------|:-------:|-------------|
| `bundled-duckdb` | ✓ | Compile DuckDB from source; no system `libduckdb` needed |
| `aliases` | ✓ | Build the `qrw` alias |

</details>

---

## Quick start

```sh
cargo install qrow
qrow data.csv
```

- Move with `h` `j` `k` `l`; jump with `gg` / `G`.
- Sort the current column: `[` ascending, `]` descending, `r` to reset;
  `z[` / `z]` add a second key.
- Chart it: `V`. Per-column stats: `I`. Frequency table: `F`. Group by pinned
  columns: `gb`. Rank, running total or a group share: `zw`.
- Select rows by an expression: `|!=amount > 1000`.
- Add a column: `=` then e.g. `revenue / units`.
- Save / export: `Ctrl+S`. Quit: `q`. Help at any time: `?`.

---

## Usage

```text
qrow [OPTIONS] [FILES]...

Arguments:
  [FILES]...  One or more files to open, a directory, a quoted glob pattern,
              or '-' for stdin. Pass multiple files to browse them as a list.
              Defaults to the current directory.

Options:
  -d, --delimiter <CHAR>   Column delimiter (auto-detected if omitted)
  -t, --type <FORMAT>      Data format (csv, tsv, txt, parquet, arrow, xlsx,
                           sqlite, duckdb, json, jsonl, yaml, toml, md).
                           Required for stdin, which takes csv, tsv, txt,
                           json, jsonl, yaml and toml; for a file it overrides
                           the extension and content detection, so
                           `-t yaml deploy.conf` and `-t csv export.dat` work
      --mcp                Run as an MCP server on stdio (see below)
      --mcp-write          Let that server change what already exists — rows,
                           a whole table, a file. Off by default; every such
                           change is shown first and applied by name
  -h, --help               Print help
  -V, --version            Print version
```

### Browse several files

```sh
qrow orders.csv customers.csv products.parquet
```

A directory-style listing opens with each file as a row. Press `Enter` to open
one; `Esc` or `q` to go back.

### Many files as one table

```sh
qrow 'data/*.csv'
qrow 'content/**/index.md'
```

Quoted, the pattern reaches qrow and every file it matches is stacked into one
table — the listing above is for picking a file, this is for reading them together.
Unquoted, the shell expands it first and you get the listing instead. Tabular files
have to hold the same columns, and the one that does not is named rather than
folded in; markdown pages are records, so they are unioned and a field a page lacks
arrives NULL. A pattern is not a file, so the sheet has nothing to reload from and
`Ctrl+S` asks where to put it.

### Pipe mode

```sh
psql -c "SELECT * FROM orders" --csv | qrow -t csv
sqlite3 app.db ".mode csv" ".headers on" "SELECT * FROM users" | qrow -t csv
```

> Stdin accepts `csv`, `tsv`, `txt`, `json`, `jsonl`, `yaml`, and `toml`. For
> Parquet/Excel/SQLite, open the file directly.

### MCP server — let an AI assistant use the engine

`qrow --mcp` speaks the [Model Context Protocol](https://modelcontextprotocol.io)
over stdio. An assistant handed a data file can then compute over it with
qrow instead of doing the arithmetic in its head:

```sh
claude mcp add qrow -- qrow --mcp
```

A source may be a glob — `content/**/index.md` reads every page of a static site as
one table, each page a row of its frontmatter — so a site can be checked against a
database in one call rather than through an export script.

Five tools: `qrow_inspect` (columns, types, row count, sample rows),
`qrow_query` (seventeen operations composed as a pipeline — filter, group by,
window functions, pivot, join, dedup and the rest — returning JSON or writing
xlsx/csv/parquet/sqlite), `qrow_describe` (per-column statistics),
`qrow_jq` (jq programs over nested JSON/YAML/TOML), and `qrow_calc` — any
calculation, file or no file, in 28-digit decimals with math, statistics and
finance functions, each value labelled exact, rounded or approximate. Several questions can share
one call, and one of them failing does not cost the answers beside it.

Two more appear with `--mcp-write`: `qrow_write` works out what a change would
do and answers with the exact SQL, the rows it would touch and a plan id —
writing nothing — and `qrow_write_apply` runs precisely that plan, in one
transaction, refusing if the table moved underneath it.

There is no SQL and no arbitrary code: the model sends structured operations,
each mapping onto a function qrow already had, and gets back numbers Polars
computed. The server documents itself — the tool list and usage notes are sent
to the model on connect.

Every operation is shared with a keybinding rather than written twice, and a test
holds the two surfaces together: adding an action to the terminal fails to
compile until someone says how a model reaches it.

The protocol is newline-delimited JSON-RPC, which `serde_json` already covers;
`qrow_calc` adds `rust_decimal` for exact arithmetic and `libm` for the normal
distribution, and implements the other distributions itself.

Full details in the [MCP server guide](https://github.com/denisotree/qrow/blob/master/docs/en/mcp.md).

---

## Keybindings

The essentials — see the [full keybinding reference](https://github.com/denisotree/qrow/blob/master/docs/en/keybindings.md)
for every command (column ops, clipboard, dedup, and more).

| Key | Action | Key | Action |
|-----|--------|-----|--------|
| `h` `j` `k` `l` | Move cursor | `[` / `]` | Sort asc / desc |
| `gg` / `G` | First / last row | `r` | Reset sort |
| `Ctrl+B` / `Ctrl+F` | Page up / down | `/` | Search (regex) |
| `!` | Pin / unpin column | `\|` | Select rows by regex / expression |
| `=` | Add computed column | `,` | Select rows by value |
| `V` | Chart column | `s` / `u` | Select / unselect row |
| `I` | Column statistics | `+` / `-` | Add / clear aggregator |
| `F` | Frequency table | `t` | Set column type |
| `W` | Pivot table | `Enter` | Transpose row / drill down / dive into node |
| `J` | JOIN with another table | `T` | Transpose table |
| `m` | Cycle JSON/YAML/TOML layout | `zEnter` | Dive into the node in this cell |
| `(` / `)` | Expand / fold a nested column | | |
| `E` | Edit cell (or node) in `$EDITOR` | `Ctrl+S` | Save / export / convert |
| `o` | Add an empty row below | `O` | New-row form, checked by column type |
| `U` / `Ctrl+R` | Undo / redo | | |
| `?` | Help | `q` | Quit / pop sheet |

> Non-QWERTY layouts (ЙЦУКЕН, QWERTZ, AZERTY) are transparently remapped, so the
> hotkeys work regardless of your keyboard.

---

## Coming from tuitab

qrow is tuitab under a new name, from version 0.12.0. The commands `tuitab`, `ttab`
and `ttb` are now `qrow` and `qrw`; the MCP server is `qrow` and its tools are
`qrow_inspect`, `qrow_query`, `qrow_describe`, `qrow_jq`, `qrow_calc`, `qrow_write` and
`qrow_write_apply`. The old repository,
[denisotree/tuitab](https://github.com/denisotree/tuitab), stays as the archive of
0.11.1 and earlier.

- **Cargo:** `cargo uninstall tuitab && cargo install qrow`.
- **Homebrew:** `brew update && brew upgrade` replaces tuitab with qrow by itself.
  Optionally, to rename the tap on your machine as well:
  `brew untap denisotree/tuitab && brew tap denisotree/qrow`.
- **AUR:** install `qrow` or `qrow-bin`; pacman offers to replace `tuitab` or
  `tuitab-bin`.
- **APT:** the old repository stays at 0.11.1 and gets no updates. Remove it, add the
  new one as in [Debian / Ubuntu (APT)](#debian--ubuntu-apt), and `apt install qrow`
  removes `tuitab`:

  ```sh
  sudo rm /etc/apt/sources.list.d/tuitab.list /usr/share/keyrings/tuitab.gpg
  ```
- **MCP in Claude Code:** register the server under its new name, keeping
  `--mcp-write` if you had it:

  ```sh
  claude mcp remove -s user tuitab
  claude mcp add -s user qrow -- qrow --mcp
  ```

  Permission rules follow the server's name: `mcp__tuitab__tuitab_*` becomes
  `mcp__qrow__qrow_*`.
- **MCP clients configured with JSON** (Claude Desktop, Cursor, Zed and others): rename
  the key and the `command` to `qrow`, with the full path if you used one —
  `/opt/homebrew/bin/qrow` after a Homebrew upgrade, since `/opt/homebrew/bin/tuitab` is
  gone. The client derives tool names from the key: a key left as `tuitab` gives
  `mcp__tuitab__qrow_*`.

## Documentation

Full guides, organised by topic, in two languages:

| 🇬🇧 English | 🇷🇺 Русский |
|------------|------------|
| [Documentation index](https://github.com/denisotree/qrow/blob/master/docs/en/README.md) | [Оглавление документации](https://github.com/denisotree/qrow/blob/master/docs/ru/README.md) |
| [Getting started](https://github.com/denisotree/qrow/blob/master/docs/en/getting-started.md) | [Начало работы](https://github.com/denisotree/qrow/blob/master/docs/ru/getting-started.md) |
| [Keybindings](https://github.com/denisotree/qrow/blob/master/docs/en/keybindings.md) | [Горячие клавиши](https://github.com/denisotree/qrow/blob/master/docs/ru/keybindings.md) |
| [Expressions](https://github.com/denisotree/qrow/blob/master/docs/en/expressions.md) | [Выражения](https://github.com/denisotree/qrow/blob/master/docs/ru/expressions.md) |
| [Charts](https://github.com/denisotree/qrow/blob/master/docs/en/charts.md) | [Графики](https://github.com/denisotree/qrow/blob/master/docs/ru/charts.md) |
| [JOIN](https://github.com/denisotree/qrow/blob/master/docs/en/join.md) | [JOIN](https://github.com/denisotree/qrow/blob/master/docs/ru/join.md) |
| [Pivot tables](https://github.com/denisotree/qrow/blob/master/docs/en/pivot.md) | [Сводные таблицы](https://github.com/denisotree/qrow/blob/master/docs/ru/pivot.md) |
| [Databases](https://github.com/denisotree/qrow/blob/master/docs/en/database.md) | [Базы данных](https://github.com/denisotree/qrow/blob/master/docs/ru/database.md) |
| [MCP server](https://github.com/denisotree/qrow/blob/master/docs/en/mcp.md) | [MCP-сервер](https://github.com/denisotree/qrow/blob/master/docs/ru/mcp.md) |
| [Recipes](https://github.com/denisotree/qrow/blob/master/docs/en/recipes.md) | [Рецепты](https://github.com/denisotree/qrow/blob/master/docs/ru/recipes.md) |

---

## Acknowledgements

qrow is inspired by [VisiData](https://www.visidata.org) — a brilliant terminal
spreadsheet multitool by [Saul Pwanson](https://github.com/saulpw). If you find
qrow useful, check out VisiData too. Built with
[ratatui](https://github.com/ratatui/ratatui), [Polars](https://www.pola.rs),
and [crossterm](https://github.com/crossterm-rs/crossterm).

## Contributing

Bug reports, feature requests, and pull requests are welcome.
See [CONTRIBUTING.md](https://github.com/denisotree/qrow/blob/master/CONTRIBUTING.md).

## License

Apache-2.0 — see [LICENSE](https://github.com/denisotree/qrow/blob/master/LICENSE).
