require 'daybreak'

class URLShortener
    def self.shorten(full_length_url, db = Daybreak::DB.new('./data/urls.db'))
        short_url = 'https://conn.io/' + rand(1000..99999).to_s(36)
        db.set!(short_url, full_length_url)
        db.close

        short_url
    end

    def self.retrieve(short_url, db = Daybreak::DB.new('./data/urls.db'))
        unless db.keys.include?(short_url)
            db.close
            raise "URL not found: #{short_url}"
        end

        full_length_url = db[short_url]
        db.close

        full_length_url
    end
end
