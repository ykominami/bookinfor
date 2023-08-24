# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# 参考: https://nekorich.com/cat-names
Abc.create(
  [
    { s: "アーチー", zid: 0 },
    { s: "アーロ", zid: 1 },
    { s: "アイヴァン", zid: 2 },
    { s: "アイリス", zid: 3 },
    { s: "アヴァロン", zid: 4 },
    { s: "アクセル", zid: 5 },
    { s: "あずき", zid: 6 },
    { s: "アディ", zid: 7 },
    { s: "アディソン", zid: 8 },
    { s: "アニー", zid: 9 },
    { s: "アビー", zid: 10 },
    { s: "アポロ", zid: 11 },
    { s: "アリエル", zid: 12 },
    { s: "アリス", zid: 13 },
    { s: "アルド", zid: 14 },
    { s: "アルフィ", zid: 15 },
    { s: "アレックス", zid: 16 },
    { s: "アンバー", zid: 17 },
    { s: "イザベラ", zid: 18 },
    { s: "イジィ", zid: 19 },

  ]
)
Readstatus.create(
  [
    { name: "etc" },
    { name: "雑誌-開始" },
    { name: "雑誌-読了" },
    { name: "開始" },
    { name: "読了" },
    { name: "不明" },
  ]
)

Category.create(
  [
    { name: "etc" },
    { name: "ソフトウェア" },
    { name: "ビジネス" },
    { name: "防衛" },
    { name: "原発" },
    { name: "国際" },
    { name: "社会" },
    { name: "歴史" },
    { name: "天皇" },
    { name: "政治" },
    { name: "思想" },
    { name: "宗教" },
    { name: "中国" },
    { name: "相続" },
    { name: "経済" },
    { name: "法律" },
    { name: "介護" },
    { name: "健康" },
    { name: "工学" },
    { name: "数学" },
    { name: "物理学" },
    { name: "科学" },
    { name: "気候変動" },
    { name: "英語" },
    { name: "語学" },
    { name: "エンタ" },
    { name: "不明" },
    { name: "本以外" },
  ]
)

Shape.create(
  [
    { name: "Kindle" },
    { name: "Kindle-U" },
    { name: "本" },
    { name: "EBOOK" },
  ]
)
=begin
スキル
ソフトウェア
ビジネス
防衛
原発
国際
社会
歴史
天皇
政治

思想
宗教

中国

相続
経済
法律

介護
健康

工学
数学
物理学
科学
気候変動

英語
語学

エンタ
不明
本以外
=============
=end
