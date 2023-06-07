module BooklistsHelper
    def get_bookstore_options()
        xar = %W(
            9	TSUTAYA春日井店
            57	紀伊國屋書店名古屋空港店
            17	アマゾン
            55	紀伊國屋書店mozoワンダーシティ店
            18	アマゾンマーケットプレイス
            19	アマゾン経由
            46	復刊ドットコム
            13	あおい書店西春店
            21	カルコス小牧店
            23	ザ・リブレットイオンタウン千種店
            25	ジュンク堂書店ロフト名古屋店
            26	ジュンク堂書店名古屋店
            36	三省堂書店名古屋本店
            37	三省堂書店名古屋高島屋店
            40	大学堂書店
            42	小牧古書センター
            43	山星書店
            47	書泉ブックタワー
            59	脇田書房
            1	(株)バリューブックス
            2	Amazon Japan G.K.
            5	BOOK-Stream
            7	CIAL桜木町店
            8	CQ出版WebShop
            16	もったいない本舗
            20	エコマケ
            27	セブンイレブン
            29	ブックアイランド三郷倉庫店
            30	ボナンザ書房
            31	マルツ名古屋小田井店
            32	ヨシヅヤ師勝店
            33	リネットジャパングループ株式会社(ネットオフ)
            38	不明
            44	川口書房
            45	彩流社
            48	有限会社アライド
            49	服部書店
            50	株式会社ガジュマル企画
            15	ちくさ正文館書店
            28	フタバ図書
            34	三洋堂上前津店
            52	正文館書店本店
            14	いまじん春日井南店     
        )

        make_key_value_pair_array(xar)
    end
    
    def make_key_value_pair_array(xar)
        ar = []
        xar.each_slice(2){ |list|
            ar << [ list[1], list[0].to_i ]
        }
        ar
    end

    def get_category_options()
        xar = %W(
            1	エンタ
            2	スキル
            3	経済
            4	ビジネス
            5	相続
            6	介護
            7	健康
            8	人生
            9	ソフトウェア
            10	防衛
            11	法律
            12	社会
            13	思想
            14	政治
            15	歴史
            16	天皇
            17	宗教
            18	国際
            19	中国
            20	サイエンス
            21	科学
            22	数学
            23	物理学
            24	原発
            25	工学
            26	気候変動
            27	温暖化
            28	環境
            29	英語
            30	語学
            31	将棋
            32	本以外
            33	不明
            34	アイヌ
        )
        make_key_value_pair_array(xar)
    end

    class Booklistx
        attr_reader :header, :body, :name

        def initialize(name , booklists)
            @name = name
            @booklists = booklists
            # @keys = %i(totalID xid purchase_date bookstore title asin read_status shape category)
            @keys = %i(totalID purchase_date title asin read_status shape category)
            @header = @keys.map{ |key| key.to_s }
            @body = @booklists.map{ |item| 
                @keys.map{ |key| item[key] }        
            }
        end
    end
end
