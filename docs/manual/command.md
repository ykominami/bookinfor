● プロジェクトの CLAUDE.md に記載されているコマンドをまとめます。

  ---
  開発サーバー起動

  foreman start -f Procfile.dev
  Rails サーバー + JS ウォッチ + CSS ウォッチを同時起動します。

  ---
  ビルド

  npm run build        # JavaScript アセットのビルド
  npm run build:css    # SCSS → CSS コンパイル
  npm run watch:css    # SCSS ファイルの変更監視

  ---
  テスト

  bundle exec rspec                                    # 全テスト実行
  bundle exec rspec spec/models/bookmark_spec.rb       # 特定ファイルのみ
  bundle exec rspec spec/models/bookmark_spec.rb:8     # 特定行のテスト
  bundle exec rspec -e "is valid with a href"          # テスト名で指定
  bin/rake db:test:prepare                             # テスト DB 準備

  タグによる絞り込み:
  bundle exec rspec --tag validatex:true   # バリデーション系テスト
  bundle exec rspec --tag dbutil:1         # DB ユーティリティ系テスト（データファイル必要）

  ---
  静的解析・セキュリティ

  bundle exec rubocop    # Ruby 静的解析
  bundle exec brakeman   # セキュリティ解析

  ---
  データベース

  bin/rails db:migrate
  bin/rails db:schema:load
  bin/rails db:seed

  ---
  データインポート（Rake タスク）

  bin/rake data:register:pi_l[pi_file,l_file]          # パスインデックス + リンクファイルを登録
  bin/rake data:conv:html[src_file,output_dir]          # HTML ブックマークファイルを変換（1ファイル）
  bin/rake data:conv:html:all[src_dir,output_dir]       # ディレクトリ内の全 HTML を変換
  bin/rake data:conv:html_pi_l[src_file,output_dir]     # HTML 変換 + パスインデックス + リンク
  bin/rake data:conv:html_pi_l:all[src_dir,output_dir]  # 全ファイル変換 + インポート
  bin/rake data:install:pyvenv                          # Python 仮想環境のセットアップ
  bin/rake data:size_bk                                 # ブックマーク件数表示

  引数省略時は環境変数 HTML_INPUT、YAML_PATH_INDEX、YAML_BOOKMARK、YAML_HIERX がフォールバックとして使われます。

  ---
  典型的な使い方の流れ:
  1. data:install:pyvenv で Python 環境を準備
  2. data:conv:html で HTML ブックマークを YAML に変換
  3. data:register:pi_l で DB にインポート
  4. foreman start -f Procfile.dev でアプリ起動

