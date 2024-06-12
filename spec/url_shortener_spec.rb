require './app/url_shortener'
require './spec_helper'

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
