class Movie < ActiveRecord::Base
    def self.all_ratings
        arr = Array.new
        self.select("rating").uniq.each {|r| arr.push(r.rating)}
        arr.sort
    end
end