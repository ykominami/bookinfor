# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Setup
```bash
bin/setup        # bundle install, db:prepare, log:clear tmp:clear, rails restart
yarn install     # JS deps (yarn 1.x is the pinned package manager)
```

### Development
```bash
bin/dev          # foreman start -f Procfile.dev — rails server on port 3001 + esbuild watch + sass watch
yarn build       # esbuild app/javascript/*.* -> app/assets/builds
yarn build:css   # sass application.bootstrap.scss -> app/assets/builds/application.css
```

### Testing
```bash
bundle exec rake spec                                      # full suite (what CI runs)
bundle exec rspec spec/importers/top_importer_spec.rb      # single file
bundle exec rspec spec/importers/book_importer_spec.rb:8   # single example by line
```

### Linting
```bash
bundle exec rubocop                   # check
bundle exec rubocop -a                # auto-fix (avoid on app/importers — many offenses are intentional)
```

### Database
```bash
bin/rails db:prepare    # create + migrate
bin/rails db:migrate
```

### Data Import/Export (`lib/tasks/data.rake`, all under the `data:` namespace)
```bash
rake data:import[search_file,datalist_file,local_file]   # main entry point; sets ConfigUtils.use_import_date = false
rake data:importfile[search_file,datalist_file]          # same, without local_file (no path lookup)
rake data:download[cmd,searchfile]                       # DlImporter — fetch raw data from the remote API
rake data:export                                         # AllExporter.new(:export)
rake data:export_import                                  # AllExporter.new(:import)
rake data:file_test                                      # shells out to data:import for bf/cf/kf/rf configs
rake data:file_test_cf / _kf / _rf / _kr_rf              # subsets of the above
rake data:size_bk_all / size_rl_all / size_ca_all / size_ki_all   # record counts
rake data:bk_all / rl_all / ca_all / ki_all              # dump all records with `p`
rake data:bk_dall / rl_dall / ca_dall / ki_dall          # destroy_all per list
rake data:all_dall                                       # destroy_all across all four lists
```
Note `data:file_test*` invokes `data:import` (not `data:importfile`) with a `local_*.json` third argument.

## Environment prerequisites (read this before running anything)

Two things the repo does **not** ship are required for the app to boot and for imports/specs to run:

1. **`config/importers/setting.json`** is gitignored, but `ConfigUtils` parses it in its **class body** — it is read at load time, so a missing file breaks Rails boot, not just imports. It holds a single key, `src_url`, pointing at the remote data API.
2. **`data/`** is gitignored (`/data*/`) and absent from a fresh clone. `DatadirUtils` creates `data/` and `data/export/` on demand, but the importer specs read a real `data/datalist.json`, so `rake spec` will not pass without local data. Treat spec failures that trace back to `datalist.json` or `DatalistUtils#parse` as missing-fixture problems, not code regressions.

## Architecture

Rails 8.1 app for managing a personal book collection across four sources. SQLite (`sqlite3` gem); `config/database.postgrsql.yml` and `config/database-sqlite3.yml` are unused alternates.

### Domain models (`app/models/`)
`Booklist` (physical/purchased), `Readinglist` (to-read), `Kindlelist`, `Calibrelist` — the four importable lists. `Category`, `Shape`, `Bookstore` classify them; `Readstatus` / `Readingstatus` track reading state. Each list model is thin; the interesting logic lives in the importers.

### Data pipeline (`app/importers/`) — the core of this codebase

`TopImporter` orchestrates a run. `TopImporter#execute` →
`make_import_data_list` (join datalist × search config) → `execute_sub` per category →
`make_importer` → `importer.xf(...)` / `xf_booklist(...)` per row group.

**Importer selection is an explicit case statement, not name derivation.** `make_importer(ext, kind)` builds `importerkind = "#{kind}#{ext}"` (e.g. `"kindle" + "file"` → `"kindlefile"`), then `TopImporter#make` maps that string to a class via a literal `case`. Adding a new importer means editing that `case` — `constantize` is not used here.

**`ext` also decides whether a path is passed.** When `ext` is non-nil and a `local_file` was supplied, `make_importer` looks up `@local_files[importerkind]` and passes it as `path`; if that key is missing it raises. File importers (`*fileImporter`) take this extra `path` argument; the non-file variants do not.

**`BaseImporter#xf` is the shared per-source pipeline**, run in this fixed order:
`load_data` → `normalize_loaded_json` → `detect_replace_key_x` (`key_replace`) → `complement_key_x` (`key_complement`) → `delete_key` (`remove`) → `after_delete_key` (`after_remove`) → `xf_supplement` (subclass hook) → `detect_blank` → `find_duplicated_field_value` → `select_valid_data_y` (subclass hook) → `@ar_klass.insert_all(data_array)`.

**Import quality gate.** `DetectorImporter` accumulates blank-field and duplicate-value counts. `BaseImporter#xf` inserts **only** when `show_detected() == 0` and `data_array` is non-empty — and it returns silently otherwise. A "successful" import that wrote nothing is almost always a detector count, visible in the debug log via `show_blank_fields` / `show_duplicated_fields`.

