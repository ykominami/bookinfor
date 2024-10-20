require 'rails_helper'

RSpec.describe TopImporter do
  describe '#import' do
    before do
      @datalist_file_pn = Rails.root.join( 'data', 'datalist.json')
      @search_file_pn = Rails.root.join('config', 'importers', 'search_b2024.json')
    end
    it 'imports top 100 movies from IMDB' do
      importertop = TopImporter.new(@datalist_file_pn, @search_file_pn)
      expect {
        importertop.execute()
      }.to raise_error(RuntimeError)
    end
  end
end
