###############################################################
#
# Hotwire is a hotel deals comparison site. They allow pulling in prices
# for various hotels in different cities
#
###############################################################

module Hotwire

  # limits for this key are 2 calls per second, 5000 calls per day
  API_KEY = "ag2n2y43pc5u5aqes4mqfjzd"

  # this url does a new hotwire search rather than recent deals
  API_URL = "http://api.hotwire.com/v1/search/hotel"

  # This should return some hotel information
  def get_hotels(dest, rooms, adults, children, start_date, end_date)
    # send request
    # get response
    # parse response
  end
end