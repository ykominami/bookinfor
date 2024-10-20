require 'rails_helper'

RSpec.describe BookImporter do
  describe 'BokkImporter#xf_booklist' do
    before do
      @datalist_file_pn = Rails.root.join( 'data', 'datalist.json')
      @search_file_pn = Rails.root.join('config', 'importers', 'search_b2024.json')

      #importer_config_dir_pn = ConfigUtils.importer_config_dir_pn
      #search_file_pn = importer_config_dir_pn + args.searchfile
    end

    it 'BookImporter#make_import_data_list' do  
      ti = TopImporter.new(@datalist_file_pn, @search_file_pn)
      # state_pn = ConfigUtils.state_pn
      # @datadir = DatadirUtils.new()
      # @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn, file_pn: @datalist_file_pn)
      # @vx = @datalist.parse
      # @ks = {}
      # config_pn = ConfigUtils.config_pn
      # obj = JsonUtils.parse(config_pn)
      # @keys = obj["keys"]
      # @xkeys = obj["xkeys"]
      # @state = JsonUtils.parse(state_pn)

      bi = ti.make_importer(nil, 'book')
      # ext = 'booklist'
      # kind = "book"
      # importerkind = "#{kind}#{ext}"
      #X  date = get_import_date(importerkind)
      ## ret = ConfigUtils.default_import_date
      ## begin
      ##   date_str = @state["import_date"][importerkind]
      ##   date = Date.parse(date_str)
      ## rescue StandardError => exception
      ##   @logger.fatal exception.message
      ## end
  
      # if ext
      #   path = @local_files[importerkind]
      #   make(importerkind, kind, date, path)
      # else
      #   make(importerkind, kind, date)
      # end
  
      # bi = BookImporter.new(vx, keys, ks)

      expect(bi.xf_booklist(year: 2024, key: "json|book|ss2|book|book|2024|c", mode: :register)).to be_truthy
    end
  end
end
