require 'daybreak'

class URLShortener

    def initialize(dbfile)
        @db = Daybreak::DB.new dbfile
    end

    def shorten(full_length_url)
        short_url = 'https://conn.io/' + rand(1000..99999).to_s(36) # extract url building as a dependency
        @db.set!(short_url, full_length_url)
        @db.close

        short_url
    end

    def retrieve(short_url)
        unless @db.keys.include?(short_url)
            @db.close
            raise "URL not found: #{short_url}"
        end

        full_length_url = @db[short_url]
        @db.close

        full_length_url
    end
end
