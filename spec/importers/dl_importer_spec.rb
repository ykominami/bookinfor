require 'rails_helper'

RSpec.describe DlImporter do
  describe 'DlImporter#execute_data_op' do
    before do
      @datalist_file_pn = Rails.root.join( 'data', 'datalist.json')
      @search_file_pn = Rails.root.join('config', 'importers', 'search_b2024.json')
    end
    it 'download files' do
      dl_result = DlResultStack::DlResult.new(:GET_AND_SAVE, true)

      cmd = DlImporter.fix_cmd("all!")

      dl = DlImporter.new(cmd: cmd, search_file_pn: @search_file_pn)
      result_stack = dl.execute_data_op
      expect(result_stack.last).to eql(dl_result)
    end
  end
end
