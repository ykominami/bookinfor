require 'rails_helper'

RSpec.describe TopImporter do
  describe '#import' do
    let(:datalist_file_pn) { Rails.root.join('data', 'datalist.json') }
    let(:search_file_pn) { Rails.root.join('config', 'importers', 'search_b2024.json') }

    it 'imports top 100 movies from IMDB' do
      importertop = described_class.new(datalist_file_pn, search_file_pn)
      expect do
        importertop.execute()
      end.to raise_error(RuntimeError)
    end
  end
end
