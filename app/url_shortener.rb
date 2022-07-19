require 'daybreak'

class URLShortener
    def self.shorten(long_url)
        short_url = 'https://conn.io/' + rand(1000..99999).to_s(36)
        db = Daybreak::DB.new './data/urls.db'
        db.set!(short_url, long_url)
        db.close

        short_url
    end
end
