require './app/url_shortener'

RSpec.configure do |config|
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
end

RSpec.describe URLShortener do
    before(:all) do
        @db = Daybreak::DB.new './data/urls.db'
    end

    describe '.shorten' do
        it 'shortens the url' do
            shortener = URLShortener.new('./data/urls_test.db')
            short_url = shortener.shorten('https://www.yahoo.com')

            # valuable test?
            # better to test: static prefix is there, as well as the size range of appended dynamic component
            expect(short_url.size).to be < 'https://www.yahoo.com'.size
        end

        it 'writes shortened url the db' do
            shortener = URLShortener.new('./data/urls_test.db')

            short_url = shortener.shorten('https://www.yahoo.com')
            db = Daybreak::DB.new './data/urls_test.db' # TODO: move out of test examples
            retrieved_url = db[short_url]

            expect(retrieved_url).to eq 'https://www.yahoo.com'
        end

        it 'retrieves shortened url when passed in an existing full length url'

        # to think about: calling shorten or retrieve multiple times (after initialization) might not work?
    end

    describe '.retrieve' do
        it 'retrieves full-length url from the db' do
            shortener = URLShortener.new('./data/urls_test.db')
            db = Daybreak::DB.new './data/urls_test.db'
            db['https://short_url.com'] = 'https://www.full_length_url.com'

            long_url = shortener.retrieve('https://short_url.com')

            expect(long_url).to eq 'https://www.full_length_url.com'
        end

        it 'raises a "not found" error when url is not in the db' do
            shortener = URLShortener.new('./data/urls_test.db')

            expect do
                shortener.retrieve('https://unknown_url.com')
            end.to raise_error('URL not found: https://unknown_url.com')
        end
    end

    after(:all) do
        @db.close
        File.delete('./data/urls.db')
    end
end
