require './app/url_shortener'

RSpec.describe URLShortenerNew do
    describe '.shorten' do
        it 'should shorten the url yahoo.com' do
            random_service = instance_double('RandomService')
            allow(random_service).to receive(:random_number).and_return(1)
            shortener = URLShortenerNew.new(random_service)

            # Value 'yahoo.com' isn't actually used by the test function
            result = shortener.shorten('yahoo.com')

            expect(result).to eq 'https://conn.io/1'
        end

        it 'should shorten the url google.com' do
            random_service = instance_double('RandomService')
            allow(random_service).to receive(:random_number).and_return(2)
            shortener = URLShortenerNew.new(random_service)

            result = shortener.shorten('google.com')

            expect(result).to eq 'https://conn.io/2'
        end
    end
end

RSpec.describe URLShortener do
    before(:each) do
        @db = Daybreak::DB.new './data/urls.db' # DON'T DO THIS, use before(:each) [was before(:all)]
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

    describe '.retrieve' do
        it 'retrieves full-length url from the db' do
            @db['https://short_url.com'] = 'https://www.full_length_url.com'
            # Was hiding non-determistic tests:
            # @db.load

            long_url = URLShortener.retrieve('https://short_url.com')

            expect(long_url).to eq 'https://www.full_length_url.com'
        end

        it 'raises a "not found" error when url is not in the db' do
            expect do
                URLShortener.retrieve('https://unknown_url.com')
            end.to raise_error('URL not found: https://unknown_url.com')
        end
    end

    after(:each) do
        @db.close
        File.delete('./data/urls.db')
    end
end
