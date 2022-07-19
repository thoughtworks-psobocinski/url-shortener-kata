require './app/url_shortener'

RSpec.describe URLShortener do
    before(:all) do
        @db = Daybreak::DB.new './data/urls.db'
    end

    describe '.shorten' do
        it 'shortens the url' do
            short_url = URLShortener.shorten('https://www.yahoo.com')

            expect(short_url.size).to be < 'https://www.yahoo.com'.size
        end

        it 'writes shortened url the db' do
            short_url = URLShortener.shorten('https://www.google.com')

            @db.load
            retrieved_url = @db[short_url]
            expect(retrieved_url).to eq 'https://www.google.com'
        end
    end

    after(:all) do
        @db.close
    end
end
