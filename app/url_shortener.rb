require 'daybreak'

class URLShortener
    def self.shorten(full_length_url, db)
      short_url = URLGenerator.generate
      db.set!(short_url, full_length_url)
      short_url
    end
  
    def self.retrieve(short_url, db)
      raise "URL not found: #{short_url}" unless db.keys.include?(short_url)
  
      db[short_url]
    end
  end
  
  class URLGenerator
    def self.generate
      'https://conn.io/' + rand(1000..99999).to_s(36)
    end
  end