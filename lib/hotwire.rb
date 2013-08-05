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
  API_URL = "http://api.hotwire.com/v1/search/hotel?"

  # this classifies the star levels into budget types
  HOTEL_CLASS = {:"1.0" => :economic, :"1.5" => :economic, :"2.0" => :economic, :"2.5" => :economic,
    :"3.0" => :moderate, :"3.5" => :moderate, :"4.0" => :moderate,
    :"4.5" => :luxury, :"5.0" => :luxury}

  # This should return some hotel information
  def self.get_hotels(dest, rooms, adults, children, start_date, end_date)
    response = GetUrl.get(API_URL + "apikey=#{API_KEY}&dest=#{dest}&rooms=#{rooms}&adults=#{adults}&children=#{children}&startdate=#{start_date}&enddate=#{end_date}")
    parse(response)
  end

  def self.parse(response)
    doc = Nokogiri::XML(response.body)
    hotels = doc.xpath('//HotelResult')
    min_price = Hash.new
    hotels.each do |hotel|
      # grab the hotel info and current min for this class of hotel
      rating = hotel.xpath('StarRating').text.to_sym
      price = hotel.xpath('TotalPrice').text.to_f
      current_min = min_price[HOTEL_CLASS[rating]]

      # assign the pricing
      if current_min
        min_price[HOTEL_CLASS[rating]] = [price, current_min].min
      else
        min_price[HOTEL_CLASS[rating]] = price
      end # end if
    end # end do
    # may want to consider returning an average w/ standard deviation instead
    min_price
  end
end