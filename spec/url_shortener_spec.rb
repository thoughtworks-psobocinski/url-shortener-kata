require './app/url_shortener'
require './spec_helper'

RSpec.describe URLShortener do
  let(:db) { double('Database') }
  let(:url_generator) { double('URLGenerator') }
  let(:long_url) { 'https://www.example.com' }
  let(:short_url) { 'https://conn.io/1' }
  let(:shorter_url) { 'https://conn.io/2' }

  before do
    allow(db).to receive(:set!)
    allow(db).to receive(:keys).and_return([])
  end

  describe '.shorten' do
    before do
      allow(url_generator).to receive(:generate).and_return(short_url)
    end

    it 'shortens the url' do
      result = URLShortener.shorten(long_url, db, url_generator)
      expect(result.size).to be < long_url.size
    end

    it 'writes shortened url to the db' do
      URLShortener.shorten(long_url, db, url_generator)
      expect(db).to have_received(:set!).with(short_url, long_url)
    end

    it 'generates a new short URL if the generated one already exists in the database' do
      allow(url_generator).to receive(:generate).and_return(short_url, shorter_url)
      allow(db).to receive(:keys).and_return([short_url])

      expect(URLShortener.shorten(long_url, db, url_generator)).to eq(shorter_url)
    end
  end

  describe '.retrieve' do
    before do
      allow(db).to receive(:[]).and_return(long_url)
      allow(db).to receive(:keys).and_return([short_url])
    end

    it 'retrieves full-length url from the db' do
      result = URLShortener.retrieve(short_url, db)
      expect(result).to eq(long_url)
    end

    it 'raises a "not found" error when url is not in the db' do
      unknown_url = 'https://unknown_url.com'
      allow(db).to receive(:[]).and_return(nil)

      expect do
        URLShortener.retrieve(unknown_url, db)
      end.to raise_error("URL not found: #{unknown_url}")
    end
  end
end