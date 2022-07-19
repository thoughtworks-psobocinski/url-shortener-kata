require 'daybreak'

class URLShortener
    def self.shorten(long_url)
        short_url = 'https://conn.io/' + rand(1000..99999).to_s(36)
        db = Daybreak::DB.new './data/urls.db'
        db.set!(short_url, long_url)
        db.close

        short_url
    end

    def self.lengthen(short_url)
        db = Daybreak::DB.new './data/urls.db'

        unless db.keys.include?(short_url)
            db.close
            raise "URL not found: #{short_url}"
        end

        long_url = db[short_url]
        db.close

        long_url
    end
end
