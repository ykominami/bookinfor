require 'rails_helper'

RSpec.describe DlImporter do
  describe '#import' do
    before do
      @datalist_file_pn = Rails.root.join( 'data', 'datalist.json')
      @search_file_pn = Rails.root.join('config', 'importers', 'search_b2024.json')

      #importer_config_dir_pn = ConfigUtils.importer_config_dir_pn
      #search_file_pn = importer_config_dir_pn + args.searchfile
    end
    it 'download files' do
      dl = DlImporter.new(cmd: :ALL, search_file_pn: @search_file_pn)
      dl_result = DlResultStack::DlResult.new(:GET_AND_SAVE, true)
      expect(dl.data.last).to eql(dl_result)
    end
  end
end
