● data ネームスペースのタスク一覧と使い方をまとめます。

  ---
  データ確認系（レコード数・内容表示）

  rake data:size_bk_all    # Booklist のレコード数を表示
  rake data:size_rl_all    # Readinglist のレコード数を表示
  rake data:size_ca_all    # Calibrelist のレコード数を表示
  rake data:size_ki_all    # Kindlelist のレコード数を表示

  rake data:bk_all         # Booklist の全レコードを表示 (p)
  rake data:rl_all         # Readinglist の全レコードを表示
  rake data:ca_all         # Calibrelist の全レコードを表示
  rake data:ki_all         # Kindlelist の全レコードを表示

  ---
  データ削除系

  rake data:bk_dall        # Booklist を destroy_all
  rake data:rl_dall        # Readinglist を destroy_all
  rake data:ca_dall        # Calibrelist を destroy_all
  rake data:ki_dall        # Kindlelist を destroy_all
  rake data:all_dall       # 上記4モデルをまとめて destroy_all

  ---
  インポート系

  API経由インポート

  rake data:import[search_file,datalist_file,local_file]
  - search_file — config/importers/ 内の検索設定 JSON（省略時: search.json）
  - datalist_file — datalist JSON のパス（省略時: data/export/datalist.json）
  - local_file — ローカルファイル設定 JSON（省略時: API から取得）

  例:
  rake data:import[search_b.json,,]          # search_b.json を使いAPI経由でインポート
  rake data:import[search_bf.json,,local_bf.json]  # ローカルファイルから book インポート

  ファイル直指定インポート

  rake data:importfile[search_file,datalist_file]
  datalist のパスを直接指定する場合に使用。

  ---
  ファイルテスト系（ローカルファイルを使った動作確認）

  rake data:file_test       # bf/cf/kf/rf の全テストを順に実行
  rake data:file_test_cf    # Calibre のみ
  rake data:file_test_kf    # Kindle のみ
  rake data:file_test_rf    # Reading のみ
  rake data:file_test_kr_rf # Kindle + Reading

  各タスクは data:import[search_Xf.json,,local_Xf.json] を呼び出す。DB
  への実際の書き込みが発生するため、テスト前に data:all_dall でリセットするのが一般的。

  ---
  ダウンロード・その他

  rake data:download[cmd,searchfile]   # 外部API からデータをダウンロード
  rake data:export                     # 全データをエクスポート
  rake data:export_import              # エクスポートデータをインポートモードで処理
  rake data:get[file]                  # data/input/api/ 配下のJSONファイルを確認（:all で全件）

  ---
  引数を渡す際の注意

  Zsh を使っている場合はブラケットをエスケープが必要:
  rake 'data:import[search_bf.json,,local_bf.json]'

  ---
  トラブルシュート（data:download などが失敗する場合）

  - `Could not find rails-... in locally installed gems` など Bundler のエラー → リポジトリ直下で `bundle install` を実行する（`Gemfile.lock` に従い gem を入れる）。
  - `Can't find .../config/importers/search_k.json` → 第2引数のファイル名とパスを確認する。
  - HTML 取得や JSON の URL 取得で失敗する → ネットワーク・`config/importers/setting.json` の `src_url`・Google Apps Script の応答を確認する。

