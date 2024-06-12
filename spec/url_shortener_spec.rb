require './app/url_shortener'
require './spec_helper'

describe URLShortener do
    let(:db) { double('Database') }
    let(:url_generator) { double('URLGenerator') }
  
    before do
      allow(db).to receive(:set!)
      allow(db).to receive(:keys).and_return([])
    end
  
    it 'generates a new short URL if the generated one already exists in the database' do
      allow(url_generator).to receive(:generate).and_return('https://conn.io/1', 'https://conn.io/2')
  
      allow(db).to receive(:keys).and_return(['https://conn.io/1'])
  
      expect(URLShortener.shorten('https://example.com', db, url_generator)).to eq('https://conn.io/2')
    end
  end

RSpec.describe URLShortener do
    before(:each) do
        @db = Daybreak::DB.new './data/urls.db'
    end

    describe '.shorten' do
        it 'shortens the url' do
            short_url = URLShortener.shorten('https://www.yahoo.com', @db)

            expect(short_url.size).to be < 'https://www.yahoo.com'.size
        end

        it 'writes shortened url the db' do
            short_url = URLShortener.shorten('https://www.google.com', @db)

            @db.load
            retrieved_url = @db[short_url]
            expect(retrieved_url).to eq 'https://www.google.com'
        end
    end

    describe '.retrieve' do
        it 'retrieves full-length url from the db' do
            @db['https://short_url.com'] = 'https://www.full_length_url.com'

            long_url = URLShortener.retrieve('https://short_url.com', @db)

            expect(long_url).to eq 'https://www.full_length_url.com'
        end

        it 'raises a "not found" error when url is not in the db' do
            expect do
                URLShortener.retrieve('https://unknown_url.com', @db)
            end.to raise_error('URL not found: https://unknown_url.com')
        end
    end

    after(:each) do
        @db.close
        File.delete('./data/urls.db')
    end
end