**Subclass hooks have inconsistent signatures.** `xf_supplement` is `(target, x, base_number = 0)` in `BookImporter`, `(x, base_number = nil)` in `CalibreImporter` / `KindleImporter`, and `(x)` in `ReadingImporter`; some classes also define a separate `xf_supplement_x`. Check the specific subclass before calling or refactoring — this is not a uniform interface.

**Data normalization.** `BaseImporter#normalize_loaded_json` accepts array-of-arrays (first row = headers), array-of-hashes, or an already-keyed hash, and yields the internal `{"0" => {col => val}, ...}` shape.

**Deduplication and date filtering.** Each importer's `select_valid_data_y` skips rows whose unique field already exists in the DB. `BaseImporter#select_valid_data` additionally drops rows older than the last import date, but only when `ConfigUtils.use_import_date?` — and `data:import` explicitly sets it to `false`, so date filtering is off by default.

**Year-based ID namespacing.** `BookImporter#xf_booklist` computes `base_number = year * 1000` and offsets `xid` / `totalID` (2024 → +2,024,000) so IDs stay unique across years without a DB constraint.

### Datalist keys (`app/utils/datalist_utils.rb`)
`data/datalist.json` maps a pipe-delimited key to `[relative_file, src_url]`. `DatalistUtils::Keylable` reads fixed positions out of that key: index 1 = category, index 4 = label, index 5 = year. Example: `json|book|ss2|book|book|2024|c` → category `book`, label `book`, year `2024`. Output files land at `data/<category>/<year>.json`, except category `api` which uses `<label>-<year>.json`.

### Importer configuration (`config/importers/`)
- `config.json` — `keys` (the four source names) and `xkeys`, keyed by source. Each `xkeys` entry: `ac_klass` (AR class name, `constantize`d), `valid`, `remove`, `after_remove`, `not_blank`, `not_duplicated`, `key_replace` (rename map, used for the Japanese column headers), `key_complement` (defaults).
- `search_*.json` — `{category => [years]}` selecting what a run processes. Values are **strings** `":all"` / `":latest"` or four-digit year strings — not Ruby symbols, despite the leading colon. `sorted_by_category_and_year` special-cases them.
- `local_*.json` — two different shapes in practice: `{"bookfile": {"2021": "data/book/2021.json"}}` (year → path, used by file importers) vs `{"book": ["book_2022.json", ...]}` (plain list). Match the shape of the importer you're targeting.
- `state.json` — last import date per importer kind (`YYYY-MM-DD`); `ConfigUtils.default_import_date` (2000-01-01) is the fallback.
- `setting.json` — gitignored, `src_url` only (see prerequisites above).
- `ConfigUtils` also exposes `exporter_config_dir_pn` → `config/exporters/`, which does not currently exist.

### Controllers / views
Conventional REST controllers, one per resource, all small (`booklists_controller.rb`, the largest, is ~180 lines). Ransack for search/filter, Kaminari for pagination. ERB views with ViewComponent (`app/components/`), `bootstrap_form` helpers, Turbo/Stimulus.

### Utilities (`app/utils/`)
`ConfigUtils` (all paths and global import flags — class-level state), `DatalistUtils`, `DatadirUtils`, `LoggerUtils`, `JsonUtils`, `YamlUtils`, `UtilUtils`.

## Conventions and gotchas

- Importer code is deliberately noisy: bare `p` calls sit alongside `@logger.debug` throughout. Leave existing ones alone unless asked; they're the primary debugging channel for the pipeline.
- RuboCop runs with very high tolerances (250-char lines, 440-line classes, a 20 KB `.rubocop_todo.yml`). `TargetRubyVersion` is pinned to **3.0** even though the app runs Ruby 4.0.6. Double quotes enforced; Japanese comments allowed (`AsciiComments: false`).
- Specs live only in `spec/importers/` (three files). There are no model, controller, or system specs, and no factories — new tests need their own setup.
- Ruby is pinned to **4.0.6** in four places that must stay in sync: `Gemfile`, `Gemfile.lock` (`RUBY VERSION`), `.tool-versions`, and the CI matrix in `.github/workflows/main.yml`. `.tool-versions` also pins nodejs 26.5.0 and python 3.13.11. CI additionally runs a Codacy workflow.
- On Windows, the mise-managed Ruby (`~/.direnv/data/mise/installs/ruby/4.0.6`) ships without an MSYS2 devkit, so `bundle install` fails building native extensions (`bigdecimal`, etc.) with "You have to install development tools first." Install the devkit (`ridk install`) before expecting `bundle install` or `rake spec` to work locally. `bundle lock` still works, since it only re-resolves.
- `docs/*.md` (datatask.md, readx.md, td.md) document this project's rake tasks and download flow. **`docs/manual/` does not** — it describes a different, bookmark-oriented app (`Bookmark`, `Pathx`, `Hierx`, `data:conv:html`, pyvenv). None of that exists here; ignore it.

# プロジェクト固有定義
project_name: "crepo-ykominami-bookinfor"
@C:\0-MD-2\_ARCHIVE\AI\SSOT.md
