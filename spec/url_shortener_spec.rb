require './app/url_shortener'
require './spec_helper'

RSpec.describe URLShortener do
  let(:db) { double('Database') }
  let(:url_generator) { double('URLGenerator') }

  before do
    allow(db).to receive(:set!)
    allow(db).to receive(:keys).and_return([])
  end

  describe '.shorten' do
    before do
      allow(url_generator).to receive(:generate).and_return('https://conn.io/1')
    end

    it 'generates a new short URL if the generated one already exists in the database' do
      allow(url_generator).to receive(:generate).and_return('https://conn.io/1', 'https://conn.io/2')
      allow(db).to receive(:keys).and_return(['https://conn.io/1'])

      expect(URLShortener.shorten('https://example.com', db, url_generator)).to eq('https://conn.io/2')
    end

    it 'shortens the url' do
      short_url = URLShortener.shorten('https://www.yahoo.com', db, url_generator)

      expect(short_url.size).to be < 'https://www.yahoo.com'.size
    end

    it 'writes shortened url to the db' do
      short_url = URLShortener.shorten('https://www.google.com', db, url_generator)

      expect(db).to have_received(:set!).with(short_url, 'https://www.google.com')
    end
  end

  describe '.retrieve' do
    before do
      allow(db).to receive(:[]).and_return('https://www.full_length_url.com')
      allow(db).to receive(:keys).and_return(['https://short_url.com'])
    end

    it 'retrieves full-length url from the db' do
      long_url = URLShortener.retrieve('https://short_url.com', db)

      expect(long_url).to eq('https://www.full_length_url.com')
    end

    it 'raises a "not found" error when url is not in the db' do
      allow(db).to receive(:[]).and_return(nil)

      expect do
        URLShortener.retrieve('https://unknown_url.com', db)
      end.to raise_error('URL not found: https://unknown_url.com')
    end
  end
end
