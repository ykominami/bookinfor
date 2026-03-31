# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Setup
```bash
bin/setup        # Install dependencies, prepare database, clear logs
```

### Development
```bash
bin/dev          # Start dev server via foreman (web + js build + css build, port 3001)
```

### Testing
```bash
bundle exec rake spec                 # Run all RSpec tests (matches CI)
bundle exec rspec spec/path/to/spec   # Run a single spec file
```

### Linting
```bash
bundle exec rubocop                   # Check code style
bundle exec rubocop -a                # Auto-fix offenses (avoid on importers — many exceptions are intentional)
```

### Database
```bash
bin/rails db:prepare    # Create and migrate
bin/rails db:migrate    # Run pending migrations
```

### Data Import/Export (custom Rake tasks)
```bash
rake data:import[search_file, datalist_file, local_file]   # Import book data (API path)
rake data:importfile[search_file, datalist_file]            # Import from local files only
rake data:export                                            # Export all data
rake data:download[cmd, searchfile]                         # Download from APIs
rake data:file_test                                         # Run all file-based import tests (bf/cf/kf/rf)
rake data:file_test_cf                                      # Calibre file test only
rake data:file_test_kf                                      # Kindle file test only
rake data:file_test_rf                                      # Reading file test only
rake data:file_test_kr_rf                                   # Kindle + reading file tests
rake data:all_dall                                          # Destroy all records in all lists
rake data:size_bk_all                                       # Print Booklist record count
```

## Architecture

This is a Rails 8.1 application for managing personal book collections across multiple sources.

### Core Domain Models
- **Booklist** — physical/purchased books
- **Readinglist** — books to read
- **Kindlelist** — Kindle library items
- **Calibrelist** — Calibre e-book library items
- **Category**, **Shape**, **Bookstore** — classification and metadata
- **Readstatus** / **Readingistatus** — reading status tracking

### Data Pipeline (`app/importers/`, `app/exporter/`)
The most complex part of the codebase. `TopImporter` orchestrates imports; source-specific importers handle each format:
- `BookImporter` / `BooktightImporter` / `BooklooseImporter` / `BookfileImporter` — physical book variants
- `KindleImporter` / `KindlefileImporter` — Kindle library
- `CalibreImporter` / `CalibrefileImporter` — Calibre e-book library
- `ReadingImporter` / `ReadingfileImporter` — reading list
- `DetectorImporter` / `BookDetectorImporter` — auto-detect and filter data sources
- `DlImporter` — downloads raw data from external APIs

`BaseImporter` provides shared association-resolution logic. Configuration lives in `config/importers/`:
- `search_*.json` — controls which categories/years to process per run; values are year arrays, `:all`, or `:latest`
- `local_*.json` — maps importer kind names to year→path hashes (used by file importers and `data:importfile`)
- `config.json` — `keys` (importer name list) / `xkeys` (per-importer field config) used across all importers
- `state.json` — tracks last import date per importer kind (default: `2000-01-01`)
- `setting.json` — contains `src_url` for the remote API

**`config.json` xkeys structure**: each entry has `ac_klass` (ActiveRecord class name as string), `valid` (allowed field names), `remove` (fields stripped before association resolution), `after_remove` (fields stripped after), `key_replace` (field rename map), `key_complement` (default value map).

**Importer routing**: `TopImporter#make_importer(ext, kind)` concatenates `kind + ext` (e.g. `"kindle" + "file"` → `KindlefileImporter`) to select the importer class. File importers receive a `path_hash` (year string → file path) instead of loading from disk, enabling in-memory test fixtures.

**Per-row transformation**: each importer defines `xf_supplement(target, x, ...)` to convert raw data — string association names to IDs, apply conditional shape mappings, fill blank associations with fallback records.

**Data normalization**: `BaseImporter#normalize_loaded_json` transparently converts three input shapes (array-of-arrays, array-of-hashes, or hash-of-hashes) into the internal `{"0" => {col: val}, ...}` format before processing.

**Deduplication and date filtering**: `select_valid_data_y` skips records already in the DB (by unique field) and, when `ConfigUtils.use_import_date = true`, skips records dated before the last import. Date filtering is **disabled by default** in all Rake tasks.

**Import quality gate**: `DetectorImporter` accumulates blank-field and duplicate-value counts per column. `show_detected()` returns the total error count; the import aborts if it is non-zero. Unexpected aborts are usually caused by detector threshold violations.

**Year-based ID namespacing**: `base_number = year * 1000` offsets `xid` and `totalID` by year (e.g. 2024 → offset 2,024,000) so IDs are unique across years without DB uniqueness constraints.

The pipeline uses `roo` for spreadsheet parsing and `nkf` for character encoding conversion (Japanese text support).

### Controllers
Standard REST controllers per resource. `BooklistsController` is the largest (~5500 lines) and contains the most domain logic. All controllers use Ransack for search/filter and Kaminari for pagination.

### Views
ERB templates using ViewComponent for reusable UI components (`app/components/`). Bootstrap form helpers and Turbo/Stimulus for interactivity.

### Utilities (`app/utils/`)
`ConfigUtils`, `DatalistUtils`, `LoggerUtils`, `JsonUtils`, `YamlUtils`, `DatadirUtils`, `UtilUtils` — shared helpers used across importers and controllers.

## Key Configuration Notes
- RuboCop is configured with high tolerances: 250-char line limit, 440-line class limit, many cops disabled in `.rubocop_todo.yml`. Double quotes are enforced.
- Japanese comments are permitted (`AsciiComments: false`).
- CI runs `bundle exec rake spec` on Ruby 4.0.1.
- `.tool-versions` pins Ruby 4.0.1 and Node.js 24.2.0 (asdf).
